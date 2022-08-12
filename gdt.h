#ifndef _GDT_H_
#define _GDT_H_ 1

#include "types.h"

#define TI_RPL_KERNEL   0
#define TI_RPL_USER     3
#define TI_GDT  0
#define TI_LDT  4

#define SEG_4K_UNIT     0x0800
#define SEG_32BITS      0x0400
#define SEG_64BITS      0x0200
#define SEG_PRESENT     0x0080
#define SEG_DPL_KERNEL  0x0000
#define SEG_DPL_USER    0x0060

#define SEG_CODE_X      0x18
#define SEG_CODE_XR     0x1A
#define SEG_DATA_RO     0x10
#define SEG_DATA_RW     0x12
#define SEG_LDT         0x02
#define SEG_TSS_READY   0x09
#define SEG_TSS_BUSY    0x0B

struct gdt_ptr48
{
    u16 limit;
    u32 base;
} __attribute__((packed));

struct gdt_entry
{
    u32 base;
    u32 limit;
    u32 attr;
};

void gdt_set_entry(u32 seg, const struct gdt_entry *entry);
void gdt_get_entry(u32 seg, struct gdt_entry *entry);

inline static void lgdt(const struct gdt_ptr48 *ptr)
{
	__asm__ __volatile__("lgdt (%0)\n"
					 :
					 : "r"(ptr)
					 : "memory");
}

inline static void sgdt(struct gdt_ptr48 *ptr)
{
	__asm__ __volatile__("sgdt (%0)\n"
					 : "+r"(ptr)
					 :
					 : "memory");
}

#endif
