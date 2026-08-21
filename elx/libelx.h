#ifndef LIBELX_H
#define LIBELX_H

#define size_t unsigned long
#define ssize_t signed long
#define umode_t unsigned short

#define stdin 0
#define stdout 1
#define stderr 2

// structs
typedef struct {
  unsigned int fd;
} FILE;

//  elx.o
void exit(int exitcode);
ssize_t write(unsigned int fd, char *buf, size_t count);
ssize_t read(unsigned int fd, char *buf, size_t count);
int open(const char *filename, int flags, umode_t mode);
int close(unsigned int fd);

//  stdlib.o

//  stdio.o
int putchar(int chr);
int puts(char *str);
int getchar(void);
FILE *fopen(char *filename, int mode);

//  math.o
int abs(int n);
double fabs(double n);

//  string.o
size_t strlen(char *str);
char *strcpy(char *dest, char *str);
char *strcat(char *dest, char *str);
int strcmp(char *a, char *b)

//  etypes.o


#endif // LIBELX_H
