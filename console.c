#include "console.h"
#include "io.h"
#include "cpu.h"
#include "lib.h"
#include "page.h"
#include "string.h"
// #include "bxdebug.h"
#include "kbd.h"
#include "key.h"

extern const u8 fontdata_8x16[];

// use for all
static enum console_env _cur_env;
static bool _cursor_visible;
static u32 _show_mem_base;
// static u32 _show_pos, _show_x, _show_y;
static u16 _show_x, _show_y;
static u16 _max_colums, _max_rows;
static u16 _show_bpp, _show_Bpp, _show_Bpl;
static u16 _line_count[256];
static bool _line_modified[256];
static bool _have_parent;

// use for TUI
static u8 _show_color;

// use for GUI
static bool _GUI_mode;
static u32 _show_mem_size;
static u32 _total_mem_size;
static u16 _max_x, _max_y;
static u32 _show_bg, _show_fg;
static u8 *_show_buffer;

static char _print_buf[2][1024];

// static void scroll_up(u32 rows);
// static void scroll_down(u32 rows);
// static void clear_rows(u32 start, u32 end);
// static void print_int(u32 n, u32 base, u32 width);

static void update(void)
{
	if (_GUI_mode)
	{
		u32 save_eflags = read_eflags();
		disable();

		void *ptr = map_mem(_show_mem_base, _show_mem_size);
		u32 offset = 0;
		for (u16 row = 0; row < _max_rows; ++row)
		{
			if (!_line_modified[row])
			{
				offset += _show_Bpl * 16;
				continue;
			}

			_line_modified[row] = false;
			for (u8 y = 0; y < 16; ++y) // each font are 16 pixel height
			{
				u32 size = (u32)8 * _line_count[row] * _show_Bpp;
				memcpy(ptr + offset, _show_buffer + offset, size);
				offset += _show_Bpl;
			}
		}

		unmap_mem(ptr);
		write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
	}
}

static void set_line_count(u16 row, u16 count)
{
	// if (_line_count[row] != count)
	// {
	_line_count[row] = count;
	_line_modified[row] = true;
	// }
}

static void set_cursor_visible(bool visible)
{
	if (_cursor_visible == visible)
	{
		return;
	}
	_cursor_visible = visible;

	if (_GUI_mode)
	{
	}
	else
	{
		u32 save_eflags = read_eflags();
		disable();
		port_write_byte(CRTC_COLOR_PORT_INDEX, CRTC_REG_CURSOR_START);
		u8 data = port_read_byte(CRTC_COLOR_PORT_DATA);
		if (visible)
			data &= ~CRTC_CURSOR_START_CD;
		else
			data |= CRTC_CURSOR_START_CD;
		port_write_byte(CRTC_COLOR_PORT_INDEX, CRTC_REG_CURSOR_START);
		port_write_byte(CRTC_COLOR_PORT_DATA, data);
		write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
	}
}

static void set_cursor_pos(u16 x, u16 y)
{
	if (_GUI_mode)
	{
	}
	else
	{
		u16 cur_pos = y * _max_colums + x;
		// u32 cur_pos = _show_pos / _show_Bpp;
		u32 save_eflags = read_eflags();
		disable();
		port_write_byte(CRTC_COLOR_PORT_INDEX, CRTC_REG_CURSOR_LOCATION_MSB); // Cursor Location High Register
		// port_write_byte(CRTC_COLOR_PORT_DATA, (cur_pos >> 8) & 0x3F);
		port_write_byte(CRTC_COLOR_PORT_DATA, cur_pos >> 8);
		port_write_byte(CRTC_COLOR_PORT_INDEX, CRTC_REG_CURSOR_LOCATION_LSB); // Cursor Location Low Register
		port_write_byte(CRTC_COLOR_PORT_DATA, cur_pos);
		write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
	}
}

