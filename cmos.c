#include "types.h"
#include "cmos.h"
#include "io.h"
#include "lib.h"
#include "console.h"
#include "pic.h"
#include "cpu.h"

// static volatile u32 _periodic_count;
static bool _rtc_bcd_mode;
static bool _rtc_12hour_format;
// static bool _rtc_daylight_saving;

#if 0
static void _irq_handler(void)
{
    ++_periodic_count;
    cmos_read_byte(CMOS_REG_STATUS_C);
}
#endif

void cmos_setup(void)
{
    /*
    Bits 6-4 = Time frequency divider - 32.768kHz
    Bits 3-0 = Periodic Interupt Rate - 1.024kHz
    */
    cmos_mask(CMOS_REG_STATUS_A, 0x26, 0x7f);
    // cmos_write_byte(CMOS_REG_STATUS_A, 0x26);    // 32.768KHz, 1.024KHz
    /*
    Clock Data Type: 0x4 - Binary
    Hour Data Type: 0x2 - 24 hour
    */
    cmos_mask(CMOS_REG_STATUS_B, 0x2, 0xff); // 24-hour BCD
    u8 status_b = cmos_read_byte(CMOS_REG_STATUS_B);
    _rtc_bcd_mode = (status_b & 0x4) == 0;
    _rtc_12hour_format = (status_b & 0x2) == 0;
    // _rtc_daylight_saving = (status_b & 0x1) == 1;

    cmos_read_byte(CMOS_REG_STATUS_C);
    cmos_read_byte(CMOS_REG_STATUS_D);
}

#if 0
void cmos_enable_periodic(void)
{
    _periodic_count = 0;
    // Enable Periodic Interupt: 0x40
    cmos_mask(CMOS_REG_STATUS_B, 0x40, 0);
    // cmos_read_byte(CMOS_REG_STATUS_C);
    pic_irq_set_entry(CMOS_IRQ, _irq_handler);
    pic_irq_enable(CMOS_IRQ);
}

void cmos_disable_periodic(void)
{
    // Disable Periodic Interupt: 0x40
    cmos_mask(CMOS_REG_STATUS_B, 0, 0x40);

    // pic_irq_disable(CMOS_IRQ);
    pic_irq_remove_entry(CMOS_IRQ);

    print_char('\n');
    print_dec(_periodic_count, 0);
    print_char('\n');
}
#endif

u8 cmos_read_byte(u8 reg)
{
    u32 save_eflags = read_eflags();
    disable();
    port_write_byte(CMOS_PORT_REG, reg);
    u8 data = port_read_byte(CMOS_PORT_DATA);
    write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
    return data;
}

void cmos_write_byte(u8 reg, u8 val)
{
    u32 save_eflags = read_eflags();
    disable();
    port_write_byte(CMOS_PORT_REG, reg);
    port_write_byte(CMOS_PORT_DATA, val);
    write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
}

void cmos_mask(u8 reg, u8 on, u8 off)
{
    u8 new_val = (cmos_read_byte(reg) & ~off) | on;
    cmos_write_byte(reg, new_val);
}

static bool cmos_rtc_wait(void)
{
    for (u8 times = 100; cmos_read_byte(CMOS_REG_STATUS_A) & CMOS_REG_STATUS_A_UIP && times; --times)
    {
        delay_ms(10);
    }

    return (cmos_read_byte(CMOS_REG_STATUS_A) & CMOS_REG_STATUS_A_UIP) == 0;
}

#if 0
bool cmos_rtc_read(u8 rtc_reg, u8 *val)
{
    if (rtc_reg <= CMOS_RTC_YEAR && !cmos_rtc_wait())
        return 0;

    *val = cmos_read_byte(rtc_reg);
    return 1;
}
#endif

bool cmos_rtc_time(struct rtc_time *tm)
{
    u8 century;
    // cmos_mask(CMOS_REG_STATUS_B, 0x80, 0);

    if (!cmos_rtc_wait())
        return false;

    tm->seconds = cmos_read_byte(CMOS_RTC_SECONDS);
    tm->minutes = cmos_read_byte(CMOS_RTC_MINUTES);
    tm->hours = cmos_read_byte(CMOS_RTC_HOURS);
    tm->day = cmos_read_byte(CMOS_RTC_DAY);
    tm->month = cmos_read_byte(CMOS_RTC_MONTH);
    tm->year = cmos_read_byte(CMOS_RTC_YEAR);
    century = cmos_read_byte(CMOS_RTC_CENTURY);

    if (_rtc_12hour_format)
    {
        print_str("\n[CMOS] unexpecting 12-hour format!\n");
        // pm = tm->hours & 0x80;
        // tm->hours &= 0x7f;
    }

    if (_rtc_bcd_mode)
    {
        tm->seconds = BCD2BIN(tm->seconds);
        tm->minutes = BCD2BIN(tm->minutes);
        tm->hours = BCD2BIN(tm->hours);
        tm->day = BCD2BIN(tm->day);
        tm->month = BCD2BIN(tm->month);
        tm->year = BCD2BIN(century) * 100 + BCD2BIN(tm->year);
    }

    return true;

#if 0
    bool ret = cmos_rtc_read(CMOS_RTC_SECONDS, &tm->seconds);
    ret = ret && cmos_rtc_read(CMOS_RTC_MINUTES, &tm->minutes);
    ret = ret && cmos_rtc_read(CMOS_RTC_HOURS, &tm->hours);
    ret = ret && cmos_rtc_read(CMOS_RTC_DAY, &tm->day);
    ret = ret && cmos_rtc_read(CMOS_RTC_MONTH, &tm->month);
    tm->year = 0;
    ret = ret && cmos_rtc_read(CMOS_RTC_YEAR, (u8 *)&tm->year);
    ret = ret && cmos_rtc_read(CMOS_RTC_CENTURY, &century);
    if (ret)
    {
        if (_rtc_12hour_format)
        {
            print_str("\n[CMOS] unexpecting 12-hour format!\n")
            // pm = tm->hours & 0x80;
            // tm->hours &= 0x7f;
        }
        if (_rtc_bcd_mode)
        {
            tm->seconds = BCD2BIN(tm->seconds);
            tm->minutes = BCD2BIN(tm->minutes);
            tm->hours = BCD2BIN(tm->hours);
            tm->day = BCD2BIN(tm->day);
            tm->month = BCD2BIN(tm->month);
            tm->year = BCD2BIN(century) * 100 + BCD2BIN(tm->year);
        }
        // if (_rtc_12hour_format && pm)
        // {
        // tm->hours += 12;
        // tm->hours %= 24;
        // }
    }
    return ret;
#endif
}
