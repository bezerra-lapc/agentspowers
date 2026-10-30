#!/usr/bin/env bash
# Uso: flow-report.sh [docs/Sprints/<slug>]
# Resume metrics.jsonl da iniciativa (default: a da branch atual).
set -euo pipefail

if [ -n "${1:-}" ]; then dir="$1"; else
  root="$(git rev-parse --show-toplevel)"
  dir="$root/docs/Sprints/$(git branch --show-current | sed -E 's#^[a-z]+/[0-9]+-##')"
fi
[ -f "$dir/metrics.jsonl" ] || { echo "sem métricas em $dir" >&2; exit 1; }

python3 -I - "$dir/metrics.jsonl" <<'PY'
import json, sys, collections, datetime
ev = [json.loads(l) for l in open(sys.argv[1]) if l.strip()]
t = lambda e: datetime.datetime.fromisoformat(e["ts"])
by = lambda name: [e for e in ev if e["event"] == name]
g = lambda e, k: int(e.get(k, 0))

print(f"Eventos: {len(ev)}  |  duração: {t(ev[-1]) - t(ev[0])}")

dr = by("dry-run")
if dr:
    print(f"\nDry-run: {len(dr)} rodada(s); gaps na 1ª: C={g(dr[0],'critical')} I={g(dr[0],'important')} M={g(dr[0],'minor')}; veredito final: {dr[-1].get('verdict','?')}")

au = collections.defaultdict(list)
for e in by("audit"): au[e.get("sprint", "?")].append(e)
if au:
    print("\nAudit por sprint (rodadas | 1ª rodada C/I/M | lacunas de spec | veredito final):")
    for s, es in sorted(au.items()):
        f = es[0]
        print(f"  sprint {s}: {len(es)} | {g(f,'critical')}/{g(f,'important')}/{g(f,'minor')} | spec_gaps 1ª={g(f,'spec_gaps')} | {'COM flag' if any(g(e,'risk') for e in es) else 'sem flag'} | {es[-1].get('verdict','?')}")

ex = by("execute")
if ex:
    print(f"\nExecute: {len(ex)} sprint(s); ADRs: {sum(g(e,'adrs') for e in ex)}; histórias: {sum(g(e,'stories') for e in ex)}")

sp = by("spawn")
if sp:
    c = collections.Counter(e.get("purpose", "?") for e in sp)
    dur = sum(g(e, "duration_s") for e in sp)
    print(f"\nAgentes lançados: {len(sp)} ({', '.join(f'{k}={v}' for k, v in sorted(c.items()))})" + (f"; tempo somado {dur}s" if dur else ""))
    wk = [e for e in sp if e.get('purpose') == 'worker']
    if wk: print(f"  workers: {len(wk)}; bloqueados: {sum(1 for e in wk if str(e.get('result','')).startswith('BLOQUEADO'))}")
    for e in sp: print(f"  - {e.get('phase','?')}{' s'+str(e['sprint']) if 'sprint' in e else ''} · {e.get('purpose','?')} → {e.get('result','?')}")

es = by("escape")
print(f"\nEscapes (achados após Approved): {len(es)}")
for e in es: print(f"  - sprint {e.get('sprint','?')}: {e.get('where','?')} - {e.get('note','')}")

fi = by("finish")
if fi: print(f"\nFinish: ci={fi[-1].get('ci','?')} pr={fi[-1].get('pr','?')}")
PY
