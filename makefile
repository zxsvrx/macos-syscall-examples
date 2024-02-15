ASSEMBLER = nasm -f macho64

LINKER = gcc -nostdlib

FILES = exit read hello_world io alloc uselibio use_ctime


all: ${FILES}

clean:
	rm exit
	rm read
	rm hello_world
	rm io
	rm alloc
	rm uselibio
	rm use_ctime

exit: exit.asm
	${ASSEMBLER} -o exit.o exit.asm
	${LINKER} -o exit exit.o
	@rm exit.o

read: read.asm
	${ASSEMBLER} -o read.o read.asm
	${LINKER} -o read read.o
	@rm read.o


hello_world: hello_world.asm
	${ASSEMBLER} -o hello_world.o hello_world.asm
	${LINKER} -o hello_world hello_world.o
	@rm hello_world.o

io: io.asm
	${ASSEMBLER} -o io.o io.asm
	${LINKER} -o io io.o
	@rm io.o

alloc: alloc.asm
	${ASSEMBLER} -o alloc.o alloc.asm
	${LINKER} -o alloc alloc.o
	@rm alloc.o

uselibio: uselibio.asm libio.asm
	${ASSEMBLER} -o libio.o libio.asm
	${ASSEMBLE} -o uselibio.o uselibio.asm
	${LINKER} -o uselibio uselibio.o libio.o
	@rm libio.o uselibio.o

use_ctime: use_ctime.asm
	${ASSEMBLER} -o use_ctime.o use_ctime.asm
	${LINKER} -o use_ctime use_ctime.o
	@rm use_ctime.o
