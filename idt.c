#include "idt.h"
#include "io.h"
#include "cpu.h"
#include "segment.h"
#include "page.h"
#include "pic.h"
#include "console.h"

extern void kTrap0(void);
extern void kTrap1(void);
extern void kTrap2(void);
extern void kTrap3(void);
extern void kTrap4(void);
extern void kTrap5(void);
extern void kTrap6(void);
extern void kTrap7(void);
extern void kTrap8(void);
extern void kTrap9(void); // reserved
extern void kTrap10(void);
extern void kTrap11(void);
extern void kTrap12(void);
extern void kTrap13(void);
extern void kTrap14(void);
//	15 is reserved
extern void kTrap16(void);
extern void kTrap17(void);
extern void kTrap18(void);
extern void kTrap19(void);
extern void kTrap20(void);
// 	21-31 is reserved
// IRQ entry begin
extern void kTrap32(void);
extern void kTrap33(void);
// extern void kTrap34(void); // Cascaded
extern void kTrap35(void);
extern void kTrap36(void);
extern void kTrap37(void);
extern void kTrap38(void);
extern void kTrap39(void);
extern void kTrap40(void);
extern void kTrap41(void);
extern void kTrap42(void);
extern void kTrap43(void);
extern void kTrap44(void);
extern void kTrap45(void);
extern void kTrap46(void);
extern void kTrap47(void);

extern void kTrapReserved(void);

static struct idt_ptr48 gk_idt_ptr;

static const char *const exception_description[] =
	{
		"#DE: Divide By Zero (DIV and IDIV instructions)",
		"#DB: Debug Exception (Instruction, data, I/O breakpoints, single-step, and others)",
		" - : Nonmaskable external interrupt",
		"#BP: Breakpoint (INT3 instruction)",
		"#OF: Overflow (INTO instruction)",
		"#BR: Bound Range Exceeded (BOUND instruction)",
		"#UD: Invalid Opcode (UD instruction or reserved opcode)",
		"#NM: No Math Coprocessor (Floating-point or WAIT/FWAIT instruction)",
		"#DF: Double Fault (Any instruction that can generate an exception, an NMI, or an INTR)",
		" - : Coprocessor Segment Overrun (Floating-point instruction)",
		"#TS: Invalid TSS (Task switch or TSS access)",
		"#NP: Segment Not Present (Loading segment registers or accessing system segments)",
		"#SS: Stack-Segment Fault (Stack operations and SS register loads)",
		"#GP: General Protection (Any memory reference and other protection checks)",
		"#PF: Page Fault (Any memory reference)",
		" - : Intel Reserved",
		"#MF: Math Fault (x87 FPU floating-point or WAIT/FWAIT instruction)",
		"#AC: Alignment Check (Any data reference in memory)",
		"#MC: Machine Check (Error codes (if any) and source are model dependent)",
		"#XM: SIMD Floating-Point Exception (SSE/SSE2/SSE3 floating-point instructions)",
		"#VE: Virtualization Exception (EPT violations)"};

#define RESERVED_INDEX 15

static void set_idt_entry(u8 index, u32 entry, u16 type)
{
	// u32 save_eflags = read_eflags();
	// disable();
	u16 *idt_entry = (u16 *)(gk_idt_ptr.base + index * 8);
	idt_entry[0] = entry;
	idt_entry[1] = KERNEL_CS << 3;
	idt_entry[2] = type;
	idt_entry[3] = entry >> 16;
	// write_eflags(save_eflags);
}

static void print_trap_frame(const struct trap_frame *frame)
{
	print_str("EAX: 0x");
	print_hex(frame->eax, 8);
	print_str(" ECX: 0x");
	print_hex(frame->ecx, 8);
	print_str("\nEDX: 0x");
	print_hex(frame->edx, 8);
	print_str(" EBX: 0x");
	print_hex(frame->ebx, 8);

	print_str("\nESI: 0x");
	print_hex(frame->esi, 8);
	print_str(" EDI: 0x");
	print_hex(frame->edi, 8);

	print_str("\nCR0: 0x");
	print_hex(frame->cr0, 8);
	print_str(" CR2: 0x");
	print_hex(frame->cr2, 8);
	print_str("\nCR3: 0x");
	print_hex(frame->cr3, 8);
	print_str(" CR4: 0x");
	print_hex(frame->cr4, 8);

	print_str("\nCS: 0x");
	print_hex(frame->cs, 8);
	print_str(" EIP: 0x");
	print_hex(frame->eip, 8);

	print_str("\nEFLAGS: 0x");
	print_hex(frame->eflags, 8);
	print_char('\n');
}

