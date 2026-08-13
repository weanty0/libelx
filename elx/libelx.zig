// elx.ll
pub extern fn exit(exitcode: i32) void;
pub extern fn write(fd: c_ulong, buf: [*]const u8, count: usize) isize;
pub extern fn read(fd: c_ulong, buf: [*]u8, count: usize) isize;

// stdlib.ll

// stdio.ll
pub extern fn getchar(void) i32;
pub extern fn putchar(chr: i32) i32;
pub extern fn puts(str: [*:0]const u8) i32;

// math.ll
pub extern fn dabs(n: i32) i32;
pub extern fn fabs(n: f64) f64;

// string.ll
pub extern fn strlen(str: [*:0]const u8) usize;

// etypes.ll
