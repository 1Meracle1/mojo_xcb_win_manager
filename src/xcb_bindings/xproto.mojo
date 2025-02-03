from memory import UnsafePointer
from collections import InlineArray


alias XCB_NONE = 0
alias XCB_COPY_FROM_PARENT = 0
alias XCB_CURRENT_TIME = 0


alias XCB_CW_BACK_PIXMAP = 1
alias XCB_CW_BACK_PIXEL = 2
alias XCB_CW_BORDER_PIXMAP = 4
alias XCB_CW_BORDER_PIXEL = 8
alias XCB_CW_OVERRIDE_REDIRECT = 512
alias XCB_CW_EVENT_MASK = 2048
alias XCB_CW_CURSOR = 16384

alias XCB_WINDOW_CLASS_COPY_FROM_PARENT = 0
alias XCB_WINDOW_CLASS_INPUT_OUTPUT = 1
alias XCB_WINDOW_CLASS_INPUT_ONLY = 2

alias XCB_EVENT_MASK_NO_EVENT = 0
alias XCB_EVENT_MASK_KEY_PRESS = 1
alias XCB_EVENT_MASK_KEY_RELEASE = 2
alias XCB_EVENT_MASK_BUTTON_PRESS = 4
alias XCB_EVENT_MASK_BUTTON_RELEASE = 8
alias XCB_EVENT_MASK_ENTER_WINDOW = 16
alias XCB_EVENT_MASK_LEAVE_WINDOW = 32
alias XCB_EVENT_MASK_POINTER_MOTION = 64
alias XCB_EVENT_MASK_POINTER_MOTION_HINT = 128
alias XCB_EVENT_MASK_BUTTON_1_MOTION = 256
alias XCB_EVENT_MASK_BUTTON_2_MOTION = 512
alias XCB_EVENT_MASK_BUTTON_3_MOTION = 1024
alias XCB_EVENT_MASK_BUTTON_4_MOTION = 2048
alias XCB_EVENT_MASK_BUTTON_5_MOTION = 4096
alias XCB_EVENT_MASK_BUTTON_MOTION = 8192
alias XCB_EVENT_MASK_KEYMAP_STATE = 16384
alias XCB_EVENT_MASK_EXPOSURE = 32768
alias XCB_EVENT_MASK_VISIBILITY_CHANGE = 65536
alias XCB_EVENT_MASK_STRUCTURE_NOTIFY = 131072
alias XCB_EVENT_MASK_RESIZE_REDIRECT = 262144
alias XCB_EVENT_MASK_SUBSTRUCTURE_NOTIFY = 524288
alias XCB_EVENT_MASK_SUBSTRUCTURE_REDIRECT = 1048576
alias XCB_EVENT_MASK_FOCUS_CHANGE = 2097152
alias XCB_EVENT_MASK_PROPERTY_CHANGE = 4194304
alias XCB_EVENT_MASK_COLOR_MAP_CHANGE = 8388608
alias XCB_EVENT_MASK_OWNER_GRAB_BUTTON = 16777216

alias XCB_KEY_PRESS = 2
alias XCB_KEY_RELEASE = 3
alias XCB_BUTTON_PRESS = 4
alias XCB_BUTTON_RELEASE = 5
alias XCB_MOTION_NOTIFY = 6
alias XCB_ENTER_NOTIFY = 7
alias XCB_LEAVE_NOTIFY = 8
alias XCB_FOCUS_IN = 9
alias XCB_FOCUS_OUT = 10
alias XCB_DESTROY_NOTIFY = 17
alias XCB_UNMAP_NOTIFY = 18
alias XCB_MAP_NOTIFY = 19
alias XCB_MAP_REQUEST = 20
alias XCB_CONFIGURE_REQUEST = 23
alias XCB_RESIZE_REQUEST = 25
alias XCB_CIRCULATE_REQUEST = 28
alias XCB_SELECTION_REQUEST = 30
alias XCB_CLIENT_MESSAGE = 33