void common_trap_handler(struct trap_frame frame, u32 index, u32 error_code)
{
	enum console_env old = console_set_env(CONSOLE_ENV_INTR);

	if (PIC_VECTOR_MASTER <= index && index <= PIC_VECTOR_SLAVE + 8)
	{
		pic_irq_common_handler(index - PIC_VECTOR_MASTER);
	}
	else
	{
		// print_str("\nenter common_trap_handler\n");
		if (index == PAGEFAULT_INDEX)
		{
			pagefault_exception_handler(&frame, error_code);
		}
		// console_clear_screen();
		console_set_color(COLOR_NORMAL_BG, COLOR_LIGHT_RED);
		print_str("vector: 0x");
		print_hex(index, 2);
		print_str("\nerror_code: 0x");
		print_hex(error_code, 0);
		print_char('\n');
		print_str(exception_description[index]);
		print_char('\n');
		print_trap_frame(&frame);

		// disable();
		halt();
		// for (;;)
		// 	;
	}

	console_set_env(old);
}

void idt_setup(void)
{
	sidt(&gk_idt_ptr);

	u32 type = GATE_PRESENT | GATE_TYPE_INTERRUPT;

	set_idt_entry(0, (u32)kTrap0, type | GATE_DPL_USER);
	set_idt_entry(1, (u32)kTrap1, type | GATE_DPL_USER);
	set_idt_entry(2, (u32)kTrap2, type);
	set_idt_entry(3, (u32)kTrap3, type | GATE_DPL_USER);
	set_idt_entry(4, (u32)kTrap4, type | GATE_DPL_USER);
	set_idt_entry(5, (u32)kTrap5, type);
	set_idt_entry(6, (u32)kTrap6, type);
	set_idt_entry(7, (u32)kTrap7, type);
	set_idt_entry(8, (u32)kTrap8, type);
	set_idt_entry(9, (u32)kTrap9, type);
	set_idt_entry(10, (u32)kTrap10, type);
	set_idt_entry(11, (u32)kTrap11, type);
	set_idt_entry(12, (u32)kTrap12, type);
	set_idt_entry(13, (u32)kTrap13, type);
	set_idt_entry(14, (u32)kTrap14, type);
	set_idt_entry(15, (u32)kTrapReserved, type);
	set_idt_entry(16, (u32)kTrap16, type);
	set_idt_entry(17, (u32)kTrap17, type);
	set_idt_entry(18, (u32)kTrap18, type);
	set_idt_entry(19, (u32)kTrap19, type);
	set_idt_entry(20, (u32)kTrap20, type);

	for (u8 i = 21; i <= 31; ++i)
	{
		set_idt_entry(i, (u32)kTrapReserved, type);
	}

	// IRQ entry
	set_idt_entry(32, (u32)kTrap32, type);
	set_idt_entry(33, (u32)kTrap33, type);
	set_idt_entry(34, (u32)kTrapReserved, type);
	set_idt_entry(35, (u32)kTrap35, type);
	set_idt_entry(36, (u32)kTrap36, type);
	set_idt_entry(37, (u32)kTrap37, type);
	set_idt_entry(38, (u32)kTrap38, type);
	set_idt_entry(39, (u32)kTrap39, type);
	set_idt_entry(40, (u32)kTrap40, type);
	set_idt_entry(41, (u32)kTrap41, type);
	set_idt_entry(42, (u32)kTrap42, type);
	set_idt_entry(43, (u32)kTrap43, type);
	set_idt_entry(44, (u32)kTrap44, type);
	set_idt_entry(45, (u32)kTrap45, type);
	set_idt_entry(46, (u32)kTrap46, type);
	set_idt_entry(47, (u32)kTrap47, type);

	for (u8 i = 255; i >= 48; --i)
	{
		set_idt_entry(i, (u32)kTrapReserved, type);
	}
}
