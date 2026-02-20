#!/usr/bin/env bash

WALLDIR="$HOME/Pictures/wallpapers"
STATEFILE="$HOME/.config/hypr/config/wallpapers.conf"

focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

# if pidof swaybg > /dev/null; then
# 	pkill swaybg
# fi

menu() {
    find "$WALLDIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) \
    | sort | while read -r img; do
        name=$(basename "$img")
        echo -en "$name\0icon\x1fthumbnail://$img\n"
    done
}

choice=$(menu | rofi -dmenu \
	-config ~/.config/rofi/wallpaper-config.rasi \
	-theme ~/.config/rofi/wallpaper-config.rasi \
	-i -show-icons )

[ -z "$choice" ] && exit

filepath=$(find "$WALLDIR" -type f -iname "$choice" | head -n 1)
[ -z "$filepath" ] && exit

pgrep -a swaybg | grep " -o $focused_monitor " | awk '{print $1}' | xargs -r kill

swaybg -o "$focused_monitor" -i "$filepath" -m fill &

mkdir -p "$(dirname "$STATEFILE")"
grep -v "^$focused_monitor:" "$STATEFILE" 2>/dev/null > "${STATEFILE}".tmp
echo "$focused_monitor:$filepath" >> "${STATEFILE}.tmp"
mv "${STATEFILE}.tmp" "$STATEFILE"
