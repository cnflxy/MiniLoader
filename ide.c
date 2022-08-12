#include "ide.h"
#include "disk.h"
#include "ata.h"
#include "pci.h"
#include "console.h"
#include "io.h"
#include "lib.h"
#include "pic.h"

/**
 * PCI IDE Controller have 2 Channel (Primary, Secondary)
 * Each Channel have 2 devices
 **/

struct device_info
{
    bool present;
    u8 device_type;
    u8 media_type;

    // u16 signature;
    // u16 capabilities;
    // u8 features;
    // char serial_number[20];
    // char firmware_revision[8];
    // char model_number[40];
    // u8 max_sectors_per_transfer;    // ATA_CMD_READ_MULTIPLE, ATA_CMD_WRITE_MULTIPLE
    struct disk_geomtery geomtery;

    u16 identify_data[256];
};

struct ide_info
{
    bool present;
    struct pci_dev_info controller;
    struct
    {
        struct device_info device[2];
        u8 cur_mode;
        bool can_change_mode;
        u32 cmd_base;
        u32 ctrl_base;
        u32 busmaster_base;
        bool irq_disable;
    } channel[2];
    // bool dma_enabled;
    bool support_dma;
    // u32 busmaster_base;
};

static struct ide_info _ide_info;
// static u32 _irq0_invoked, _irq1_invoked;

static void _irq_handler0(void)
{
    // ++_irq0_invoked;
    // printf("_irq0_invoked=%d\n", _irq0_invoked);
}

static void _irq_handler1(void)
{
    // ++_irq1_invoked;
    // printf("_irq0_invoked=%d\n", _irq0_invoked);
}

static void ide_write(u8 channel, u8 reg, u8 data)
{
    if (ATA_REG_COMMAND < reg && reg < ATA_REG_CONTROL)
    {
        ide_write(channel, ATA_REG_CONTROL, ATA_CONTROL_HOB | _ide_info.channel[channel].irq_disable << ATA_CONTROL_NIEN_SHIFT);
        port_write_byte(_ide_info.channel[channel].cmd_base + reg - ATA_REG_SECTOR_COUNT1 + ATA_REG_SECTOR_COUNT0, data);
        ide_write(channel, ATA_REG_CONTROL, _ide_info.channel[channel].irq_disable << ATA_CONTROL_NIEN_SHIFT);
    }
    else if (reg <= ATA_REG_COMMAND)
    {
        port_write_byte(_ide_info.channel[channel].cmd_base + reg, data);
    }
    else if (reg <= ATA_REG_CONTROL)
    {
        port_write_byte(_ide_info.channel[channel].ctrl_base + reg - ATA_REG_CONTROL, data);
    }
    else if (reg < IDE_REG_BM_COMMAND + 8)
    {
        port_write_byte(_ide_info.channel[channel].busmaster_base + reg - IDE_REG_BM_COMMAND, data);
    }
    else
    {
        printf("%s(): unexpecting reg: 0x%x\n", __func__, reg);
    }
}

static u8 ide_read(u8 channel, u8 reg)
{
    u8 data;

    if (ATA_REG_STATUS < reg && reg < ATA_REG_ALTSTATUS)
    {
        ide_write(channel, ATA_REG_CONTROL, ATA_CONTROL_HOB | _ide_info.channel[channel].irq_disable << ATA_CONTROL_NIEN_SHIFT);
        data = port_read_byte(_ide_info.channel[channel].cmd_base + reg - ATA_REG_SECTOR_COUNT1 + ATA_REG_SECTOR_COUNT0);
        ide_write(channel, ATA_REG_CONTROL, _ide_info.channel[channel].irq_disable << ATA_CONTROL_NIEN_SHIFT);
    }
    else if (reg <= ATA_REG_STATUS)
    {
        data = port_read_byte(_ide_info.channel[channel].cmd_base + reg);
    }
    else if (reg <= ATA_REG_ALTSTATUS)
    {
        data = port_read_byte(_ide_info.channel[channel].ctrl_base + reg - ATA_REG_ALTSTATUS);
    }
    else if (reg < IDE_REG_BM_COMMAND + 8)
    {
        data = port_read_byte(_ide_info.channel[channel].busmaster_base + reg - IDE_REG_BM_COMMAND);
    }
    else
    {
        printf("%s(): unexpecting reg: 0x%x\n", __func__, reg);
        data = 0;
    }

    return data;
}

