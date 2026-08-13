;When I started working on this project, only god knew how it worked. Today, Nothing has changed
;Anyone contributing to this, increse the counter. ty
;
;Total hours wasted on this dumpsterfire: 6
;
;Implemented with x86_64 asm

; int -> i32
; long, size_t -> i64

;implementing a syscall wrapper
define i64 @syscall(i64 %call, i64 %rdi, i64 %rsi, i64 %rdx, i64 %r10, i64 %r8, i64 %r9) alwaysinline {
  %rax = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11}"(i64 %call, i64 %rdi, i64 %rsi, i64 %rdx, i64 %r10, i64 %r8, i64 %r9)
  ret i64 %rax
}

;stating main exsists somewhere
declare i32 @main(i32, ptr)

;start
define void @_start() naked {
  ;zero rbp
  call void asm sideeffect "", "{rbp}"(i64 0)
  ;loading rsp
  %rsp = call ptr asm "", "={rsp},{rsp}"(ptr undef)

  ;deref rsp to get argc
  %argc = load i32, ptr %rsp
  ;compute address of argv
  %argv = getelementptr i8, ptr %rsp, i64 8

  ;calling main
  %exc = call i32 @main(i32 %argc, ptr %argv)
  %ec = zext i32 %exc to i64
  call void @exit(i64 %ec)
  unreachable
}

;exiting
define void @exit(i32 %ec) alwaysinline noreturn {
  %exitcode = zext i32 %ec to i64
  call i64 @syscall(i64 60, i64 %exitcode, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef)

  ;stuff i need to sleep at night
  call void asm sideeffect "hlt", ""() noreturn
  unreachable
}

;moving all of the asm wrapping to this file
;first of write for puts, printf etc...
define i64 @write(i64 %fd, ptr %buf, i64 %count) {
  ;nob for number of bytes
  %nob.w = call i64 @syscall(i64 1, i64 %fd, ptr %buf, i64 %count, i64 undef, i64 undef, i64 undef)
  ret i64 %nob.w
}

;read for getchar etc..
define i64 @read(i64 %fd, ptr %buf, i64 %count) {
  ;number of bytes read
  %nob.r = call i64 @syscall(i64 0, i64 %fd, ptr %buf, i64 %count, i64 undef, i64 undef, i64 undef)
  ret i64 %nob.r
}
