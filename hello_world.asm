; -----------------------------------------------------------------------------
; name:
; 	hello_world.asm
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
; 	nasm
; compiler:
;	nasm 2.16.01
; build tool:
; 	gcc (Apple clang version 15.0.0)
;
; build with:
; 	nasm -f macho64 -o hello_world.o hello_world.asm && gcc -nostdlib -o hello_world hello_world.o
;
; Program that exits with return code 0 (no error)
; -----------------------------------------------------------------------------

; syscall number for exit
%define SYS_exit 0x2000001
; syscall number for write
%define SYS_write 0x2000004

; file descriptor for the standard output
%define FD_stdout 1

	section .text

	global _main

_main:
; rax contains the syscall
	mov rax, SYS_write
; rdi (1st parameter) contains the file descriptor
	mov rdi, FD_stdout
; rsi (2nd parameter) contains the address of our message
; use lea (Load Effective Address) to load the address of message and not the content
	lea rsi, [rel message]
; rdx (3rd parameter) contains the length of our message
	mov rdx, message.len
	syscall

; exit
; see exit.asm
	mov rax, SYS_exit
	mov rdi, 0
	syscall


; section data is for data that will not be modified
	section .data
; db = define bytes
; 10 = line break (\n)
message: db "Hello, world!", 10
; calculate the length of message by taking the address of message.len ($) and subtracting the address of message
message.len: equ $ - message
