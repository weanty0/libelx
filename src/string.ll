;stringy shit
;string.h

;size_t strlen(char* str);
define external i64 @strlen(ptr %str) {
entry:
  br label %loop
loop:
  %i = phi i64 [ 0, %entry], [ %i.next, %loop ]   ;setting i to 0 or the i+1 depending on if it comes from entry or nay.
  %i.next = add i64 %i, 1
  %char.ptr = getelementptr i8, ptr %str, i64 %i  ;getting the ptr
  %char = load i8, ptr %char.ptr                  ;loading char from the ptr
  %is.null = icmp eq i8 %char, 0                  ;checking if the char is a null terminator
  br i1 %is.null, label %return, label %loop
return:
  ret i64 %i
}
