#!/usr/bin/env bash

set -euo pipefail

WALL_DIR="${WALLPAPER_DIR:-$HOME/Desktop/Wallpaper/}"

# Start daemon if not running
if ! pgrep -x awww-daemon &>/dev/null; then
  awww-daemon &
  sleep 1 # Give it more time to initialize
fi

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

# Remove the hardcoded override — IMG_FMT="sixel" was killing the kitty branch
# if [[ "$TERM" == "xterm-kitty" ]]; then
#   IMG_FMT="kitty"
# elif [[ "$TERM" == "foot" ]]; then
#   IMG_FMT="sixel"
# else
#   IMG_FMT="symbols"
# fi
#
# IMG_FMT="sixel"
# selected=$(
#   printf "%s\n" "${images[@]}" |
#     fzf \
#       --prompt "Wallpaper > " \
#       --preview "bash -c 'chafa -f $IMG_FMT --size=\${FZF_PREVIEW_COLUMNS}x\${FZF_PREVIEW_LINES} -- \"{}\"'" \
#       --preview-window 'right:60%' \
#       --ansi \
#       --layout=reverse \
#       --no-sort \
#       --cycle
# )

selected=$(
  printf "%s\n" "${images[@]}" |
    fzf \
      --prompt "Wallpaper > " \
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
systemd-run --user ~/.config/scripts/theme_change.sh "$selected" --quiet
notify-send "Theme change" "Changed the wallpaper and the theming ig ma man"

exit 0
