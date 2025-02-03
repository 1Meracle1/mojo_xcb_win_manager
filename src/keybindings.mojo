from memory import UnsafePointer
from xcb_bindings import *
from collections import InlinedFixedVector, Dict
from xcb_bindings import Xcb


@value
struct Keybinding:
    var modifier: xcb_mod_mask_t
    var keycode: xcb_keycode_t
    var mods_count: UInt32
    var action: fn () -> None


struct KeybindingsManager:
    var keybindings: List[Keybinding]

    fn __init__(out self, keybindings: List[Keybinding]):
        self.keybindings = keybindings

    fn grab_keys(self, read xcb: Xcb):
        for binding in self.keybindings:
            xcb.grab_key(binding[].modifier, binding[].keycode)
            xcb.grab_key(binding[].modifier, binding[].keycode | XCB_MOD_MASK_2)
            xcb.grab_key(
                binding[].modifier, binding[].keycode | XCB_MOD_MASK_LOCK
            )
            xcb.grab_key(
                binding[].modifier,
                binding[].keycode | XCB_MOD_MASK_2 | XCB_MOD_MASK_LOCK,
            )

    fn handle_key_press(mut self, event: UnsafePointer[xcb_key_press_event_t]):
        var modifiers = (
            event[].state & ~(XCB_MOD_MASK_2 | XCB_MOD_MASK_LOCK)
        ).cast[DType.uint32]()
        var keycode = event[].detail
        print("modifiers:", modifiers, "keycode:", keycode, "root:", event[].root)
        if modifiers == 0:
            return
        for binding in self.keybindings:
            if (
                modifiers & binding[].modifier
            ) == binding[].modifier and keycode == binding[].keycode:
                binding[].action()

    fn handle_key_release(
        mut self, event: UnsafePointer[xcb_key_release_event_t]
    ):
        _ = event


# alias keycode_to_str: InlineArray[String, 100](
#         self.keys_to_strs[9] = "Escape"
#         self.keys_to_strs[10] = "1"
#         self.keys_to_strs[11] = "2"
#         self.keys_to_strs[12] = "3"
#         self.keys_to_strs[13] = "4"
#         self.keys_to_strs[14] = "5"
#         self.keys_to_strs[15] = "6"
#         self.keys_to_strs[16] = "7"
#         self.keys_to_strs[17] = "8"
#         self.keys_to_strs[18] = "9"
#         self.keys_to_strs[19] = "0"
#         self.keys_to_strs[20] = "minus"
#         self.keys_to_strs[21] = "equal"
#         self.keys_to_strs[22] = "BackSpace"
#         self.keys_to_strs[23] = "Tab"
#         self.keys_to_strs[24] = "q"
#         self.keys_to_strs[25] = "w"
#         self.keys_to_strs[26] = "e"
#         self.keys_to_strs[27] = "r"
#         self.keys_to_strs[28] = "t"
#         self.keys_to_strs[29] = "y"
#         self.keys_to_strs[30] = "u"
#         self.keys_to_strs[31] = "i"
#         self.keys_to_strs[32] = "o"
#         self.keys_to_strs[33] = "p"
#         self.keys_to_strs[34] = "bracketleft"
#         self.keys_to_strs[35] = "bracketright"
#         self.keys_to_strs[36] = "Return"
#         self.keys_to_strs[37] = "Control_L"
#         self.keys_to_strs[38] = "a"
#         self.keys_to_strs[39] = "s"
#         self.keys_to_strs[40] = "d"
#         self.keys_to_strs[41] = "f"
#         self.keys_to_strs[42] = "g"
#         self.keys_to_strs[43] = "h"
#         self.keys_to_strs[44] = "j"
#         self.keys_to_strs[45] = "k"
#         self.keys_to_strs[46] = "l"
#         self.keys_to_strs[47] = "semicolon"
#         self.keys_to_strs[48] = "apostrophe"
#         self.keys_to_strs[50] = "Shift_L"
#         self.keys_to_strs[51] = "backslash"
#         self.keys_to_strs[52] = "z"
#         self.keys_to_strs[53] = "x"
#         self.keys_to_strs[54] = "c"
#         self.keys_to_strs[55] = "v"
#         self.keys_to_strs[56] = "b"
#         self.keys_to_strs[57] = "n"
#         self.keys_to_strs[58] = "m"
#         self.keys_to_strs[59] = "comma"
#         self.keys_to_strs[60] = "period"
#         self.keys_to_strs[61] = "slash"
#         self.keys_to_strs[62] = "Shift_R"
#         self.keys_to_strs[64] = "Alt_L"
#         self.keys_to_strs[65] = "space"
#         self.keys_to_strs[67] = "F1"
#         self.keys_to_strs[68] = "F2"
#         self.keys_to_strs[69] = "F3"
#         self.keys_to_strs[70] = "F4"
#         self.keys_to_strs[71] = "F5"
#         self.keys_to_strs[72] = "F6"
#         self.keys_to_strs[73] = "F7"
#         self.keys_to_strs[74] = "F8"
#         self.keys_to_strs[75] = "F9"
#         self.keys_to_strs[76] = "F10"
#         self.keys_to_strs[94] = "less"
#         self.keys_to_strs[95] = "F11"
#         self.keys_to_strs[96] = "F12"
#         self.keys_to_strs[104] = "KP_Enter"
#         self.keys_to_strs[105] = "Control_R"
#         self.keys_to_strs[107] = "Print"
#         self.keys_to_strs[108] = "Alt_R"
#         self.keys_to_strs[110] = "Home"
#         self.keys_to_strs[111] = "Up"
#         self.keys_to_strs[112] = "Prior"
#         self.keys_to_strs[113] = "Left"
#         self.keys_to_strs[114] = "Right"
#         self.keys_to_strs[115] = "End"
#         self.keys_to_strs[116] = "Down"
#         self.keys_to_strs[117] = "Next"
#         self.keys_to_strs[118] = "Insert"
#         self.keys_to_strs[119] = "Delete"
#         self.keys_to_strs[126] = "plusminus"
#         self.keys_to_strs[133] = "Super_L"
#         self.keys_to_strs[134] = "Super_R"
#         self.keys_to_strs[136] = "Cancel"
#         self.keys_to_strs[137] = "Redo"
#         self.keys_to_strs[139] = "Undo"
# )


