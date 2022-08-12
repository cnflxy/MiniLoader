#ifndef _KBD_H_
#define _KBD_H_ 1

/*
** Intel 8048 Chip
** https://wiki.osdev.org/Keyboard
** https://wiki.osdev.org/PS/2_Keyboard
*/

#include "types.h"

#define KBD_CMD_SET_LED     0xED
#define KBD_CMD_ECHO        0xEE
#define KBD_CMD_SCANCODE    0xF0
#define KBD_CMD_INDENTIFY   0xF2
#define KBD_CMD_TYPEMATIC   0xF3
#define KBD_CMD_ENABLE      0xF4
#define KBD_CMD_DISABLE     0xF5
#define KBD_CMD_RESET       0xFF

struct kbd_key_packet
{
    u8 key;
    bool released;
};

bool kbd_setup(void);
bool kbd_get_key(struct kbd_key_packet *key);

#endif
