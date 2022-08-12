#ifndef _8042_H_
#define _8042_H_ 1

#include "types.h"

/*
Intel 8042 PS/2 Controller (Keyboard controller)

https://wiki.osdev.org/"8042"_PS/2_Controller
*/

#define PS2_PORT_DATA   0x60    // Data Port (Read/Write)
#define PS2_PORT_STATUS 0x64    // Status Register (Read)
#define PS2_PORT_CMD    0x64    // Command Register (Write)
#define PS2_PORT_ACK    0x61    // The PC-XT PPI had used port 0x61 to reset the keyboard interrupt request signal (among other unrelated functions)

#define PS2_SATTUS_OUT_FULL 0x01    // must be set before attempting to read data from IO port 0x60
#define PS2_STATUS_IN_FULL  0x02    // must be clear before attempting to write data to IO port 0x60 or IO port 0x64
#define PS2_STATUS_CMD      0x08    // 0 = data written to input buffer is data for PS/2 device
                                    // 1 = data written to input buffer is data for PS/2 controller command
#define PS2_STATUS_TIMEOUT  0x40    // 0 = no error, 1 = time-out error
#define PS2_STATUS_PARITY   0x80    // 0 = no error, 1 = parity error

#define PS2_CMD_READ_CONF   0x20    // Read Controller Configuration Byte 0
#define PS2_CMD_WRITE_CONF  0x60    // Write Controller Configuration Byte 0
#define PS2_CMD_DISABLE_2   0xA7    // Disable second PS/2 port (only if 2 PS/2 ports supported)
#define PS2_CMD_ENABLE_2    0xA8    // Enable second PS/2 port (only if 2 PS/2 ports supported)
#define PS2_CMD_TEST_2      0xA9    // Test second PS/2 port (only if 2 PS/2 ports supported)
#define PS2_CMD_TEST_PS2    0xAA    // Test PS/2 Controller (0x55 test passed, 0xFC test failed)
#define PS2_CMD_TEST_1      0xAB    // Test first PS/2 port
                                    // 0x00 test passed
                                    // 0x01 clock line stuck low
                                    // 0x02 clock line stuck high
                                    // 0x03 data line stuck low
                                    // 0x04 data line stuck high
#define PS2_CMD_DISABLE_1   0xAD    // Disable first PS/2 port
#define PS2_CMD_ENABLE_1    0xAE    // Enable first PS/2 port
#define PS2_CMD_READ_OUT    0xD0    // Read Controller Output Port
#define PS2_CMD_WRITE_OUT   0xD1    // Write next byte to Controller Output Port
                                    // Note: Check if output buffer is empty first

#define PS2_CONF_INTR1  0x1 // First PS/2 port interrupt (1 = enabled, 0 = disabled)
#define PS2_CONF_INTR2  0x2 // Second PS/2 port interrupt (1 = enabled, 0 = disabled, only if 2 PS/2 ports supported)
#define PS2_CONF_FLAG   0x4 // System Flag (1 = system passed POST, 0 = your OS shouldn't be running)
#define PS2_CONF_CLCK1  0x10    // First PS/2 port clock (1 = disabled, 0 = enabled)
#define PS2_CONF_CLCK2  0x20    // Second PS/2 port clock (1 = disabled, 0 = enabled, only if 2 PS/2 ports supported)
#define PS2_CONF_TRANSLATION    0x40    // First PS/2 port translation (1 = enabled, 0 = disabled)

#define PS2_OUT_RESET   0x1
#define PS2_OUT_A20     0x2
#define PS2_OUT_FULL1   0x10
#define PS2_OUT_FULL2   0x20

#define PS2_IRQ1    1   // first PS/2 device
#define PS2_IRQ2    12  // second PS/2 device

void ps2_setup(void);
bool ps2_write(u8 data, bool cmd, bool wait_infinite);
bool ps2_read(u8 *data, bool wait_infinite);

#endif
