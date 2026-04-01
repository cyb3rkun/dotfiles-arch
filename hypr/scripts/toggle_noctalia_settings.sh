#!/bin/bash
ACTIVE_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
qs -c noctalia-shell ipc call settings toggle --monitor "$ACTIVE_MONITOR"
