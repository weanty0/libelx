# libelx
A libc replacement in llvm ir.

Note: This lib is still early in development, so it may be buggy and it is incomplete. Feel free to open issues as soon as you spot a bug, and as soon as I see the issue I will look into it.
This lib is implemented with `x86_64 asm`.

### Building
```sh
make        #builds obj files inside of build/, and also the libelx.a
make clean  #cleans up build and libelx
```

### Using libelx in C
You only have to import the .h file
```c
#include "libelx.h"
```
Compilation
```sh
gcc -ffreestanding -nostdlib -static -no-pie -fno-stack-protector -e _start main.c libelx.a -o main
```

### Function call table
Read the `docs/func.md`.
