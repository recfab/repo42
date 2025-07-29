#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

target_dir="$1"

shopt -s globstar nullglob
for file in "$target_dir"/**/*.md
do
  first_line=$(head -1 "$file")
  if [[ $first_line != '---' ]]; then
    sed -e '1s/^/---\n---\n/' -i '' "$file"
  fi
done
