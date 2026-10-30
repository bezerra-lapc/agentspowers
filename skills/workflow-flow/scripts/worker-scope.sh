#!/usr/bin/env bash
# Uso: worker-scope.sh <arquivo-com-lista-permitida>
# Falha (exit 1) se algum arquivo alterado/criado no working tree estiver fora da lista (um caminho ou glob por linha).
# Rode a partir da raiz do repo, com a árvore limpa antes de spawnar os workers.
set -euo pipefail

list="${1:?uso: worker-scope.sh <lista-permitida.txt>}"
[ -f "$list" ] || { echo "lista não encontrada: $list" >&2; exit 1; }

out=0
while IFS= read -r changed; do
  [ -z "$changed" ] && continue
  ok=1
  while IFS= read -r pat; do
    [ -z "$pat" ] && continue
    # shellcheck disable=SC2254
    case "$changed" in $pat) ok=0; break ;; esac
  done < "$list"
  if [ "$ok" -ne 0 ]; then echo "FORA DO ESCOPO: $changed"; out=1; fi
done < <(git status --porcelain -uall | sed -E 's/^.{3}//; s/.* -> //')

[ "$out" -eq 0 ] && echo "escopo ok"
exit "$out"
