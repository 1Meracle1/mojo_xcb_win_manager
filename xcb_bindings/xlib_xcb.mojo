from sys import DLHandle, RTLD
from memory import UnsafePointer
from sys import ffi

from xcb_bindings.xcb import xcb_connection_t
from xcb_bindings.xlib import XDisplay


@value
struct XlibXcb:
    var handle: DLHandle

    fn __init__(out self):
        self.handle = DLHandle("libX11-xcb.so", RTLD.LAZY)

    fn __del__(owned self):
        self.handle.close()

    fn XGetXCBConnection(self, display: XDisplay, out conn: xcb_connection_t):
        conn = self.handle.call["XGetXCBConnection", xcb_connection_t](display)