struct Keys:
    alias Escape = 9
    alias _1 = 10
    alias _2 = 11
    alias _3 = 12
    alias _4 = 13
    alias _5 = 14
    alias _6 = 15
    alias _7 = 16
    alias _8 = 17
    alias _9 = 18
    alias _0 = 19
    alias minus = 20
    alias equal = 21
    alias BackSpace = 22
    alias Tab = 23
    alias q = 24
    alias w = 25
    alias e = 26
    alias r = 27
    alias t = 28
    alias y = 29
    alias u = 30
    alias i = 31
    alias o = 32
    alias p = 33
    alias bracketleft = 34
    alias bracketright = 35
    alias Return = 36
    alias Control_L = 37
    alias a = 38
    alias s = 39
    alias d = 40
    alias f = 41
    alias g = 42
    alias h = 43
    alias j = 44
    alias k = 45
    alias l = 46
    alias semicolon = 47
    alias apostrophe = 48
    alias Shift_L = 50
    alias backslash = 51
    alias z = 52
    alias x = 53
    alias c = 54
    alias v = 55
    alias b = 56
    alias n = 57
    alias m = 58
    alias comma = 59
    alias period = 60
    alias slash = 61
    alias Shift_R = 62
    alias Alt_L = 64
    alias space = 65
    alias F1 = 67
    alias F2 = 68
    alias F3 = 69
    alias F4 = 70
    alias F5 = 71
    alias F6 = 72
    alias F7 = 73
    alias F8 = 74
    alias F9 = 75
    alias F10 = 76
    alias less = 94
    alias F11 = 95
    alias F12 = 96
    alias KP_Enter = 104
    alias Control_R = 105
    alias Print = 107
    alias Alt_R = 108
    alias Home = 110
    alias Up = 111
    alias Prior = 112
    alias Left = 113
    alias Right = 114
    alias End = 115
    alias Down = 116
    alias Next = 117
    alias Insert = 118
    alias Delete = 119
    alias plusminus = 126
    alias Super_L = 133
    alias Super_R = 134
    alias Cancel = 136
    alias Redo = 137
    alias Undo = 139
