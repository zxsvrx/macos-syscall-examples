; -----------------------------------------------------------------------------
; name:
; 	io.asm
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
;	nasm
; compiler:
;	nasm 2.16.01
; build tool:
; 	gcc (Apple clang version 15.0.0)
;
; build with:
; 	nasm -f macho64 -o io.o io.asm && gcc -nostdlib -o io io.o
;
; A program that asks for a name and greets the user.
;
; It is recommended to first take a look at exit.asm, hello_world.asm and
; read.asm to understand the assembly code below.
; -----------------------------------------------------------------------------

; syscalls
%define SYS_exit 	0x2000001
%define SYS_read 	0x2000003
%define SYS_write 	0x2000004

; file descriptors
%define FD_stdin 	0
%define FD_stdout 	1

	section .text

	global _main

_main:
; write first message
	mov rax, SYS_write
	mov rdi, FD_stdout
	lea rsi, [rel msg_ask]
	mov rdx, msg_ask.len
	syscall

; input name
	mov rax, SYS_read
	mov rdi, FD_stdin
	lea rsi, [rel name]
	mov rdx, name.len
	syscall

; remove the last character (linebreak, \n) from name.
; load address of name in rbx
	lea rbx, [rel name]
; add length of input (stored in rax) to address
	add rbx, rax
; decrease rbx by one to get last character
	dec rbx
; move 0 (end of string) into memory at address stored in rbx
	mov [rbx], BYTE 0

; write second message
	mov rax, SYS_write
	mov rdi, FD_stdout
	lea rsi, [rel msg_greet0]
	mov rdx, msg_greet0.len
	syscall

; write name
	mov rax, SYS_write
	mov rdi, FD_stdout
	lea rsi, [rel name]
	mov rdx, name.len
	syscall

; write third message
	mov rax, SYS_write
	mov rdi, FD_stdout
	lea rsi, [rel msg_greet1]
	mov rdx, msg_greet1.len
	syscall

; exit
	mov rax, SYS_exit
	mov rdi, 0
	syscall

	section .data
msg_ask: db "Please enter your name: ", 0
msg_ask.len: equ $ - msg_ask

msg_greet0: db "Hello ", 0
msg_greet0.len: equ $ - msg_greet0

msg_greet1: db "!", 10, 0
msg_greet1.len: equ $ - msg_greet1

	section .bss
name: resb 265
name.len: equ 256
