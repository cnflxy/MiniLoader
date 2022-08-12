#include "types.h"
#include "pit.h"
#include "io.h"
#include "console.h"
#include "pic.h"

// static u32 _frequency, _ms, _fractions;

static u32 volatile _ticks; // , _fractions;

static void pit_irq_handler(void)
{
    ++_ticks;
    // 1194000 - 1193182 = 818
    // _fractions += 818;
    // if(_fractions >= 1193182) {
    //     ++_ticks;
    //     _fractions -= 1193182;
    // }
    // print_char('0');
}

void pit_setup(void)
{
    // 14.31818 MHz / 12
    // 1.193182 MHz
    // 1193182 Hz / 65536 = 18.2065 Hz
    // 65536 = 0x10000 = 0
    // 1193182 Hz / 1000 Hz = 1193 = 0x04A9
    // // but
    // // 1194 / 1193182 * 1000 * 1000 = 1000.68556 s
    // // more accurate
    port_write_byte(PIT_PORT_MODE_COMMAND, PIT_CHANNEL0 | PIT_LSB_MSB | PIT_MODE2 | PIT_BINARY);
    // port_write_byte(PIT_PORT_DATA_CHANNEL0, 0); // LSB
    // port_write_byte(PIT_PORT_DATA_CHANNEL0, 0); // MSB
    port_write_byte(PIT_PORT_DATA_CHANNEL0, 0xB0); // LSB
    port_write_byte(PIT_PORT_DATA_CHANNEL0, 0x04); // MSB

    pic_irq_set_entry(PIT_IRQ, pit_irq_handler);
    pic_irq_enable(PIT_IRQ);

    // port_write_byte(PIT_PORT_MODE_COMMAND, PIT_CHANNEL1 | PIT_LSB_MSB | PIT_MODE2 | PIT_BINARY);
    // port_write_byte(PIT_PORT_DATA_CHANNEL1, 0); // LSB
    // port_write_byte(PIT_PORT_DATA_CHANNEL1, 0); // MSB
    // port_write_byte(PIT_PORT_DATA_CHANNEL1, 0xA9); // LSB
    // port_write_byte(PIT_PORT_DATA_CHANNEL1, 0x04); // MSB

    /*
    port_write_byte(PIT_PORT_MODE_COMMAND, PIT_CHANNEL2 | PIT_LSB_MSB | PIT_MODE3 | PIT_BINARY);
    // port_write_byte(PIT_PORT_DATA_CHANNEL2, 0xA9);
    // port_write_byte(PIT_PORT_DATA_CHANNEL2, 0x04);
    port_write_byte(PIT_PORT_DATA_CHANNEL2, 0);
    port_write_byte(PIT_PORT_DATA_CHANNEL2, 0);
    */
}

/*
void pit_enable(void)
{
    u32 reload_value, tmp;

    if(freq <= 18) {
        reload_value = 0x10000;
    } else if(freq >= 1193181) {
        reload_value = 1;
    } else {
        reload_value = 3579545 / freq;
        reload_value += 3579545 % freq >= 3579545 / 2;
        tmp = reload_value;
        reload_value /= 3;
        reload_value += tmp % 3 >= 3 / 2;
    }

    _frequency = 3579545 / reload_value;
    _frequency += 3579545 % reload_value >= 3579545 / 2;
    tmp = _frequency;
    _frequency /= 3;
    _frequency += tmp % 3 >= 3 / 2;

    // 0xDBB3A062 * reload_value >> 10
   _ticks = 0;

   pic_irq_enable(PIT_IRQ, (u32)pit_irq_handler);
}

void pit_disable(void)
{
    pic_irq_disable(PIT_IRQ);
    
    print_char('\n');
    print_dec(_ticks, 0);
    print_char('\n');
}
*/

u32 pit_get_ticks(void)
{
    return _ticks;
}
