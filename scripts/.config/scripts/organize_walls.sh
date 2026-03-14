#!/usr/bin/env bash
# #!/usr/bin/env bash
#
# wall_dir="$HOME/Desktop/Wallpaper"
#
# cd "$wall_dir" || {
#   echo "Directory not found: $wall_dir"
#   exit 1
# }
#
# max=0
# for f in wall[0-9]*.png; do
#   num="${f//[^0-9]/}"
#   ((num > max)) && max=$num
# done
#
# for f in wallhaven-*.png; do
#   ((max++))
#   mv -v "$f" "wall${max}.png"
# done
set -euo pipefail

WALL_DIR="${WALLPAPER_DIR:-$HOME/Desktop/Wallpaper}"
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case $1 in
  -d | --dry-run)
    DRY_RUN=true
    shift
    ;;
  -h | --help)
    echo "Usage: $0 [--dry-run]"
    exit 0
    ;;
  *)
    echo "Unknown option: $1"
    exit 2
    ;;
  esac
done

cd "$WALL_DIR" || {
  echo "Not found: $WALL_DIR"
  exit 1
}

max=0
while IFS= read -r f; do
  base="${f##*/}"
  num="${base//[^0-9]/}"
  [[ -n "$num" && "$num" -gt "$max" ]] && max=$num
done < <(find . -maxdepth 2 -type f -regextype posix-extended \
  -regex '.*/wall[0-9]+\.(jpg|jpeg|png|webp|gif)' 2>/dev/null)

renamed=0

while IFS= read -r f; do
  dir="${f%/*}"
  base="${f##*/}"
  ext="${base##*.}"
  ext="${ext,,}"

  max=$((max + 1))         # safe — never returns falsy
  renamed=$((renamed + 1)) # safe

  new_path="${dir}/wall${max}.${ext}"

  if $DRY_RUN; then
    echo "[dry-run] $f  ->  $new_path"
    renamed=$((renamed - 1))
  else
    mv -v "$f" "$new_path"
  fi

done < <(find . -maxdepth 2 -type f \
  \( -iname "*.jpg" -o -iname "*.jpeg" \
  -o -iname "*.png" -o -iname "*.webp" \
  -o -iname "*.gif" \) |
  grep -Ev '/wall[0-9]+\.' |
  sort)

$DRY_RUN || echo "Done. Renamed: $renamed file(s)."
