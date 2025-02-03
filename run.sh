#!/bin/fish

mojo build -D ASSERT=all --optimization-level 0 --debug-level full src/main.mojo -o ./bin/wm || exit # --sanitize address

set XEPHYR $(whereis -b Xephyr | sed -E 's/^.*: ?//')
if [ -z "$XEPHYR" ]
  echo "Xephyr not found"
  exit 1
end

xinit ./xinitrc -- "$XEPHYR" :100 -ac -screen 1920x1080 -host-cursor
