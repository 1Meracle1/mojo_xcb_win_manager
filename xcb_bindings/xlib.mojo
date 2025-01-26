from sys import DLHandle, RTLD
from memory import UnsafePointer
from sys import ffi

alias XDisplay = UnsafePointer[NoneType]

@value
struct Xlib:
    var handle: DLHandle

    fn __init__(out self):
        self.handle = DLHandle("libX11.so", RTLD.LAZY)

    fn __del__(owned self):
        self.handle.close()

    fn XOpenDisplay(self, out display: XDisplay):
        display = self.handle.call["XOpenDisplay", XDisplay](
            UnsafePointer[ffi.c_char]()
        )