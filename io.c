#include "io.h"
// #include "cpu.h"

void inline port_write_byte(u16 port, u8 data)
{
	__asm__ inline("outb %0, %1"
					 :
					 : "a"(data), "d"(port)
					 :);
}

u8 inline port_read_byte(u16 port)
{
	u8 data;
	__asm__ volatile("inb %1, %0"
					 : "=a"(data)
					 : "d"(port)
					 :);
	return data;
}

void inline port_write_word(u16 port, u16 data)
{
	__asm__ inline("outw %0, %1"
					 :
					 : "a"(data), "d"(port)
					 :);
}

u16 inline port_read_word(u16 port)
{
	u16 data;
	__asm__ volatile("inw %1, %0"
					 : "=a"(data)
					 : "d"(port)
					 :);
	return data;
}

void inline port_write_dword(u16 port, u32 data)
{
	__asm__ inline("outl %0, %1"
					 :
					 : "a"(data), "d"(port)
					 :);
}

u32 inline port_read_dword(u16 port)
{
	u32 data;
	__asm__ volatile("inl %1, %0"
					 : "=a"(data)
					 : "d"(port)
					 :);
	return data;
}
