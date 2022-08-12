#ifndef _BXDEBUG_H_
#define _BXDEBUG_H_ 1

#include "io.h"

// void bxdebug_break(void);

inline static void bxdebug_break(void)
{
    port_write_word(0x8a00, 0x8a00);
    port_write_word(0x8a00, 0x8ae0);
}

#endif
