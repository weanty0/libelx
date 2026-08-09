;basically stdio.ll

;int putchar(int c);
define external i32 @putchar(i32 %char) {
  ;truncating the 64 bit int to a char
  %buf = alloca i8
  %c = trunc i32 %char to i8
  store i8 %c, ptr %buf

  ;writing
  %wrote = call i32 @write(i32 1, ptr %buf, i32 1)
  %is.successful = icmp sle i32 0, %wrote
  br i1 %is.successful, label %return, label %err
return:
  ;return the char written
  ret i32 %char
err:
  ;return -1
  ret i32 -1
}

;int puts(char* str)
define external i32 @puts(ptr %str) {
  %len = call i32 @strlen(ptr %str)
  ;nob is short for number of bytes (written in this case)
  %nob_w = call i32 @write(i32 1, ptr %str, i32 %len)
  ret i32 %nob_w
}

declare i32 @strlen(ptr)
declare i32 @write(i32, ptr, i32)
