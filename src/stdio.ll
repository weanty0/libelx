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
define i32 @putchar(i32 %chr) {
	;truncating the 64 bit int to a char
	%buf = alloca i8
	%c = trunc i32 %chr to i8
	store i8 %c, ptr %buf

	;writing
	%wrote = call i64 @write(i64 1, ptr %buf, %size_t 1)
	%is.successful = icmp sle i64 0, %wrote
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
define i32 @getchar() {
	%char = alloca [ 1 x i8 ]
	call i64 @read(i64 0, ptr %char, i64 1)
	%chr.ptr = getelementptr i32, ptr %char, i64 0
	%chr = load i32, ptr %chr.ptr
	ret i32 %chr
}

;int puts(char* str)
define i32 @puts(ptr %str) {
	%len = call i64 @strlen(ptr %str)
	;nob is short for number of bytes (written in this case)
	%nob.w = call i64 @write(i64 1, ptr %str, i64 %len)
	%nob_w = trunc i64 %nob.w to i32
	ret i32 %nob_w
}

;FILE *fopen(char *name, char *mode) {i will just use an int}
define ptr @fopen(ptr %fname, i32 %mode) {
	%fd = call i32 @open(ptr %fname, i32 %mode, i16 0)
	;test if open didnt get a stroke
	%is.good = icmp sge i32 %fd, 0
	br i1 %is.good, label %good, label %nahbro
good:
	%slot = call i32 @_allocate_slot()
	%is.full = icmp eq i32 %slot, -1
	br i1 %is.full, label %nahbro, label %havesex
havesex:
	%fd.64 = zext i32 %fd to i64
	%f = getelementptr ptr, ptr @.filestack, i32 %slot
	%f.fd.ptr = getelementptr i64, ptr %f, i32 0
store i64 %fd.64, ptr %f.fd.ptr
	;this mentally hurts
	ret ptr %f
nahbro:
	ret ptr null
}

;int close(FILE *file)
define i32 @fclose(ptr %file) {
	;getting the fd
	%fd.64 = call i64 @gfdff(ptr %file)
	%fd = trunc i64 %fd.64 to i32

	;close the file
	%rv = call i32 @close(i32 %fd)

	;free the stack. yeyy...
	%stack.base = getelementptr ptr, ptr @.filestack, i32 0
	%f.i.n.g = ptrtoint ptr %file to i64
	%stack.bi = ptrtoint ptr %stack.base to i64
	%offs = sub i64 %f.i.n.g, %stack.bi
	%i.64 = udiv i64 %offs, 8
	%i = trunc i64 %i.64 to i32
	%range = icmp ult i32 %i, 16
	br i1 %range, label %freets, label %bippityboppityboo
freets:
	%used.ptr = getelementptr i8, ptr @.filestack.used, i32 %i
	store i8 0, ptr %used.ptr
	br label %bippityboppityboo
bippityboppityboo:
	ret i32 %rv
}

;int fputs(char *str, FILE *file)
define i32 @fputs(ptr %str, ptr %file){
	;getting fd
	%fd.64 = call i64 @gfdff(ptr %file)

	%len = call i64 @strlen(ptr %str)
	%nob.w = call i64 @write(i64 %fd.64, ptr %str, i64 %len)
	%nob.w.32 = trunc i64 %nob.w to i32
	ret i32 %nob.w.32
}

;char *fgets(char *buf, size_t len, FILE *stream);
define ptr @fgets(ptr %buf, i64 %len, ptr %stream) {
	;gettin fd
	%fd = call i64 @gfdff(ptr %stream)
	%lenm1 = sub i64 %len, 1
	%nob.r = call i64 @read(i64 %fd, ptr %buf, i64 %lenm1)
	%is.good = icmp sge i64 %nob.r, 0
	br i1 %is.good, label %pass, label %err
pass:
	%bufl.p = getelementptr i8, ptr %buf, i64 %nob.r
	store i8 0, ptr %bufl.p
	ret ptr %buf
err:
	ret ptr null
}

;int fputc(int c, FILE *stream);
define i32 @fputc(i32 %c, ptr %stream) {
	%fd = call i64 @gfdff(ptr %stream)
	%buf = alloca i8
	%chr = trunc i32 %c to i8
	store i8 %chr, ptr %buf

	%nobw = call i64 @write(i64 %fd, ptr %buf, i64 1)
	%nob.w = trunc i64 %nobw to i32
	ret i32 %nob.w
}

;int fgetc(FILE *stream);
define i32 @fgetc(ptr %stream) {
  %fd = call i64 @gfdff(ptr %stream)
  %buf = alloca i8

	%nobr = call i64 @read(i64 %fd, ptr %buf, i64 1)
	%nob.r = trunc i64 %nobr to i32
	ret i32 %nob.r
}

;int putu(int x);
define i32 @putu(i32 %x) {
entry:
  %isui = icmp sge i32 %x, 0
  br i1 %isui, label %alloc, label %err
alloc:
  %buf = alloca [ 11 x i8 ]
  br label %loop
loop:
  %i = phi i32 [ 9, %alloc ], [ %inext, %shiftY ]
  %y = phi i32 [ %x, %alloc ], [ %ynext, %shiftY ]
  %inext = sub i32 %i, 1
  %cptr = getelementptr i8, ptr %buf, i32 %i
  %lsbit = srem i32 %x, 10
  %cint = trunc i32 %lsbit to i8
  %char = add i8 %cint, 48
  store i8 %char, ptr %cptr

  %putq = icmp eq i32 %y, 0
  br i1 %putq, label %put, label %shiftY
shiftY:
  %yMlsbit = sub i32 %y, %lsbit
  %ynext = udiv i32 %yMlsbit, 10
  br label %loop
put:
  %isFul = icmp eq i32 %i, 0
  br i1 %isFul, label %printUint, label %fZ
fZ:
  %j = phi i32 [ %i, %put ], [ %jnext, %fZ ]
  %chptr = getelementptr i8, ptr %buf, i32 %j
  store i8 0, ptr %chptr
  %jnext = sub i32 %j, 1
  %isJnul = icmp eq i32 %j, 0
  br i1 %isJnul, label %printUint, label %fZ
printUint:
  %nNobw = call i64 @write(i64 1, ptr %buf, i64 11)
  %nobw = trunc i64 %nNobw to i32
  ret i32 %nobw
err:
  ret i32 -1
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
	%used.ptr = getelementptr ptr, ptr @.filestack.used, i32 %i
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

declare i32 @open(ptr, i32, i16)
declare i32 @close(i32)

declare i64 @strlen(ptr)
declare i64 @write(i64, ptr, i64)
declare i64 @read(i64, ptr, i64)
