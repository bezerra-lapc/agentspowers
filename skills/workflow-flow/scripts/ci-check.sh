#!/usr/bin/env bash
# Uso: ci-check.sh [raiz=.]
# Detecta frontend/backend por manifesto e roda build, testes e lint. Falha se qualquer etapa falhar.
set -uo pipefail

root="$(cd "${1:-.}" && pwd)"
fail=0
declare -a results

run() { # run <rótulo> <dir> <cmd...>
  local label="$1" dir="$2"; shift 2
  echo "▶ [$label] ($dir) $*"
  if (cd "$dir" && "$@"); then results+=("OK    $label"); else results+=("FALHA $label"); fail=1; fi
}

npm_script() { (cd "$1" && node -e "process.exit((require('./package.json').scripts||{})['$2']?0:1)" 2>/dev/null); }

check_node() {
  local d="$1" n; n="$(basename "$d")"
  for s in build test lint; do
    npm_script "$d" "$s" && run "$n:$s" "$d" npm run "$s" --silent
  done
}

while IFS= read -r m; do
  d="$(dirname "$m")"
  case "$m" in
    */package.json) check_node "$d" ;;
    */go.mod) run "$(basename "$d"):go-build" "$d" go build ./...
              run "$(basename "$d"):go-test"  "$d" go test ./...
              run "$(basename "$d"):go-vet"   "$d" go vet ./... ;;
    */pyproject.toml) run "$(basename "$d"):pytest" "$d" uv run pytest -q
                      run "$(basename "$d"):ruff"   "$d" uv run ruff check . ;;
  esac
done < <(find "$root" -maxdepth 3 \( -name node_modules -o -name .git -o -name vendor \) -prune -o \
         \( -name package.json -o -name go.mod -o -name pyproject.toml \) -print)

echo; echo "== Resumo =="; printf '%s\n' "${results[@]:-nenhum projeto detectado}"
exit $fail
