#!/usr/bin/env bash

binds=$(hyprctl binds)

menu=$(echo "$binds" | awk '
	/modmask:/ {
		modmask=$2
		mods=""
		if (and(modmask, 64)) mods = mods "SUPER + "
		if (and(modmask, 4)) mods = mods "CTRL + "
		if (and(modmask, 1)) mods = mods "SHIFT + "
		if (and(modmask, 8)) mods = mods "ALT + "
	}
	/key:/ {
		key=$2
	}
	/description:/{
		desc=$2
		for (i=3; i<=NF; i++) desc=desc " " $i
		if (desc == "") desc = "(no description)"
			print mods key " - " desc
	}'
)

chosen=$(echo "$menu" | wofi -dmenu -p "Hyprland Keybinds")
[ -n "$chosen" ] && echo "$chosen" | wl-copy