alias XCB_INPUT_FOCUS_NONE = 0
alias XCB_INPUT_FOCUS_POINTER_ROOT = 1
alias XCB_INPUT_FOCUS_PARENT = 2
alias XCB_INPUT_FOCUS_FOLLOW_KEYBOARD = 3

alias XCB_MOD_MASK_SHIFT = 1
alias XCB_MOD_MASK_LOCK = 2
alias XCB_MOD_MASK_CONTROL = 4
alias XCB_MOD_MASK_1 = 8
alias XCB_MOD_MASK_2 = 16
alias XCB_MOD_MASK_3 = 32
alias XCB_MOD_MASK_4 = 64
alias XCB_MOD_MASK_5 = 128
alias XCB_MOD_MASK_ANY = 32768

alias XCB_KEY_BUT_MASK_SHIFT = 1
alias XCB_KEY_BUT_MASK_LOCK = 2
alias XCB_KEY_BUT_MASK_CONTROL = 4
alias XCB_KEY_BUT_MASK_MOD_1 = 8
alias XCB_KEY_BUT_MASK_MOD_2 = 16
alias XCB_KEY_BUT_MASK_MOD_3 = 32
alias XCB_KEY_BUT_MASK_MOD_4 = 64
alias XCB_KEY_BUT_MASK_MOD_5 = 128
alias XCB_KEY_BUT_MASK_BUTTON_1 = 256
alias XCB_KEY_BUT_MASK_BUTTON_2 = 512
alias XCB_KEY_BUT_MASK_BUTTON_3 = 1024
alias XCB_KEY_BUT_MASK_BUTTON_4 = 2048
alias XCB_KEY_BUT_MASK_BUTTON_5 = 4096

alias XCB_GRAB_MODE_SYNC = 0
alias XCB_GRAB_MODE_ASYNC = 1