static void clear_line(u16 row, u16 begin)
{
	if (_line_count[row] <= begin)
		return;

	u32 save_eflags = read_eflags();
	disable();

	if (_GUI_mode)
	{
		void *ptr = map_mem(_show_mem_base + (u32)row * _show_Bpl * 16, _show_Bpl * 16);
		u32 offset = (u32)begin * _show_Bpp * 8;
		// ptr += (u32)row * _show_Bpl * 16 + (u32)begin * _show_Bpp * 8;
		for (u8 y = 0; y < 16; ++y) // each font are 16 pixel height
		{
			u8 *tmp = ptr + offset;
			for (u32 x = (u32)begin * 8; x < _line_count[row] * 8; ++x) // each row are _max_colums font or _max_colums*8 pixel
			{
				// for (u8 i = 0; i < 8; ++i) // each font are 8 pixel width
				// {
				// memcpy(ptr, &_show_bg, _show_Bpp);
				memcpy(tmp, &_show_bg, 3);
				tmp += _show_Bpp;
				// for (u8 i = 0; i < _show_Bpp; ++i)
				// *ptr++ = (&_show_bg)[i];
				// }
			}
			offset += _show_Bpl;
			// ptr += _show_Bpl;
		}
		unmap_mem(ptr);
	}
	else
	{
		u8 *ptr = _show_buffer + (u32)row * _show_Bpl + (u32)begin * _show_Bpp;
		// ptr += (u32)row * _show_Bpl + (u32)begin * _show_Bpp;
		for (u32 i = begin; i < _line_count[row]; ++i)
		{
			*(u16 *)ptr = ((u16)_show_color << 8) | ' ';
			ptr += _show_Bpp;
		}
	}

	write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));

	set_line_count(row, begin);
}

static void clear_rows(u16 start, u32 count)
{
	for (u32 i = 0; i < count; ++i)
		clear_line(start + i, 0);
}

static void scroll_up(u16 rows)
{
	bool do_self = !_have_parent;
	if (do_self)
		_have_parent = true;

	if (_show_y < rows)
	{
		_show_y = 0;
		clear_rows(0, _max_rows);
	}
	else if (_show_y == 0)
	{
		_show_x = 0;
		clear_line(0, 0);
		// clear_rows(0, 1);
	}
	else
	{
		_show_y -= rows;

		// u16 tmp_line_count[255];
		u8 *ptr_src = _show_buffer, *ptr_dst = _show_buffer;
		u16 src_start = rows, dst_start = 0, count = MIN(_show_y + 1, _max_rows - 1);
		// memcpy(tmp_line_count, &_line_count[src_start], sizeof(u16) * count);
		if (_GUI_mode)
		{
			ptr_src += src_start * _show_Bpl * 16;
			for (u32 i = 0; i < count; ++i)
			{
				u32 size = (u32)_show_Bpp * 8 * _line_count[src_start];
				// _line_count[dst_start] = _line_count[src_start];
				for (u8 y = 0; y < 16; ++y) // each font are 16 pixel height
				{
					memcpy(ptr_dst, ptr_src, size);
					ptr_dst += _show_Bpl;
					ptr_src += _show_Bpl;
				}

				if (_line_count[dst_start] > _line_count[src_start])
				{
					clear_line(dst_start, _line_count[src_start]);
				}
				else
				{
					set_line_count(dst_start, _line_count[src_start]);
				}
				++dst_start;
				++src_start;
			}
		}
		else
		{
			ptr_src += src_start * _show_Bpl;
			for (u16 i = 0; i < count; ++i)
			{
				// u32 size = (u32)_show_Bpp * _line_count[src_start];
				// _line_count[dst_start] = _line_count[src_start];
				memcpy(ptr_dst, ptr_src, _show_Bpp * _line_count[src_start]);
				ptr_dst += _show_Bpl;
				ptr_src += _show_Bpl;

				if (_line_count[dst_start] > _line_count[src_start])
				{
					clear_line(dst_start, _line_count[src_start]);
				}
				else
				{
					_line_count[dst_start] = _line_count[src_start];
				}
				++dst_start;
				++src_start;
			}
		}

		if (_show_x == 0)
			clear_rows(_show_y, rows);
		else
		{
			if (_show_x != _max_colums - 1)
				clear_line(_show_y, _show_x);
			if (rows - 1)
				clear_rows(_show_y + 1, rows - 1);
		}
	}

	if (do_self)
	{
		update();
		_have_parent = false;
	}
}

static void print_int(u32 n, u32 base, u32 width)
{
	char translate_table[] = {"0123456789abcdef"};
	u8 index_seq[16], index_count;

	bool do_self = !_have_parent;
	if (do_self)
		_have_parent = true;

	index_count = 0;
	do
	{
		index_seq[index_count++] = n % base;
		n /= base;
	} while (n != 0);

	if (width > index_count)
	{
		width -= index_count;
		while (width--)
		{
			print_char('0');
		}
	}

	while (index_count--)
	{
		print_char(translate_table[index_seq[index_count]]);
	}

	if (do_self)
	{
		update();
		_have_parent = false;
	}
}

