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

### Function call table (with c style function declaration)
**elx.ll**
```c
void exit(int exitcode);
ssize_t write(unsigned int fd, char *buf, size_t count);
ssize_t read(unsigned int fd, char *buf, size_t count);
```

**stdio.ll**
```c
int putchar(int char);
int puts(char *str);
int getchar(void);
```

**string.ll**
```c
size_t strlen(char *str);
char *strcpy(char *dest, char *str);
char *strcat(char *dest, char *str);
int strcmp(char *a, char *b)
```

**math.ll**
```c
int dabs(int n);
double fabs(double n);
```
