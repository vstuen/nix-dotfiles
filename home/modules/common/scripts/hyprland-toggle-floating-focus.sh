#!/usr/bin/env bash

FLOATING=$(hyprctl activewindow -j | jq .floating)
hyprctl dispatch focuswindow $([ "$FLOATING" == "true" ] && echo "tiled" || echo "floating")