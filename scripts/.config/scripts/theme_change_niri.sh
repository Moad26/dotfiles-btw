#!/usr/bin/env bash

set -euo pipefail

selected=$1

awww img "$selected" \
  --transition-type simple \
  --transition-fps 60 \
  --transition-step 20

wal -i "$selected" -n -q

# Reload swaync
swaync-client -R && swaync-client -rs

niri msg action reconfigure || true

pkill waybar || true
sleep 0.3
waybar \
  -c "${XDG_CONFIG_HOME:-$HOME/.config}/waybar/niri/config.jsonc" \
  -s "${XDG_CONFIG_HOME:-$HOME/.config}/waybar/niri/style.css" &

exit 0
