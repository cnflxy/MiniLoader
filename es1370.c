#include "es1370.h"
#include "pci.h"
#include "console.h"
#include "io.h"
#include "lib.h"
#include "pic.h"

static struct pci_dev_info _dev_info = {
    .ven_id = ES1370_PCI_VENID,
    .dev_id = ES1370_PCI_DEVID};
static struct pci_bar_info _iobase;
static bool _present;
static u32 _ctrl;
static u32 _sctrl;
static u8 _irq;

static void reset_mixer(void)
{
    port_write_word(_iobase.base + ES1370_REG_CODEC, 0x10 << 8 | 0x2);
    port_read_word(_iobase.base + ES1370_REG_CODEC);
    delay_ms(1);
    port_write_word(_iobase.base + ES1370_REG_CODEC, 0x10 << 8 | 0x3);
    port_read_word(_iobase.base + ES1370_REG_CODEC);
    delay_ms(1);
}

static void irq_handler(void)
{
    enum console_env old_env = console_set_env(CONSOLE_ENV_INTR);
    u32 status = port_read_dword(_iobase.base + ES1370_REG_STATUS);
    printf("[ES1370] Irq Handler Invoked - 0x%x\n", status);
    console_set_env(old_env);
}

void es1370_setup(void)
{
    bool found = pci_dev_find(&_dev_info, true);
    if (!found)
    {
        console_set_color(COLOR_NORMAL_BG, COLOR_YELLOW);
        print_str("ES1370 PCI Controller not present!\n");
        console_set_color(COLOR_NORMAL_BG, COLOR_NORMAL_FG);
        return;
    }

    printf("ES1370 PCI Controller\n"
           "PCI/BUS_%x&DEV_%x&FUNC_%x"
           "&VEN_%x&DEV_%x&CLASS_%x&SUB_%x&IF_%x&REV_%x\n",
           _dev_info.bus, _dev_info.dev, _dev_info.func,
           _dev_info.ven_id, _dev_info.dev_id,
           _dev_info.class, _dev_info.subclass, _dev_info.progif, _dev_info.rev);

    u32 subsys_ven, status_cmd;
    subsys_ven = pci_conf_read_dword(_dev_info.bus, _dev_info.dev, _dev_info.func, 11);
    printf("subsys: 0x%x, ven: 0x%x\n", subsys_ven >> 16, subsys_ven & 0xffff);
    status_cmd = pci_conf_read_dword(_dev_info.bus, _dev_info.dev, _dev_info.func, 1);
    printf("status: 0x%x, command: 0x%x\n", status_cmd >> 16, status_cmd & 0xffff);
    
    u16 intr_pin_line = pci_conf_read_word(_dev_info.bus, _dev_info.dev, _dev_info.func, 30);
    printf("IntrPin: %d, Line: %d\n", intr_pin_line >> 8, intr_pin_line & 0xff);

    _irq = intr_pin_line & 0xff;

    pci_decode_bar(&_dev_info, 0, &_iobase);
    if (_iobase.type != PCI_BAR_TYPE_PIO)
    {
        printf("[ES1370] ERROR: BAR0.type=%d!\n", _iobase.type);
        return;
    }
    printf("BAR0: base=0x%x, size=0x%x, type=PIO\n", _iobase.base, _iobase.size);

    u32 reg_ctrl = port_read_dword(_iobase.base + ES1370_REG_CONTROL);
    u32 reg_status = port_read_dword(_iobase.base + ES1370_REG_STATUS);
    u8 reg_mem_page = port_read_byte(_iobase.base + ES1370_REG_MEM_PAGE) & 0xf;
    u16 reg_codec = port_read_word(_iobase.base + ES1370_REG_CODEC);
    u32 reg_serial = port_read_dword(_iobase.base + ES1370_REG_SERIAL);

    printf("reg_ctrl=0x%x\nreg_status=0x%x\nreg_mem_page=0x%x\nreg_codec=0x%x\nreg_serial=0x%x\n",
           reg_ctrl, reg_status, reg_mem_page, reg_codec, reg_serial);

    pic_irq_set_entry(_irq, irq_handler);

    u16 status = pci_conf_read_word(_dev_info.bus, _dev_info.dev, _dev_info.func, 2);
    pci_conf_write_word(_dev_info.bus, _dev_info.dev, _dev_info.func, 2, status | 0x5);

    reset_mixer();

    _ctrl = (1 << 31) | (((1411200 / 8000 - 2) & 0x1fff) << 16) | (0x3 << 12) | (1 << 1);
    _sctrl = 0;
    port_write_dword(_iobase.base + ES1370_REG_CONTROL, _ctrl);
    port_write_dword(_iobase.base + ES1370_REG_SERIAL, _sctrl);
    port_write_byte(_iobase.base + ES1370_REG_UART_CTRL, 0);
    port_write_byte(_iobase.base + ES1370_REG_UART_RES, 0);
    // port_write_dword(_iobase.base + ES1370_REG_STATUS)
    // port_write_dword(_iobase.base + ES1370_REG_MEM_PAGE, 0xd);

    _present = true;
}

bool es1370_play(void *laddr, u32 len, u16 freq, u8 width, u8 channels)
{
    u32 mode = 0, count;

    if (!_present)
    {
        return false;
    }

    if (width == 16)
    {
        mode |= 0x2;
    }
    if (channels > 1)
    {
        mode |= 0x1;
    }

    switch (mode)
    {
    case 0: // MONO 8-bits
        count = len;
        break;
    case 1: // STEREO 8-bits
    case 2: // MONO 16-bits
        count = len >> 1;
        break;
    case 3: // STEREO 16-bits
        count = len >> 2;
        break;
    }

    _ctrl &= ~(1 << 5);
    port_write_dword(_iobase.base + ES1370_REG_CONTROL, _ctrl);
    port_write_dword(_iobase.base + ES1370_REG_MEM_PAGE, 0xc);
    port_write_dword(_iobase.base + ES1370_REG_DAC2_FRAME, (u32)laddr);
    port_write_dword(_iobase.base + ES1370_REG_DAC2_SIZE, (len >> 2) - 1);
    _sctrl &= ~((0x7 << 19) | (0x7 << 16) | (1 << 14) | (1 << 12) | (1 << 6) || (0x3 << 2));
    _sctrl |= ((mode & 2 ? 2 : 1) << 19) | (0 << 16) | (1 << 9) | ((mode & 0x3) << 2);
    port_write_dword(_iobase.base + ES1370_REG_SERIAL, _sctrl);
    port_write_dword(_iobase.base + ES1370_REG_DAC2_COUNT, count);

    _ctrl &= ~(0x1fff << 16);
    _ctrl |= (((1411200 / freq - 2) & 0x1fff) << 16);
    // switch (freq)
    // {
    // case 5512:
    //     _ctrl |= (0x0 << 12);
    //     break;
    // case 11025:
    //     _ctrl |= (0x1 << 12);
    //     break;
    // case 22050:
    //     _ctrl |= (0x2 << 12);
    //     break;
    // case 44100:
    //     _ctrl |= (0x3 << 12);
    //     break;
    // default:
    //     printf("\n[ES1370] unsupported freq: %d\n", freq);
    //     return false;
    // }

    pic_irq_enable(_irq);

    port_write_dword(_iobase.base + ES1370_REG_CONTROL, _ctrl);

    _ctrl |= (1 << 5);
    port_write_dword(_iobase.base + ES1370_REG_CONTROL, _ctrl);

    return true;
}
