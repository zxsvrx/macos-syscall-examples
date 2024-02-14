; -----------------------------------------------------------------------------
; name:
; 	libio.asm
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
; compile with:
; 	nasm -f macho64 -o libio.o libio.asm
;
; A simple input output (io) library that provides subroutines to other
; assembly programs
;
; Functions:
; 	io_print(adr: 8)
;	io_println(adr: 8)
;	io_getc()
;	io_getline(adr: 8, len: 4)
; -----------------------------------------------------------------------------

	section .text

	global io_print
	global io_println
	global io_getc
	global io_getline
	global io_strlen

io_strlen:
	push rbp
	mov rbp, rsp

	mov rax, 0
	
io_strlen.loop:
	cmp BYTE [rdi], 0
	je io_strlen.exit
	inc rdi
	inc rax
	jmp io_strlen.loop

io_strlen.exit:
	pop rbp
	ret


io_print:
	push rbp
	mov rbp, rsp

	mov rcx, rdi
	
	call io_strlen
	
	mov rdx, rax
	mov rsi, rcx
	mov rdi, 1
	mov rax, 0x2000004
	syscall
	
	pop rbp
	ret


io_println:
	push rbp
	mov rbp, rsp

	mov rcx, rdi
	
	call io_strlen
	
	mov rdx, rax
	mov rsi, rcx
	mov rdi, 1
	mov rax, 0x2000004
	syscall

	mov [rbp - 1], BYTE 10

	mov rdx, 1
	mov rsi, rbp
	dec rsi
	mov rdi, 1
	mov rax, 0x2000004
	syscall

	pop rbp
	ret
	

io_getc:
	push rbp
	mov rbp, rsp

	mov rax, 0x2000003
	mov rdi, 0
	lea rsi, [rel input_buffer]
	mov rdx, 256
	syscall

	xor rax, rax
	mov al, BYTE [rel input_buffer]
	
	pop rbp
	ret


io_getline:
	push rbp
	mov rbp, rsp

	mov QWORD [rbp - 8], QWORD rdi
	
	mov rdx, rsi
	mov rsi, rdi
	mov rdi, 0
	mov rax, 0x2000003
	syscall
	
	mov rdi, QWORD [rbp - 8]
	add rdi, rax
	dec rdi
	mov [rdi], BYTE 0
	
	pop rbp
	ret



	section .bss
input_buffer: resb 256
