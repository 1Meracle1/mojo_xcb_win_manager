from sys import DLHandle, RTLD
from memory import UnsafePointer
from memory.maybe_uninitialized import UnsafeMaybeUninitialized
from sys import ffi
from collections import InlineArray

from xcb_bindings.xproto import *
from window import *


struct XcbEwmh:
    var handle: DLHandle
    var ewmh: UnsafePointer[xcb_ewmh_connection_t]

    fn __init__(out self, conn: xcb_connection_t) raises:
        self.handle = DLHandle("libxcb-ewmh.so", RTLD.LAZY)
        self.ewmh = UnsafePointer[xcb_ewmh_connection_t].alloc(1)

        var cookie = self.handle.call[
            "xcb_ewmh_init_atoms", UnsafePointer[xcb_intern_atom_cookie_t]
        ](conn, self.ewmh)
        if not self.handle.call["xcb_ewmh_init_atoms_replies", UInt8](
            self.ewmh, cookie, UnsafePointer[xcb_generic_error_t]()
        ):
            raise Error("Failed to initialize ewmh atoms")

        var net_atoms = InlineArray[xcb_atom_t, 27](
            self.ewmh[]._NET_SUPPORTED,
            self.ewmh[]._NET_SUPPORTING_WM_CHECK,
            self.ewmh[]._NET_DESKTOP_NAMES,
            self.ewmh[]._NET_DESKTOP_VIEWPORT,
            self.ewmh[]._NET_NUMBER_OF_DESKTOPS,
            self.ewmh[]._NET_CURRENT_DESKTOP,
            self.ewmh[]._NET_CLIENT_LIST,
            self.ewmh[]._NET_ACTIVE_WINDOW,
            self.ewmh[]._NET_WM_NAME,
            self.ewmh[]._NET_CLOSE_WINDOW,
            self.ewmh[]._NET_WM_STRUT_PARTIAL,
            self.ewmh[]._NET_WM_DESKTOP,
            self.ewmh[]._NET_WM_STATE,
            self.ewmh[]._NET_WM_STATE_HIDDEN,
            self.ewmh[]._NET_WM_STATE_FULLSCREEN,
            self.ewmh[]._NET_WM_STATE_BELOW,
            self.ewmh[]._NET_WM_STATE_ABOVE,
            self.ewmh[]._NET_WM_STATE_STICKY,
            self.ewmh[]._NET_WM_STATE_DEMANDS_ATTENTION,
            self.ewmh[]._NET_WM_WINDOW_TYPE,
            self.ewmh[]._NET_WM_WINDOW_TYPE_DOCK,
            self.ewmh[]._NET_WM_WINDOW_TYPE_DESKTOP,
            self.ewmh[]._NET_WM_WINDOW_TYPE_NOTIFICATION,
            self.ewmh[]._NET_WM_WINDOW_TYPE_DIALOG,
            self.ewmh[]._NET_WM_WINDOW_TYPE_SPLASH,
            self.ewmh[]._NET_WM_WINDOW_TYPE_UTILITY,
            self.ewmh[]._NET_WM_WINDOW_TYPE_TOOLBAR,
        )
        var set_supported_cookie = self.handle.call[
            "xcb_ewmh_set_supported_checked", xcb_void_cookie_t
        ](self.ewmh, 0, net_atoms.__len__(), net_atoms.unsafe_ptr())
        var error = self.handle.call[
            "xcb_request_check", UnsafePointer[xcb_generic_error_t]
        ](conn, set_supported_cookie)
        if error:
            raise Error("Failed to set supported ewmh atoms")

    fn __moveinit__(out self, owned existing: Self):
        self.handle = existing.handle
        self.ewmh = existing.ewmh

    fn __del__(owned self):
        self.ewmh.free()
        self.handle.close()

    fn window_type(self, window: xcb_window_t) -> WindowType._type:
        var res = WindowType.Normal

        var cookie = self.handle.call[
            "xcb_ewmh_get_wm_window_type", xcb_get_property_cookie_t
        ](self.ewmh, window)
        var atoms_reply = xcb_ewmh_get_atoms_reply_t()
        if self.handle.call["xcb_ewmh_get_wm_window_type_reply", UInt8](
            self.ewmh,
            cookie,
            UnsafePointer.address_of(atoms_reply),
            UnsafePointer[xcb_generic_error_t](),
        ):
            for idx in range(atoms_reply.atoms_len):
                var atom = atoms_reply.atoms[idx]
                if atom == self.ewmh[]._NET_WM_WINDOW_TYPE_NORMAL:
                    break

                if (
                    atom == self.ewmh[]._NET_WM_WINDOW_TYPE_DIALOG
                    or atom == self.ewmh[]._NET_WM_WINDOW_TYPE_UTILITY
                    or atom == self.ewmh[]._NET_WM_WINDOW_TYPE_TOOLBAR
                    or atom == self.ewmh[]._NET_WM_WINDOW_TYPE_SPLASH
                    or atom == self.ewmh[]._NET_WM_WINDOW_TYPE_MENU
                ):
                    res = WindowType.Floating
                    break

                if atom == self.ewmh[]._NET_WM_WINDOW_TYPE_DOCK:
                    res = WindowType.Docked
                    break

        return res

    fn window_rect_hints(self, window: xcb_window_t, read xcb: Xcb) -> Rect:
        var rect = Rect()
        var normal_hints_reply = xcb.get_property(
            0,
            window,
            XCB_ATOM_WM_NORMAL_HINTS,
            XCB_GET_PROPERTY_TYPE_ANY,
            0,
            1024,
        )
        if (
            normal_hints_reply
            or normal_hints_reply[].type != XCB_ATOM_WM_SIZE_HINTS
        ):
            var size_hints = xcb.get_property_value[xcb_size_hints_t](
                normal_hints_reply
            )
            rect = Rect(
                size_hints[].x,
                size_hints[].y,
                size_hints[].width,
                size_hints[].height,
            )

        return rect

    fn window_strut_partial_rect(
        self, window: xcb_window_t, available_rect: Rect
    ) -> Rect:
        var cookie = self.handle.call[
            "xcb_ewmh_get_wm_strut_partial", xcb_get_property_cookie_t
        ](self.ewmh, window)
        var strut = xcb_ewmh_wm_strut_partial_t()
        if self.handle.call["xcb_ewmh_get_wm_strut_partial_reply", UInt8](
            self.ewmh, cookie, UnsafePointer.address_of(strut)
        ):
            if strut.left > 0:
                return Rect(
                    0,
                    0,
                    strut.left.cast[DType.int32](),
                    available_rect.height.cast[DType.int32](),
                )
            if strut.right > 0:
                return Rect(
                    available_rect.width - strut.right.cast[DType.int32](),
                    0,
                    strut.right.cast[DType.int32](),
                    available_rect.height.cast[DType.int32](),
                )
            if strut.top > 0:
                return Rect(
                    strut.top_start_x.cast[DType.int32](),
                    0,
                    strut.top_end_x.cast[DType.int32](),
                    strut.top.cast[DType.int32](),
                )
            if strut.bottom > 0:
                return Rect(
                    strut.bottom_start_x.cast[DType.int32](),
                    available_rect.height - strut.bottom.cast[DType.int32](),
                    strut.bottom_end_x.cast[DType.int32]()
                    - strut.bottom_start_x.cast[DType.int32]()
                    + 1,
                    strut.bottom.cast[DType.int32](),
                )
            return Rect(
                0,
                available_rect.height - 25,
                available_rect.width + 1,
                25,
            )
        return Rect()

    fn window_requested_space(self, window: xcb_window_t) -> Int:
        var cookie = self.handle.call[
            "xcb_ewmh_get_wm_desktop", xcb_get_property_cookie_t
        ](self.ewmh, window)
        var space: Int = -1
        _ = self.handle.call["xcb_ewmh_get_cardinal_reply", UInt8](
            self.ewmh,
            cookie,
            UnsafePointer.address_of(space),
            UnsafePointer[xcb_generic_error_t](),
        )
        # if space == UInt32.MAX:
        #     return -1
        # return Int(space.cast[DType.]())
        return space