static s8 ide_wait(u8 channel, bool check_err, u8 *err)
{
    u8 status;
    int times = 30000;
    s8 ret = 0;

    while (true)
    {
        status = ide_read(channel, ATA_REG_STATUS);
        if (status & ATA_STATUS_BSY)
        {
            if (times-- == 0)
            {
                ret = -2;
                break;
            }
            continue;
        }
        break;

        // if ((status & (ATA_STATUS_BSY | ATA_STATUS_DRDY)) == ATA_STATUS_DRDY)
        //     break;
        // if (status & (ATA_STATUS_ERR | ATA_STATUS_DRQ))
        // {
        //     ret = -1;
        //     break;
        // }
    }

    if (check_err)
    {
        if ((status & (ATA_STATUS_DF | ATA_STATUS_ERR)) || !(status & ATA_STATUS_DRQ))
        {
            ret = -1;
            *err = status;
        }
    }
    return ret;
}

// static u8 _ide_buf[512];

static bool detect_ide(void)
{
}

static void init_ide(void)
{
    ide_write(0, ATA_REG_CONTROL, ATA_CONTROL_NIEN);
    ide_write(1, ATA_REG_CONTROL, ATA_CONTROL_NIEN);

    _ide_info.channel[0].irq_disable = true;
    _ide_info.channel[1].irq_disable = true;

    for (u8 c = 0; c < 2; ++c)
    {
        for (u8 d = 0; d < 2; ++d)
        {
            _ide_info.channel[c].device[d].present = false;

            ide_write(c, ATA_REG_DEVICE, 0xA0 | (d << ATA_DEVICE_DEV_SHIFT));
            delay_ms(1);

            ide_write(c, ATA_REG_COMMAND, ATA_CMD_IDENTIFY);
            delay_ms(1);

            u8 err;
            if ((err = ide_read(c, ATA_REG_STATUS)) == 0 || err == 0xff)
            {
                printf("IDE %d:%d timeout\n", c, d);
                continue;
            }

            s8 status = ide_wait(c, true, &err);

            u8 type = 1;
            if (status == -2)
            {
                printf("IDE %d:%d timeout\n", c, d);
                continue;
            }
            else if (status == -1)
            {
                u8 sig1 = ide_read(c, ATA_REG_LBA1), sig2 = ide_read(c, ATA_REG_LBA2);
                if (sig1 != 0x14 || sig2 != 0xEB)
                {
                    // _ide_info.channel[c].device[d].present = false;
                    continue;
                }

                type = 2;
                ide_write(c, ATA_REG_COMMAND, ATA_CMD_IDENTIFY_PACKET);
                // ide_wait(c, false, NULL);
                delay_ms(1);
            }

            port_read_dword_count(_ide_info.channel[c].cmd_base + ATA_REG_DATA, _ide_info.channel[c].device[d].identify_data, 128);

            _ide_info.channel[c].device[d].present = true;
            _ide_info.channel[c].device[d].device_type = type;

            printf("\nIDE %d:%d %d, %x, %d, ", c, d, type,
                   _ide_info.channel[c].device[d].identify_data[0],
                   _ide_info.channel[c].device[d].identify_data[47] & 0xff);

            if (_ide_info.channel[c].device[d].identify_data[83] & (1 << 10)) // 48-bit Address feature set supported
            {
                printf("LBA48 - 0x%x_%x",
                       _ide_info.channel[c].device[d].identify_data[102],
                       *(u32 *)&_ide_info.channel[c].device[d].identify_data[100]);
            }
            else
            {
                if (_ide_info.channel[c].device[d].identify_data[49] & (1 << 9)) // 28-bit Address feature set supported
                    print_str("LBA28 - ");
                else
                    print_str("CHS - ");
                printf("0x%x",
                       *(u32 *)&_ide_info.channel[c].device[d].identify_data[60]);
            }

            print_str("\nSerial number: ");
            for (u8 i = 10; i <= 19; ++i)
            {
                printf("%c%c", _ide_info.channel[c].device[d].identify_data[i] >> 8, _ide_info.channel[c].device[d].identify_data[i] & 0xff);
            }

            print_str("\nFirmware revision: ");
            for (u8 i = 23; i <= 26; ++i)
            {
                printf("%c%c", _ide_info.channel[c].device[d].identify_data[i] >> 8, _ide_info.channel[c].device[d].identify_data[i] & 0xff);
            }

            print_str("\nModel number: ");
            for (u8 i = 27; i <= 46; ++i)
            {
                printf("%c%c", _ide_info.channel[c].device[d].identify_data[i] >> 8, _ide_info.channel[c].device[d].identify_data[i] & 0xff);
            }
            print_char('\n');
        }
    }

    ide_write(0, ATA_REG_CONTROL, 0);
    ide_write(1, ATA_REG_CONTROL, 0);

    _ide_info.channel[0].irq_disable = false;
    _ide_info.channel[1].irq_disable = false;
}