alias XCB_ATOM_NONE = 0
alias XCB_ATOM_ANY = 0
alias XCB_ATOM_PRIMARY = 1
alias XCB_ATOM_SECONDARY = 2
alias XCB_ATOM_ARC = 3
alias XCB_ATOM_ATOM = 4
alias XCB_ATOM_BITMAP = 5
alias XCB_ATOM_CARDINAL = 6
alias XCB_ATOM_COLORMAP = 7
alias XCB_ATOM_CURSOR = 8
alias XCB_ATOM_CUT_BUFFER0 = 9
alias XCB_ATOM_CUT_BUFFER1 = 10
alias XCB_ATOM_CUT_BUFFER2 = 11
alias XCB_ATOM_CUT_BUFFER3 = 12
alias XCB_ATOM_CUT_BUFFER4 = 13
alias XCB_ATOM_CUT_BUFFER5 = 14
alias XCB_ATOM_CUT_BUFFER6 = 15
alias XCB_ATOM_CUT_BUFFER7 = 16
alias XCB_ATOM_DRAWABLE = 17
alias XCB_ATOM_FONT = 18
alias XCB_ATOM_INTEGER = 19
alias XCB_ATOM_PIXMAP = 20
alias XCB_ATOM_POINT = 21
alias XCB_ATOM_RECTANGLE = 22
alias XCB_ATOM_RESOURCE_MANAGER = 23
alias XCB_ATOM_RGB_COLOR_MAP = 24
alias XCB_ATOM_RGB_BEST_MAP = 25
alias XCB_ATOM_RGB_BLUE_MAP = 26
alias XCB_ATOM_RGB_DEFAULT_MAP = 27
alias XCB_ATOM_RGB_GRAY_MAP = 28
alias XCB_ATOM_RGB_GREEN_MAP = 29
alias XCB_ATOM_RGB_RED_MAP = 30
alias XCB_ATOM_STRING = 31
alias XCB_ATOM_VISUALID = 32
alias XCB_ATOM_WINDOW = 33
alias XCB_ATOM_WM_COMMAND = 34
alias XCB_ATOM_WM_HINTS = 35
alias XCB_ATOM_WM_CLIENT_MACHINE = 36
alias XCB_ATOM_WM_ICON_NAME = 37
alias XCB_ATOM_WM_ICON_SIZE = 38
alias XCB_ATOM_WM_NAME = 39
alias XCB_ATOM_WM_NORMAL_HINTS = 40
alias XCB_ATOM_WM_SIZE_HINTS = 41
alias XCB_ATOM_WM_ZOOM_HINTS = 42
alias XCB_ATOM_MIN_SPACE = 43
alias XCB_ATOM_NORM_SPACE = 44
alias XCB_ATOM_MAX_SPACE = 45
alias XCB_ATOM_END_SPACE = 46
alias XCB_ATOM_SUPERSCRIPT_X = 47
alias XCB_ATOM_SUPERSCRIPT_Y = 48
alias XCB_ATOM_SUBSCRIPT_X = 49
alias XCB_ATOM_SUBSCRIPT_Y = 50
alias XCB_ATOM_UNDERLINE_POSITION = 51
alias XCB_ATOM_UNDERLINE_THICKNESS = 52
alias XCB_ATOM_STRIKEOUT_ASCENT = 53
alias XCB_ATOM_STRIKEOUT_DESCENT = 54
alias XCB_ATOM_ITALIC_ANGLE = 55
alias XCB_ATOM_X_HEIGHT = 56
alias XCB_ATOM_QUAD_WIDTH = 57
alias XCB_ATOM_WEIGHT = 58
alias XCB_ATOM_POINT_SIZE = 59
alias XCB_ATOM_RESOLUTION = 60
alias XCB_ATOM_COPYRIGHT = 61
alias XCB_ATOM_NOTICE = 62
alias XCB_ATOM_FONT_NAME = 63
alias XCB_ATOM_FAMILY_NAME = 64
alias XCB_ATOM_FULL_NAME = 65
alias XCB_ATOM_CAP_HEIGHT = 66
alias XCB_ATOM_WM_CLASS = 67
alias XCB_ATOM_WM_TRANSIENT_FOR = 68

alias XCB_GET_PROPERTY_TYPE_ANY = 0


# alias int16_t = SIMD[DType.int16, 1]
# alias int32_t = SIMD[DType.int32, 1]
# alias uint32_t = SIMD[DType.uint32, 1]
# alias uint16_t = SIMD[DType.uint16, 1]
# alias uint8_t = SIMD[DType.uint8, 1]
alias int16_t = Int16
alias int32_t = Int32
alias uint8_t = UInt8
alias uint16_t = UInt16
alias uint32_t = UInt32

alias xcb_window_t = uint32_t
alias xcb_colormap_t = uint32_t
alias xcb_visualid_t = uint32_t
alias xcb_keycode_t = uint8_t
alias xcb_timestamp_t = uint32_t
alias xcb_atom_t = uint32_t

alias xcb_connection_t = UnsafePointer[NoneType]
alias xcb_setup_t = UnsafePointer[NoneType]

alias xcb_key_release_event_t = xcb_key_press_event_t

alias xcb_mod_mask_t = UInt32


@value
@register_passable("trivial")
struct xcb_screen_iterator_t:
    var data: UnsafePointer[xcb_screen_t]
    var rem: int32_t
    var index: int32_t


@value
@register_passable("trivial")
struct xcb_screen_t:
    var root: xcb_window_t
    var default_colormap: xcb_colormap_t
    var white_pixel: uint32_t
    var black_pixel: uint32_t
    var current_input_masks: uint32_t
    var width_in_pixels: uint16_t
    var height_in_pixels: uint16_t
    var width_in_millimeters: uint16_t
    var height_in_millimeters: uint16_t
    var min_installed_maps: uint16_t
    var max_installed_maps: uint16_t
    var root_visual: xcb_visualid_t
    var backing_stores: uint8_t
    var save_unders: uint8_t
    var root_depth: uint8_t
    var allowed_depths_len: uint8_t


