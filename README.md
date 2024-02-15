# macos-syscall-examples
A repository containing example programs written in assembly using nasm syntax and the x86_64 syscalls and System V AMD64 ABI calling convention

## Before you start

Please see `registers.md` if you are not familiar with the x86_64 registers and the calling convention used in macos.

### Check if you have all nessecary tools installed

You need the following tools:
* `gcc`
* `nasm`

## Contributing

If you want to contribute programs, please use the content of `template_file_description.txt` in your file.

## Warning: Platform load command

I do not know of any fix for the linker (ld) warning. But because it is only a warning and the right platform is selected (macos) we *ignore it for now*.

## Disclaimer

I am not a professional. The code is based on what I could find on the web and what I thaught myself.

If you encounter any errors or problems feel free to suggest changes and / or fixes.

## Other

This repository is inspired by [this repository for 32bit assembly](https://github.com/ruda/osx-syscall-examples/tree/master)
