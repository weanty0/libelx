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

;char *strcpy(char *dest, char *str);
define external ptr @strcpy(ptr %dest, ptr %str) {
entry:
  br label %loop
loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop ]
  %i.next = add i64 %i, 1
  %str.p = getelementptr i8, ptr %str, i64 %i
  %chr = load i8, ptr %str.p
  %dest.p = getelementptr i8, ptr %dest, i64 %i
  store i8 %chr, ptr %dest.p
  %is.null = icmp eq i8 %chr, 0
  br i1 %is.null, label %return, label %loop
return:
  ret ptr %dest
}

;int strcmp(char *s1, char *s2);
define external i32 @strcmp(ptr %a, ptr %b) {
entry:
  br label %loop
loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.pst ]
  %i.next = add i64 %i, 1
  %a.p = getelementptr i8, ptr %a, i64 %i
  %b.p = getelementptr i8, ptr %b, i64 %i
  %c.a = load i8, ptr %a.p
  %c.b = load i8, ptr %b.p
  %is.eq = icmp eq i8 %c.a, %c.b
  br i1 %is.eq, label %loop.pst, label %return
loop.pst:
  %is.null = icmp eq i8 %c.a, 0
  br i1 %is.null, label %return, label %loop
return:
  %rval = phi i32 [ 0, %loop.pst ], [ 1, %loop ]
  ret i32 %rval
}
