#include "8042.h"
#include "kbd.h"
#include "io.h"
#include "lib.h"
#include "console.h"

static u8 _ps2_port_count;

static bool wait_for_read(void)
{
    int times = 50;
    while ((port_read_byte(PS2_PORT_STATUS) & PS2_SATTUS_OUT_FULL) == 0 && times--)
    {
        delay_ms(10);
    }
    return port_read_byte(PS2_PORT_STATUS) & PS2_SATTUS_OUT_FULL;
}

static bool wait_for_write(void)
{
    int times = 50;
    while (port_read_byte(PS2_PORT_STATUS) & PS2_STATUS_IN_FULL && times--)
    {
        delay_ms(10);
    }
    return (port_read_byte(PS2_PORT_STATUS) & PS2_STATUS_IN_FULL) == 0;
}

void ps2_setup(void)
{
    ps2_write(PS2_CMD_DISABLE_1, true, true);
    ps2_write(PS2_CMD_DISABLE_2, true, true);

    while (ps2_read(NULL, false))
        ;

    ps2_write(PS2_CMD_READ_CONF, true, true);
    u8 conf;
    ps2_read(&conf, true);
    // printf("original conf=0x%x\n", conf);
    conf &= ~(PS2_CONF_INTR1 | PS2_CONF_INTR2 | PS2_CONF_TRANSLATION);
    // printf("first conf=0x%x\n", conf);
    ps2_write(PS2_CMD_WRITE_CONF, true, true);
    ps2_write(conf, false, true);

    ps2_write(PS2_CMD_TEST_PS2, true, true);
    u8 result;
    ps2_read(&result, true);
    if (result != 0x55)
    {
        printf("PS/2 Controller Self Test Failed: 0x%x\n", result);
        return;
    }

    ps2_write(PS2_CMD_TEST_1, true, true);
    ps2_read(&result, true);
    if (result)
    {
        printf("First PS/2 Port Test Failed: 0x%x\n", result);
        return;
    }

    _ps2_port_count = 1;

    if (!kbd_setup())
    {
        printf("Keyboard Initial Failed!\n");
    }
    else
    {
        ps2_write(PS2_CMD_READ_CONF, true, true);
        ps2_read(&conf, true);
        // printf("original conf=0x%x\n", conf);
        conf &= ~(PS2_CONF_TRANSLATION | PS2_CONF_INTR2);
        conf |= PS2_CONF_INTR1;
        // printf("second conf=0x%x\n", conf);
        ps2_write(PS2_CMD_WRITE_CONF, true, true);
        ps2_write(conf, false, true);
        ps2_write(PS2_CMD_ENABLE_1, true, true);
    }
}

bool ps2_write(u8 data, bool cmd, bool wait_infinite)
{
    u16 port = cmd ? PS2_PORT_CMD : PS2_PORT_DATA;
    bool ret;
    do
    {
        ret = wait_for_write();
    } while (!ret && wait_infinite);

    if (ret)
    {
        port_write_byte(port, data);
    }
    return ret;
}

bool ps2_read(u8 *data, bool wait_infinite)
{
    bool ret;
    do
    {
        ret = wait_for_read();
    } while (!ret && wait_infinite);

    if (ret)
    {
        u8 tmp = port_read_byte(PS2_PORT_DATA);
        if (data)
            *data = tmp;
    }
    return ret;
}
