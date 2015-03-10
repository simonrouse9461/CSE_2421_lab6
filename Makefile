all: lab6
lab6: lab6.o
	ld -melf_i386 lab6.o -o lab6
lab6.o: lab6.asm
	nasm -felf lab6.asm -o lab6.o
