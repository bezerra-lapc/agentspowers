#!/usr/bin/env bash
# Uso: ambient.sh <issue> <slug> [base=main]
# Cria branch saudável, pasta da iniciativa e comenta o path relativo na issue.
set -euo pipefail

issue="${1:?uso: ambient.sh <issue> <slug> [base]}"
slug="${2:?uso: ambient.sh <issue> <slug> [base]}"
base="${3:-main}"
branch="feat/${issue}-${slug}"
dir="docs/Sprints/${slug}"

root="$(git rev-parse --show-toplevel)"
cd "$root"

if [ -n "$(git status --porcelain)" ]; then
  echo "ERRO: árvore de trabalho suja. Commit ou stash antes." >&2; exit 1
fi

git fetch origin "$base" --quiet
git checkout -b "$branch" "origin/$base"

if [ "$(git rev-parse HEAD)" != "$(git rev-parse "origin/$base")" ]; then
  echo "ERRO: branch não está sincronizada com origin/$base." >&2; exit 1
fi

mkdir -p "$dir/ADR" "$dir/reviews"
tpl="$HOME/.claude/skills/workflow-flow/templates"
[ -f "$dir/PROJECT_CONTEXT.md" ] || cp "$tpl/PROJECT_CONTEXT.template.md" "$dir/PROJECT_CONTEXT.md"
touch "$dir/ADR/.gitkeep" "$dir/reviews/.gitkeep"

echo "Branch: $branch (base $base @ $(git rev-parse --short HEAD))"
echo "Pasta:  $dir"
echo "Saúde:  rode ci-check.sh agora para registrar o estado da base."

if command -v gh >/dev/null 2>&1; then
  gh issue comment "$issue" --body "Iniciativa iniciada. Branch: \`$branch\`. Pasta: \`$dir\`."
  echo "Issue #$issue comentada."
else
  echo "AVISO: gh não encontrado; comente o path na issue manualmente." >&2
fi
