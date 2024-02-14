; -----------------------------------------------------------------------------
; name:
; 	alloc.asm
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
; 	nasm -f macho64 -o alloc.o alloc.asm && gcc -nostdlib -o alloc alloc.o
;
; Program that allocates 4 kilobyte of memory on the heap using mmap and
; subsequently frees that memory with munmap
;
; For mmap and munmap parameters see
; https://github.com/opensource-apple/xnu/blob/master/bsd/kern/syscalls.master,
; man mmap,
; man munmap
;
; For flag definitions see the source code for mmap.h
; /Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/System/Library/Frameworks/Kernel.framework/Versions/A/Headers/sys
; -----------------------------------------------------------------------------

%define SYS_exit	0x2000001
%define SYS_write	0x2000004
%define SYS_mmap	0x20000C5
%define SYS_munmap	0x2000049

%define FD_stdout 	1
%define FD_stderr 	2

; from mmap.h
%define MAP_PROT_READ 	0x1
%define MAP_PROT_WRITE 	0x2

%define MAP_PRIVATE		0x2

%define MAP_ANONYMOUS	0x1000

%define MAP_FAILED		-1


	section .text

	global _main

_main:
; allocate 4 kilobyte using mmap
	mov rax, SYS_mmap
; 0x0 to get any memory location available that does not overlap whith other
; mapped regions (flag for map_fixed must not be passed)
	mov rdi, 0x0
; the size in bytes we want to allocate
	mov rsi, size
; the protection flag
	mov rdx, protection
; flags that define memory 'settings'
	mov r10, flags
; -1 as file descriptor to indicate that no file is mapped
	mov r9, -1
; offset is ignored for anonymous mapping
	mov r8, 0
	syscall

; move 8 bytes (QWORD) into allocated
	mov [rel allocated], QWORD rax

	cmp rax, MAP_FAILED
; if rax contains a valid address, we have successfully allocated memory!
	je _main.error_alloc
	
_main.success:
	mov rax, SYS_write
	mov rdi, FD_stdout
	lea rsi, [rel msg_mem]
	mov rdx, msg_mem.len
	syscall

; now we unmap the allocated memory
	mov rax, SYS_munmap
	mov rdi, [rel allocated]
; we have to pass the area we want to free.
; because we want to completely free the mapped region, we need to pass our allocated size
	mov rsi, size
	syscall
	
; check if munmap was successfull
	cmp rax, -1
; if not jump to error label
	je _main.error_free

	mov rax, SYS_write
	mov rdi, FD_stdout
	lea rsi, [rel msg_free]
	mov rdx, msg_free.len
	syscall
	
; set error code to 0 (no error)
	mov rdi, 0
	
_main.exit:
	mov rax, SYS_exit
	syscall


_main.error_alloc:
	mov rax, SYS_write
	mov rdi, FD_stderr
	lea rsi, [rel errmsg_alloc]
	mov rdx, errmsg_alloc.len
	syscall

; set return code to error
	mov rdi, 1
	jmp _main.exit

_main.error_free:
	mov rax, SYS_write
	mov rdi, FD_stderr
	lea rsi, [rel errmsg_free]
	mov rdx, errmsg_free.len
	syscall

; set return code to error
	mov rdi, 2
	jmp _main.exit








	section .data
; 4 kilobyte
size: equ 4096
protection: equ MAP_PROT_WRITE | MAP_PROT_READ
flags: equ MAP_PRIVATE | MAP_ANONYMOUS

msg_mem: db "Memory successfully allocated!", 10, 0
msg_mem.len: equ $ - msg_mem

msg_free: db "Memory succesfully freed!", 10, 0
msg_free.len: equ $ - msg_free

errmsg_alloc: db "Failed to allocate memory!", 10, 0
errmsg_alloc.len: equ $ - errmsg_alloc

errmsg_free: db "Failed to free allocated memory!", 10, 0
errmsg_free.len: equ $ - errmsg_free

	section .bss
; size of a pointer is reserved
allocated: resb 8
