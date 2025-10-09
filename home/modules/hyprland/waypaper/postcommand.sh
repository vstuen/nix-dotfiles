#!/usr/bin/env bash

wallpaper=$1
echo "Using wallpaper: $wallpaper"
symlink=$HOME/Pictures/Wallpapers/.current_wallpaper.jpg
if [[ $(stat -c "%i" $wallpaper) != $(stat -c "%i" $symlink) ]]; then
  echo "Setting new current wallpaper link: $wallpaper"
  ln -sf $wallpaper $symlink
fi
# wal -qi $(readlink -f $wallpaper)
# readarray -t colors < $HOME/.cache/wal/colors

# replace mako (notification daemon) background color
# disabled: it prevents home-manager from executing switch due to 
# the file being tampered with. Need to find another approach
#sed -ri "s/background-color=.*$/background-color=${colors[1]}/" $HOME/.config/mako/config
#pkill mako

# waybar
echo "Reloading waybar"
kill -SIGUSR2 $(pgrep waybar)
