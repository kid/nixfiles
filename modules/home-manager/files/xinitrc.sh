#!/usr/bin/env bash

if [ "$(xrandr --listmonitors | head -n1 | cut -d ' ' -f 2)" != "1" ]; then
	xrandr --output DP-4 --scale 1x1 --mode 3840x1600 --rate 144 --pos 0x0 --primary
	xrandr --output DP-2 --scale 1x1 --mode 2560x1440 --rate 144 --pos 3840x-480 --rotate left
fi

case "${1:-leftwm}" in

	leftwm) eval exec ~/.xsession leftwm ;;

	*) eval exec ~/.xsession "$1" ;;

esac
