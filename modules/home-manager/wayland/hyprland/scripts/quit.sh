#!/usr/bin/env bash

pkill -u "$(whoami)" chrome

sleep 2

hyprctl dispatch exit
