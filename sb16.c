#include "sb16.h"
#include "console.h"
#include "dma.h"
// #include "idt.h"
#include "io.h"
#include "pic.h"
#include "page.h"
#include "string.h"
#include "lib.h"

static bool _present;
static u16 _io_base;
static u8 _irq, _dma_8, _dma_16;

inline static u8 read_dsp(u8 reg)
{
    if (reg == SB16_PORT_DSP_READ)
    {
        while ((port_read_byte(_io_base + SB16_PORT_DSP_R_STATUS) & 0x80) == 0)
            ;
    }

    return port_read_byte(_io_base + reg);
}

static void write_dsp(u8 reg, u8 data)
{
    if (reg == SB16_PORT_DSP_WRITE)
    {
        while (port_read_byte(_io_base + SB16_PORT_DSP_W_STATUS) & 0x80)
            ;
    }

    port_write_byte(_io_base + reg, data);
}

static void write_dsp_cmd(u8 data)
{
    write_dsp(SB16_PORT_DSP_WRITE, data);
}

static bool reset_dsp(void)
{
    write_dsp(SB16_PORT_DSP_RESET, 1);
    delay_ms(3);
    write_dsp(SB16_PORT_DSP_RESET, 0);

    for (int i = 0; i < 65535; ++i)
    {
        if (read_dsp(SB16_PORT_DSP_R_STATUS) & 0x80)
        {
            if (read_dsp(SB16_PORT_DSP_READ) == 0xaa)
                return true;
        }
        // delay_ms(1);
    }

    return false;
}

static bool detect_sb16(void)
{
    for (_io_base = 0x220; _io_base <= 0x280; _io_base += 0x20)
    {
        if (reset_dsp())
            return true;
    }
    return false;
}

inline static u8 read_mixer(u8 reg)
{
    // CT1745 mixer chip
    write_dsp(SB16_PORT_MIXER_REG, reg);
    // delay_ms(1);
    return read_dsp(SB16_PORT_MIXER_DATA);
}

inline static void write_mixer(u8 reg, u8 data)
{
    write_dsp(SB16_PORT_MIXER_REG, reg);
    // delay_ms(1);
    write_dsp(SB16_PORT_MIXER_DATA, data);
}

static void reset_mixer(void)
{
    write_mixer(0x00, 0x00);
    delay_ms(10);
    write_mixer(0x43, 0x1);
}

#define DMA_BUFFER_LEN 8192*2

static bool _is_16bits;
// static bool _stopped;
static volatile bool _first_block_playing;
static volatile bool _first_block_need_fill;
static volatile bool _end_of_data;
static volatile bool _last_block_played;

// static volatile bool _second_last_block_played;
static void _irq_handler(void)
{
    u8 intr_status = read_mixer(0x82); // Interrupt Status

    // printf("SB16._irq_handler intr_status=0x%x\n", intr_status);

    if (_is_16bits)
    {
        if (intr_status & 2)
            read_dsp(SB16_PORT_DSP_EOI1);
    }
    else
        read_dsp(SB16_PORT_DSP_EOI0);

    // else if (intr_status & 2)
    // {
    //     read_dsp(SB16_PORT_DSP_EOI1);
    // }
    // else if (intr_status & 4)
    // {
    //     // read_dsp(SB16_PORT_DSP_EOI2);
    //     printf("\nunexpecting sb16 intr_status: 0x%x\n", intr_status);
    // }

    _first_block_playing = !_first_block_playing;

    // if (_second_last_block_played)
    // {
    //     print_char('?');
    //     _last_block_played = true;
    // }

    if (_end_of_data)
    {
        // print_char('#');
        // _second_last_block_played = true;
        _last_block_played = true;
    }
}

