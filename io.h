#ifndef _IO_H_
#define _IO_H_ 1

#include "types.h"

/*
BIT Description
0   Alternate hot reset
1 	Alternate gate A20
2 	Reserved
3 	Security Lock
4* 	Watchdog timer status
5 	Reserved
6 	HDD 2 drive activity
7 	HDD 1 drive activity 
*/
#define SYSTEM_CONTROL_PORT_A 0x92
/*
BIT Description
0 	Timer 2 tied to speaker
1 	Speaker data enable
2 	Parity check enable
3 	Channel check enable
4 	Refresh request
5 	Timer 2 output
6* 	Channel check
7* 	Parity check 
*/
#define SYSTEM_CONTROL_PORT_B 0x61

// u8 port_read_byte(u16 port);
// u16 port_read_word(u16 port);
// u32 port_read_dword(u16 port);
// void port_write_byte(u16 port, u8 data);
// void port_write_word(u16 port, u16 data);
// void port_write_dword(u16 port, u32 data);

inline static void port_write_byte(u16 port, u8 data)
{
    __asm__ volatile("outb %0, %1"
                     :
                     : "a"(data), "dN"(port));
}

inline static u8 port_read_byte(u16 port)
{
    u8 data;
    __asm__ volatile("inb %1, %0"
                     : "=a"(data)
                     : "dN"(port));
    return data;
}

inline static void port_write_word(u16 port, u16 data)
{
    __asm__ volatile("outw %0, %1"
                     :
                     : "a"(data), "dN"(port));
}

inline static u16 port_read_word(u16 port)
{
    u16 data;
    __asm__ volatile("inw %1, %0"
                     : "=a"(data)
                     : "dN"(port));
    return data;
}

inline static void port_write_dword(u16 port, u32 data)
{
    __asm__ volatile("outl %0, %1"
                     :
                     : "a"(data), "dN"(port));
}

inline static u32 port_read_dword(u16 port)
{
    u32 data;
    __asm__ volatile("inl %1, %0"
                     : "=a"(data)
                     : "dN"(port));
    return data;
}

inline static void port_read_word_count(u16 port, volatile void *buffer, u32 count)
{
    __asm__ volatile("cld\n\trep insw"
                     : "+D"(buffer)
                     : "dN"(port), "c"(count)
                     : "memory");
}

inline static void port_write_word_count(u16 port, const volatile void *buffer, u32 count)
{
    __asm__ volatile("cld\n\trep outsw"
                     : "+S"(buffer)
                     : "dN"(port), "c"(count)
                     : "memory");
}

inline static void port_read_dword_count(u16 port, volatile void *buffer, u32 count)
{
    __asm__ volatile("cld\n\trep insl"
                     : "+D"(buffer)
                     : "dN"(port), "c"(count)
                     : "memory");
}

inline static void port_write_dword_count(u16 port, const volatile void *buffer, u32 count)
{
    __asm__ volatile("cld\n\trep outsl"
                     : "+S"(buffer)
                     : "dN"(port), "c"(count)
                     : "memory");
}

#endif
