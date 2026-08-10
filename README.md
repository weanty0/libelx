# libelx
A libc replacement in llvm ir.

Note: This lib is still early in development, so it may be buggy and it is incomplete. Feel free to open issues as soon as you spot a bug, and as soon as I see the issue I will look into it.
This lib is implemented with `x86_64 asm`.

### Building
```sh
make        #builds obj files inside of build/, and also the libelx.a
make clean  #cleans up build and libelx
```

### Using libelx in with C
Example hello world
```c
#include "../elx/stdio.h"

int main(int argc, char *argv[]) {
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
int putchar(int char);
int puts(char *str);
```

**string.ll**
```c
size_t strlen(char *str);
```

**math.ll**
```c
int dabs(int n);
double fabs(double n);
```
