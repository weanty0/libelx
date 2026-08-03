;basically stdio.ll

;int puts(char* str)
define external i64 @puts(ptr %str) {
  %len = call i64 @strlen(ptr %str)
  ;nob is short for number of bytes (written in this case)
  %nob_w = call i64 @write(i64 1, ptr %str, i64 %len)
  ret i64 %nob_w
}

declare i64 @strlen(ptr)
declare i64 @write(i64, ptr, i64)
