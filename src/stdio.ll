;basically stdio.ll

;int putchar(int c);
define external i64 @putchar(i64 %char) {
  ;truncating the 64 bit int to a char
  %buf = alloca i8
  %c = trunc i64 %char to i8
  store i8 %c, ptr %buf

  ;writing
  %wrote = call i64 @write(i64 1, ptr %buf, i64 1)
  %is.successful = icmp sle i64 0, %wrote
  br i1 %is.successful, label %return, label %err
return:
  ;return the char written
  ret i64 %c
err:
  ;return -1
  ret i64 -1
}

;int puts(char* str)
define external i64 @puts(ptr %str) {
  %len = call i64 @strlen(ptr %str)
  ;nob is short for number of bytes (written in this case)
  %nob_w = call i64 @write(i64 1, ptr %str, i64 %len)
  ret i64 %nob_w
}

declare i64 @strlen(ptr)
declare i64 @write(i64, ptr, i64)
