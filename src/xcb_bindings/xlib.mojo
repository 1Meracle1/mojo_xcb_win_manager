from sys import DLHandle, RTLD
from memory import UnsafePointer
from sys import ffi

alias XDisplay = UnsafePointer[NoneType]

struct Xlib:
    var handle_xlib: DLHandle
    var handle_xlib_xcb: DLHandle
    var display: XDisplay

    fn __init__(out self):
        self.handle_xlib = DLHandle("libX11.so", RTLD.LAZY)
        self.handle_xlib_xcb = DLHandle("libX11-xcb.so", RTLD.LAZY)
        self.display = self.handle_xlib.call["XOpenDisplay", XDisplay](
            UnsafePointer[ffi.c_char]()
        )
    
    fn __moveinit__(out self, owned existing: Self):
        self.handle_xlib = existing.handle_xlib
        self.handle_xlib_xcb = existing.handle_xlib_xcb
        self.display = existing.display

    fn __del__(owned self):
        self.handle_xlib.call["XCloseDisplay"](self.display)
        self.handle_xlib.close()
        self.handle_xlib_xcb.close()

    fn XGetXCBConnection(self, out conn: xcb_connection_t):
        conn = self.handle_xlib_xcb.call["XGetXCBConnection", xcb_connection_t](self.display)