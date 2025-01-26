from xcb_bindings import *


def main():
    xlib = Xlib()
    display = xlib.XOpenDisplay()
    if not display:
        print("Failed to grab Xlib's display.")
        return

    xlib_xcb = XlibXcb()
    conn = xlib_xcb.XGetXCBConnection(display)
    if not conn:
        print("Failed to get XCB connection.")
        return

    xcb = Xcb(conn)

    err = xcb.change_window_attributes_checked(
        xcb.root,
        XCB_CW_EVENT_MASK,
        XCB_EVENT_MASK_SUBSTRUCTURE_REDIRECT
        | XCB_EVENT_MASK_SUBSTRUCTURE_NOTIFY
        | XCB_EVENT_MASK_POINTER_MOTION,
    )
    if err:
        print("Another window manager is running.")
        return
    
    meta_window = xcb.generate_id()
    xcb.create_window(meta_window, -1, -1, 1, 1, 0)
    print("meta_window:", meta_window)

    while True:
        generic_event = xcb.poll_for_event()
        if not generic_event:
            print("Received null event, exiting")
            break