static void draw_font(u32 x, u32 y, char c)
{
	if (_GUI_mode)
	{
		const u8 *font_ptr = &fontdata_8x16[(c - 32) * 16];
		u8 *ptr = _show_buffer + y * _show_Bpl * 16 + x * _show_Bpp * 8;
		for (u8 i = 0; i < 16; ++i)
		{
			u8 *tmp = ptr;
			for (u8 j = 0; j < 8; ++j)
			{
				if ((font_ptr[i] << j) & 0x80)
				{
					memcpy(tmp, &_show_fg, 3);
				}
				else
				{
					memcpy(tmp, &_show_bg, 3);
				}
				tmp += _show_Bpp;
			}
			ptr += _show_Bpl;
		}
	}
	else
	{
		u32 offset = y * _show_Bpl + x * _show_Bpp;
		_show_buffer[offset++] = c;
		_show_buffer[offset] = _show_color;
	}
}

void console_setup(const struct console_configuration *console_info)
{
	_show_mem_base = console_info->show_mem_base;
	_show_bpp = console_info->bpp;
	_show_Bpp = _show_bpp / 8;
	_show_Bpl = console_info->Bpl;
	_cur_env = CONSOLE_ENV_NORMAL;

	if (console_info->GUI)
	{
		_max_x = console_info->width;
		_max_y = console_info->height;
		_max_colums = _max_x / 8;
		_max_rows = _max_y / 16;
		_total_mem_size = console_info->total_memory_size * 64 * 1024;
		_show_mem_size = _show_Bpl * _max_y;
		_show_buffer = alloc_page(_max_rows * 16 * _show_Bpl, normal_phy_mem);

		_GUI_mode = true;

		if (_max_rows * 16 != _max_y)
		{
			u32 y = _max_rows * 16, index = 0, count = (_max_y - y) * _max_x;
			u8 *ptr = map_mem(_show_mem_base + y * _show_Bpl, count * _show_Bpp);
			for (u32 i = 0; i < count; ++i)
			{
				ptr[index] = 0x00;
				ptr[index + 1] = 0xff;
				ptr[index + 2] = 0x00;
				index += _show_Bpp;
			}
			unmap_mem(ptr);
		}
	}
	else
	{
		_show_buffer = (u8 *)_show_mem_base;
		_max_colums = console_info->width;
		_max_rows = console_info->height;
	}

	console_set_color(COLOR_NORMAL_BG, COLOR_NORMAL_FG);
	// console_clear_screen(); // test vmem mapping
	set_cursor_visible(true);
}

void console_dumpinfo(void)
{
	printf("\nline_count=0x%x\nmax_colums=%d\nmax_rows=%d\nbpp=%d\nBpp=%d\nBpl=%d\n",
		   _line_count, _max_colums, _max_rows, _show_bpp, _show_Bpp, _show_Bpl);
}

void console_set_color(u32 bg, u32 fg)
{
	if (_GUI_mode)
	{
		_show_bg = bg & 0xFFFFFF;
		_show_fg = fg & 0xFFFFFF;
	}
	else
	{
		/*
	** 16-color
	** BG-FG
	** KRGB-IRGB
	** K-闪烁，I-亮、浅
	*/
		bg &= 0xFFFFFF;
		fg &= 0xFFFFFF;
		bg = (bg >> 21 & 0x4) | (bg >> 13 & 0x2) | (bg >> 7 & 0x1);
		fg = (fg >> 16 == 0xff || (fg >> 8 & 0xff) == 0xff || (fg & 0xff) == 0xff) << 3 | (fg >> 21 & 0x4) | (fg >> 13 & 0x2) | (fg >> 7 & 0x1);

		_show_color = MAKE_COLOR(bg, fg);
		// _show_color = MAKE_COLOR(bg & 0xF, fg & 0xF);
	}
}

enum console_env console_set_env(enum console_env env)
{
	if(_cur_env == env) return env;

	enum console_env old = _cur_env;
	_cur_env = env;
	return old;
}

void console_clear_screen(void)
{
	clear_rows(0, _max_rows);
	_show_x = _show_y = 0;
}

void console_get_print_size(u32 *colums, u32 *rows)
{
	*colums = _max_colums;
	*rows = _max_rows;
}

void console_get_size(u32 *width, u32 *height)
{
	if (_GUI_mode)
	{
		*width = _max_x;
		*height = _max_y;
	}
	else
	{
		console_get_print_size(width, height);
	}
}

void print_char(char c)
{
	bool do_self = !_have_parent;
	if (do_self)
		_have_parent = true;

	if (c == '\r' || c == '\n')
	{
		_show_x = 0;
		if (c == '\n')
		{
			++_show_y;
		}
	}
	else if (c == '\b' && _show_x)
	{
		--_show_x;
		// --_line_count[_show_y];
	}
	else
	{
		if (c == '\t')
		{
			_show_x += MIN(_max_colums - _show_x, 4);
		}
		else
		{
			if (c < 32 || c > 126)
			{
				c = ' ';
			}

			draw_font(_show_x, _show_y, c);
			++_show_x;
		}

		set_line_count(_show_y, _show_x);
		if (_show_x == _max_colums)
		{
			_show_x = 0;
			++_show_y;
		}
	}

	if (_show_y == _max_rows)
	{
		scroll_up(1);
	}

	set_cursor_pos(_show_x, _show_y);

	if (do_self)
	{
		update();
		_have_parent = false;
	}
}

