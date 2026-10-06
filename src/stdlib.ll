;Implementation of stdlib.h wah
define i32 @atoi(ptr %str) {
  br label %loop
loop:
  %i = phi i32 [ 0, %0 ], [ %iNext, %parse ]
  %result = phi i32 [ 0, %0 ], [ %resultNext, %parse ]
  %iNext = add i32 %i, 1
  %cptr = getelementptr i8, ptr %str, i32 %i
  %c = load i8, ptr %cptr

  %isNumLow = icmp uge i8 %c, 48
  %isNumHigh = icmp ule i8 %c, 57
  %isNum = and i1 %isNumLow, %isNumHigh
  br i1 %isNum, label %parse, label %return
parse:
  %cnum = sub i8 %c, 48
  %cint = zext i8 %cnum to i32
  %result.c = mul i32 %result, 10
  %resultNext = add i32 %result.c, %cint
  br label %loop
return:
  ret i32 %result
}

define ptr @itoa(i32 %x) {
  %buf = alloca [ 12 x i8 ]
  %isNeg = icmp slt i32 %x, 0
  br i1 %isNeg, label %negex, label %posx
negex:
  %pzero = getelementptr i8, ptr %buf, i32 0
  store i8 45, ptr %pzero
  %ngx = mul i32 %x , -1
  br label %entry
posx:
  %pzeri = getelementptr i8, ptr %buf, i32 0
  store i8 0, ptr %pzeri
  br label %entry
entry:
  %z = phi i32 [ %x, %posx ], [ %ngx, %negex ]
  br label %loop
loop:
  %i = phi i32 [ 10, %entry ], [ %inext, %shiftY ]
  %y = phi i32 [ %z, %entry ], [ %ynext, %shiftY ]
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
  %isFul = icmp eq i32 %i, 1
  br i1 %isFul, label %retu, label %fZ
fZ:
  %j = phi i32 [ %i, %put ], [ %jnext, %fZ ]
  %chptr = getelementptr i8, ptr %buf, i32 %j
  store i8 0, ptr %chptr
  %jnext = sub i32 %j, 1
  %isJnul = icmp eq i32 %j, 1
  br i1 %isJnul, label %retu, label %fZ
retu:
  ret ptr %buf
}
