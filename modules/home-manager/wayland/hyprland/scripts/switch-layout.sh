#!/usr/bin/env bash

current_layout=$(hyprctl getoption general:layout -j | jaq -r '.str')

declare -a layouts=(master dwindle)
count=${#layouts[@]}
for ((i = 0; i < count; i++)); do
	if [[ $current_layout == "${layouts[$i - 1]}" ]]; then
		hyprctl keyword general:layout "${layouts[$i]}"
		if [[ "${layouts[i]}" == "master" ]]; then
			hyprctl keyword bind "SUPER,H,layoutmsg,orientationprev"
			hyprctl keyword bind "SUPER,J,layoutmsg,cyclenext"
			hyprctl keyword bind "SUPER,K,layoutmsg,cycleprev"
			hyprctl keyword bind "SUPER,L,layoutmsg,orientationnext"
			hyprctl keyword bind "SUPER_SHIFT,J,layoutmsg,swapnext"
			hyprctl keyword bind "SUPER_SHIFT,K,layoutmsg,swapprev"
		elif [[ "${layouts[i]}" == "dwindle" ]]; then
			hyprctl keyword bind "SUPER,J,cyclenext"
			hyprctl keyword bind "SUPER,K,cyclenext,prev"
			hyprctl keyword bind "SUPER_SHIFT,J,swapnext"
			hyprctl keyword bind "SUPER_SHIFT,K,swapnext,prev"
		elif [[ "${layouts[i]}" == "hy3" ]]; then
			hyprctl keyword bind "SUPER,H,hy3:movefocus,l"
			hyprctl keyword bind "SUPER,J,hy3:movefocus,d"
			hyprctl keyword bind "SUPER,K,hy3:movefocus,u"
			hyprctl keyword bind "SUPER,L,hy3:movefocus,r"
			hyprctl keyword bind "SUPER_SHIFT,H,hy3:movewindow,l"
			hyprctl keyword bind "SUPER_SHIFT,J,hy3:movewindow,d"
			hyprctl keyword bind "SUPER_SHIFT,K,hy3:movewindow,u"
			hyprctl keyword bind "SUPER_SHIFT,L,hy3:movewindow,r"
			hyprctl keyword bind "SUPER_SHIFT,V,hy3:makegroup,v"
			hyprctl keyword bind "SUPER_SHIFT,X,hy3:makegroup,h"
		fi
		break
	fi
done
