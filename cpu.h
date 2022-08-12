#ifndef _CPU_H_
#define _CPU_H_ 1

#include "types.h"

#define CR0_PE_SHIFT 0
#define CR0_WP_SHIFT 16
#define CR0_CD_SHIFT 30
#define CR0_PG_SHIFT 31
#define CR0_PE (1 << CR0_PE_SHIFT)
#define CR0_WP (1 << CR0_WP_SHIFT)
#define CR0_CD (1 << CR0_CD_SHIFT)
#define CR0_PG (1 << CR0_PG_SHIFT)

#define EFLAGS_IF (1 << 9)

typedef union
{
	struct
	{
		u32 eax;
		u32 edx;
	};
	u64 quad_data;
} __attribute__((packed)) msr_data;

// void read_msr(u32 index, msr_data *data);
// void write_msr(u32 index, msr_data data);

// void cpuid(u32 index, u32 *eax, u32 *ebx, u32 *ecx, u32 *edx);

// u32 read_eflags(void);
// void write_eflags(u32 eflags);

// u32 read_cr0(void);
// u32 read_cr2(void);
// u32 read_cr3(void);
// u32 read_cr4(void);
// void write_cr0(u32 cr0);
// void write_cr2(u32 cr2);
// void write_cr3(u32 cr3);
// void write_cr4(u32 cr4);

inline static u32 read_eflags(void)
{
	u32 eflags;
	__asm__ __volatile__("pushfl\n\t"
						 "popl %0\n"
						 : "=r"(eflags)
						 :
						 : "memory");
	return eflags;
}

inline static u32 read_cr0(void)
{
	u32 cr0;
	__asm__ __volatile__("movl %%cr0, %0\n"
						 : "=r"(cr0)
						 :
						 : "memory");
	return cr0;
}

inline static u32 read_cr2(void)
{
	u32 cr2;
	__asm__ __volatile__("movl %%cr2, %0\n"
						 : "=r"(cr2)
						 :
						 : "memory");
	return cr2;
}

inline static u32 read_cr3(void)
{
	u32 cr3;
	__asm__ __volatile__("movl %%cr3, %0\n"
						 : "=r"(cr3)
						 :
						 : "memory");
	return cr3;
}

inline static u32 read_cr4(void)
{
	u32 cr4;
	__asm__ __volatile__("movl %%cr4, %0\n"
						 : "=r"(cr4)
						 :
						 : "memory");
	return cr4;
}

inline static void write_eflags(u32 eflags)
{
	__asm__ __volatile__("pushl %0\n\t"
						 "popfl\n"
						 :
						 : "r"(eflags)
						 : "memory");
}

inline static void write_cr0(u32 cr0)
{
	__asm__ __volatile__("movl %0, %%cr0\n"
						 :
						 : "r"(cr0)
						 : "memory");
}

inline static void write_cr2(u32 cr2)
{
	__asm__ __volatile__("movl %0, %%cr2\n"
						 :
						 : "r"(cr2)
						 : "memory");
}

inline static void write_cr3(u32 cr3)
{
	__asm__ __volatile__("movl %0, %%cr3\n"
						 :
						 : "r"(cr3)
						 : "memory");
}

inline static void write_cr4(u32 cr4)
{
	__asm__ __volatile__("movl %0, %%cr4\n"
						 :
						 : "r"(cr4)
						 : "memory");
}

inline static void read_msr(u32 index, msr_data *data)
{
	__asm__ __volatile__("rdmsr\n"
						 : "=a"(data->eax), "=d"(data->edx)
						 : "c"(index)
						 : "memory");
}

inline static void write_msr(u32 index, msr_data data)
{
	__asm__ __volatile__("wrmsr\n"
						 :
						 : "c"(index), "a"(data.eax), "d"(data.edx)
						 : "memory");
}

inline static void cpuid(u32 index, u32 *eax, u32 *ebx, u32 *ecx, u32 *edx)
{
	__asm__ __volatile__("cpuid\n"
						 : "=a"(*eax), "=b"(*ebx), "=c"(*ecx), "=d"(*edx)
						 : "a"(index)
						 : "memory");
}

inline static void disable(void)
{
	__asm__ __volatile__("cli\n" ::
							 : "memory");
}

inline static void enable(void)
{
	__asm__ __volatile__("sti\n" ::
							 : "memory");
}

inline static void halt(void)
{
	__asm__ __volatile__("hlt\n" ::
							 : "memory");
}

inline static void barrier(void)
{
	__asm__ __volatile__("" ::
							 : "memory");
}

inline static void cpu_relax(void)
{
	__asm__ __volatile__("pause\n" ::
							 : "memory");
}

#endif
