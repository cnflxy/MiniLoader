#ifndef _SB16_H_
#define _SB16_H_ 1

/**
 * https://www.gamedev.net/tutorials/programming/general-and-gameplay-programming/programming-the-soundblaster-16-r444/
 * https://www.gamedeveloper.com/disciplines/programming-digitized-sound-on-the-sound-blaster
 * http://www.dcee.net/Files/Programm/Sound/
 * https://wiki.osdev.org/Sound_Blaster_16
 * 
 * 
 * 
 *                  Digitized Sound Data Format
 * The digitized sound data is in Pulse Code Modulation (PCM) format.
 * For 8-bit PCM data, each sample is represented by an unsigned byte.
 * For 16-bit PCM data, each sample is represented by a 16-bit signed value.
 * 
 *                                  PCM Data Order
 *            8-bit mono      8-bit stereo       16-bit mono            16-bit stereo
 * SAMPLE:  |S1|S2|S3|S4|    |S1|S1|S2|S2|  |S1-L|S1-H|S2-L|S2-H|   |S1-L|S1-H|S1-L|S1-H|
 * CHANNEL: |C0|C0|C0|C0|    |C0|C1|C0|C1|  | C0 | C0 | C0 | C0 |   | C0 | C0 | C1 | C1 |
 * 
 * Time Constant = 65536 - (256 000 000/(channels * sampling rate))
 **/

#include "types.h"

#define SB16_PORT_MIXER_REG     0x4
#define SB16_PORT_MIXER_DATA    0x5
#define SB16_PORT_DSP_RESET     0x6
#define SB16_PORT_DSP_READ      0xa
#define SB16_PORT_DSP_WRITE     0xc
#define SB16_PORT_DSP_W_STATUS  0xc
#define SB16_PORT_DSP_R_STATUS  0xe
#define SB16_PORT_DSP_EOI0      0xe     // 8-bit DMA-mode digitized sound I/O or SB-MIDI
#define SB16_PORT_DSP_EOI1      0xf     // 16-bit DMA-mode digitized sound I/O
#define SB16_PORT_DSP_EOI2      0x100   // MPU-401 - 3x0h

#define SB16_MIXER_INTR_SETUP   0x80
#define SB16_MIXER_DMA_SETUP    0x81

// #define SB16_IRQ    5   // 2 5 7 10
// #define SB16_DMA8   1   // 0 1 3
// #define SB16_DMA16  5   // 5 6 7

void sb16_setup(void);
bool sb16_play(void *laddr, u32 len, u16 freq, bool is_16bits, bool is_stereo);

#endif
