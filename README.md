# X11 Window Manager powered by Mojo and XCB

#### How to run debug version (JIT-ed, with all assertions enabled):
```sh
magic shell
mojo -D ASSERT=all main.mojo
```

#### Build debug executable:
```sh
mojo build -D ASSERT=all --optimization-level 0 --debug-level full --sanitize address main.mojo -o bin/wm
```

#### Build release executable:
```sh
magic shell
mojo build --optimization-level 3 --debug-level none main.mojo -o bin/wm
```