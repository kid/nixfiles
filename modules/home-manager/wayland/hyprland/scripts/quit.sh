#!/usr/bin/env bash

pkill -u "$(whoami)" chrome

hyprctl dispatch exit
