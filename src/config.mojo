from collections import List, InlineArray
from os.path import exists
from encoding import Ini
from memory import bitcast


@value
struct Color(Writable):
    var r: UInt8
    var g: UInt8
    var b: UInt8
    var a: UInt8

    fn __init__(out self):
        self.r = 255
        self.g = 255
        self.b = 255
        self.a = 255

    fn write_to[W: Writer](self, mut writer: W):
        writer.write(
            "Color(r=",
            self.r,
            ", g=",
            self.g,
            ", b=",
            self.b,
            ", a=",
            self.a,
            ")",
        )

    @staticmethod
    fn from_hex_str(hex_str: String) raises -> Color:
        if not hex_str:
            raise Error(
                "for conversion to Color, hex string should not be empty"
            )
        var start_idx = 0
        if hex_str[0] == "#":
            start_idx = 1
        var num = Int32(int(hex_str[start_idx:], 16))
        var bytes = bitcast[DType.uint8, 4](SIMD[DType.int32, 1](num))
        return Color(r=bytes[3], g=bytes[2], b=bytes[1], a=bytes[0])


@value
struct StyleConfig(Writable):
    var default_width_percent_available_width: Float64
    var minimum_width_window: Int
    var minimum_height_window: Int
    var inner_gap: Int
    var outer_gap_horizontal: Int
    var outer_gap_vertical: Int
    var border_width: Int
    var border_default_color: Color
    var border_active_color: Color

    fn __init__(out self):
        self.default_width_percent_available_width = 0.333
        self.minimum_width_window = 10
        self.minimum_height_window = 10
        self.inner_gap = 5
        self.outer_gap_horizontal = 10
        self.outer_gap_vertical = 10
        self.border_width = 3
        self.border_default_color = Color(77, 208, 225, 255)
        self.border_active_color = Color(255, 255, 255, 255)

    fn write_to[W: Writer](self, mut writer: W):
        writer.write(
            "StyleConfig(\n\tdefault_width_percent_available_width=",
            self.default_width_percent_available_width,
            ",\n\tminimum_width_window=",
            self.minimum_width_window,
            ",\n\tminimum_height_window=",
            self.minimum_height_window,
            ",\n\tinner_gap=",
            self.inner_gap,
            ",\n\touter_gap_horizontal=",
            self.outer_gap_horizontal,
            ",\n\touter_gap_vertical=",
            self.outer_gap_vertical,
            ",\n\tborder_width=",
            self.border_width,
            ",\n\tborder_default_color=",
            self.border_default_color,
            ",\n\tborder_active_color=",
            self.border_active_color,
            ",\n)",
        )


@value
struct EventsConfig(Writable):
    var target_fps: UInt32
    var animations_enabled: Bool
    var animation_duration: Float64  # in seconds

    fn __init__(out self):
        self.target_fps = 60
        self.animations_enabled = True
        self.animation_duration = 1.0

    fn write_to[W: Writer](self, mut writer: W):
        writer.write(
            "EventsConfig(\n\ttarget_fps=",
            self.target_fps,
            ",\n\tanimations_enabled=",
            self.animations_enabled,
            ",\n\tanimation_duration=",
            self.animation_duration,
            ",\n)",
        )


