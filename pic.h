#ifndef _PIC_H_
#define _PIC_H_ 1

/*
Intel 8259 PIC
*/

#include "idt.h"

#define PIC_PORT_CMD_MASTER     0x20
#define PIC_PORT_DATA_MASTER    0x21
#define PIC_PORT_CMD_SLAVE      0xa0
#define PIC_PORT_DATA_SLAVE     0xa1

#define PIC_VECTOR_MASTER   0x20
#define PIC_VECTOR_SLAVE    (PIC_VECTOR_MASTER + 8)

#define PIC_ICW1_ICW4       0x01
#define PIC_ICW1_SINGLE     0x02
#define PIC_ICW1_4BYTE      0x04
#define PIC_ICW1_LEVEL      0x08
#define PIC_ICW1_INIT       0x10

#define PIC_ICW4_8086       0x01
#define PIC_ICW4_AUTO       0x02
#define PIC_ICW4_BUF_SLAVE  0x08
#define PIC_ICW4_BUF_MASTER 0x0C
#define PIC_ICW4_NESTED     0x10

#define PIC_EOI 0x20

#define PIC_IRQ_SLAVE_ATTACH 2

#define PIC_IRQ0_MASTER (1 << 0)
#define PIC_IRQ1_MASTER (1 << 1)
#define PIC_IRQ2_MASTER (1 << PIC_IRQ_SLAVE_ATTACH)
#define PIC_IRQ3_MASTER (1 << 3)
#define PIC_IRQ4_MASTER (1 << 4)
#define PIC_IRQ5_MASTER (1 << 5)
#define PIC_IRQ6_MASTER (1 << 6)
#define PIC_IRQ7_MASTER (1 << 7)
#define PIC_IRQ8_SLAVE (1 << 8)
#define PIC_IRQ9_SLAVE (1 << 9)
#define PIC_IRQ10_SLAVE (1 << 10)
#define PIC_IRQ11_SLAVE (1 << 11)
#define PIC_IRQ12_SLAVE (1 << 12)
#define PIC_IRQ13_SLAVE (1 << 13)
#define PIC_IRQ14_SLAVE (1 << 14)
#define PIC_IRQ15_SLAVE (1 << 15)

typedef void(*pic_irq_entry)(void);

void pic_setup(void);
void pic_irq_set_entry(u8 irq, pic_irq_entry entry);
void pic_irq_remove_entry(u8 irq);
void pic_irq_enable(u8 irq);
void pic_irq_disable(u8 irq);

void pic_irq_common_handler(u8 irq);

#endif