void sb16_setup(void)
{
    if (!detect_sb16())
    {
        console_set_color(COLOR_NORMAL_BG, COLOR_YELLOW);
        printf("SB not detected!\n");
        console_set_color(COLOR_NORMAL_BG, COLOR_NORMAL_FG);
        return;
    }

    write_dsp_cmd(0xE1); // Get DSP version
    u16 version = read_dsp(SB16_PORT_DSP_READ) << 8;
    version |= read_dsp(SB16_PORT_DSP_READ);

    if (version >> 8 >= 4)
    {
        reset_mixer();
        u8 irq_map = read_mixer(SB16_MIXER_INTR_SETUP) & 0xf; // Interrupt Setup
        u8 dma_map = read_mixer(SB16_MIXER_DMA_SETUP) & 0xeb; // DMA Setup

        printf("irq_map=0x%x, dma_map=0x%x\n", irq_map, dma_map);

        if (irq_map)
        {
            u8 bit = 0;
            while (irq_map >> (bit + 1))
                ++bit;
            u8 irqs[] = {2, 5, 7, 10};
            _irq = irqs[bit];
        }
        else
        {
            _irq = 5;
            write_mixer(SB16_MIXER_INTR_SETUP, 0x2);
        }

        bool need_setup_dma = false;
        if (dma_map & 0xb)
        {
            while (!(dma_map & (1 << _dma_8)))
                ++_dma_8;
        }
        else
        {
            need_setup_dma = true;
            _dma_8 = 1;
            dma_map |= 0x2;
        }

        _dma_16 = 5;
        if (dma_map & 0xe0)
        {
            while (!(dma_map & (1 << _dma_16)))
                ++_dma_16;
        }
        else
        {
            need_setup_dma = true;
            dma_map |= 0x20;
        }
        if (need_setup_dma)
            write_mixer(SB16_MIXER_DMA_SETUP, dma_map);

        printf("SB16 version: %d.%d\niobase: 0x%x\nirq: %d\ndma8: %d\ndma16: %d\n", version >> 8, version & 0xff, _io_base, _irq, _dma_8, _dma_16);

        _present = true;
    }
    else
    {
        printf("SB not SB16! version: %d.%d\n", version >> 8, version & 0xff);
    }
}

/**
 * freq: 5000 to 45000 Hz
 * PCM_s16le stereo/mono
 * PCM_u8 stereo/mono
 **/
