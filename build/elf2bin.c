#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <elf.h>

int main(int argc, char **argv)
{
	int ret = 0;
	FILE *fpElf, *fpBin;
	
	fpElf = fpBin = NULL;
	
	if(argc != 3) {
		fprintf(stderr, "Usage: %s [elf_file] [bin_file]\r\n", *argv);
		goto on_failed;
	}
	
	if((fpElf = fopen(argv[1], "rb")) == NULL) {
		fprintf(stderr, "%s %s\r\n", argv[1], strerror(errno));
		goto on_failed;
	}
	
	if((fpBin = fopen(argv[2], "wb")) == NULL) {
		fprintf(stderr, "%s %s\r\n", argv[1], strerror(errno));
		goto on_failed;
	}
	
	fseek(fpElf, 0, SEEK_END);
	long BufSize = ftell(fpElf);
	fseek(fpElf, 0, SEEK_SET);
	
	if(ferror(fpElf) != 0 || BufSize <= sizeof(Elf32_Ehdr) + sizeof(Elf32_Phdr) + sizeof(Elf32_Shdr)) {
		fprintf(stderr, "%s %s\r\n", argv[1], strerror(errno));
		goto on_failed;
	}
	
	Elf32_Ehdr ehdr;
	Elf32_Phdr phdr;
	
	if(fread(&ehdr, 1, sizeof(ehdr), fpElf) != sizeof(ehdr) || ferror(fpElf) != 0) {
		fprintf(stderr, "%s %s\r\n", argv[1], strerror(errno));
		goto on_failed;
	}
	
	if(memcmp(&ehdr.e_ident, ELFMAG, 4) != 0) {
		fprintf(stderr, "memcmp\r\n");
		goto on_failed;
	}
	
	if(ehdr.e_type != ET_EXEC || ehdr.e_machine != EM_386 || ehdr.e_version == EV_NONE || ehdr.e_ehsize != sizeof(ehdr) || ehdr.e_phentsize != sizeof(phdr) || ehdr.e_phnum == 0 || ehdr.e_shentsize != sizeof(Elf32_Shdr) || ehdr.e_shnum == 0) {
		fprintf(stderr, "1\r\n");
		goto on_failed;
	}
	
	if(ehdr.e_phoff + sizeof(phdr) >= BufSize || ehdr.e_shoff + sizeof(Elf32_Shdr) >= BufSize) {
		fprintf(stderr, "2\r\n");
		goto on_failed;
	}
	
	fseek(fpElf, ehdr.e_phoff, SEEK_SET);
	if(ferror(fpElf) != 0) {
		fprintf(stderr, "%s %s\r\n", argv[1], strerror(errno));
		goto on_failed;
	}
	
	if(fread(&phdr, 1, sizeof(phdr), fpElf) != sizeof(phdr) || ferror(fpElf) != 0) {
		fprintf(stderr, "%s %s\r\n", argv[1], strerror(errno));
		goto on_failed;
	}
	
	if(phdr.p_type != PT_LOAD || phdr.p_offset + phdr.p_filesz > BufSize || phdr.p_memsz == 0 || phdr.p_filesz == 0 || phdr.p_memsz < phdr.p_filesz) {
		fprintf(stderr, "3\r\n");
		goto on_failed;
	}
	
	phdr.p_memsz -= phdr.p_filesz;
	
	fseek(fpElf, phdr.p_offset, SEEK_SET);
	if(ferror(fpElf) != 0) {
		fprintf(stderr, "%s %s\r\n", argv[1], strerror(errno));
		goto on_failed;
	}
	
	while(phdr.p_filesz && ferror(fpElf) == 0 && ferror(fpBin) == 0) {
		fputc(fgetc(fpElf), fpBin);
		--phdr.p_filesz;
	}
	
	if(phdr.p_filesz != 0) {
		fprintf(stderr, "4\r\n");
		goto on_failed;
	}
	
	while(phdr.p_memsz && ferror(fpBin) == 0) {
		fputc(0, fpBin);
		--phdr.p_memsz;
	}
	
	if(phdr.p_memsz != 0) {
		fprintf(stderr, "5\r\n");
		goto on_failed;
	}
	
	puts("Successful!");
	goto on_exit;
	
on_failed:
	puts("Failed!");
	ret = 1;
	
on_exit:
	if(fpElf != NULL) fclose(fpElf);
	if(fpBin != NULL) fclose(fpBin);
	
	return ret;
}
