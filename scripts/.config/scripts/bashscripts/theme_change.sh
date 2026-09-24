#!/usr/bin/env bash

set -euo pipefail

selected=$1

awww img "$selected" \
  --transition-type simple \
  --transition-fps 60 \
  --transition-step 20

# sleep 0.5
wal -i "$selected" -n -q
swaync-client -R && swaync-client -rs
swaymsg reload || true

exit 0
