usage() {
  cat <<'EOF'
Usage: git delete-merged-branch [--dry-run] [--no-fetch] [--remote <name>]

Delete local branches that are safe to remove because either:
  - their tip is already contained in the remote default branch, or
  - a merged GitHub PR has the same head branch and head commit.

Options:
  -n, --dry-run        Show branches without deleting them
      --no-fetch       Do not fetch and prune before checking
  -r, --remote <name>  Remote to fetch (default: origin)
  -h, --help           Show this help
EOF
}

dry_run=false
fetch_first=true
remote=origin

while (( $# > 0 )); do
  case "$1" in
    -n|--dry-run)
      dry_run=true
      ;;
    --no-fetch)
      fetch_first=false
      ;;
    -r|--remote)
      if (( $# < 2 )); then
        echo "error: $1 requires a remote name" >&2
        exit 2
      fi
      remote=$2
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "error: not inside a Git repository" >&2
  exit 1
fi

if ! git remote get-url "$remote" >/dev/null 2>&1; then
  echo "error: remote '$remote' does not exist" >&2
  exit 1
fi

if [[ $fetch_first == true ]]; then
  echo "Fetching '$remote' and pruning stale remote branches..."
  git fetch --prune "$remote"
fi

current_branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)
github_available=true

if ! repository=$(gh repo view --json nameWithOwner --jq '.nameWithOwner' 2>/dev/null); then
  github_available=false
  repository=''
  echo "warning: GitHub PRs cannot be checked; only Git merge history will be used" >&2
fi

default_branch=''
if [[ $github_available == true ]]; then
  if ! default_branch=$(gh repo view --repo "$repository" --json defaultBranchRef --jq '.defaultBranchRef.name' 2>/dev/null); then
    github_available=false
    echo "warning: the GitHub default branch cannot be read; only Git merge history will be used" >&2
  fi
fi

if [[ -z $default_branch ]]; then
  default_branch=$(git symbolic-ref --quiet --short "refs/remotes/$remote/HEAD" 2>/dev/null || true)
  default_branch=${default_branch#"$remote/"}
fi

target_ref=''
if [[ -n $default_branch ]] && git show-ref --verify --quiet "refs/remotes/$remote/$default_branch"; then
  target_ref="refs/remotes/$remote/$default_branch"
fi

is_protected_branch() {
  local branch=$1

  case "$branch" in
    "$current_branch"|"$default_branch"|main|master|develop|release|release/*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

deleted=0
kept=0
errors=0

while IFS=$'\t' read -r branch commit worktree_path; do
  if is_protected_branch "$branch"; then
    printf 'keep    %-30s protected branch\n' "$branch"
    ((kept += 1))
    continue
  fi

  if [[ -n $worktree_path ]]; then
    printf 'keep    %-30s checked out at %s\n' "$branch" "$worktree_path"
    ((kept += 1))
    continue
  fi

  delete_mode=''
  reason=''

  if [[ -n $target_ref ]] && git merge-base --is-ancestor "$commit" "$target_ref"; then
    delete_mode=-d
    reason="contained in $remote/$default_branch"
  elif [[ $github_available == true ]]; then
    if ! pull_requests=$(
      gh pr list \
        --repo "$repository" \
        --state merged \
        --head "$branch" \
        --limit 100 \
        --json number,url,headRefOid,mergedAt 2>/dev/null
    ); then
      printf 'keep    %-30s GitHub PR lookup failed\n' "$branch"
      ((kept += 1))
      ((errors += 1))
      continue
    fi

    merged_pr=$(jq -r --arg commit "$commit" '
      map(select(.headRefOid == $commit))
      | sort_by(.mergedAt)
      | last
      | if . == null then empty else "#\(.number)\t\(.url)" end
    ' <<<"$pull_requests")

    if [[ -n $merged_pr ]]; then
      pr_number=${merged_pr%%$'\t'*}
      pr_url=${merged_pr#*$'\t'}
      delete_mode=-D
      reason="merged PR $pr_number ($pr_url), head commit matches"
    fi
  fi

  if [[ -z $delete_mode ]]; then
    printf 'keep    %-30s not merged\n' "$branch"
    ((kept += 1))
    continue
  fi

  if [[ $dry_run == true ]]; then
    printf 'delete? %-30s %s\n' "$branch" "$reason"
  elif git branch "$delete_mode" -- "$branch" >/dev/null; then
    printf 'deleted %-30s %s\n' "$branch" "$reason"
  else
    printf 'error   %-30s deletion failed\n' "$branch" >&2
    ((errors += 1))
    continue
  fi
  ((deleted += 1))
done < <(git for-each-ref --format='%(refname:short)%09%(objectname)%09%(worktreepath)' refs/heads/)

if [[ $dry_run == true ]]; then
  printf '\nDry run: %d branch(es) would be deleted; %d kept.\n' "$deleted" "$kept"
else
  printf '\n%d branch(es) deleted; %d kept.\n' "$deleted" "$kept"
fi

if (( errors > 0 )); then
  echo "$errors error(s) occurred." >&2
  exit 1
fi
