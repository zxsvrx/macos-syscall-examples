# macOS syscalls

[Source from the xnu kernel repository](https://github.com/opensource-apple/xnu/blob/master/bsd/kern/syscalls.master)

[Full list](https://gist.github.com/nikolay-n/5ad64ae82ae91c21d2d2a5be5d49b3b3#file-syscalls-txt)

| syscall number | syscall name | syscall args (name: size)      | return values in registers |
|----------------|--------------|--------------------------------|----------------------------|
| 1 (0x1)        | exit         | rval: 4                        | none                       |
| 2 (0x2)        | fork         |                                | rax = child pid or -1 on error; rdi = errcode, rdx = 0 -> parent, != child | 
| 3 (0x3)        | read         | fd: 4, cbuf: 8, nbyte: 8       | rax = bytes read           |
| 4 (0x4)        | write        | fd: 4, cbuf: 8, nbyte: 8       | rax = bytes written        |
| 5 (0x5)        | open         | path: 8, flags: 4, mode: 4     | rax = fd or -1 on error    |
| 6 (0x6)        | close        | fd: 4                          | rax = 0 or -1 on error     |
| 20 (0x14)      | getpid       |                                | rax = pid                  |
| 37 (0x25)      | kill         | pid: 4, signum: 4, posix: 4    | rax = 0 or -1 on error     |
| 73 (0x49)      | munmap       | addr: 8, len: 8                | rax = 0 or -1 on error     |
| 197 (0xC5)     | mmap         | addr: 8, len: 8, prot: 4, flags: 4, fd: 4, pos: 8 | rax = starting address or (void *)-1 on error |
