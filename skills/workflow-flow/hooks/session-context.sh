#!/usr/bin/env bash
# SessionStart: informa branch e iniciativa ativa do Flow, se houver.
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
root="$(git rev-parse --show-toplevel)"; branch="$(git branch --show-current)"
slug="$(echo "$branch" | sed -E 's#^[a-z]+/[0-9]+-##')"
dir="$root/docs/Sprints/$slug"
if [ -d "$dir" ]; then
  echo "Flow: iniciativa ativa '$slug' (branch $branch) em docs/Sprints/$slug."
  [ -f "$dir/PROJECT_CONTEXT.md" ] && echo "Flow: leia PROJECT_CONTEXT.md antes de continuar."
  ls "$dir"/SPRINT_*.md >/dev/null 2>&1 && echo "Flow: sprints: $(ls "$dir" | grep -c '^SPRINT_[0-9]')"
fi
exit 0
