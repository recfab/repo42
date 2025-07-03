#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

this_dir=$(dirname "$0")
notes_dir=$(realpath "$this_dir/../notes")
note_id=$(date -u "+%Y%m%d%H%M%S")
note_file="$notes_dir/$note_id/index.md"

mkdir -p "$(dirname "$note_file")"
touch "$note_file"

echo "New note created at $note_file"
