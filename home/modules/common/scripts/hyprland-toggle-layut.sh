#!/usr/bin/env bash

CURRENT=$(hyprctl getoption -j general:layout | jq -r .str)
if [ "$CURRENT" == "dwindle" ]; then
    NEW_LAYOUT="master"
else
    NEW_LAYOUT="dwindle"
fi

hyprctl keyword general:layout $NEW_LAYOUT
notify-send "Layout changed to $NEW_LAYOUT"