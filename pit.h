#ifndef _PIT_H_
#define _PIT_H_ 1

/*
Intel 8253/8254
*/

#define PIT_PORT_DATA_CHANNEL0  0x40    // (read/write)
// #define PIT_PORT_DATA_CHANNEL1  0x41    // (read/write - unusable)
#define PIT_PORT_DATA_CHANNEL2  0x42    // (read/write - PC speaker)
#define PIT_PORT_MODE_COMMAND   0x43    // (write only)

// Bit 0
#define PIT_BINARY    0x00
#define PIT_BCD       0x01
// Bit 1-3
#define PIT_MODE0     0x00  // interrupt on terminal count
#define PIT_MODE1     0x02  // hardware re-triggerable one-shot
#define PIT_MODE2     0x04  // rate generator (counter 1 default)
#define PIT_MODE3     0x06  // square wave generator (counter 0 default)
#define PIT_MODE4     0x08  // software triggered strobe
#define PIT_MODE5     0x0a  // hardware triggered strobe
#define PIT_MODE2_ALTERNATE 0x0c
#define PIT_MODE3_ALTERNATE 0x0f
// Bit 4-5
#define PIT_LATCH     0x00
#define PIT_MSB       0x10
#define PIT_LSB       0x20
#define PIT_LSB_MSB   0x30
// Bit 6-7
#define PIT_CHANNEL0  0x00
// #define PIT_CHANNEL1  0x40
#define PIT_CHANNEL2  0x80
// #define PIT_READBACK  0xc0  // 8254 only

#define PIT_IRQ 0   // only for channel 0

void pit_setup(void);
// void pit_enable(void);
// void pit_disable(void);
u32 pit_get_ticks(void);

#endif
