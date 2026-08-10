; BigJ would be proud

; int dabs(int n);
define i32 @dabs(i32 %n) {
  %is.neg = icmp slt i32 %n, 0
  br i1 %is.neg, label %nret, label %pret
nret:
  %p.n = mul i32 %n, -1
  ret i32 %p.n
pret:
  ret i32 %n
}

; double fabs(double n);
define double @fabs(double %n) {
  %is.neg = fcmp olt double %n, 0.0
  br i1 %is.neg, label %nret, label %pret
nret:
  %p.n = fmul double %n, -1.0
  ret double %p.n
pret:
  ret double %n
}
