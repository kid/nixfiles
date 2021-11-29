#!/usr/bin/env sh

if [ "$(xrandr --listmonitors | head -n1 | cut -d ' ' -f 2)" != "1" ]; then
  xrandr --output DP-4 --scale 1x1 --mode 3840x1600 --rate 119.98 --pos 0x480 --primary
  xrandr --output DP-2 --scale 1x1 --mode 2560x1440 --rate 119.98 --pos 3840x0 --rotate left
fi

exec dbus-launch xmonad-kid

# have() { type "$1" > /dev/null 2>&1; }
#
# if [ ! "$DBUS_SESSION_BUS_ADDRESS" ] && have dbus-launch; then
#   exec dbus-launch --exit-with-session ~/.xinitrc "$@" || exit
# fi
#
# taffybar-kid &
# exec xmonad-kid
