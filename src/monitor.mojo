from window import *
from space import *

@value
struct Monitor:
    var rect: Rect
    var spaces: List[Space]
    var focused_space: Int
    var docked_windows: List[Window]

    fn __init__(out self, x: Int32, y: Int32, width: Int32, height: Int32):
        self.rect = Rect(x, y, width, height)
        self.spaces = List[Space](Space())
        self.focused_space = 0
        self.docked_windows = List[Window]()
    
    fn available_rect(self) -> Rect:
        var rect = self.rect
        return rect