void print_str(const char *s)
{
	bool do_self = !_have_parent;
	if (do_self)
		_have_parent = true;

	while (*s != '\0')
	{
		print_char(*(s++));
	}

	if (do_self)
	{
		update();
		_have_parent = false;
	}
}

void printf(const char *fmt, ...)
{
	va_list args;
	bool do_self = !_have_parent;
	if (do_self)
		_have_parent = true;

	va_start(args, fmt);
	vsprintf(_print_buf[_cur_env], fmt, args);
	va_end(args);

	print_str(_print_buf[_cur_env]);

	if (do_self)
	{
		update();
		_have_parent = false;
	}
}

void print_dec(u32 n, u32 width)
{
	bool do_self = !_have_parent;
	if (do_self)
		_have_parent = true;

	print_int(n, 10, width);

	if (do_self)
	{
		update();
		_have_parent = false;
	}
}

void print_hex(u32 n, u32 width)
{
	bool do_self = !_have_parent;
	if (do_self)
		_have_parent = true;

	print_int(n, 16, width);

	if (do_self)
	{
		update();
		_have_parent = false;
	}
}

void print_oct(u32 n, u32 width)
{
	bool do_self = !_have_parent;
	if (do_self)
		_have_parent = true;

	print_int(n, 8, width);

	if (do_self)
	{
		update();
		_have_parent = false;
	}
}

static u8 kbd_flags; // shift-ctrl-alt-caps-gui

u8 getkey(bool *released)
{
	struct kbd_key_packet key;
	bool ret = kbd_get_key(&key);
	if (ret)
	{
		if (released)
			*released = key.released;
		return key.key;
	}
	return 0;
}

char getchar(void)
{
	static const char *key_char_mapping[] = {
		"`-=[]/\\;\'.,0123456789\0\0\0\0\0\0\0abcdefghijklmnopqrstuvwxyz",
		"~_+{}?|:\"><)!@#$%^&*(\0\0\0\0\0\0\0ABCDEFGHIJKLMNOPQRSTUVWXYZ"};
	struct kbd_key_packet key;
	char c;
	while (true)
	{
		if (!kbd_get_key(&key))
			continue;
		if (key.key == KEY_LSHIFT || key.key == KEY_RSHIFT)
		{
			if (key.released)
				kbd_flags &= ~(1 << 4);
			else
				kbd_flags |= 1 << 4;
		}
		// else if (key.key == KEY_LCTRL || key.key == KEY_RCTRL)
		// {
		// 	if (key.released)
		// 		kbd_flags &= ~(1 << 3);
		// 	else
		// 		kbd_flags |= 1 << 3;
		// }
		// else if (key.key == KEY_LALT || key.key == KEY_RALT)
		// {
		// 	if (key.released)
		// 		kbd_flags &= ~(1 << 2);
		// 	else
		// 		kbd_flags |= 1 << 2;
		// }
		// else if (key.key == KEY_LGUI || key.key == KEY_RGUI)
		// {
		// 	if (key.released)
		// 		kbd_flags &= ~(1 << 0);
		// 	else
		// 		kbd_flags |= 1 << 0;
		// }
		else if (!key.released)
		{
			if (key.key == KEY_CAPS)
			{
				if (kbd_flags & 0x2)
					kbd_flags &= ~(1 << 1);
				else
					kbd_flags |= 1 << 1;
			}
			else if (key.key == KEY_ENTER)
			{
				c = '\n';
				break;
			}
			else if (key.key == KEY_TAB)
			{
				c = '\t';
				break;
			}
			else if (key.key == KEY_BACK)
			{
				c = '\b';
				break;
			}
			else if (key.key == KEY_SPACE)
			{
				c = ' ';
				break;
			}
			else if ((key.key >= KEY_BTICK && key.key <= '9') || (key.key >= 'A' && key.key <= 'Z'))
			{
				u8 idx = 0;
				if (kbd_flags & 0x2 && key.key >= 'A')
				{
					idx = 1;
				}
				if (kbd_flags & 0x10)
				{
					if (idx == 1)
						idx = 0;
					else
						idx = 1;
				}
				c = key_char_mapping[idx][key.key - KEY_BTICK];
				break;
			}
		}
	}

	print_char(c);
	return c;
}
