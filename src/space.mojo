from xcb_bindings import *
from window import *

@value
struct Space:
    var focused_window: xcb_window_t
    var focused_type: WindowType._type
    var floating_windows: List[xcb_window_t]
    var normal_windows: List[Window]
    var docked_windows: List[Window]

    fn __init__(out self):
        self.focused_window = XCB_NONE
        self.focused_type = WindowType.Normal
        self.floating_windows = List[xcb_window_t]()
        self.normal_windows = List[Window]()
        self.docked_windows = List[Window]()

    fn available_rect(self, monitor_available_rect: Rect) -> Rect:
        var rect = monitor_available_rect
        return rect