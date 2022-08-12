#include "pic.h"
#include "console.h"
#include "cpu.h"
#include "io.h"

static pic_irq_entry _irq_entry[15];

static void pic_irq_mask(u16 on, u16 off)
{
    u8 master_on = on, master_off = off, slave_on = on >> 8, slave_off = off >> 8;
    port_write_byte(PIC_PORT_DATA_MASTER, (port_read_byte(PIC_PORT_DATA_MASTER) | master_off) & ~master_on);
    port_write_byte(PIC_PORT_DATA_SLAVE, (port_read_byte(PIC_PORT_DATA_SLAVE) | slave_off) & ~slave_on);
}

static void pic_eoi(u8 irq)
{
    if (irq >= 8)
        port_write_byte(PIC_PORT_CMD_SLAVE, PIC_EOI);
    port_write_byte(PIC_PORT_CMD_MASTER, PIC_EOI);
}

// In-Service Register
static u8 pic_isr_read(void)
{
    u8 isr;
    port_write_byte(PIC_PORT_CMD_SLAVE, 0x0b);
    isr = port_read_byte(PIC_PORT_CMD_SLAVE);
    if (!isr)
    {
        port_write_byte(PIC_PORT_CMD_MASTER, 0x0b);
        isr = port_read_byte(PIC_PORT_CMD_MASTER);
    }
    return isr;
}

// Intqrrupt Request Register
static u16 pic_irr_read(void)
{
    u16 irr_map;
    port_write_byte(PIC_PORT_CMD_SLAVE, 0x0a);
    irr_map = (u16)port_read_byte(PIC_PORT_CMD_SLAVE) << 8;
    port_write_byte(PIC_PORT_CMD_MASTER, 0x0a);
    irr_map |= port_read_byte(PIC_PORT_CMD_MASTER);
    return irr_map;
}

void pic_irq_common_handler(u8 irq)
{
    // print_str("\nenter pic_irq_common_handler\n");

    if (_irq_entry[irq])
        _irq_entry[irq]();
    else
    {
        // pic_irr_read();
        console_set_color(COLOR_NORMAL_BG, COLOR_LIGHT_RED);
        printf("\nIRQ%d not registered!\nirr=0x%x, isr=0x%x\n", irq, pic_irr_read(), pic_isr_read());
        // print_str("\nIRQ");
        // print_hex(irq, 4);
        // print_hex(pic_isr_read(), 4);
        // print_str(" entry not registered\n");
        console_set_color(COLOR_NORMAL_BG, COLOR_NORMAL_FG);
    }

    pic_eoi(irq);
}

void pic_setup(void)
{
    // ICW1
    port_write_byte(PIC_PORT_CMD_MASTER, PIC_ICW1_INIT | PIC_ICW1_ICW4); // ICW4 cascading 8byte edge
    port_write_byte(PIC_PORT_CMD_SLAVE, PIC_ICW1_INIT | PIC_ICW1_ICW4);

    // ICW2
    port_write_byte(PIC_PORT_DATA_MASTER, PIC_VECTOR_MASTER);
    port_write_byte(PIC_PORT_DATA_SLAVE, PIC_VECTOR_SLAVE);

    // ICW3
    port_write_byte(PIC_PORT_DATA_MASTER, 1 << PIC_IRQ_SLAVE_ATTACH);
    port_write_byte(PIC_PORT_DATA_SLAVE, PIC_IRQ_SLAVE_ATTACH);

    // ICW4
    port_write_byte(PIC_PORT_DATA_MASTER, PIC_ICW4_8086); // 80x86 normal no-buffered seq
    port_write_byte(PIC_PORT_DATA_SLAVE, PIC_ICW4_8086);

    // OCW1
    pic_irq_mask(1 << PIC_IRQ_SLAVE_ATTACH, 0xffff);
}

void pic_irq_set_entry(u8 irq, pic_irq_entry entry)
{
    if (irq <= 15 && irq != PIC_IRQ_SLAVE_ATTACH)
    {
        // u32 save_eflags = read_eflags();
        // disable();
        pic_irq_disable(irq);
        // pic_irq_mask(0, 1 << irq);
        _irq_entry[irq] = entry;
        // write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
    }
}

void pic_irq_remove_entry(u8 irq)
{
    if (irq <= 15 && irq != PIC_IRQ_SLAVE_ATTACH)
    {
        // u32 save_eflags = read_eflags();
        // disable();
        pic_irq_disable(irq);
        // pic_irq_mask(0, 1 << irq);
        _irq_entry[irq] = NULL;
        // write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
    }
}

void pic_irq_enable(u8 irq)
{
    if (irq <= 15 && irq != PIC_IRQ_SLAVE_ATTACH)
    {
        // u32 save_eflags = read_eflags();
        // disable();
        if (_irq_entry[irq] != NULL)
            pic_irq_mask(1 << irq, 0);
        // _irq_entry[irq] = entry;
        // write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
    }
}

void pic_irq_disable(u8 irq)
{
    if (irq <= 15 && irq != PIC_IRQ_SLAVE_ATTACH)
    {
        // u32 save_eflags = read_eflags();
        // disable();
        pic_irq_mask(0, 1 << irq);
        // _irq_entry[irq] = NULL;
        // write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
    }
}
