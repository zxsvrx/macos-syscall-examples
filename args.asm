; -----------------------------------------------------------------------------
; name:
; 	args.asm
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
; 	nasm -f macho64 -o args.o args.asm && gcc -o args args.o
;
; A program that prints all arguments that are passed to main as well as the
; name of the executable itself.
;
; puts() is used to print the strings.
; -----------------------------------------------------------------------------

	section .text

	extern _puts
	
	global _main

_main:
	push rbp
	mov rbp, rsp
	
	sub rsp, 16

; save argc on stack. lets call it remaining args
	mov [rbp - 8], QWORD rdi
; save argv on stack. lets call it addr of arg
	mov [rbp - 16], QWORD rsi
	
_main.iter_args:
; get addr of arg
	mov rdi, QWORD [rbp - 16]
; load from addr of arg
	mov rdi, QWORD [rdi]
	call _puts

; increase addr of arg by 8 to tet the next argument
	mov rsi, QWORD [rbp - 16]
	add rsi, 8
	mov [rbp - 16], QWORD rsi

; decrease remaining args by 1
	mov rdi, QWORD [rbp - 8]
	dec rdi
	mov [rbp - 8], QWORD rdi

; check if no more args remain
	cmp rdi, 0
	jne _main.iter_args

_main.exit:
	mov rax, 0x2000001
	mov rdi, 0
	syscall
