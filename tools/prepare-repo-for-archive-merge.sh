#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  prepare-repo-for-archive-merge.sh [--apply] [--force] /path/to/local/repo

Description:
  Rewrites the given repository history so all tracked files live under:
    archive/<year>
  where <year> is taken from the most recent commit date in that repository.
  Default mode is dry-run: prints the command it would run.

Options:
  --apply   Execute the rewrite command (default is dry-run)
  --force   Pass --force to git filter-repo (needed for non-fresh clones)
  -h, --help  Show this help
USAGE
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "error: required command not found: $1" >&2
    exit 1
  fi
}

force_flag=""
apply_changes="false"
repo_path=""

print_cmd() {
  printf '+ '
  printf '%q ' "$@"
  printf '\n'
}

while (($# > 0)); do
  case "$1" in
    --apply)
      apply_changes="true"
      shift
      ;;
    --force)
      force_flag="--force"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -* )
      echo "error: unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      if [[ -n "$repo_path" ]]; then
        echo "error: only one repository path is supported" >&2
        usage >&2
        exit 1
      fi
      repo_path="$1"
      shift
      ;;
  esac
done

if [[ -z "$repo_path" ]]; then
  echo "error: repository path is required" >&2
  usage >&2
  exit 1
fi

require_cmd git
require_cmd git-filter-repo

if [[ ! -d "$repo_path" ]]; then
  echo "error: path does not exist or is not a directory: $repo_path" >&2
  exit 1
fi

if [[ ! -d "$repo_path/.git" ]]; then
  echo "error: not a git repository: $repo_path" >&2
  exit 1
fi

latest_year="$(git -C "$repo_path" log --all -1 --date=format:%Y --format=%ad)"

if [[ -z "$latest_year" ]]; then
  echo "error: repository has no commits: $repo_path" >&2
  exit 1
fi

target_subdir="archive/$latest_year"

echo "Preparing repository: $repo_path"
echo "Most recent commit year: $latest_year"
echo "Applying history rewrite to subdirectory: $target_subdir"
echo

# Rewrites history in-place in the target repository.
filter_repo_cmd=(git -C "$repo_path" filter-repo --to-subdirectory-filter "$target_subdir")
if [[ -n "$force_flag" ]]; then
  filter_repo_cmd+=(--force)
fi

print_cmd "${filter_repo_cmd[@]}"

if [[ "$apply_changes" == "true" ]]; then
  "${filter_repo_cmd[@]}"
  echo "Done. Repository history is now rooted at: $target_subdir"
else
  echo "Dry-run only. Re-run with --apply to execute."
fi
