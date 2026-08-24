;When I started working on this project, only god knew how it worked. Today, Nothing has changed
;Anyone contributing to this, increse the counter. ty
;
;Total hours wasted on this dumpsterfire: 11
;
;Implemented with x86_64 asm

; int -> i32
; long, size_t -> i64

%size_t = type i64
%ssize_t = type i64
%umode_t = type i16

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
define void @exit(i64 %ec) alwaysinline noreturn {
  call i64 @syscall(i64 60, i64 %ec, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef)

  ;stuff i need to sleep at night
  call void asm sideeffect "hlt", ""() noreturn
  unreachable
}

;moving all of the asm wrapping to this file
;first of write for puts, printf etc...
define external %ssize_t @write(i64 %fd, ptr %buf, %size_t %count) {
  ;nob for number of bytes
  %nob.w = call i64 @syscall(i64 1, i64 %fd, ptr %buf, %size_t %count, i64 undef, i64 undef, i64 undef)
  ret %ssize_t %nob.w
}

;read for getchar etc..
define external %ssize_t @read(i64 %fd, ptr %buf, %size_t %count) {
  ;number of bytes read
  %nob.r = call i64 @syscall(i64 0, i64 %fd, ptr %buf, %size_t %count, i64 undef, i64 undef, i64 undef)
  ret %ssize_t %nob.r
}

;wrapper for open
define external i32 @open(ptr %filename, i32 %flags, %umode_t %mode) {
  ;expanding shit to i64
  %flags.64 = zext i32 %flags to i64
  %mode.64 = zext %umode_t %mode to i64

  ;call
  %fd.64 = call i64 @syscall(i64 2, ptr %filename, i64 %flags.64, i64 %mode.64, i64 undef, i64 undef, i64 undef)
  ;trunc for return
  %fd = trunc i64 %fd.64 to i32
  ret i32 %fd
}

;fclose
define external i32 @close(i32 %fd) {
  %fd.64 = zext i32 %fd to i64
  ;rval
  %rv.64 = call i64 @syscall(i64 3, i64 %fd.64, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef)
  %rv = trunc i64 %rv.64 to i32
  ret i32 %rv
}
