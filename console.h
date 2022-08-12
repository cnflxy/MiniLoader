#ifndef _CONSOLE_H_
#define _CONSOLE_H_ 1

/*
** 6845 CRT Controller
** http://www.osdever.net/FreeVGA/vga/crtcreg.htm
*/

#include "types.h"

// #define CRTC_MONO_PORT_INDEX     0x3B4
// #define CRTC_MONO_PORT_DATA      0x3B5
#define CRTC_COLOR_PORT_INDEX 0x3D4
#define CRTC_COLOR_PORT_DATA 0x3D5

#define CRTC_REG_CURSOR_START 0x0A
#define CRTC_REG_CURSOR_END 0x0B
#define CRTC_REG_CURSOR_LOCATION_MSB 0x0E
#define CRTC_REG_CURSOR_LOCATION_LSB 0x0F

#define CRTC_CURSOR_START_CD 0x10 // Cursor Disable

#define MAKE_RGB(_R, _G, _B) ((_R) << 16 | (_G) << 8 | (_B))
#define COLOR_BLACK MAKE_RGB(0, 0, 0)
#define COLOR_BLUE MAKE_RGB(0, 0, 0xfe)
#define COLOR_GREEN MAKE_RGB(0, 0xfe, 0)
// #define COLOR_CYAN          0x3 // 青色
#define COLOR_RED MAKE_RGB(0xfe, 0, 0)
#define COLOR_WHITE MAKE_RGB(0xff, 0xff, 0xff)
// #define COLOR_MAGENTA       0x5 // 紫红色
// #define COLOR_BROWN         0x6
// #define COLOR_LIGHT_GRAY    0x7 // 银色
// #define COLOR_DARK_GRAY     0x8
// #define COLOR_LIGHT_BLUE    0x9
#define COLOR_LIGHT_GREEN MAKE_RGB(0, 0xff, 0)
// #define COLOR_LIGHT_CYAN    0xB
#define COLOR_LIGHT_RED MAKE_RGB(0xff, 0, 0)
// #define COLOR_LIGHT_MAGENTA 0xD
#define COLOR_YELLOW MAKE_RGB(0xfe, 0xfe, 0)
// #define COLOR_WHITE         0xF

#define COLOR_NORMAL_BG COLOR_BLACK
#define COLOR_NORMAL_FG MAKE_RGB(0xd3, 0xd3, 0xd3)

#define MAKE_COLOR(_BG, _FG) ((_BG) << 4 | (_FG))

// #define COLOR_NORMAL        MAKE_COLOR(COLOR_NORMAL_BG, COLOR_NORMAL_FG)

struct console_configuration
{
	bool GUI;
	u16 version;
	u16 oem_version;
	u16 width;
	u16 height;
	u32 show_mem_base;
	// u8 capabilities;
	u32 video_mode_list;
	u16 total_memory_size; // in 64KB units
	u8 bpp;
	u16 Bpl;
	// u32 show_mem_offset;
	// u16 show_mem_size;	// in 1k units
} __attribute__((packed));

enum console_env
{
	CONSOLE_ENV_NORMAL,
	CONSOLE_ENV_INTR
};

void console_dumpinfo(void);

void console_setup(const struct console_configuration *console_info);

void console_set_color(u32 bg, u32 fg);
enum console_env console_set_env(enum console_env env);
// void console_set_pos(u32 x, u32 y);
void console_clear_screen(void);
void console_get_print_size(u32 *colums, u32 *rows);
void console_get_size(u32 *width, u32 *height);

void print_char(char c);
void print_str(const char *s);
void printf(const char *fmt, ...);

void print_oct(u32 n, u32 width);
void print_dec(u32 n, u32 width);
void print_hex(u32 n, u32 width);

u8 getkey(bool *released);
char getchar(void);

#endif
