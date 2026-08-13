;basically stdio.ll

;int putchar(int c);
define external i32 @putchar(i32 %chr) {
  ;truncating the 64 bit int to a char
  %buf = alloca i8
  %c = trunc i32 %chr to i8
  store i8 %c, ptr %buf

  ;writing
  %wrote = call i64 @write(i64 1, ptr %buf, i64 1)
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
define external i32 @puts(ptr %str) {
  %len = call i64 @strlen(ptr %str)
  ;nob is short for number of bytes (written in this case)
  %nob.w = call i64 @write(i64 1, ptr %str, i64 %len)
  %nob_w = trunc i64 %nob.w to i32
  ret i32 %nob_w
}

declare i64 @strlen(ptr)
declare i64 @write(i64, ptr, i64)
declare i64 @read(i64, ptr, i64)
