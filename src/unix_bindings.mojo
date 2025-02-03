from memory import UnsafePointer
from sys import ffi, external_call

alias NSEC_PER_USEC = 1000
alias NSEC_PER_MSEC = 1_000_000
alias USEC_PER_MSEC = 1000
alias MSEC_PER_SEC = 1000
alias NSEC_PER_SEC = NSEC_PER_USEC * USEC_PER_MSEC * MSEC_PER_SEC

@value
@register_passable("trivial")
struct CTimeSpec(Stringable):
    var tv_sec: Int  # Seconds
    var tv_subsec: Int  # subsecond (nanoseconds on linux and usec on mac)

    fn __init__(out self):
        self.tv_sec = 0
        self.tv_subsec = 0

    fn as_nanoseconds(self) -> UInt:
        return self.tv_sec * NSEC_PER_SEC + self.tv_subsec

    @no_inline
    fn __str__(self) -> String:
        return str(self.as_nanoseconds()) + "ns"

fn nanosleep(nanos: UInt64):
    var tv_spec = CTimeSpec(
        int(nanos / NSEC_PER_SEC),
        int(nanos % NSEC_PER_SEC),
    )
    var req = UnsafePointer[CTimeSpec].address_of(tv_spec)
    var rem = UnsafePointer[CTimeSpec]()
    _ = external_call["nanosleep", Int32](req, rem)