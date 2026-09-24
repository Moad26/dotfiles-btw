#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ge 1 && ("$1" == "niri" || "$1" == "sway") ]]; then
  WM="$1"
elif [[ -n "${NIRI_SOCKET:-}" ]]; then
  WM="niri"
elif [[ -n "${SWAYSOCK:-}" ]]; then
  WM="sway"
else
  notify-send "Wallpaper Picker" "Could not detect WM (set NIRI_SOCKET or SWAYSOCK, or pass niri/sway as arg)" \
    --icon=dialog-warning
  exit 1
fi

SCRIPT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/scripts"
THEME_SCRIPT="${SCRIPT_DIR}/theme_change_${WM}.sh"

if [[ ! -x "$THEME_SCRIPT" ]]; then
  notify-send "Wallpaper Picker" "Theme script not found or not executable: $THEME_SCRIPT" \
    --icon=dialog-warning
  exit 1
fi

WALL_DIR="${WALLPAPER_DIR:-$HOME/Wallpaper/}"

# if ! pgrep -x awww-daemon &>/dev/null; then
#   awww-daemon &
#   sleep 1
# fi

# ── Build image list ──────────────────────────────────────────────────────────
mapfile -t images < <(
  find "$WALL_DIR" -maxdepth 2 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" \
    -o -iname "*.png" -o -iname "*.webp" \
    -o -iname "*.gif" \) | sort -V
)

if [[ ${#images[@]} -eq 0 ]]; then
  notify-send "Wallpaper Picker" "No images found in $WALL_DIR" --icon=dialog-warning
  exit 1
fi

selected=$(
  printf "%s\n" "${images[@]}" |
    fzf \
      --prompt "Wallpaper [$WM] > " \
      --preview "bash -c 'chafa --format=sixel --size=\${FZF_PREVIEW_COLUMNS}x\${FZF_PREVIEW_LINES} -- {}'" \
      --preview-window 'right:75%,border-none' \
      --with-nth -1 \
      --delimiter '/' \
      --ansi \
      --layout=reverse \
      --no-sort \
      --cycle \
      --bind 'enter:accept'
)

[[ -z "$selected" ]] && exit 0

systemd-run --user "$THEME_SCRIPT" "$selected" 2>/dev/null
notify-send "Theme change" "Changed the wallpaper and the theming ig ma man"

exit 0
