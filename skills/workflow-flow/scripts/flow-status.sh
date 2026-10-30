#!/usr/bin/env bash
# Uso: flow-status.sh fase=<f> status=<aprovado|bloqueado|aguardando-decisao> [chave=valor ...]
# Anexa o bloco RESULTADO em docs/Sprints/<slug>/STATUS.md (leitura humana; métricas ficam em metrics.jsonl).
# Chaves: fase, status, escopo, base, pendencias, decisoes_tomadas, riscos_aceitos, agentes, alterados, proximo.
set -euo pipefail

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "fora de repositório git" >&2; exit 1; }
root="$(git rev-parse --show-toplevel)"
slug="$(git branch --show-current | sed -E 's#^[a-z]+/[0-9]+-##')"
dir="$root/docs/Sprints/$slug"
[ -d "$dir" ] || { echo "pasta da iniciativa não existe: $dir" >&2; exit 1; }

python3 -I - "$dir/STATUS.md" "$@" <<'PY'
import sys, datetime
path, *pairs = sys.argv[1:]
kv = dict(p.partition("=")[::2] for p in pairs)
for req in ("fase", "status"):
    if req not in kv: sys.exit(f"falta {req}=")
order = ["escopo", "base", "pendencias", "decisoes_tomadas", "riscos_aceitos", "agentes", "alterados", "proximo"]
ts = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%d %H:%MZ")
lines = [f"### {ts} · {kv['fase']} · {kv['status']}"]
lines += [f"- {k}: {kv.get(k, 'nenhum' if k != 'proximo' else '?')}" for k in order]
block = "\n".join(lines) + "\n\n"
new = not __import__("os").path.exists(path)
with open(path, "a") as f:
    if new: f.write("# STATUS da iniciativa\n\nLog humano das fases (mais recente embaixo). Métricas: metrics.jsonl.\n\n")
    f.write(block)
print(block, end="")
PY
