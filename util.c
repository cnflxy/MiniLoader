#include "types.h"
#include "util.h"
#include "io.h"

void delay_ms(dword ms)
{
    volatile dword i, j;
    byte old_val, val;

    for (i = 0; i < ms; ++i) {
        j = 66;
        old_val = port_read_byte(0x61) & 0x10;
        while (j) {
            val = port_read_byte(0x61) & 0x10;
            if (old_val != val) {
                old_val = val;
                --j;
            }
        }
    }
}

void memory_copy(void *dst, const void *src, size_t count)
{
    if(!dst || !src || !count)
        return;
    
    __asm__ volatile ("rep movsb": : "D" (dst), "S" (src), "c" (count): "memory");
}

void memory_fill(void *dst, byte val, size_t count)
{
    if(!dst || !count)
        return;

    __asm__ volatile ("rep stosb": : "D" (dst), "a" (val), "c" (count): "memory");
}

