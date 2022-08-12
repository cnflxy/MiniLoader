#ifndef _IDT_H_
#define _IDT_H_ 1

#include "types.h"

#define GATE_PRESENT 0x8000
#define GATE_DPL_KERNEL 0x0
#define GATE_DPL_USER 0x6000

// #define GATE_TYPE_TASK		0x0500
#define GATE_TYPE_INTERRUPT 0x0E00
#define GATE_TYPE_TRAP 0x0F00

struct idt_ptr48
{
	u16 limit;
	u32 base;
} __attribute__((packed));

struct trap_frame
{
	u32 cr0;
	u32 cr2;
	u32 cr3;
	u32 cr4;

	u32 edi;
	u32 esi;

	u32 ebp;
	u32 esp;

	u32 ebx;
	u32 edx;
	u32 ecx;
	u32 eax;

	u32 eip;
	u32 cs;

	u32 eflags;
} __attribute__((packed));

void idt_setup(void);

inline static void lidt(const struct idt_ptr48 *ptr)
{
	__asm__ volatile("lidt (%0)\n\t"
					 :
					 : "r"(ptr)
					 : "memory");
}

inline static void sidt(struct idt_ptr48 *ptr)
{
	__asm__ volatile("sidt (%0)\n\t"
					 :
					 : "r"(ptr)
					 : "memory");
}

#endif
