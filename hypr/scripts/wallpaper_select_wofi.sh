#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# === User-editable paths ===
WALLDIR="$HOME/Pictures/wallpapers"                   # <- your wallpapers dir (explicit)
STATEFILE="$HOME/.config/hypr/config/wallpapers.conf"
CACHE_DIR="$HOME/.cache/wallpaper-thumbs"
WOFI_CONF="$HOME/.config/wofi/wallpaper.conf"

# === thumbnail size ===
THUMB_W=250
THUMB_H=141

mkdir -p "$CACHE_DIR"
mkdir -p "$(dirname "$STATEFILE")"

# focused monitor (Hyprland)
focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

# Check for ImageMagick
if ! command -v magick >/dev/null 2>&1; then
	echo "ImageMagick (magick) is required. Install it (eg. sudo dnf install ImageMagick)." >&2
	exit 1
fi

# Generate a thumbnail (magick)
generate_thumb() {
	local src="$1" dst="$2"
	magick "$src" -thumbnail "${THUMB_W}x${THUMB_H}^" -gravity center -extent "${THUMB_W}x${THUMB_H}" "$dst"
}

# Create a simple "Shuffle" thumbnail if none exists
SHUFFLE_ICON="$CACHE_DIR/shuffle.png"
if [[ ! -f "$SHUFFLE_ICON" ]]; then
	magick -size "${THUMB_W}x${THUMB_H}" xc:'#2e2e2e' -gravity center \
		-pointsize 36 -fill white -annotate 0 'Shuffle' "$SHUFFLE_ICON"
fi

# Build menu items (sorted, safe for spaces)
build_menu() {
	# Shuffle entry first
	echo -en "Shuffle\0icon\x1fimage-path://$SHUFFLE_ICON\n"

	# collect files (null-separated), then sort (case-insensitive)
	mapfile -d '' -t files < <(find "$WALLDIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \) -print0)

	# sort filenames (this loses null separation, but filenames containing newline are extremely rare)
	IFS=$'\n' sorted=($(printf "%s\n" "${files[@]}" | sort -f))
	unset IFS

	for img in "${sorted[@]}"; do
		[[ -f "$img" ]] || continue
		name=$(basename "$img")
		thumb="$CACHE_DIR/${name%.*}.png"
		if [[ ! -f "$thumb" ]] || [[ "$img" -nt "$thumb" ]]; then
			generate_thumb "$img" "$thumb"
		fi
		# label\0icon\x1fimage-path://path-to-thumb\n
		echo -en "$name\0icon\x1fimage-path://$thumb\n"
	done
}

# Show Wofi (run mode, images enabled via config + explicit flag)
choice=$(build_menu | wofi --conf "$WOFI_CONF" --show run --prompt "Select Wallpaper")

[[ -z "${choice:-}" ]] && exit 0

# Resolve choice -> full path
if [[ "$choice" == "Shuffle" ]]; then
	filepath=$(find "$WALLDIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \) | shuf -n1)
else
	# find the file by basename (case-insensitive)
	filepath=$(find "$WALLDIR" -type f -iname "$choice" | head -n1)
fi

[[ -z "${filepath:-}" ]] && { notify-send "Wallpaper" "Could not find file for selection: $choice"; exit 1; }

# kill existing swaybg for that monitor
pgrep -a swaybg | grep " -o $focused_monitor " | awk '{print $1}' | xargs -r kill

# set wallpaper (swaybg)
swaybg -o "$focused_monitor" -i "$filepath" -m fill &

# persist state
grep -v "^$focused_monitor:" "$STATEFILE" 2>/dev/null > "${STATEFILE}.tmp" || true
echo "$focused_monitor:$filepath" >> "${STATEFILE}.tmp"
mv "${STATEFILE}.tmp" "$STATEFILE"

notify-send "Wallpaper" "Set wallpaper on $focused_monitor" -i "$filepath"

