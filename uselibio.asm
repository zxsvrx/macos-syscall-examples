; -----------------------------------------------------------------------------
; name:
; 	uselibio.asm
; author:
; 	zxsvrx
; copyright:
;	Copyright (c) 2024 zxsvrx
; license:
;	MIT License (see LICENSE in /master)
; platform:
; 	macOS
; architecture:
; 	x86_64
; syntax:
;	nasm
; compiler:
;	nasm 2.16.01
; build tool:
; 	gcc (Apple clang version 15.0.0)
;
; build with:
; 	nasm -f macho64 -o uselibio.o uselibio.asm && gcc -nostdlib -o uselibio uselibio.o libio.o
;	(libio needs to be build first)
;
; A program that uses and demonstrates the functions provided by libio.asm
; -----------------------------------------------------------------------------

	section .text

	extern io_print
	extern io_println
	extern io_getc
	extern io_getline
	extern io_strlen

	global _main

_main:
	push rbp
	mov rbp, rsp
	
	lea rdi, [rel msg0]
	call io_println
	
	call io_getc
	
	lea rdi, [rel msg1]
	call io_print

	lea rdi, [rel input]
	mov rsi, input.len
	call io_getline
	
	mov rax, 0x2000001
	mov rdi, 0x0
	syscall


	section .text
msg0: db "Hello, world!", 0
msg1: db "Your name: ", 0

	section .bss
input: resb 256
input.len: equ 256
