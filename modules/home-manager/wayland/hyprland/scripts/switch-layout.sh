#!/usr/bin/env bash

current_layout=$(hyprctl getoption general:layout -j | jaq -r '.str')

declare -a layouts=(master dwindle)
count=${#layouts[@]}
for ((i = 0; i < count; i++)); do
	if [[ $current_layout == "${layouts[$i - 1]}" ]]; then
		hyprctl keyword general:layout "${layouts[$i]}"
		break
	fi
done
