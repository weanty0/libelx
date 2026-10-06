define i64 @ipow(i32 %base, i32 %e) {
  %b = sext i32 %base to i64
  %sqrt = icmp slt i32 %e, 0
  br i1 %sqrt, label %retNUL, label %isNulE
isNulE:
  %nule = icmp eq i32 %e, 0
  br i1 %nule, label %retONE, label %loop
loop:
  %i = phi i32 [ 1, %isNulE ], [ %iNext, %loop ]
  %result = phi i64 [ 1, %isNulE ], [ %resultNext, %loop ]
  %iNext = add i32 %i, 1
  %resultNext = mul i64 %result, %b
  %final = icmp eq i32 %i, %e
  br i1 %final, label %retu, label %loop
retu:
  ret i64 %resultNext
retONE:
  ret i64 1
retNUL:
  ret i64 0
}
