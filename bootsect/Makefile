all: clean build install

clean:
	rm -f *.mns

build: fat_fd.asm fat_hd.asm
	nasm -I../ -Wall -f bin -o fat_fd.mns fat_fd.asm
	nasm -I../ -Wall -f bin -o fat_hd.mns fat_hd.asm

install: fat_fd.mns fat_hd.mns
	cp fat_fd.mns fat_hd.mns ../demo
