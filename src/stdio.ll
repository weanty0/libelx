;basically stdio.ll

;basic file struct
%FILE = type { i64 }

;filecache
@.filestack = global [ 16 x %FILE ] zeroinitializer
@.filestack.used = global [ 16 x i8 ] zeroinitializer

;std
@.stdin_struct  = global %FILE { i64 0 }
@.stdout_struct = global %FILE { i64 1 }
@.stderr_struct = global %FILE { i64 2 }

@stdin = global  ptr @.stdin_struct
@stdout = global ptr @.stdout_struct
@stderr = global ptr @.stderr_struct

;types
%size_t = type i64
%ssize_t = type i64
%umode_t = type i16

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
  %fd = call i32 @open(ptr %fname, i32 %mode, %umode_t 0)
  ;test if open didnt get a stroke
  %is.good = icmp sge i32 %fd, 0
  br i1 %is.good, label %good, label %nahbro
good:
  %slot = call i32 @_allocate_slot()
  %is.full = icmp eq i32 %slot, -1
  br i1 %is.full, label %nahbro, label %havesex
havesex:
  %fd.64 = zext i32 %fd to i64
  %f = getelementptr ptr, ptr @.filestack, i32 0, i32 %slot
  %f.fd.ptr = getelementptr i64, ptr %f, i32 0
  store i64 %fd.64, ptr %f.fd.ptr
  ;this mentally hurts
  ret ptr %f
nahbro:
  ret ptr null
}

;int close(FILE *file)
define external i32 @fclose(ptr %file) {
  ;getting the fd
  %fd.64 = call i64 @gfdff(ptr %file)
  %fd = trunc i64 %fd.64 to i32

  ;close the file
  %rv = call i32 @close(i32 %fd)
  ret i32 %rv
}

;int fputs(char *str, FILE *file)
define external i32 @fputs(ptr %str, ptr %file){
  ;getting fd
  %fd.64 = call i64 @gfdff(ptr %file)

  %len = call %size_t @strlen(ptr %str)
  %nob.w = call %ssize_t @write(i64 %fd.64, ptr %str, %size_t %len)
  %nob.w.32 = trunc %ssize_t %nob.w to i32
  ret i32 %nob.w.32
}

;char *fgets(char *buf, size_t len, FILE *stream);
define external ptr @fgets(ptr %buf, %size_t %len, ptr %stream) {
  ;gettin fd
  %fd = call i64 @gfdff(ptr %stream)
  %lenm1 = sub %size_t %len, 1
  %nob.r = call %ssize_t @read(i64 %fd, ptr %buf, %size_t %lenm1)
  %is.good = icmp sge %ssize_t %nob.r, 0
  br i1 %is.good, label %pass, label %err
pass:
  %bufl.p = getelementptr i8, ptr %buf, %ssize_t %nob.r
  store i8 0, ptr %bufl.p
  ret ptr %buf
err:
  ret ptr null
}

; --- Helper funcs ---

define i64 @gfdff(ptr %file) {
  %fd.ptr = getelementptr i64, ptr %file, i32 0
  %fd.64 = load i64, ptr %fd.ptr
  ret i64 %fd.64
}

; --- stack ---
define internal i32 @_allocate_slot() {
  br label %chk
chk:
  %i = phi i32 [ 0, %0 ], [ %i_next, %post ]
  %full = icmp eq i32 %i, 16
  br i1 %full, label %brim, label %cond
cond:
  %used.ptr = getelementptr ptr, ptr @.filestack.used, i32 0, i32 %i
  %used.v = load i8, ptr %used.ptr
  %is.free = icmp eq i8 %used.v, 0
  br i1 %is.free, label %free, label %post
free:
  store i8 1, ptr %used.ptr
  ret i32 %i
post:
  %i_next = add i32 %i, 1
  br label %chk
brim:
  ret i32 -1
}

declare i32 @open(ptr, i32, %umode_t)
declare i32 @close(i32)

declare %size_t @strlen(ptr)
declare %ssize_t @write(i64, ptr, %size_t)
declare %ssize_t @read(i64, ptr, %size_t)
