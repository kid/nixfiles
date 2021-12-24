#!/usr/bin/env bash

if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
	eval "$(dbus-launch --exit-with-session --sh-syntax)"
fi

systemctl --user import-environment DISPLAY XAUTHORITY

if command -v dbus-update-activation-environment >/dev/null 2>&1; then
	dbus-update-activation-environment DISPLAY XAUTHORITY
fi

if [ "$(xrandr --listmonitors | head -n1 | cut -d ' ' -f 2)" != "1" ]; then
	xrandr --output DP-4 --scale 1x1 --mode 3840x1600 --rate 144 --pos 0x480 --primary
	xrandr --output DP-2 --scale 1x1 --mode 2560x1440 --rate 144 --pos 3840x0 --rotate left
fi

exec xmonad-kid