@value
struct xcb_generic_error_t:
    var response_type: uint8_t  # Type of the response
    var error_code: uint8_t  # Error code
    var sequence: uint16_t  # Sequence number
    var resource_id: uint32_t  # Resource ID for requests with side effects only
    var minor_code: uint16_t  # Minor opcode of the failed request
    var major_code: uint8_t  # Major opcode of the failed request
    var pad0: uint8_t
    var pad: InlineArray[uint32_t, 5]  # Padding
    var full_sequence: uint32_t  # full sequence


@value
@register_passable("trivial")
struct xcb_void_cookie_t:
    var sequence: uint32_t


@value
struct xcb_generic_event_t:
    var response_type: uint8_t  #  /**< Type of the response */
    var pad0: uint8_t  # /**< Padding */
    var sequence: uint16_t  # /**< Sequence number */
    var pad: InlineArray[uint32_t, 7]  # /**< Padding */
    var full_sequence: uint32_t  # /**< full sequence */


@value
struct xcb_map_request_event_t:
    var response_type: uint8_t
    var pad0: uint8_t
    var sequence: uint16_t
    var parent: xcb_window_t
    var window: xcb_window_t


@value
struct xcb_key_press_event_t:
    var response_type: uint8_t
    var detail: xcb_keycode_t
    var sequence: uint16_t
    var time: xcb_timestamp_t
    var root: xcb_window_t
    var event: xcb_window_t
    var child: xcb_window_t
    var root_x: int16_t
    var root_y: int16_t
    var event_x: int16_t
    var event_y: int16_t
    var state: uint16_t
    var same_screen: uint8_t
    var pad0: uint8_t


@value
@register_passable("trivial")
struct xcb_get_window_attributes_cookie_t:
    var sequence: UInt32


@value
struct xcb_get_window_attributes_reply_t:
    var response_type: uint8_t
    var backing_store: uint8_t
    var sequence: uint16_t
    var length: uint32_t
    var visual: xcb_visualid_t
    var _class: uint16_t
    var bit_gravity: uint8_t
    var win_gravity: uint8_t
    var backing_planes: uint32_t
    var backing_pixel: uint32_t
    var save_under: uint8_t
    var map_is_installed: uint8_t
    var map_state: uint8_t
    var override_redirect: uint8_t
    var colormap: xcb_colormap_t
    var all_event_masks: uint32_t
    var your_event_mask: uint32_t
    var do_not_propagate_mask: uint16_t
    var pad0: InlineArray[uint8_t, 2]


@value
@register_passable("trivial")
struct xcb_get_property_cookie_t:
    var sequence: UInt32


@value
struct xcb_get_property_reply_t:
    var response_type: uint8_t
    var format: uint8_t
    var sequence: uint16_t
    var length: uint32_t
    var type: xcb_atom_t
    var bytes_after: uint32_t
    var value_len: uint32_t
    var pad0: InlineArray[uint8_t, 12]

@value
@register_passable("trivial")
struct xcb_intern_atom_cookie_t:
    var sequence: UInt32

@value
struct xcb_size_hints_t:
    var flags: uint32_t 
    var x: int32_t 
    var y: int32_t 
    var width: int32_t 
    var height: int32_t 
    var min_width: int32_t 
    var min_height: int32_t 
    var max_width: int32_t 
    var max_height: int32_t 
    var width_inc: int32_t 
    var height_inc: int32_t 
    var min_aspect_num: int32_t 
    var min_aspect_den: int32_t 
    var max_aspect_num: int32_t 
    var max_aspect_den: int32_t 
    var base_width: int32_t 
    var base_height: int32_t 
    var win_gravity: uint32_t 