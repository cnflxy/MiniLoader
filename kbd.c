#include "kbd.h"
#include "8042.h"
#include "pic.h"
#include "key.h"
#include "console.h"
#include "string.h"
#include "cpu.h"
#include "io.h"

static bool _kbd_avaliable = false;
static struct kbd_key_packet _kbd_buf[128];
static u8 _kbd_buf_idx, _kbd_buf_size, _kbd_buf_oldest;
// static bool _kbd_shift;
// static u8 _kbd_alternate;

static bool kbd_write(u8 data, bool wait_infinite)
{
    return ps2_write(data, false, wait_infinite);
}

static bool kbd_read(u8 *data, bool wait_infinite)
{
    return ps2_read(data, wait_infinite);
}

static void push_key(u8 key, bool released)
{
    _kbd_buf[_kbd_buf_idx].key = key;
    _kbd_buf[_kbd_buf_idx].released = released;
    if (++_kbd_buf_idx == 128)
        _kbd_buf_idx = 0;

    if (_kbd_buf_idx == _kbd_buf_oldest)
    {
        if (++_kbd_buf_oldest == 128)
            _kbd_buf_oldest = 0;
    }

    if (_kbd_buf_size != 128)
        ++_kbd_buf_size;
}

static bool pop_key(struct kbd_key_packet *key)
{
    if (_kbd_buf_size == 0)
        return false;
    key->key = _kbd_buf[_kbd_buf_oldest].key;
    key->released = _kbd_buf[_kbd_buf_oldest].released;
    --_kbd_buf_size;
    if (++_kbd_buf_oldest == 128)
        _kbd_buf_oldest = 0;
    return true;
}

