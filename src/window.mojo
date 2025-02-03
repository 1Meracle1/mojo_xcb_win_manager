@value
struct Window:
    var window: UInt32
    var rect: Rect

    fn __init__(out self):
        self.window = 0
        self.rect = Rect()


@value
@register_passable("trivial")
struct Rect(Writable):
    var x: Int32
    var y: Int32
    var width: Int32
    var height: Int32

    fn __init__(out self):
        self.x = 0
        self.y = 0
        self.width = 0
        self.height = 0

    fn write_to[W: Writer](self, mut writer: W):
        writer.write(
            "Rect(x=",
            self.x,
            ", y=",
            self.y,
            ", width=",
            self.width,
            ", height=",
            self.height,
            ")",
        )


struct WindowType:
    alias _type = Int

    alias Normal = 1
    alias Floating = 2
    alias Docked = 3

    @staticmethod
    fn to_string(window_type: WindowType._type) -> String:
        if window_type == WindowType.Normal:
            return "WindowType.Normal"
        if window_type == WindowType.Floating:
            return "WindowType.Floating"
        if window_type == WindowType.Docked:
            return "WindowType.Docked"
        return "WindowType.Unknown"
