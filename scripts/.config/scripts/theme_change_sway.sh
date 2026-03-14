#!/usr/bin/env bash

set -euo pipefail

selected=$1

awww img "$selected" \
    --transition-type simple \
    --transition-fps 60 \
    --transition-step 20

wal -i "$selected" -n -q

swaync-client -R && swaync-client -rs
swaymsg reload || true

exit 0