#if 0
void ata_identify(int devid)
{
    u32 cmd_base = _ide_info.channel[devid >> 1].cmd_base;
    u32 ctrl_base = _ide_info.channel[devid >> 1].ctrl_base;
    u32 dev = devid & 0x1;

    while ((port_read_byte(cmd_base + ATA_REG_STATUS) & ATA_STATUS_DRDY) == 0)
        ;
    port_write_byte(cmd_base + ATA_REG_DEVICE, dev << 4);
    port_write_byte(cmd_base + ATA_REG_COMMAND, ATA_CMD_IDENTIFY_DEVICE);

    port_read_byte(ctrl_base + ATA_REG_ALTSTATUS);
    port_read_byte(ctrl_base + ATA_REG_ALTSTATUS);
    port_read_byte(ctrl_base + ATA_REG_ALTSTATUS);
    port_read_byte(ctrl_base + ATA_REG_ALTSTATUS);

    while ((port_read_byte(cmd_base + ATA_REG_STATUS) & ATA_STATUS_BSY) == ATA_STATUS_BSY)
        ;
    if ((port_read_byte(cmd_base + ATA_REG_STATUS) & ATA_STATUS_DRQ) == ATA_STATUS_DRQ)
    {
        for (u32 i = 0; i < 128; ++i)
            printf("%x ", port_read_dword(cmd_base + ATA_REG_DATA));
    }
}
#endif

