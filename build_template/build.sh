# Copyright (c) 2024 zxsvrx
# MIT License (see /LICENSE)

echo "Compiling assembly file..."

if ! nasm -f macho64 -o $1.o $1.asm ; then
	echo "Failed to compile assembly!"
	exit 1
fi

echo "Creating executable..."

if ! gcc -nostdlib -o $1 $1.o ; then
	echo "Failed to create executable!"
	exit 2
fi

echo "Removing object file..."

if ! rm $1.o ; then
	echo "Failed to remove object file!"
	exit 3
fi

echo "Executable build!"
