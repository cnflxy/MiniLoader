#ifndef _FLOPPY_H_
#define _FLOPPY_H_ 1

/*
http://isdaman.com/alsos/hardware/fdc/floppy.htm
https://wiki.osdev.org/Floppy_Disk_Controller
*/

#include "types.h"

// #define FDC_PORT_SRA    0x3f0   // STATUS_REGISTER_A(read-only)
// #define FDC_PORT_SRB    0x3f1   // STATUS_REGISTER_B(read-only)
#define FDC_PORT_DOR    0x03F2  // DIGITAL_OUTPUT_REGISTER(write-only)
// #define FDC_PORT_TDR    0x3f3   // TAPE_DRIVE_REGISTER
#define FDC_PORT_MSR    0x03F4  // MAIN_STATUS_REGISTER (read)
#define FDC_PORT_DSR    0x03F4  // Data Rate Select Register (write)
#define FDC_PORT_DATA   0x03F5  // DATA_FIFO
#define FDC_PORT_DIR    0x03F7  // DIGITAL_INPUT_REGISTER (read)
#define FDC_PORT_CCR    0x03F7  // CONFIGURATION_CONTROL_REGISTER (write)

/*
DOR[0..1]: Drive Select
*/
#define FDC_DOR_RESET      0x04 // enter reset mode when clean
#define FDC_DOR_DMA_IRQ    0x08
#define FDC_DOR_MOTOR_A    0x10
#define FDC_DOR_MOTOR_B    0x20
#define FDC_DOR_MOTOR_C    0x40
#define FDC_DOR_MOTOR_D    0x80

#define FDC_MSR_BUSY   0x10
#define FDC_MSR_IOD    0x40    // I/O direction (0 = CPU to FDC, 1 = FDC to CPU)
#define FDC_MSR_READY  0x80

// all with DEFAULT Precompensation Delays
#define FDC_DSR_1M      0x03
#define FDC_DSR_500K    0x00
#define FDC_DSR_300K    0x01
#define FDC_DSR_250K    0x02

#define FDC_CMD_SPECIFY         0x03    // 3 command bytes, 0 result bytes
#define FDC_CMD_SENSE_DRIVE     0x04    // 2 command bytes, 1 result bytes
#define FDC_CMD_WRITE_DATA      0xc5    // 9 command bytes, 7 result bytes
#define FDC_CMD_READ_DATA       0xe6    // 9 command bytes, 7 result bytes
#define FDC_CMD_RECALIBRATE     0x07    // 2 command bytes, 0 result bytes
#define FDC_CMD_SENSE_IRQ       0x08    // 1 command bytes, 2 result bytes
#define FDC_CMD_READ_ID         0x4a    // 2 command bytes, 7 result bytes
#define FDC_CMD_FORMAT_TRACK    0x4d    // 6 command bytes, 7 result bytes
#define FDC_CMD_SEEK            0x0f    // 3 command bytes, 0 result bytes
#define FDC_CMD_VERSION         0x10    // 1 command bytes, 1 result bytes

#define FDC_IRQ 6
#define FDC_DMA 2

void floppy_dumpinfo(void);

void floppy_setup(void);
bool floppy_prepare(u8 fd_n, bool transfer);
bool floppy_release(u8 fd_n);

void floppy_cmd_readid(void);
void floppy_cmd_version(void);

#endif
