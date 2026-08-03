;basically stdio.ll

;int puts(char* str)
define external i64 @puts(ptr %str) {
  %len = call i64 @strlen(ptr %str)
  ;nob is short for number of bytes (written in this case)
  %nob_w = call i64 @syscall(i64 1, i64 1, ptr %str, i64 %len, i64 undef, i64 undef, i64 undef)
  ret i64 %nob_w
}

declare i64 @strlen(ptr)
declare i64 @syscall(i64, i64, i64, i64, i64, i64, i64)
