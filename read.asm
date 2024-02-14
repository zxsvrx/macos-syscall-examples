; -----------------------------------------------------------------------------
; name:
; 	read.asm
; author:
; 	zxsvrx
; copyright:
;	Copyright (c) 2024 zxsvrx
; license:
;	MIT License (see LICENSE in /main)
; platform:
; 	macOS
; architecture:
; 	x86_64
; syntax:
; 	nasm
; compiler:
;	nasm 2.16.01
; build tool:
; 	gcc (Apple clang version 15.0.0)
;
; build with:
; 	nasm -f macho64 -o read.o read.asm && gcc -nostdlib -o read read.o
;
; Program that reads from the standard input and returns the length of read
; characters.
; -----------------------------------------------------------------------------

; syscall for exit
%define SYS_exit 0x2000001

; syscall for read
%define SYS_read 0x2000003

; file descriptor for the standard input
%define FD_stdin 0

	section .text

	global _main

_main:
	mov rax, SYS_read
	mov rdi, FD_stdin
	lea rsi, [rel input]
	mov rdx, input.max_len
	syscall

; exit
; see (/exit.asm)

; we move the length of read data into our exit code.
; that means if we enter 10 characters, our program should exit with exit
; code 11 (+1 because of the linebreak from your input)
	mov rdi, rax
	
	mov rax, SYS_exit
	syscall


; data that may change at runtime is stored in the bss (block starting symbol) section
	section .bss
; reserve byte 256
; input can hold 256 bytes (256 characters)
input: resb 256
; the size of input
input.max_len: equ 256
