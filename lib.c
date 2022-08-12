#include "lib.h"
#include "cpu.h"
#include "io.h"
#include "pit.h"

void delay_ms(u32 ms)
{
	// u8 old_val, val, i;
	/*
	1000 / 18.206 = 54.9
	*/

	/*
	old_val = port_read_byte(SYSTEM_CONTROL_PORT_B) & 0x10;
	while(ms--) {
		i = 55;
		do {
			val = port_read_byte(SYSTEM_CONTROL_PORT_B) & 0x10;
			if(val != old_val) {
				old_val = val;
				--i;
			}
		} while(i);
	}
	*/
	u32 save_eflags = read_eflags();
	enable();
	for (u32 end = pit_get_ticks() + ms; pit_get_ticks() < end;)
		;
	write_eflags(read_eflags() & (save_eflags & EFLAGS_IF));
}

u8 checksum_add(const void *p, u32 len)
{
	u8 sum = 0;
	while (len--)
	{
		sum += ((const u8 *)p)[len];
	}
	return sum;
}
