; -----------------------------------------------------------------------------
; name:
; 	exit.asm
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
; 	nasm -f macho64 -o exit.o exit.asm && gcc -nostdlib -o exit exit.o
;
; Program that exits with exit code 0 (no error)
; -----------------------------------------------------------------------------

; syscall for exit
%define SYS_exit 0x2000001

	section .text

	global _main

_main:
; rax contains the syscall
	mov rax, SYS_exit
; rdi (1st parameter) contains the exit code
	mov rdi, 0
	syscall
