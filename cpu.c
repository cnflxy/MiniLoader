#include "cpu.h"

u32 inline read_eflags(void)
{
	u32 eflags;
	__asm__ __volatile__ ("pushfl\n\t"
					"popl %0\n"
					: "=r" (eflags)
					:
					: "memory");
	return eflags;
}

u32 inline read_cr0(void)
{
	u32 cr0;
	__asm__ __volatile__ ("movl %%cr0, %0\n"
					: "=r" (cr0)
					:
					: "memory");
	return cr0;
}

u32 inline read_cr2(void)
{
	u32 cr2;
	__asm__ __volatile__ ("movl %%cr2, %0\n"
					: "=r" (cr2)
					:
					: "memory");
	return cr2;
}

u32 inline read_cr3(void)
{
	u32 cr3;
	__asm__ __volatile__ ("movl %%cr3, %0\n"
					: "=r" (cr3)
					:
					: "memory");
	return cr3;
}

u32 inline read_cr4(void)
{
	u32 cr4;
	__asm__ __volatile__ ("movl %%cr4, %0\n"
					: "=r" (cr4)
					:
					: "memory");
	return cr4;
}

void inline write_eflags(u32 eflags)
{
	__asm__ __volatile__ ("pushl %0\n\t"
					"popfl\n"
					:
					: "r" (eflags)
					: "memory");
}

void inline write_cr0(u32 cr0)
{
	__asm__ __volatile__ ("movl %0, %%cr0\n"
					:
					: "r" (cr0)
					: "memory");
}

void inline write_cr2(u32 cr2)
{
	__asm__ __volatile__ ("movl %0, %%cr2\n"
					:
					: "r" (cr2)
					: "memory");
}

void inline write_cr3(u32 cr3)
{
	__asm__ __volatile__ ("movl %0, %%cr3\n"
					:
					: "r" (cr3)
					: "memory");
}

void inline write_cr4(u32 cr4)
{
	__asm__ __volatile__ ("movl %0, %%cr4\n"
					:
					: "r" (cr4)
					: "memory");
}

void inline read_msr(u32 index, msr_data *data)
{
	__asm__ __volatile__ ("rdmsr\n"
					: "=a" (data->eax), "=d" (data->edx)
					: "c" (index)
					: "memory");
}

void inline write_msr(u32 index, msr_data data)
{
	__asm__ __volatile__ ("wrmsr\n"
					:
					: "c" (index), "a" (data.eax), "d" (data.edx)
					: "memory");
}

void inline cpuid(u32 index, u32 *eax, u32 *ebx, u32 *ecx, u32 *edx)
{
	__asm__ __volatile__ ("cpuid\n"
					: "=a" (*eax), "=b" (*ebx), "=c" (*ecx), "=d" (*edx)
					: "a" (index)
					: "memory");
}

