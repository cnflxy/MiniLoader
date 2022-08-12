CFLAGS = -std=c99 -m32 -march=i386 \
		-Wall -Wextra -Wstrict-prototypes \
		-fno-stack-protector -fno-builtin -fno-common \
		-fno-strict-aliasing -fno-omit-frame-pointer \
		-fno-pie -fno-unwind-tables -fno-asynchronous-unwind-tables \
		-Os -ggdb
ASMFLAGS = -Wall -f elf32
LDFLAGS = -melf_i386 -Ttext 0x10000 -e LdrEntry16 -N
ALLCSRC = 8042.c apm.c bitmap.c cmos.c console.c dma.c es1370.c floppy.c font_8x16.c gdt.c ide.c idt.c kbd.c lib.c list.c memory.c page.c pci.c pic.c pit.c sb16.c string.c loader_main.c
ALLASMSRC = loader_entry.asm a20.asm apm_call.asm trap.asm
ALLOBJS = loader_entry.o a20.o trap.o 8042.o apm.o apm_call.o bitmap.o cmos.o console.o dma.o es1370.o floppy.o font_8x16.o gdt.o ide.o idt.o kbd.o lib.o list.o memory.o page.o pci.o pic.o pit.o sb16.o string.o loader_main.o

all: clean build install

clean:
	rm -f $(ALLOBJS) loader_block.o
	rm -f loader_block.S loader_block.asm loader.mns

build: $(ALLASMSRC) $(ALLCSRC)
	nasm $(ASMFLAGS) loader_entry.asm
	nasm $(ASMFLAGS) a20.asm
	nasm $(ASMFLAGS) apm_call.asm
	nasm $(ASMFLAGS) trap.asm
	gcc $(CFLAGS) -c $(ALLCSRC)
	ld $(LDFLAGS) -o loader_block.o $(ALLOBJS)
	./elf2bin loader_block.o loader.mns
	objdump -S loader_block.o > loader_block.S
	ndisasm -a -p intel loader.mns > loader_block.asm
	
install: loader.mns
	cp loader.mns ./demo
