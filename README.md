# libelx
A libc replacement in llvm ir.

Note: Thois lib is still early in development, so it may be buggy and it is incomplete. Feel free to open issues as soon as you spot a bug, and as soon as I see the issue I will look into it.
This lib is implemented with `x86_64 asm`.

### Building
```bash
make        #builds obj files inside of build/, and also the libelx.a
make clean  #cleans up build and libelx
```

### Using libelx in with C
Example hello world
```c
#include "../elx/stdio.h"

long main(long argc, char **argv) {
  puts("Hello, World!\n");
  return 0;
}
```
Compilation
```sh
gcc -ffreestanding -nostdlib -static -no-pie -e _start main.c libelx.a -o main
```

### Function call table (with c style function declaration)
elx.ll -> runtime

**stdio.ll**
```c
long putchar(int char);
long puts(char *str);
```

**string.ll**
```c
long strlen(char *str);
```

**math.ll**
```c
long dabs(long n);
double fabs(double n);
```
