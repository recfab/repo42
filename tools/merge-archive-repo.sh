#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  merge-archive-repo.sh [--apply] [--ref <source-ref>] /path/to/local/repo

Description:
  Merges history from a local repository into the current repository.
  Intended to be used after the source repo has been rewritten under
  archive/<year> via prepare-repo-for-archive-merge.sh.

  Default mode is dry-run: prints commands without executing.

Options:
  --apply              Execute commands (default is dry-run)
  --ref <source-ref>   Source ref in the source repo to merge (default: HEAD)
  -h, --help           Show this help
USAGE
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "error: required command not found: $1" >&2
    exit 1
  fi
}

print_cmd() {
  printf '+ '
  printf '%q ' "$@"
  printf '\n'
}

apply_changes="false"
source_ref="HEAD"
source_repo=""

while (($# > 0)); do
  case "$1" in
    --apply)
      apply_changes="true"
      shift
      ;;
    --ref)
      if (($# < 2)); then
        echo "error: --ref requires a value" >&2
        usage >&2
        exit 1
      fi
      source_ref="$2"
      shift 2
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
      if [[ -n "$source_repo" ]]; then
        echo "error: only one source repository path is supported" >&2
        usage >&2
        exit 1
      fi
      source_repo="$1"
      shift
      ;;
  esac
done

if [[ -z "$source_repo" ]]; then
  echo "error: source repository path is required" >&2
  usage >&2
  exit 1
fi

require_cmd git

if [[ ! -d .git ]]; then
  echo "error: current directory is not a git repository" >&2
  exit 1
fi

if [[ ! -d "$source_repo" ]]; then
  echo "error: path does not exist or is not a directory: $source_repo" >&2
  exit 1
fi

if [[ ! -d "$source_repo/.git" ]]; then
  echo "error: not a git repository: $source_repo" >&2
  exit 1
fi

current_repo_root="$(git rev-parse --show-toplevel)"
source_repo_root="$(git -C "$source_repo" rev-parse --show-toplevel)"

if [[ "$current_repo_root" == "$source_repo_root" ]]; then
  echo "error: source repository must be different from current repository" >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "error: current repository has uncommitted changes; commit or stash first" >&2
  exit 1
fi

if ! git -C "$source_repo" rev-parse --verify --quiet "$source_ref" >/dev/null; then
  echo "error: source ref not found in source repository: $source_ref" >&2
  exit 1
fi

source_sha="$(git -C "$source_repo" rev-parse --verify "$source_ref")"

fetch_cmd=(git fetch --no-tags "$source_repo_root" "$source_sha")
merge_cmd=(git merge --allow-unrelated-histories --no-ff FETCH_HEAD)

echo "Current repository: $current_repo_root"
echo "Source repository: $source_repo_root"
echo "Source ref: $source_ref"
echo "Source commit: $source_sha"
echo

print_cmd "${fetch_cmd[@]}"
print_cmd "${merge_cmd[@]}"

if [[ "$apply_changes" == "true" ]]; then
  "${fetch_cmd[@]}"
  "${merge_cmd[@]}"
  echo "Done. Merged source history into current repository."
else
  echo "Dry-run only. Re-run with --apply to execute."
fi
