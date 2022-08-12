#include "bxdebug.h"
#include "io.h"

void bxdebug_break(void)
{
    port_write_word(0x8a00, 0x8a00);
    port_write_word(0x8a00, 0x8ae0);
}

