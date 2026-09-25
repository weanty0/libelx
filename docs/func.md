```c
size_t syscall(int rax, int rdi, int rsi, int rdx, int r10, int r8, int r9);
void exit(int code);
ssize_t write(int fd, const char *buf, size_t len);
ssize_t read(int fd, char *buf, size_t len);
int open(const char *path, int flags, mode_t mode);
int close(int fd);
int rename(const char *old, const char *new);
long creat(const char *path, mode_t mode);

int putchar(int chr);
int getchar();
FILE *fopen(char *name, int mode);
int fclose(FILE *file);
int fputs(char *str, FILE *file);
char *fgets(char *buf, size_t len, FILE *stream);
int fputc(int char, FILE *stream);
int fgetc(FILE *stream);

size_t strlen(char *str);
char *strcpy(char *dest, const char *str);
int strcmp(char *s1, char *s2);
char *strcat(char *dest, const char *src);
int chksuf(char *str, char *suf);
```
