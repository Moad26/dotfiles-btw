#!/usr/bin/env bash

wall_dir="$HOME/Desktop/Wallpaper"

cd "$wall_dir" || {
  echo "Directory not found: $wall_dir"
  exit 1
}

max=0
for f in wall[0-9]*.png; do
  num="${f//[^0-9]/}"
  ((num > max)) && max=$num
done

for f in wallhaven-*.png; do
  ((max++))
  mv -v "$f" "wall${max}.png"
done
