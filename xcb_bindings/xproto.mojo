from memory import UnsafePointer
from collections import InlineArray

alias int32_t = SIMD[DType.int32, 1]
alias uint32_t = SIMD[DType.uint32, 1]
alias uint16_t = SIMD[DType.uint16, 1]
alias uint8_t = SIMD[DType.uint8, 1]

alias xcb_window_t = uint32_t
alias xcb_colormap_t = uint32_t
alias xcb_visualid_t = uint32_t


alias xcb_connection_t = UnsafePointer[NoneType]
alias xcb_setup_t = UnsafePointer[NoneType]


@value
@register_passable("trivial")
struct xcb_screen_iterator_t:
    var data: UnsafePointer[xcb_screen_t]
    var rem: ffi.c_int
    var index: ffi.c_int


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
