# Flow — Evals

Medem o **próprio fluxo**, não o produto. Duas fontes:

1. **Métricas por iniciativa** (`docs/Sprints/<slug>/metrics.jsonl`, via `scripts/flow-metrics.sh`; resumo via `scripts/flow-report.sh`).
2. **Casos dourados** (abaixo): situações reais em que uma fase deveria ter pego algo, ou pegou algo que valia a pena.

## Sinais a observar

| Sinal | Como ler |
|---|---|
| Gaps do dry-run na 1ª rodada (C/I/M) | Alto = plan escreve mal ou brief incompleto |
| `spec_gaps` na 1ª rodada do audit | Critérios não atendidos que o implementador declarou prontos. Alto = §11 não está sendo seguida |
| Rodadas de audit por sprint | >2 de forma recorrente = execute entrega sem rigor, ou plano ambíguo |
| Issues da 1ª rodada de audit | Tendência por sprint, não valor absoluto |
| **Escapes** (achado depois de `Approved`: CI, PR, produção) | O sinal mais importante. Cada escape vira caso dourado |
| ADRs por sprint | Muitos = plano divergiu do código; dry-run não pegou |
| Duração entre eventos | Gargalo de fase |

## Regra para mudar o Flow

1. Mude **uma coisa** por vez (um comando, um template, uma regra).
2. Antes de aceitar a mudança, rode os casos dourados relevantes com e sem ela (ao menos 2 execuções: o resultado de agente varia).
3. Compare os **casos que mudaram**, não só o total.
4. Registre a mudança em "Histórico" abaixo. Se piorou, reverta.

## Casos dourados

Formato: `### G-NNN — <título>` com **Fase**, **Situação**, **Esperado** (o que a fase deveria ter pego), **Resultado** (pegou / escapou) e **Origem** (iniciativa/sprint).

_(vazio: o primeiro entra no primeiro escape ou achado relevante)_

## Histórico de mudanças no Flow

- 2026-10-29 — Removido o pacote fechado (REVIEW PACKAGE) em favor de brief com ponteiros; dry-run passa a ser feito por agente spawnado pelo `plan`; adicionadas métricas e esta página. Motivação: handoff com perda e ausência de evals (artigo "when to fold subagents into your main agent loop"). Baseline: sem métricas anteriores.
- 2026-10-29 — Adicionada §11 (verificação antes de concluir) e audit em duas passadas (spec, depois qualidade/segurança), inspirados no Superpowers. Métrica nova: `spec_gaps`. Comparar rodadas de audit e escapes nas próximas iniciativas com o baseline acima.
- 2026-10-29 — Adicionados princípios de desenvolvimento (§12) e risco e controle humano (§13): flags por sprint, gate após audit em sprint com flag, `security.md`, escopo do audit ancorado no diff, regras de produção e bloqueio de bypass de hook. Inspirado no Codeform. Métrica nova: `risk`. Observar: sprints com flag bloqueiam por tempo razoável? Escapes em sprint sem flag indicam flag faltando.
- 2026-10-29 — Observabilidade (§14): evento `spawn` por agente lançado, bloco RESULTADO em `STATUS.md` ao fim de cada fase, relatório em ordem fixa e painel por sprint nos gates. Revisor de segurança separado avaliado e descartado (divide por tipo de problema, duplica leitura e exige reconciliação). Próximo candidato: execução paralela de histórias independentes com worker que devolve BLOQUEADO em vez de decidir.
- 2026-10-29 — Execução paralela (§15): workers só em blocos independentes declarados no plano e confirmados no dry-run; worker devolve CONCLUIDO ou BLOQUEADO e nunca decide; integração, commit e relatório no fio principal; `worker-scope.sh` rejeita arquivo fora do escopo. Sinais novos: taxa de BLOQUEADO e rejeições por escopo (plano declarando blocos que não são independentes). Comparar duração da sprint, rodadas de audit e escapes com e sem workers.
- 2026-10-29 — Wireframe (§16), baseado no command do Codeform: o brainstorm só marca se toca frontend; o `plan` faz inventário e decisões com o usuário, um agente gera o HTML a partir do inventário aprovado e um agente novo confere. Wireframe não entra no brainstorm (read-only, sem pasta ainda, command interativo). Sinais: ciclos de `Corrigir`, NOVO que ficou sem task (pego no dry-run), divergência frontend × wireframe pega no audit.
