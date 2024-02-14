# Registers (x86_64)

## General opurpose registers

| 64 bit | 32 bit | 16 bit | 8 high bits of lower 16 bits | 8 bit       |
|--------|--------|--------|------------------------------|-------------|
| rax    | eax    | ax     | al                           | al          |
| rbx    | ebx    | bx     | bl                           | bl          |
| rcx    | ecx    | cx     | cl                           | cl          |
| rdx    | edx    | dx     | dl                           | dl          |
| rsi    | esi    | si     |                              | sil         |
| rdi    | edi    | di     |                              | dil         |
| rsp    | esp    | sp     |                              | spl         |
| rbp    | ebp    | bp     |                              | sbl         |
| r8     | r8d    | r8w    |                              | r8b         |
| ...    | ...    | ...    |                              | ...         |
| r15    | r15d   | r15w   |                              | r15b        |

[See OSDev.org](https://wiki.osdev.org/CPU_Registers_x86-64)

## System V AMD64 ABI calling convention
Parameters are passed in:
`RDI`, `RSI`, `RDX`, `RCX`, `R8`, `R9`, `[XYZ]MM0–7`

The call order is RTL (right to left)

### Example

#### If a function is called that takes 3 arguments

the first argument is passed in `RDI`

the second argument is passend in `RSI`

and the third argument is passed in `RDX`

[See Wikipedia article](https://en.wikipedia.org/wiki/X86_calling_conventions#List_of_x86_calling_conventions)

## Registers used for syscalls

The syscall number is passed in `RAX`

The parameters are passed in `RDI`, `RSI`, `RDX`, ...
