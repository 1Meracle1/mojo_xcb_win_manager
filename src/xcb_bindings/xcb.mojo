from sys import DLHandle, RTLD
from memory import UnsafePointer
from sys import ffi
from collections import InlineArray
from utils import StringRef

from xcb_bindings.xproto import *


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
        print("root:", self.root)

    fn __moveinit__(out self, owned existing: Self):
        self.handle = existing.handle
        self.conn = existing.conn
        self.screen = existing.screen
        self.root = existing.root

    fn __del__(owned self):
        # self.handle.call["xcb_disconnect"](self.conn)
        self.handle.close()

    @always_inline
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
        self, window: xcb_window_t, value_mask: uint32_t, value: uint32_t
    ) -> UnsafePointer[xcb_generic_error_t]:
        values = InlineArray[uint32_t, 1](value)
        cookie = self.handle.call[
            "xcb_change_window_attributes_checked",
            xcb_void_cookie_t,
        ](self.conn, window, value_mask, values.unsafe_ptr())

        return self.handle.call[
            "xcb_request_check",
            UnsafePointer[xcb_generic_error_t],
        ](self.conn, cookie)

    @always_inline
    fn change_window_attributes(
        self, window: xcb_window_t, value_mask: uint32_t, value: uint32_t
    ):
        values = InlineArray[uint32_t, 1](value)
        self.handle.call["xcb_change_window_attributes",](
            self.conn, window, value_mask, values.unsafe_ptr()
        )

    @always_inline
    fn poll_for_event(self) -> UnsafePointer[xcb_generic_event_t]:
        return self.handle.call[
            "xcb_poll_for_event", UnsafePointer[xcb_generic_event_t]
        ](self.conn)

    @always_inline
    fn flush(self):
        self.handle.call["xcb_flush"](self.conn)

    fn map_window(self, window: xcb_window_t):
        _ = self.handle.call["xcb_map_window", xcb_void_cookie_t](
            self.conn, window
        )

    fn set_input_focus(self, window: xcb_window_t):
        _ = self.handle.call["xcb_set_input_focus", xcb_void_cookie_t](
            self.conn, XCB_INPUT_FOCUS_POINTER_ROOT, window, XCB_CURRENT_TIME
        )

    fn grab_key(self, modifiers: xcb_mod_mask_t, keycode: xcb_keycode_t):
        _ = self.handle.call["xcb_grab_key", xcb_void_cookie_t](
            self.conn, 
            1, 
            self.root, 
            modifiers.cast[DType.uint16](), 
            keycode,
            XCB_GRAB_MODE_ASYNC,
            XCB_GRAB_MODE_ASYNC
        )

    fn get_window_attributes(self, window: xcb_window_t) -> UnsafePointer[xcb_get_window_attributes_reply_t]:
        var cookie = self.handle.call["xcb_get_window_attributes", xcb_get_window_attributes_cookie_t](
            self.conn, window
        )
        return self.handle.call["xcb_get_window_attributes_reply", UnsafePointer[xcb_get_window_attributes_reply_t]](
            self.conn, cookie, UnsafePointer[xcb_generic_error_t]()
        )

    fn has_override_redirect(self, window: xcb_window_t) -> Bool:
        var window_attrs = self.get_window_attributes(window)
        return window_attrs and window_attrs[].override_redirect == 1

    fn get_property(self, 
        delete: UInt8, 
        window: xcb_window_t, 
        prop: xcb_atom_t, 
        type_t: xcb_atom_t, 
        long_offset: UInt32, 
        long_length: UInt32
    ) -> UnsafePointer[xcb_get_property_reply_t]:
        var cookie = self.handle.call["xcb_get_property", xcb_get_property_cookie_t](
            self.conn, delete, window, prop, type_t, long_offset, long_length
        )
        return self.handle.call["xcb_get_property_reply", UnsafePointer[xcb_get_property_reply_t]](
            self.conn, cookie, UnsafePointer[xcb_generic_error_t]()
        )

    fn get_property_value[T: AnyType](self, r: UnsafePointer[xcb_get_property_reply_t]) -> UnsafePointer[T]:
        return self.handle.call["xcb_get_property_value", UnsafePointer[AnyType]](r).bitcast[T]()

    fn window_class_instance_names(self, window: xcb_window_t) -> (String, String):
        var wm_class_reply = self.get_property(0, window, XCB_ATOM_WM_CLASS, XCB_GET_PROPERTY_TYPE_ANY, 0, 1024)
        if not wm_class_reply:
            print("Failed to retrieve wm class")
            return (String(""), String(""))
        else:
            var cstr = self.get_property_value[UInt8](wm_class_reply)
            var class_name = StringRef(ptr=cstr)
            var instance_name = StringRef(ptr=UnsafePointer.address_of(cstr[class_name.length+1]))
            return (String(class_name), String(instance_name))