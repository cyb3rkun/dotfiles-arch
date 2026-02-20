STATEFILE="$HOME/.config/hypr/config/wallpapers.conf"

[ -f "$STATEFILE" ] || exit

while IFS=: read -r monitor filepath; do
	[ -n "$monitor" ] && [ -f "$filepath" ] && swaybg -o "$monitor" -i "$filepath" -m fill &
done < "$STATEFILE"
