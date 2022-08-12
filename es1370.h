#ifndef _ES1370_H_
#define _ES1370_H_ 1

#include "types.h"

#define ES1370_PCI_VENID    0x1274
#define ES1370_PCI_DEVID    0x5000

#define ES1370_REG_CONTROL      0x00    // Interrupt/Chip Select Control Register
#define ES1370_REG_STATUS       0x04    // Interrupt/Chip Select Status Register
#define ES1370_REG_UART_DATA    0x08    // UART Data Register
#define ES1370_REG_UART_STATUS  0x09    // UART Status Register
#define ES1370_REG_UART_CTRL    0x09    // UART Control Register
#define ES1370_REG_UART_RES     0x0A    // UART Reserved Register
#define ES1370_REG_MEM_PAGE     0x0C    // Memory Page Register
#define ES1370_REG_CODEC        0x10    // CODEC Write Register - AK4531 Codec
#define ES1370_REG_SERIAL       0x20    // Serial Interface Control Register
#define ES1370_REG_DAC1_COUNT   0x24    // DAC1 Channel Sample Count Register
#define ES1370_REG_DAC2_COUNT   0x28    // DAC2 Channel Sample Count Register
#define ES1370_REG_ADC_COUNT    0x2C    // ADC Channel Sample Count Register
#define ES1370_REG_DAC1_FRAME   0x30    // DAC1 Frame Address Register
#define ES1370_REG_DAC1_SIZE    0x34    // DAC1 Frame Size Register
#define ES1370_REG_DAC2_FRAME   0x38    // DAC2 Frame Address Register
#define ES1370_REG_DAC2_SIZE    0x3C    // DAC2 Frame Size Register
#define ES1370_REG_ADC_FRAME    0x30    // ADC Frame Address Register
#define ES1370_REG_ADC_SIZE     0x34    // ADC Frame Size Register

void es1370_setup(void);
bool es1370_play(void *laddr, u32 len, u16 freq, u8 width, u8 channels);

#endif
