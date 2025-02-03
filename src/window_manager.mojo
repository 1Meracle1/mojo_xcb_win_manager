from xcb_bindings import *
from time import monotonic, sleep
from unix_bindings import NSEC_PER_SEC, nanosleep
from keybindings import KeybindingsManager, Keybinding, Keys
from sys import alignof
from space import *
from monitor import *
from config import *


struct WindowManager:
    var config: Config
    var xlib: Xlib
    var xcb: Xcb
    var ewmh: XcbEwmh
    var keybindings_manager: KeybindingsManager
    var monitors: List[Monitor]
    var focused_monitor: Int

    fn __init__(out self) raises:
        self.config = Config()
        print("config:", self.config)

        self.xlib = Xlib()
        if not self.xlib.display:
            raise Error("Failed to get Xlib's Display")
        conn = self.xlib.XGetXCBConnection()
        if not conn:
            raise Error("Failed to get XCB connection.")

        self.xcb = Xcb(conn)
        self.monitors = List[Monitor](
            Monitor(
                0,
                0,
                self.xcb.screen[].width_in_pixels.cast[DType.int32](),
                self.xcb.screen[].height_in_pixels.cast[DType.int32](),
            )
        )
        self.focused_monitor = 0

        err = self.xcb.change_window_attributes_checked(
            self.xcb.root,
            XCB_CW_EVENT_MASK,
            XCB_EVENT_MASK_SUBSTRUCTURE_REDIRECT
            | XCB_EVENT_MASK_SUBSTRUCTURE_NOTIFY
            | XCB_EVENT_MASK_POINTER_MOTION
            | XCB_EVENT_MASK_KEY_PRESS
            | XCB_EVENT_MASK_KEY_RELEASE,
        )
        if err:
            raise Error("Another window manager is running.")

        # xcb_input = XcbInput(conn)
        # if not xcb_input.check_supported(conn):
        #     print("xinput extension is not supported.")
        #     return

        # meta_window = xcb.generate_id()
        # xcb.create_window(meta_window, -1, -1, 1, 1, 0)
        # print("meta_window:", meta_window)

        self.ewmh = XcbEwmh(conn)

        fn spawn_alacritty():
            print("swap alacritty")

        var keybindings = List[Keybinding](
            Keybinding(
                modifier=XCB_MOD_MASK_1,
                keycode=Keys.Return,
                mods_count=1,
                action=spawn_alacritty,
            )
        )
        self.keybindings_manager = KeybindingsManager(keybindings)
        self.keybindings_manager.grab_keys(self.xcb)

        self.xcb.flush()

    fn main_loop(mut self):
        alias frame_time = 1.0 / 60.0
        while True:
            var start_time: Float64 = monotonic()

            while True:
                generic_event = self.xcb.poll_for_event()
                if not generic_event:
                    break
                var event_type = generic_event[].response_type & ~0x80
                # print("event_type:", event_type)
                # if event_type != XCB_MOTION_NOTIFY:
                #     print("event_type:", event_type)

                if event_type == XCB_KEY_PRESS:
                    var key_press = generic_event.bitcast[
                        xcb_key_press_event_t
                    ]()
                    self.keybindings_manager.handle_key_press(key_press)

                elif event_type == XCB_KEY_RELEASE:
                    var key_release = generic_event.bitcast[
                        xcb_key_release_event_t
                    ]()
                    self.keybindings_manager.handle_key_release(key_release)

                elif event_type == XCB_MAP_REQUEST:
                    var map_request = generic_event.bitcast[
                        xcb_map_request_event_t
                    ]()
                    self._handle_map_request(map_request)

                self.xcb.flush()

            var end_time: Float64 = monotonic()
            var diff = end_time - start_time
            if diff < frame_time:
                sleep(frame_time - diff)

    fn _handle_map_request(
        mut self, map_request: UnsafePointer[xcb_map_request_event_t]
    ):
        var window = map_request[].window
        print("map request for", window)

        if self.xcb.has_override_redirect(window):
            print("window requested override-redirect")
            return

        var class_instance_names = self.xcb.window_class_instance_names(window)
        print(
            "class name:",
            class_instance_names[0],
            "instance name:",
            class_instance_names[1],
        )

        var size_hints = self.ewmh.window_rect_hints(window, self.xcb)
        print("size hints:", size_hints)

        var window_type = self.ewmh.window_type(window)
        print("window type:", WindowType.to_string(window_type))

        var current_monitor = self.monitors[self.focused_monitor]
        var current_space = current_monitor.spaces[
            current_monitor.focused_space
        ]

        var requested_space = self.ewmh.window_requested_space(window)
        print("requested space:", requested_space)

        if window_type == WindowType.Floating:
            if size_hints.width == 0 or size_hints.height == 0:
                size_hints.width = 800
                size_hints.height = 600
            current_space.floating_windows.append(window)

        elif window_type == WindowType.Normal:
            current_space.normal_windows.append(Window(window, size_hints))

        elif window_type == WindowType.Docked:
            var available_rect = current_monitor.available_rect()
            if requested_space != -1:
                available_rect = current_space.available_rect(available_rect)
            var partial_strut = self.ewmh.window_strut_partial_rect(
                window, available_rect
            )
            var window_size: Rect
            if partial_strut.width == 0 or partial_strut.height == 0:
                window_size = size_hints
            else:
                window_size = partial_strut
            # TODO: separate methods on either monitor or space should be called
            #       to identify actual x and y positions of the newly added docked windows
            if requested_space != -1:
                current_monitor.spaces[requested_space].docked_windows.append(
                    Window(window, window_size)
                )
            else:
                current_monitor.docked_windows.append(
                    Window(window, window_size)
                )

        self.xcb.change_window_attributes(
            window,
            XCB_CW_EVENT_MASK,
            XCB_EVENT_MASK_POINTER_MOTION
            | XCB_EVENT_MASK_KEY_PRESS
            | XCB_EVENT_MASK_KEY_RELEASE,
        )
        self.xcb.map_window(window)

        self.xcb.set_input_focus(window)
        current_space.focused_type = window_type
        current_space.focused_window = window
