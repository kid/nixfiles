#!/usr/bin/env bash

hyprctl clients -j | jq '.[] | select(.pid > 0) .pid' | xargs kill -SIGTERM

while [[ "$count" -gt 0 ]]; do
	count=$(hyprctl clients -j | jq 'map(select(.pid > 0)) | length')
	sleep 1
done

hyprctl dispatch exit