void ide_setup(void)
{
    struct pci_dev_info *dev_info = &_ide_info.controller;
    dev_info->class = 0x1;    // Mass storage controller
    dev_info->subclass = 0x1; // IDE controller

    _ide_info.present = pci_dev_find(dev_info, false);
    if (!_ide_info.present)
    {
        console_set_color(COLOR_NORMAL_BG, COLOR_YELLOW);
        print_str("IDE Controller not present!\n");
        console_set_color(COLOR_NORMAL_BG, COLOR_NORMAL_FG);
        return;
    }

    printf("IDE Controller\n"
           "PCI/BUS_%x&DEV_%x&FUNC_%x"
           "&VEN_%x&DEV_%x&CLASS_%x&SUB_%x&IF_%x&REV_%x\n",
           dev_info->bus, dev_info->dev, dev_info->func,
           dev_info->ven_id, dev_info->dev_id,
           dev_info->class, dev_info->subclass, dev_info->progif, dev_info->rev);
    
    u32 subsys_ven, status_cmd;
    subsys_ven = pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, 11);
    printf("subsys: 0x%x, ven: 0x%x\n", subsys_ven >> 16, subsys_ven & 0xffff);
    status_cmd = pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, 1);
    printf("status: 0x%x, command: 0x%x\n", status_cmd >> 16, status_cmd & 0xffff);

    u16 intr_pin_line = pci_conf_read_word(dev_info->bus, dev_info->dev, dev_info->func, 30);
    printf("IntrPin: %d, Line: %d\n", intr_pin_line >> 8, intr_pin_line & 0xff);
    // pci_conf_write_byte(dev_info->bus, dev_info->dev, dev_info->func, 0x3c, 0xfe);
    // intr_pin_line = pci_conf_read_word(dev_info->bus, dev_info->dev, dev_info->func, 30);
    // if((intr_pin_line & 0xff) == 0xfe)
    // {

    // }

    if (dev_info->progif & 0x1)
    {
        _ide_info.channel[0].cur_mode = 2;
        print_str("primary channel in PCI native mode!\n");
    }
    else
    {
        _ide_info.channel[0].cur_mode = 1;
        print_str("primary channel in compatibility mode!\n");
    }
    if (dev_info->progif & 0x2)
    {
        _ide_info.channel[0].can_change_mode = true;
        print_str("primary channel can change mode!\n");
    }
    if (dev_info->progif & 0x4)
    {
        _ide_info.channel[1].cur_mode = 2;
        print_str("secondary channel in PCI native mode!\n");
    }
    else
    {
        _ide_info.channel[1].cur_mode = 1;
        print_str("secondary channel in compatibility mode!\n");
    }
    if (dev_info->progif & 0x8)
    {
        _ide_info.channel[1].can_change_mode = true;
        print_str("secondary channel can change mode!\n");
    }

    if (dev_info->progif & 0x80)
    {
        struct pci_bar_info bar_info;
        pci_decode_bar(dev_info, 4, &bar_info);
        if (bar_info.type == PCI_BAR_TYPE_NONE)
        {
            print_str("progif set the BusMaster bit but BAR4 not present!\n");
        }
        else
        {
            _ide_info.support_dma = true;
            _ide_info.channel[0].busmaster_base = bar_info.base;
            _ide_info.channel[1].busmaster_base = bar_info.base + 8;
            printf("BusMaster BAR: base=0x%x, size=0x%x, type=%s\n",
                   bar_info.base, bar_info.size, bar_info.type == PCI_BAR_TYPE_PIO ? "PIO" : "MMIO");
        }
        // if (status_cmd & 0x4)
        // {
        //     _ide_info.dma_enabled = true;
        //     print_str("Enabled!");
        //     // pci_conf_write_byte(dev_info->bus, dev_info->dev, dev_info->func, 0x4, status_cmd | 0x4);
        //     // status_cmd = pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, 0x4);
        //     // printf("new command: 0x%x\n", status_cmd & 0xffff);
        // }
        // else
        // {
        //     _ide_info.dma_enabled = false;
        //     print_str("Disabled!");
        // }
        // print_char('\n');
    }

    for (u32 bar = 0; bar <= 5; ++bar)
    {
        struct pci_bar_info bar_info;
        if (bar == 4)
            continue;
        pci_decode_bar(dev_info, bar, &bar_info);
        if (bar_info.type == PCI_BAR_TYPE_NONE)
            continue;

        printf("BAR%d: base=0x%x, size=0x%x, type=%s\n",
               bar, bar_info.base, bar_info.size, bar_info.type == PCI_BAR_TYPE_PIO ? "PIO" : "MMIO");
    }

    if ((status_cmd >> 16) & 0x10)
    {
        u8 cap_ptr = pci_conf_read_byte(dev_info->bus, dev_info->dev, dev_info->func, 0x34);
        printf("Capabilities List Ptr=0x%x\n", cap_ptr);
        while (cap_ptr)
        {
            u16 cap = pci_conf_read_word(dev_info->bus, dev_info->dev, dev_info->func, cap_ptr >> 1);
            cap_ptr = cap >> 8;
            printf("id=0x%x, next=0x%x\n", cap & 0xff, cap_ptr);
        }
    }

    bool need_change = false;
    u8 progif = pci_conf_read_byte(dev_info->bus, dev_info->dev, dev_info->func, 0x9);
    if (_ide_info.channel[0].cur_mode == 2 && _ide_info.channel[0].can_change_mode)
    {
        progif &= 0xfe;
        _ide_info.channel[0].cur_mode = 1;
        need_change = true;
    }
    if (_ide_info.channel[1].cur_mode == 2 && _ide_info.channel[1].can_change_mode)
    {
        progif &= 0xfb;
        _ide_info.channel[1].cur_mode = 1;
        need_change = true;
    }
    if (need_change)
    {
        pci_conf_write_byte(dev_info->bus, dev_info->dev, dev_info->func, 0x9, progif);
    }

    if (_ide_info.channel[0].cur_mode == 2)
    {
        print_str("primary channel at native mode but we not support it!\n");
    }
    else
    {
        _ide_info.channel[0].cmd_base = IDE_IOBASE0;
        _ide_info.channel[0].ctrl_base = IDE_CTRLBASE0;
    }

    if (_ide_info.channel[1].cur_mode == 2)
    {
        print_str("secondary channel at native mode but we not support it!\n");
    }
    else
    {
        _ide_info.channel[1].cmd_base = IDE_IOBASE1;
        _ide_info.channel[0].ctrl_base = IDE_CTRLBASE1;
    }

    init_ide();

    pic_irq_set_entry(IDE_IRQ0, _irq_handler0);
    pic_irq_set_entry(IDE_IRQ1, _irq_handler1);
    pic_irq_enable(IDE_IRQ0);
    pic_irq_enable(IDE_IRQ1);
}

