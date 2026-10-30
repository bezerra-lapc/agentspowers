#!/usr/bin/env bash
# Uso: flow-metrics.sh <evento> [chave=valor ...]
# Anexa uma linha JSON em docs/Sprints/<slug>/metrics.jsonl (slug vem da branch).
# Eventos: plan, dry-run, execute, audit, fix, finish, escape, spawn.
# spawn: um por agente lançado. Chaves: purpose, phase, sprint, brief (caminho), result, duration_s.
set -euo pipefail

event="${1:?uso: flow-metrics.sh <evento> [chave=valor ...]}"; shift || true
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "fora de repositório git" >&2; exit 1; }
root="$(git rev-parse --show-toplevel)"
slug="$(git branch --show-current | sed -E 's#^[a-z]+/[0-9]+-##')"
dir="$root/docs/Sprints/$slug"
[ -d "$dir" ] || { echo "pasta da iniciativa não existe: $dir" >&2; exit 1; }

python3 -I - "$event" "$dir/metrics.jsonl" "$@" <<'PY'
import json, sys, datetime
event, path, *pairs = sys.argv[1:]
rec = {"ts": datetime.datetime.now(datetime.timezone.utc).isoformat(timespec="seconds"), "event": event}
for p in pairs:
    k, _, v = p.partition("=")
    rec[k] = int(v) if v.lstrip("-").isdigit() else v
with open(path, "a") as f:
    f.write(json.dumps(rec, ensure_ascii=False) + "\n")
print(json.dumps(rec, ensure_ascii=False))
PY
