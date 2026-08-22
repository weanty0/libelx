;basically stdio.ll

%size_t = type i64
%ssize_t = type i64
%umode_t = type i16

;basic file struct
%FILE = type { i64 }

;int putchar(int c);
define external i32 @putchar(i32 %chr) {
  ;truncating the 64 bit int to a char
  %buf = alloca i8
  %c = trunc i32 %chr to i8
  store i8 %c, ptr %buf

  ;writing
  %wrote = call %ssize_t @write(i64 1, ptr %buf, %size_t 1)
  %is.successful = icmp sle %ssize_t 0, %wrote
  br i1 %is.successful, label %return, label %err
return:
  ;return the char written
  ret i32 %chr
err:
  ;return -1
  ret i32 -1
}

;yanking the character entered
;int getchar(void);
define external i32 @getchar() {
  %char = alloca [ 1 x i8 ]
  call %ssize_t @read(i64 0, ptr %char, %size_t 1)
  %chr.ptr = getelementptr i32, ptr %char, i64 0
  %chr = load i32, ptr %chr.ptr
  ret i32 %chr
}

;int puts(char* str)
define external i32 @puts(ptr %str) {
  %len = call %size_t @strlen(ptr %str)
  ;nob is short for number of bytes (written in this case)
  %nob.w = call %ssize_t @write(i64 1, ptr %str, %size_t %len)
  %nob_w = trunc %ssize_t %nob.w to i32
  ret i32 %nob_w
}

;FILE *fopen(char *name, char *mode) {i will just use an int}
define external ptr @fopen(ptr %fname, i32 %mode) {
  ;parsing the mode
  %fd = call i32 @open(ptr %fname, i32 %mode, %umode_t 0)
  %fd.64 = zext i32 %fd to i64

  %f = alloca %FILE
  %f.fd.ptr = getelementptr i64, ptr %f, i32 0
  store i64 %fd.64, ptr %f.fd.ptr

  ret ptr %f
}

;int close(FILE *file)
define external i32 @fclose(ptr %file) {
  ;getting the fd
  %fd.ptr = getelementptr i64, ptr %file, i32 0
  %fd.64 = load i64, ptr %fd.ptr
  %fd = trunc i64 %fd.64 to i32

  ;close the file
  %rv = call i32 @close(i32 %fd)
  ret i32 %rv
}

declare i32 @open(ptr, i32, %umode_t)
declare i32 @close(i32)

declare %size_t @strlen(ptr)
declare %ssize_t @write(i64, ptr, %size_t)
declare %ssize_t @read(i64, ptr, %size_t)
