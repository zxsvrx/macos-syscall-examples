; -----------------------------------------------------------------------------
; name:
; 	use_ctime
; author:
; 	zxsvrx
; copyright:
;	Copyright (c) -- year -- zxsvrx
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
; 	nasm -f macho64 -o use_ctime.o use_ctime.asm && gcc -o use_ctime use_ctime.o
;
; A program that calls c functions from libc.
; -----------------------------------------------------------------------------

%define SYS_exit 0x2000001

	section .text

	extern _puts
	extern _printf
	extern _time

	global _main

_main:
	push rbp
	mov rbp, rsp
	
	mov rdi, 0x0
	call _time

; seconds
	mov [rbp - 8], QWORD rax
; minutes
	cqo
	mov rcx, 60
	div rcx
	mov [rbp - 16], QWORD rax
; hours
	cqo
	mov rcx, 60
	div rcx
	mov [rbp - 24], QWORD rax
; days
	cqo
	mov rcx, 24
	div rcx
	mov [rbp - 32], QWORD rax
; years
	cqo
	mov rcx, 365
	div rcx
	mov [rbp - 40], QWORD rax

	mov rsi, QWORD [rbp - 8]
	mov rdx, QWORD [rbp - 16]
	mov rcx, QWORD [rbp - 24]
	mov r8,  QWORD [rbp - 32]
	mov r9,  QWORD [rbp - 40]
	
	lea rdi, [rel format]
	call _printf
	
	mov rax, SYS_exit
	mov rdi, 0
	syscall


	section .data
format: db "%lu seconds", 10, "%lu minutes", 10, "%lu hours", 10, "%lu days", 10, "%lu years", 10, "since the Epoch (01-01-1970 00:00:00 UTC).", 10
