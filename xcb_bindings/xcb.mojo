from sys import DLHandle, RTLD
from memory import UnsafePointer
from sys import ffi
from collections import InlineArray

from xcb_bindings.xproto import *


@value
struct Xcb:
    var handle: DLHandle
    var conn: xcb_connection_t
    var screen: UnsafePointer[xcb_screen_t]
    var root: xcb_window_t

    fn __init__(out self, owned conn: xcb_connection_t):
        self.handle = DLHandle("libxcb.so", RTLD.LAZY)
        self.conn = conn
        setup = self.handle.call["xcb_get_setup", xcb_setup_t](self.conn)
        iter = self.handle.call[
            "xcb_setup_roots_iterator", xcb_screen_iterator_t
        ](setup)
        self.screen = iter.data
        self.root = self.screen[].root

    fn __del__(owned self):
        self.handle.close()

    fn generate_id(self) -> xcb_window_t:
        return self.handle.call["xcb_generate_id", xcb_window_t](self.conn)

    fn create_window(
        self,
        window: xcb_window_t,
        x: int32_t,
        y: int32_t,
        width: uint32_t,
        height: uint32_t,
        border_width: uint32_t,
    ):
        self.handle.call["xcb_create_window"](
            self.conn,
            XCB_COPY_FROM_PARENT,
            window,
            self.root,
            x,
            y,
            width,
            height,
            border_width,
            XCB_WINDOW_CLASS_INPUT_OUTPUT,
            XCB_COPY_FROM_PARENT,
            XCB_NONE,
            UnsafePointer[NoneType](),
        )

    fn change_window_attributes_checked(
        self, window: xcb_window_t, value_mask: uint32_t, owned value: uint32_t
    ) -> UnsafePointer[xcb_generic_error_t]:
        values = InlineArray[uint32_t, 1](value)
        cookie = self.handle.call[
            "xcb_change_window_attributes_checked",
            xcb_void_cookie_t,
        ](
            self.conn,
            self.root,
            value_mask,
            values.unsafe_ptr(),
        )
        # UnsafePointer.load(UnsafePointer[uint32_t].address_of(value).address),

        return self.handle.call[
            "xcb_request_check",
            UnsafePointer[xcb_generic_error_t],
        ](self.conn, cookie)

    fn poll_for_event(self) -> UnsafePointer[xcb_generic_event_t]:
        return self.handle.call[
            "xcb_poll_for_event", UnsafePointer[xcb_generic_event_t]
        ](self.conn)
