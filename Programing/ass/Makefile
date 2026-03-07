.PHONY: all

all: first_program skeleton loop if_else hello_world input_read prime_number bits
first_program: first_program.asm
	nasm -f elf64 first_program.asm
	gcc -o first_program first_program.o

skeleton: skeleton.asm
	nasm -f elf64 skeleton.asm
	gcc -o skeleton skeleton.o

loop: loop.asm
	nasm -f elf64 loop.asm
	gcc -o loop loop.o

if_else: if_else.asm
	nasm -f elf64 if_else.asm
	gcc -o if_else if_else.o

hello_world: hello_world.asm
	nasm -f elf64 hello_world.asm
	gcc -o hello_world hello_world.o

input_read: input_read.asm
	nasm -f elf64 input_read.asm
	gcc -o input_read input_read.o

prime_number: prime_number.asm
	nasm -f elf64 prime_number.asm
	gcc -o prime_number prime_number.o

bits: bits.asm
	nasm -f elf64 bits.asm
	gcc -o bits bits.o

clean:
	rm -rf first_program.o skeleton.o loop.o if_else.o hello_world.o input_read.o prime_number.o bits.o
	rm -rf first_program skeleton loop if_else hello_world input_read prime_number bits
