; -----------------------------------------------------------------------------
; name:
; 	fork
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
; 	nasm -f macho64 -o fork.o fork.asm && gcc -nostdlib -o fork fork.o
;
; A program that forks itself using the macOS syscall fork
;
; ! README:
;	In macOS the syscall fork returns the childs pid in rax or -1 in rax on
;	error! We need to check rdx to determine if the current process is a
;	child or the parent. rdx = 0 -> parent, rdx != 0 -> child.
; -----------------------------------------------------------------------------

%define SYS_exit	0x2000001
%define SYS_fork 	0x2000002
%define SYS_write	0x2000004

%define FD_stdout	1
%define FD_stderr	2

	section .text

	global _main

_main:
	push rbp
	mov rbp, rsp
	
	mov rax, SYS_fork
	syscall

; for an unknown reason we are the parent process if rdx is 0
; and the child process if it is not
	cmp rdx, 0
	jne child_proc
; rax always contains the address of the child
; and contains -1 on failure
	cmp rax, -1
	je fork_failed

	mov rax, SYS_write
	mov rdi, FD_stdout
	lea rsi, [rel parent_proc_msg]
	mov rdx, parent_proc_msg.len
	syscall

_main.exit:
	mov rdi, 0
_main.error:
	mov rax, SYS_exit
	syscall

child_proc:
	mov rax, SYS_write
	mov rdi, FD_stdout
	lea rsi, [rel child_proc_msg]
	mov rdx, child_proc_msg.len
	syscall

	jmp _main.exit

fork_failed:
	mov rax, SYS_write
	mov rdi, FD_stderr
	lea rsi, [rel fork_failed_errmsg]
	mov rdx, fork_failed_errmsg.len
	syscall

	mov rdi, 0
	jmp _main.error

	section .data
parent_proc_msg: db "Hello from parent process!", 10
parent_proc_msg.len: equ $ - parent_proc_msg

child_proc_msg: db "Hello from child process!", 10
child_proc_msg.len: equ $ - child_proc_msg

fork_failed_errmsg: db "Fork failed!", 10
fork_failed_errmsg.len: equ $ - fork_failed_errmsg

	section .bss
msg: resb 2