static void kbd_decode_scode(void)
{
    static const u8 key_mapping[2][0x84] = {
        {
            0, KEY_F9, 0, KEY_F5,
            KEY_F3, KEY_F1, KEY_F2, KEY_F12,
            0, KEY_F10, KEY_F8, KEY_F6,
            KEY_F4, KEY_TAB, KEY_BTICK, 0,
            0, KEY_LALT, KEY_LSHIFT, 0,
            KEY_LCTRL, 'Q', '1', 0,
            0, 0, 'Z', 'S',
            'A', 'W', '2', 0,
            0, 'C', 'X', 'D',
            'E', '4', '3', 0,
            0, KEY_SPACE, 'V', 'F',
            'T', 'R', '5', 0,
            0, 'N', 'B', 'H',
            'G', 'Y', '6', 0,
            0, 0, 'M', 'J',
            'U', '7', '8', 0,
            0, KEY_COMMA, 'K', 'I',
            'O', '0', '9', 0,
            0, KEY_PERIOD, KEY_SLASH, 'L',
            KEY_SEMI, 'P', KEY_MINUS, 0,
            0, 0, KEY_SQUOTE, 0,
            KEY_LBRACK, KEY_EQUAL, 0, 0,
            KEY_CAPS, KEY_RSHIFT, KEY_ENTER, KEY_RBRACK,
            0, KEY_BSLASH, 0, 0,
            0, 0, 0, 0,
            0, 0, KEY_BACK, 0,
            0, KEY_KPAD1, 0, KEY_KPAD4,
            KEY_KPAD7, 0, 0, 0,
            KEY_KPAD0, KEY_KPAD_PERIOD, KEY_KPAD2, KEY_KPAD5,
            KEY_KPAD6, KEY_KPAD8, KEY_ESC, KEY_NUM,
            KEY_F11, KEY_KPAD_PLUS, KEY_KPAD3, KEY_KPAD_MINUS,
            KEY_KPAD_MUL, KEY_KPAD9, KEY_SCROLL, 0,
            0, 0, 0, KEY_F7, // 0x83
        },
        {0, 0, 0, 0,
         0, 0, 0, 0,
         0, 0, 0, 0,
         0, 0, 0, 0,
         KEY_W3SEARCH, KEY_RALT, 0, 0,
         KEY_RCTRL, KEY_PRETRACK, 0, 0,
         KEY_W3FAVOUR, 0, 0, 0,
         0, 0, 0, KEY_LGUI,
         KEY_W3REFRESH, KEY_VOLDOWN, 0, KEY_MUTE,
         0, 0, 0, KEY_RGUI,
         KEY_STOP, 0, 0, KEY_CALC,
         0, 0, 0, KEY_APPS,
         KEY_W3FORWARD, 0, KEY_VOLUP, 0,
         KEY_PLAY, 0, 0, KEY_POWER,
         KEY_W3BACK, 0, KEY_W3HOME, KEY_STOP,
         0, 0, 0, KEY_SLEEP,
         KEY_MYPC, 0, 0, 0,
         0, 0, 0, 0,
         KEY_EMAIL, 0, KEY_KPAD_SLASH, 0,
         0, KEY_NEXTTRACK, 0, 0,
         KEY_SELECT, 0, 0, 0,
         0, 0, 0, 0,
         0, 0, KEY_KPAD_ENTER, 0,
         0, 0, KEY_WAKE, 0,
         0, 0, 0, 0,
         0, 0, 0, 0,
         0, KEY_END, 0, KEY_LEFT,
         KEY_HOME, 0, 0, 0,
         KEY_INSERT, KEY_DEL, KEY_DOWN, 0,
         KEY_RIGHT, KEY_UP, 0, 0,
         0, 0, KEY_PGDOWN, 0,
         0, KEY_PGUP, 0, 0,
         0, 0, 0, 0}};

    static const u8 scode_seq[3][8] = {
        {0xE0, 0x12, 0xE0, 0x7C},                        // print scr pressed
        {0xE0, 0xF0, 0x7C, 0xE0, 0xF0, 0x12},            // print scr released
        {0xE1, 0x14, 0x77, 0xE1, 0xF0, 0x14, 0xF0, 0x77} // pause pressed
    };
    u32 scode_seq_idx = 0;

    bool released = false, alternate = false, expecting_pause = false, expecting_prtscr = false, success = false, failed = false;
    u8 scode[32], latest_scode = 0, len = 0, key = 0;

    while (true)
    {
        if (failed)
            break;

        if (success)
        {
            push_key(key, released);
            break;
            // len = 0;
            // scode_seq_idx = 0;
            // released = alternate = expecting_pause = expecting_prtscr = success = false;
        }

        if (!kbd_read(&scode[len], false))
        {
            failed = true;
            continue;
            // if (len == 0 || failed)
            //     break;
        }
        latest_scode = scode[len++];

        if (expecting_pause)
        {
            if (latest_scode == scode_seq[2][scode_seq_idx])
            {
                if (++scode_seq_idx == 8)
                {
                    key = KEY_PAUSE;
                    success = true;
                }
            }
            else
                failed = true;
        }
        else if (expecting_prtscr)
        {
            if (latest_scode == scode_seq[released][released + scode_seq_idx])
            {
                ++scode_seq_idx;
                if ((scode_seq_idx == 4 && !released) || (scode_seq_idx == 6 && released))
                {
                    key = KEY_PRTSCR;
                    success = true;
                }
            }
            else
                failed = true;
        }
        else
        {
            switch (latest_scode)
            {
            case 0xE1:
            {
                expecting_pause = true;
                scode_seq_idx = 1;
            }
            break;
            case 0xE0:
            {
                alternate = true;
            }
            break;
            case 0xF0:
            {
                released = true;
            }
            break;
            default:
            {
                if (alternate && (latest_scode == 0x12 || latest_scode == 0x7C))
                {
                    expecting_prtscr = true;
                    scode_seq_idx = 2;
                }
                else if (latest_scode > 0x83)
                {
                    failed = true;
                }
                else
                {
                    key = key_mapping[alternate][latest_scode];
                    if (key == 0)
                        failed = true;
                    else
                        success = true;
                }
            }
            }
        }
    }

    if (failed)
    {
        printf("\nunexpecting scode seq(%d):", len);
        for (int i = 0; i < len; ++i)
        {
            printf(" 0x%x", scode[i]);
        }
    }
}