@value
struct Config(Writable):
    var style: StyleConfig
    var events: EventsConfig
    var keymap: List[String]
    var startup_actions: List[String]

    alias DEFAULT_FILE_LOCATIONS = InlineArray[String, 2](
        "./config.ini", "~/.config/mojo_xcb_win_manager/config.ini"
    )

    # when config file path is specified in the command line arguments to the executable
    # fn __init__(out self, preferred_file_path: String):

    @staticmethod
    fn _default() -> Config:
        return Config(
            style=StyleConfig(),
            events=EventsConfig(),
            keymap=List[String](
                "Alt+Left            focus_window left",
                "Alt+Right           focus_window right",
                "Alt+Up              focus_window up",
                "Alt+Down            focus_window down",
                "Alt+H               focus_window left",
                "Alt+L               focus_window right",
                "Alt+K               focus_window up",
                "Alt+J               focus_window down",
                "Alt+Left            focus_window left",
                "Alt+Right           focus_window right",
                "Alt+Up              focus_window up",
                "Alt+Down            focus_window down",
                "Alt+Ctrl+H          move_window left  15",
                "Alt+Ctrl+L          move_window right 15",
                "Alt+Ctrl+K          move_window up    15",
                "Alt+Ctrl+J          move_window down  15",
                "Alt+Shift+H         window_size_change horizontal  15",
                "Alt+Shift+L         window_size_change horizontal  15",
                "Alt+Shift+J         window_size_change vertical    15",
                "Alt+Shift+K         window_size_change vertical    15",
                "Alt+Enter           exec alacritty",
                "Alt+Shift+D         exec dmenu",
                "Alt+Q               kill_focused_window",
                "Alt+Shift+R         restart_window_manager",
                "Alt+Shift+E         exec prompt_exit_window_manager",
                "Alt+Shift+Q         exit_window_manager",
                "Alt+1               switch_to_workspace 1",
                "Alt+2               switch_to_workspace 2",
                "Alt+3               switch_to_workspace 3",
                "Alt+4               switch_to_workspace 4",
                "Alt+5               switch_to_workspace 5",
                "Alt+6               switch_to_workspace 6",
                "Alt+7               switch_to_workspace 7",
                "Alt+8               switch_to_workspace 8",
                "Alt+9               switch_to_workspace 9",
                "Alt+Shift+1         move_focused_window_to_workspace 1",
                "Alt+Shift+2         move_focused_window_to_workspace 2",
                "Alt+Shift+3         move_focused_window_to_workspace 3",
                "Alt+Shift+4         move_focused_window_to_workspace 4",
                "Alt+Shift+5         move_focused_window_to_workspace 5",
                "Alt+Shift+6         move_focused_window_to_workspace 6",
                "Alt+Shift+7         move_focused_window_to_workspace 7",
                "Alt+Shift+8         move_focused_window_to_workspace 8",
                "Alt+Shift+9         move_focused_window_to_workspace 9",
            ),
            startup_actions=List[String](
                "exec    feh --bg-scale wallpapers/wallpaper.png"
            ),
        )

    @staticmethod
    fn _decode_from_file(file_path: String) raises -> Config:
        var map = Ini.load_from_path(file_path)
        var style_map = map["style"].take[Ini.ValueMap]()
        var events_map = map["events"].take[Ini.ValueMap]()
        return Config(
            style=StyleConfig(
                default_width_percent_available_width=style_map[
                    "default_width_percent_available_width"
                ].take[Float64](),
                minimum_width_window=style_map["minimum_width_window"].take[
                    Int
                ](),
                minimum_height_window=style_map["minimum_height_window"].take[
                    Int
                ](),
                inner_gap=style_map["inner_gap"].take[Int](),
                outer_gap_horizontal=style_map["outer_gap_horizontal"].take[
                    Int
                ](),
                outer_gap_vertical=style_map["outer_gap_vertical"].take[Int](),
                border_width=style_map["border_width"].take[Int](),
                border_default_color=Color.from_hex_str(
                    style_map["border_default_color"].take[String]()
                ),
                border_active_color=Color.from_hex_str(
                    style_map["border_active_color"].take[String]()
                ),
            ),
            events=EventsConfig(
                target_fps=events_map["target_fps"].take[Int](),
                animations_enabled=events_map["animations_enabled"].take[
                    Bool
                ](),
                animation_duration=events_map["animation_duration"].take[
                    Float64
                ](),
            ),
            keymap=map["keymap"].take[Ini.ValueStrList](),
            startup_actions=map["startup_actions"].take[Ini.ValueStrList](),
        )

    fn __init__(out self):
        for idx in range(self.DEFAULT_FILE_LOCATIONS.__len__()):
            var file_path = self.DEFAULT_FILE_LOCATIONS[idx]
            if not exists(file_path):
                continue
            try:
                self = Self._decode_from_file(file_path)
                return
            except e:
                print("Failed to decode config from file:", file_path)
                continue

        self = Self._default()

    fn write_to[W: Writer](self, mut writer: W):
        writer.write(
            "Config(\n\tstyle=",
            self.style,
            ",\n\tevents=",
            self.events,
            ",\n\tkeymap=[",
        )
        for idx in range(self.keymap.__len__()):
            writer.write("\n\t\t[", idx, "]=", self.keymap[idx])

        writer.write(
            "),\n\tstartup_actions=[",
        )

        for idx in range(self.startup_actions.__len__()):
            writer.write("\n\t\t[", idx, "]=", self.startup_actions[idx])

        writer.write("],\n)")