int ide_read_write_sectors(u8 channel, u8 device, u32 lba, bool write, u8 count, void *buffer)
{
    if (!_ide_info.present || !_ide_info.channel[channel].device[device].present || _ide_info.channel[channel].device[device].device_type != 1)
        return -1;

    u8 *lba28 = (u8 *)&lba;

    // ide_write(channel, ATA_REG_CONTROL, _ide_info.channel[channel].irq_disable << ATA_CONTROL_NIEN_SHIFT);

    ide_write(channel, ATA_REG_DEVICE, 0xA0 | ATA_DEVICE_LBA | device << ATA_DEVICE_DEV_SHIFT | (lba28[3] & 0xf)); // LBA
    delay_ms(1);

    if (ide_wait(channel, false, NULL) == -2)
    {
        printf("IDE %d:%d timeout!\n", channel, device);
        return -2;
    }

    ide_write(channel, ATA_REG_SECTOR_COUNT0, count);
    ide_write(channel, ATA_REG_LBA0, lba28[0]);
    ide_write(channel, ATA_REG_LBA1, lba28[1]);
    ide_write(channel, ATA_REG_LBA2, lba28[2]);

    ide_write(channel, ATA_REG_COMMAND, write ? ATA_CMD_WRITE_SECTORS : ATA_CMD_READ_SECTORS);

    for (u8 i = 0; i < count; ++i)
    {
        // delay_ms(1);

        u8 err;
        s8 status = ide_wait(channel, true, &err);
        if (status)
        {
            if (status == -2)
            {
                printf("IDE %d:%d timeout!\n", channel, device);
                return -3;
            }
            if (err & ATA_STATUS_ERR)
                return -4;
            if (err & ATA_STATUS_DF)
                return -5;
            return -6;
        }

        if (write)
            port_write_dword_count(_ide_info.channel[channel].cmd_base + ATA_REG_DATA, (u8 *)buffer + i * 512, 128);
        else
            port_read_dword_count(_ide_info.channel[channel].cmd_base + ATA_REG_DATA, (u8 *)buffer + i * 512, 128);
    }

    if (write)
    {
        ide_write(channel, ATA_REG_COMMAND, ATA_CMD_FLUSH_CACHE);
        ide_wait(channel, false, NULL);
    }

    return 0;
}

#if 0
int ide_write_sectors(u8 channel, u8 device, u32 lba, u8 count, void *buffer)
{
    if (!_ide_info.present || !_ide_info.channel[channel].device[device].present || _ide_info.channel[channel].device[device].device_type != 1)
        return -1;

    while (ide_read(channel, ATA_REG_STATUS) & ATA_STATUS_BSY)
        ;

    u8 *lba28 = (u8 *)&lba;

    ide_write(channel, ATA_REG_DEVICE, 0xA0 | ATA_DEVICE_LBA | device << 4 | (lba28[3] & 0xf)); // LBA
    delay_ms(10);

    ide_write(channel, ATA_REG_SECTOR_COUNT0, count);
    ide_write(channel, ATA_REG_LBA0, lba28[0]);
    ide_write(channel, ATA_REG_LBA1, lba28[1]);
    ide_write(channel, ATA_REG_LBA2, lba28[2]);

    ide_write(channel, ATA_REG_COMMAND, ATA_CMD_WRITE_SECTORS);

    for (u8 i = 0; i < count; ++i)
    {
        delay_ms(10);
        while (ide_read(channel, ATA_REG_STATUS) & ATA_STATUS_BSY)
            ;

        port_write_dword_count(_ide_info.channel[channel].cmd_base + ATA_REG_DATA, buffer + i * 512, 128);
    }

    ide_write(channel, ATA_REG_COMMAND, ATA_CMD_FLUSH_CACHE);
    delay_ms(10);
    while (ide_read(channel, ATA_REG_STATUS) & ATA_STATUS_BSY)
        ;

    return 0;
}
#endif