bool sb16_play(void *laddr, u32 len, u16 freq, bool is_16bits, bool is_stereo)
{
    if (!_present || freq < 5000 || 45000 < freq || !len)
    {
        return false;
    }

    u8 *dma_buffer = alloc_page(DMA_BUFFER_LEN, dma_phy_mem);
    u32 dma_buf_paddr = get_paddr(dma_buffer);
    u8 dma_channel = is_16bits ? _dma_16 : _dma_8;
    u8 *cur_data_addr = laddr;
    u32 data_remain = len;
    u32 cur_play_count;

    _is_16bits = is_16bits;
    _first_block_playing = true;
    _first_block_need_fill = true;
    _end_of_data = false;
    _last_block_played = false;
    // _second_last_block_played = false;

    if (!reset_dsp())
    {
        printf("reset dsp failed!\n");
        free_page(dma_buffer);
        return false;
    }

    write_mixer(0x0a, 0x00); // MIC Volume
    write_mixer(0x04, 0xff); // VOC Volume

    pic_irq_set_entry(_irq, _irq_handler);
    pic_irq_enable(_irq);

    dma_prepare(dma_channel, dma_buf_paddr, DMA_BUFFER_LEN, true);

    // write_mixer(0x22, 0xFF);    // Master volume L.R
    // write_mixer(0x30, 30 << 3); // Master volume L
    // write_mixer(0x31, 30 << 3); // Master volume R
    write_dsp_cmd(0xD1); // turn on DAC speaker
    delay_ms(112);

    if (data_remain < DMA_BUFFER_LEN / 2)
    {
        memcpy(dma_buffer, cur_data_addr, data_remain);
        cur_play_count = data_remain;
        _end_of_data = true;
        // memset(_dma_buffer + _data_remain, 0, DMA_BUFFER_LEN - _data_remain);
        data_remain = 0;
    }
    else
    {
        memcpy(dma_buffer, cur_data_addr, DMA_BUFFER_LEN / 2);
        cur_play_count = DMA_BUFFER_LEN / 2;
        cur_data_addr += DMA_BUFFER_LEN / 2;
        data_remain -= DMA_BUFFER_LEN / 2;
    }
    _first_block_need_fill = false;

    if (cur_play_count <= 1 && is_16bits)
        cur_play_count = 2;
    else if (cur_play_count == 0 && !is_16bits)
        cur_play_count = 1;

    write_dsp_cmd(0x41); // set output rate
    write_dsp_cmd(freq >> 8);
    write_dsp_cmd(freq);

    // 00148429143 (5) DMA is 8b, 44100Hz, mono, output, mode 2, unsigned, normal speed, 44100 bps, 8707 usec/DMA

    u8 mode = is_stereo << 5 | is_16bits << 4;
    write_dsp_cmd(is_16bits ? 0xB6 : 0xC6); // transfer mode - D/A, AutoInit, FIFO
    write_dsp_cmd(mode);                    // type of sound data

    u16 count = cur_play_count;
    if (is_16bits)
        count >>= 1;
    count -= 1;

    write_dsp_cmd(count);
    write_dsp_cmd(count >> 8);

    if (cur_play_count < DMA_BUFFER_LEN / 2)
    {
        while (_first_block_playing)
            ;
    }
    else
    {
        do
        {
            while (_first_block_playing == _first_block_need_fill)
                ;

            // if (data_remain == 0)
            // {
            //     _end_of_data = true;
            // }
            // else
            // {
            u32 offset = _first_block_need_fill ? 0 : DMA_BUFFER_LEN / 2;
            if (data_remain < DMA_BUFFER_LEN / 2)
            {
                memcpy(dma_buffer + offset, cur_data_addr, data_remain);
                cur_play_count = data_remain;
                _end_of_data = true;
                data_remain = 0;
            }
            else
            {
                memcpy(dma_buffer + offset, cur_data_addr, DMA_BUFFER_LEN / 2);
                cur_play_count = DMA_BUFFER_LEN / 2;
                cur_data_addr += DMA_BUFFER_LEN / 2;
                data_remain -= DMA_BUFFER_LEN / 2;
            }
            _first_block_need_fill = !_first_block_need_fill;

            if (cur_play_count < DMA_BUFFER_LEN / 2)
            {
                if (cur_play_count <= 1 && is_16bits)
                    cur_play_count = 2;
                else if (cur_play_count == 0 && !is_16bits)
                    cur_play_count = 1;

                write_dsp_cmd(0x41); // set output rate
                write_dsp_cmd(freq >> 8);
                write_dsp_cmd(freq);

                u8 mode = is_stereo << 5 | is_16bits << 4;
                write_dsp_cmd(is_16bits ? 0xB2 : 0xC2); // transfer mode - D/A, Single-cycle, FIFO
                write_dsp_cmd(mode);                    // type of sound data

                u16 count = cur_play_count;
                if (is_16bits)
                    count >>= 1;
                count -= 1;

                write_dsp_cmd(count);
                write_dsp_cmd(count >> 8);

                // print_char('.');
            }
            // }

            // if (!data_remain)
            // {
            //     _end_of_data = true;
            //     break;
            // }
        } while (!_end_of_data);

        // print_char('!');

        while (!_last_block_played)
            ;
    }

    write_dsp_cmd(is_16bits ? 0xD9 : 0xDA); // stop auto-init DMA sound
    write_dsp_cmd(0xD3);                    // turn off DAC speaker

    // dma_release(_is_16bits ? _dma_16 : _dma_8);
    pic_irq_disable(_irq);
    free_page(dma_buffer);

    return true;
}
