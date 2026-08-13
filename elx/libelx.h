#ifndef LIBELX_H
#define LIBELX_H

#define size_t unsigned long

#define stdin 0
#define stdout 1
#define stderr 2

//  elx.o
void exit(int exitcode);
size_t write(unsigned int fd, char *buf, size_t count);
size_t read(unsigned int fd, char *buf, size_t count);

//  stdlib.o

//  stdio.o
int putchar(int chr);
int puts(char *str);

//  math.o
int dabs(int n);
double fabs(double n);

//  string.o
size_t strlen(char *str);

//  etypes.o


#endif