@value
struct xcb_ewmh_connection_t:
    var connection: UnsafePointer[xcb_connection_t]
    var screens: UnsafePointer[xcb_screen_t]
    var nb_screens: Int32
    var _NET_WM_CM_Sn: UnsafePointer[xcb_atom_t]
    var _NET_SUPPORTED: xcb_atom_t
    var _NET_CLIENT_LIST: xcb_atom_t
    var _NET_CLIENT_LIST_STACKING: xcb_atom_t
    var _NET_NUMBER_OF_DESKTOPS: xcb_atom_t
    var _NET_DESKTOP_GEOMETRY: xcb_atom_t
    var _NET_DESKTOP_VIEWPORT: xcb_atom_t
    var _NET_CURRENT_DESKTOP: xcb_atom_t
    var _NET_DESKTOP_NAMES: xcb_atom_t
    var _NET_ACTIVE_WINDOW: xcb_atom_t
    var _NET_WORKAREA: xcb_atom_t
    var _NET_SUPPORTING_WM_CHECK: xcb_atom_t
    var _NET_VIRTUAL_ROOTS: xcb_atom_t
    var _NET_DESKTOP_LAYOUT: xcb_atom_t
    var _NET_SHOWING_DESKTOP: xcb_atom_t
    var _NET_CLOSE_WINDOW: xcb_atom_t
    var _NET_MOVERESIZE_WINDOW: xcb_atom_t
    var _NET_WM_MOVERESIZE: xcb_atom_t
    var _NET_RESTACK_WINDOW: xcb_atom_t
    var _NET_REQUEST_FRAME_EXTENTS: xcb_atom_t
    var _NET_WM_NAME: xcb_atom_t
    var _NET_WM_VISIBLE_NAME: xcb_atom_t
    var _NET_WM_ICON_NAME: xcb_atom_t
    var _NET_WM_VISIBLE_ICON_NAME: xcb_atom_t
    var _NET_WM_DESKTOP: xcb_atom_t
    var _NET_WM_WINDOW_TYPE: xcb_atom_t
    var _NET_WM_STATE: xcb_atom_t
    var _NET_WM_ALLOWED_ACTIONS: xcb_atom_t
    var _NET_WM_STRUT: xcb_atom_t
    var _NET_WM_STRUT_PARTIAL: xcb_atom_t
    var _NET_WM_ICON_GEOMETRY: xcb_atom_t
    var _NET_WM_ICON: xcb_atom_t
    var _NET_WM_PID: xcb_atom_t
    var _NET_WM_HANDLED_ICONS: xcb_atom_t
    var _NET_WM_USER_TIME: xcb_atom_t
    var _NET_WM_USER_TIME_WINDOW: xcb_atom_t
    var _NET_FRAME_EXTENTS: xcb_atom_t
    var _NET_WM_PING: xcb_atom_t
    var _NET_WM_SYNC_REQUEST: xcb_atom_t
    var _NET_WM_SYNC_REQUEST_COUNTER: xcb_atom_t
    var _NET_WM_FULLSCREEN_MONITORS: xcb_atom_t
    var _NET_WM_FULL_PLACEMENT: xcb_atom_t
    var UTF8_STRING: xcb_atom_t
    var WM_PROTOCOLS: xcb_atom_t
    var MANAGER: xcb_atom_t
    var _NET_WM_WINDOW_TYPE_DESKTOP: xcb_atom_t
    var _NET_WM_WINDOW_TYPE_DOCK: xcb_atom_t
    var _NET_WM_WINDOW_TYPE_TOOLBAR: xcb_atom_t
    var _NET_WM_WINDOW_TYPE_MENU: xcb_atom_t
    var _NET_WM_WINDOW_TYPE_UTILITY: xcb_atom_t
    var _NET_WM_WINDOW_TYPE_SPLASH: xcb_atom_t
    var _NET_WM_WINDOW_TYPE_DIALOG: xcb_atom_t
    var _NET_WM_WINDOW_TYPE_DROPDOWN_MENU: xcb_atom_t
    var _NET_WM_WINDOW_TYPE_POPUP_MENU: xcb_atom_t
    var _NET_WM_WINDOW_TYPE_TOOLTIP: xcb_atom_t
    var _NET_WM_WINDOW_TYPE_NOTIFICATION: xcb_atom_t
    var _NET_WM_WINDOW_TYPE_COMBO: xcb_atom_t
    var _NET_WM_WINDOW_TYPE_DND: xcb_atom_t
    var _NET_WM_WINDOW_TYPE_NORMAL: xcb_atom_t
    var _NET_WM_STATE_MODAL: xcb_atom_t
    var _NET_WM_STATE_STICKY: xcb_atom_t
    var _NET_WM_STATE_MAXIMIZED_VERT: xcb_atom_t
    var _NET_WM_STATE_MAXIMIZED_HORZ: xcb_atom_t
    var _NET_WM_STATE_SHADED: xcb_atom_t
    var _NET_WM_STATE_SKIP_TASKBAR: xcb_atom_t
    var _NET_WM_STATE_SKIP_PAGER: xcb_atom_t
    var _NET_WM_STATE_HIDDEN: xcb_atom_t
    var _NET_WM_STATE_FULLSCREEN: xcb_atom_t
    var _NET_WM_STATE_ABOVE: xcb_atom_t
    var _NET_WM_STATE_BELOW: xcb_atom_t
    var _NET_WM_STATE_DEMANDS_ATTENTION: xcb_atom_t
    var _NET_WM_ACTION_MOVE: xcb_atom_t
    var _NET_WM_ACTION_RESIZE: xcb_atom_t
    var _NET_WM_ACTION_MINIMIZE: xcb_atom_t
    var _NET_WM_ACTION_SHADE: xcb_atom_t
    var _NET_WM_ACTION_STICK: xcb_atom_t
    var _NET_WM_ACTION_MAXIMIZE_HORZ: xcb_atom_t
    var _NET_WM_ACTION_MAXIMIZE_VERT: xcb_atom_t
    var _NET_WM_ACTION_FULLSCREEN: xcb_atom_t
    var _NET_WM_ACTION_CHANGE_DESKTOP: xcb_atom_t
    var _NET_WM_ACTION_CLOSE: xcb_atom_t
    var _NET_WM_ACTION_ABOVE: xcb_atom_t
    var _NET_WM_ACTION_BELOW: xcb_atom_t


@value
struct xcb_ewmh_get_atoms_reply_t:
    var atoms_len: uint32_t
    var atoms: UnsafePointer[xcb_atom_t]
    var _reply: UnsafePointer[xcb_get_property_reply_t]

    fn __init__(out self):
        self.atoms_len = 0
        self.atoms = UnsafePointer[xcb_atom_t]()
        self._reply = UnsafePointer[xcb_get_property_reply_t]()


@value
struct xcb_ewmh_wm_strut_partial_t:
    var left: uint32_t
    var right: uint32_t
    var top: uint32_t
    var bottom: uint32_t
    var left_start_y: uint32_t
    var left_end_y: uint32_t
    var right_start_y: uint32_t
    var right_end_y: uint32_t
    var top_start_x: uint32_t
    var top_end_x: uint32_t
    var bottom_start_x: uint32_t
    var bottom_end_x: uint32_t

    fn __init__(out self):
        self.left = 0
        self.right = 0
        self.top = 0
        self.bottom = 0
        self.left_start_y = 0
        self.left_end_y = 0
        self.right_start_y = 0
        self.right_end_y = 0
        self.top_start_x = 0
        self.top_end_x = 0
        self.bottom_start_x = 0
        self.bottom_end_x = 0
