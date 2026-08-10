; BigJ would be proud

; int dabs(int n);
define i64 @dabs(i64 %n) {
  %is.neg = icmp slt i64 %n, 0
  br i1 %is.neg, label %nret, label %pret
nret:
  %p.n = mul i64 %n, -1
  ret i64 %p.n
pret:
  ret i64 %n
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
