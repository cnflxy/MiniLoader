#ifndef _CMOS_H_
#define _CMOS_H_ 1

#define CMOS_PORT_REG   0x70
#define CMOS_PORT_DATA  0x71

#define CMOS_PORT_REG_NMI   0x80

#define CMOS_RTC_SECONDS        0x00
// #define CMOS_RTC_SECONDS_ALARM  0x01
#define CMOS_RTC_MINUTES        0x02
// #define CMOS_RTC_MINUTES_ALARM  0x03
#define CMOS_RTC_HOURS          0x04
// #define CMOS_RTC_HOURS_ALARM    0x05
#define CMOS_RTC_DAY_OF_WEEK    0x06
#define CMOS_RTC_DAY            0x07
#define CMOS_RTC_MONTH          0x08
#define CMOS_RTC_YEAR           0x09
#define CMOS_REG_STATUS_A       0x0a
#define CMOS_REG_STATUS_B       0x0b
#define CMOS_REG_STATUS_C       0x0c
#define CMOS_REG_STATUS_D       0x0d
#define CMOS_REG_FLOPPY_DRIVE_TYPES 0x10
#define CMOS_REG_CONFIGURATION      0x11
#define CMOS_REG_HARD_DISK_TYPES    0x12
//
#define CMOS_REG_EQUIPMENT_INFO     0x14
//
#define CMOS_RTC_CENTURY		0x32

#define CMOS_REG_STATUS_A_UIP   0x80    // must be clean then RTC can be read

#define CMOS_IRQ 8

struct rtc_time {
	u16 year;
	u8 month;
	u8 day;
	u8 hours;
	u8 minutes;
	u8 seconds;
};

void cmos_setup(void);
u8 cmos_read_byte(u8 reg);
void cmos_write_byte(u8 reg, u8 val);
void cmos_mask(u8 reg, u8 on, u8 off);
bool cmos_rtc_read(u8 rtc_reg, u8* val);
bool cmos_rtc_time(struct rtc_time* tm);

#if 0
void cmos_enable_periodic(void);
void cmos_disable_periodic(void);
#endif

#endif
