#include "floppy.h"
#include "io.h"
#include "cmos.h"
#include "console.h"
#include "pic.h"
#include "lib.h"
// #include "bxdebug.h"

static u8 _drive_count;
static u8 _drive_type[2];
static u8 _fdc_dor;
static volatile u8 _irq_trigger;

static u8 read_dor(void)
{
    return _fdc_dor;
}

static void write_dor(u8 dor)
{
    _fdc_dor = dor;
    port_write_byte(FDC_PORT_DOR, dor);
}

static void mask_dor(u8 on, u8 off)
{
    write_dor((read_dor() & ~off) | on);
}

static void _irq_handler(void)
{
    // print_str("fdc irq handler triggered!\n");
    ++_irq_trigger;
}

static bool wait_fdc_ready(void)
{
    s8 times = 100;
    u8 msr;
    do
    {
        delay_ms(10);
        msr = port_read_byte(FDC_PORT_MSR);
    } while (times-- && (msr & FDC_MSR_BUSY) && !(msr & FDC_MSR_READY));

    return times >= 0;
}

static bool wait_irq_ready(void)
{
    s8 times = 100;

    do
    {
        delay_ms(10);
    } while (times-- && !_irq_trigger);

    if (_irq_trigger)
    {
        --_irq_trigger;
        return true;
    }

    return false;
}

void floppy_dumpinfo(void)
{
    if (!_drive_count)
    {
        console_set_color(COLOR_NORMAL_BG, COLOR_YELLOW);
        print_str("no floppy drive installed!\n");
        console_set_color(COLOR_NORMAL_BG, COLOR_NORMAL_FG);
        return;
    }

    printf("fd_count: %d\n", _drive_count);

    u8 type[2];
    type[1] = cmos_read_byte(CMOS_REG_FLOPPY_DRIVE_TYPES);
    /*
        CMOS_REG_FLOPPY_DRIVE_TYPES
        Bits 7 to 4 – Disk 0 (A:)
        Bits 3 to 0 – Disk 1 (B:)
            0000 - no drive
            0001 - 360k
            0010 - 1.2M
            0011 - 720k
            0100 - 1.44M
            0101 - 2.88M
        */
    type[0] = type[1] >> 4;
    type[1] &= 0xf;

    static const char *fd_type[] = {"none", "360k", "1.2M", "720k", "1.44M", "2.88M"};

    printf("fd0_type: %s\nfd1_type: %s\n",
           type[0] > 5 ? fd_type[0] : fd_type[type[0]],
           type[1] > 5 ? fd_type[1] : fd_type[type[1]]);
}

void floppy_setup(void)
{
    u8 equ = cmos_read_byte(CMOS_REG_EQUIPMENT_INFO);
    /*
    CMOS_REG_EQUIPMENT_INFO
    Bits 6 & 7 – No. Of Floppy Drives
            00=1, 01=2, 10=3, 11=4
    Bit 0 – Floppy Drive(s) Available
    */
    _drive_count = (equ >> 6) + (equ & 1);

    if (!_drive_count)
    {
        return;
    }

    // for(u8 drive = 0; drive < _drive_count; ++drive)
    // write_dor(drive);
    write_dor(0);
}

bool floppy_prepare(u8 fd_n, bool transfer)
{
    if (fd_n >= _drive_count)
        return false;

    _drive_type[1] = cmos_read_byte(CMOS_REG_FLOPPY_DRIVE_TYPES);
    /*
        CMOS_REG_FLOPPY_DRIVE_TYPES
        Bits 7 to 4 – Disk 0 (A:)
        Bits 3 to 0 – Disk 1 (B:)
            0000 - no drive
            0001 - 360k
            0010 - 1.2M
            0011 - 720k
            0100 - 1.44M
            0101 - 2.88M
        */
    _drive_type[0] = _drive_type[1] >> 4;
    _drive_type[1] &= 0xf;

    if (!_drive_type[fd_n])
    {
        return false;
    }

    _irq_trigger = 0;
    pic_irq_set_entry(FDC_IRQ, _irq_handler);
    pic_irq_enable(FDC_IRQ);
    write_dor((FDC_DOR_MOTOR_A << fd_n) | FDC_DOR_DMA_IRQ | fd_n);
    // mask_dor((FDC_DOR_MOTOR_A << fd_n) | FDC_DOR_DMA_IRQ | fd_n, FDC_DOR_RESET);
    delay_ms(100);
    mask_dor(FDC_DOR_RESET, 0);
    return wait_irq_ready();
}

bool floppy_release(u8 fd_n)
{
    if (fd_n >= _drive_count)
    {
        return false;
    }

    mask_dor(0, FDC_DOR_RESET);
    delay_ms(100);
    if (wait_fdc_ready())
    {
        mask_dor(FDC_DOR_RESET, (FDC_DOR_MOTOR_A << fd_n) | FDC_DOR_DMA_IRQ);
        delay_ms(50);
        wait_irq_ready();
    }
    pic_irq_remove_entry(FDC_IRQ);
    return true;
}

void floppy_cmd_readid(void)
{
    u8 send_len = 2, recv_len = 7;

    for (; send_len; --send_len)
    {
        if (!wait_fdc_ready())
            break;

        if (port_read_byte(FDC_PORT_MSR) & FDC_MSR_IOD)
            break;

        if (send_len == 2)
            port_write_byte(FDC_PORT_DATA, FDC_CMD_READ_ID);
        else
            port_write_byte(FDC_PORT_DATA, 0);
    }

    if (!send_len)
    { // in BOCHS irq not triggered
        wait_irq_ready();
        print_str("result: ");
        for (; recv_len; --recv_len)
        {
            if (!wait_fdc_ready())
                break;

            if (!(port_read_byte(FDC_PORT_MSR) & FDC_MSR_IOD))
                break;

            print_hex(port_read_byte(FDC_PORT_DATA), 2);
            print_char(' ');
        }
    }

    if (send_len || recv_len)
    {
        print_str("failed!");
    }
    print_char('\n');
}

void floppy_cmd_version(void)
{
    u8 send_len = 1, recv_len = 1;

    for (; send_len; --send_len)
    {
        if (!wait_fdc_ready())
            break;

        if (port_read_byte(FDC_PORT_MSR) & FDC_MSR_IOD)
            break;

        if (send_len == 1)
            port_write_byte(FDC_PORT_DATA, FDC_CMD_VERSION);
    }

    if (!send_len)
    { // in BOCHS irq not triggered
        wait_irq_ready();
        print_str("result: ");
        for (; recv_len; --recv_len)
        {
            if (!wait_fdc_ready())
                break;

            if (!(port_read_byte(FDC_PORT_MSR) & FDC_MSR_IOD))
                break;

            print_hex(port_read_byte(FDC_PORT_DATA), 2);
            print_char(' ');
        }
    }

    if (send_len || recv_len)
    {
        print_str("failed!");
    }
    print_char('\n');
}