static void _irq_handler(void)
{
    kbd_decode_scode();

    // for PC-XT PPI used to reset kbd intr req signals
    u8 ack = port_read_byte(PS2_PORT_ACK);
    port_write_byte(PS2_PORT_ACK, ack | 0x80);
    port_write_byte(PS2_PORT_ACK, ack);
}

bool kbd_setup(void)
{
    u8 result[3], i = 0;

    kbd_write(KBD_CMD_DISABLE, true);
    while (kbd_read(result, false))
        ;

    if (result[0] != 0xfa)
    {
        printf("No Keyboard Connected! (KBD_CMD_DISABLE): %x\n", result[0]);
        goto Exit;
    }

    kbd_write(KBD_CMD_RESET, true);
    while (kbd_read(&result[i], false) && i < 2)
    {
        ++i;
    }
    if (result[0] != 0xfa || result[1] != 0xaa)
    {
        printf("Reset Keyboard Failed: %x %x\n", result[0], result[1]);
        goto Exit;
    }

    kbd_write(KBD_CMD_DISABLE, true);
    while (kbd_read(result, false))
        ;

    if (result[0] != 0xfa)
    {
        printf("No Keyboard Connected! (KBD_CMD_DISABLE): %x\n", result[0]);
        goto Exit;
    }

    kbd_write(KBD_CMD_INDENTIFY, true);
    i = 0;
    while (kbd_read(&result[i], false))
    {
        ++i;
    }
    if ((i == 1 || i == 3) && result[0] == 0xfa)
    {
        print_str("PS/2 keyboard type:");
        for (u8 j = 0; j < i; ++j)
        {
            printf(" %x", result[j]);
        }
        print_char('\n');
    }
    else
    {
        print_str("No Keyboard Connected! (KBD_CMD_INDENTIFY)");
        if (i)
        {
            print_char(':');
            for (u8 j = 0; j < i; ++j)
            {
                printf("%x ", result[j]);
            }
        }
        print_char('\n');
        goto Exit;
    }

    kbd_write(KBD_CMD_SCANCODE, true);
    kbd_write(2, true); // Set scan code set 2
    i = 0;
    while (kbd_read(&result[i], false))
    {
        ++i;
    }
    if (i != 2 || result[0] != 0xfa || result[1] != 0xfa)
    {
        print_str("Set Keyboard Typematic failed!");
        if (i)
        {
            print_char(':');
            for (u8 j = 0; j < i; ++j)
            {
                printf("%x ", result[j]);
            }
        }
        print_char('\n');
        goto Exit;
    }

    kbd_write(KBD_CMD_TYPEMATIC, true);
    kbd_write(0, true); // Repeat rate: 30Hz, Delay before keys repeat: 250ms
    i = 0;
    while (kbd_read(&result[i], false))
    {
        ++i;
    }
    if (i != 2 || result[0] != 0xfa || result[1] != 0xfa)
    {
        print_str("Set Keyboard Typematic failed!");
        if (i)
        {
            print_char(':');
            for (u8 j = 0; j < i; ++j)
            {
                printf("%x ", result[j]);
            }
        }
        print_char('\n');
        goto Exit;
    }

    kbd_write(KBD_CMD_ENABLE, true);
    if (!kbd_read(result, false) || (result[0] != 0xfa && result[0] != 0xfe))
    {
        print_str("Enable Keyboard function failed!\n");
        goto Exit;
    }

    pic_irq_set_entry(PS2_IRQ1, _irq_handler);
    pic_irq_enable(PS2_IRQ1);

    _kbd_avaliable = true;
Exit:
    return _kbd_avaliable;
}

bool kbd_get_key(struct kbd_key_packet *key)
{
    if (!_kbd_avaliable)
        return false;
    // u32 save_eflags = read_eflags();
    // disable();
    pic_irq_disable(PS2_IRQ1);
    bool ret = pop_key(key);
    // write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
    pic_irq_enable(PS2_IRQ1);
    return ret;
}
