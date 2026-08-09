;When I started working on this project, only god knew how it worked. Today, Nothing has changed
;Anyone contributing to this, increse the counter. ty
;
;Total hours wasted on this dumpsterfire: 3
;
;Implemented with x86_64 asm

; note:
; int - i32
; long & long long & size_t -> i64

;implementing a syscall wrapper
define i32 @syscall(i32 %call, i32 %rdi, i32 %rsi, i32 %rdx, i32 %r10, i32 %r8, i32 %r9) alwaysinline {
  %rax = call i32 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11}"(i32 %call, i32 %rdi, i32 %rsi, i32 %rdx, i32 %r10, i32 %r8, i32 %r9)
  ret i32 %rax
}

;stating main exsists somewhere
declare i32 @main(i32, ptr)

;start
define void @_start() naked {
  ;zero rbp
  call void asm sideeffect "", "{rbp}"(i32 0)
  ;loading rsp
  %rsp = call ptr asm "", "={rsp},{rsp}"(ptr undef)

  ;deref rsp to get argc
  %argc = load i32, ptr %rsp
  ;compute address of argv
  %argv = getelementptr i8, ptr %rsp, i32 8

  ;calling main
  %ec = call i32 @main(i32 %argc, ptr %argv)
  call void @exit(i32 %ec)
  unreachable
}

;exiting
define void @exit(i32 %exitcode) alwaysinline noreturn {
  call i64 @syscall(i32 60, i32 %exitcode, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef)

  ;stuff i need to sleep at night
  call void asm sideeffect "hlt", ""() noreturn
  unreachable
}

;moving all of the asm wrapping to this file
;first of write for puts, printf etc...
define i64 @write(i32 %fd, ptr %buf, i32 %count) {
  ;nob for number of bytes
  %nob.w = call i32 @syscall(i32 1, i32 %fd, ptr %buf, i32 %count, i32 undef, i32 undef, i32 undef)
  ret i32 %nob.w
}
