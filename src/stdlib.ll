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
