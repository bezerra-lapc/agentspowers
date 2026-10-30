---
name: workflow-flow
description: Fluxo pessoal de desenvolvimento em 7 fases (brainstorm → ambient → plan → dry-run → execute → audit → finish) com gates humanos, TDD, dry-run e review por agentes isolados e evals do próprio fluxo. Use ao receber uma demanda nova, planejar uma iniciativa, escrever PROJECT_CONTEXT e sprints, executar ou auditar uma sprint, ou fechar o trabalho com CI e PR. Roteia para os comandos /flow:* e aplica a methodology.
---

# Flow — Desenvolvimento por iniciativa

Esta skill faz o Claude saber qual fase usar. Uma iniciativa = uma branch = um PR. A fonte de verdade é `methodology.md`; a delegação a subagentes segue `delegation.md`.

## O ciclo

| O usuário quer… | Use | Gate ao final |
|---|---|---|
| Entender o pedido e chegar a um design | `/flow:brainstorm <demanda>` | design aprovado |
| Preparar branch, pasta e issue | `/flow:ambient <issue> [slug]` | base saudável |
| Escrever PROJECT_CONTEXT e sprints (o plan spawna o dry-run) | `/flow:plan` | plano validado e aprovado |
| Revalidar um plano existente contra o código real | `/flow:dry-run` | zero decisões em aberto |
| Implementar UMA sprint com TDD | `/flow:execute <sprint>` | testes verdes + commit |
| Review e segurança da sprint | `/flow:audit <sprint>` | `Approved` |
| CI, PR e issue | `/flow:finish` | confirmação do usuário |

Se o usuário descrever a tarefa sem citar o comando, identifique a fase e ofereça o command correspondente.

## Regras que valem em toda fase

1. **Gates humanos** (methodology §0): decisão difícil de reverter, ou que altere contrato, escopo, arquitetura, dados, segurança ou preferência do usuário, exige aprovação. Decisão local e reversível o agente toma e registra com justificativa.
2. **Explicação em duas camadas**: ao devolver entendimento ou plano, primeiro a versão não técnica (literal, frases curtas, sem metáforas ou subentendidos), depois a técnica.
3. **TDD** (§8): RED → GREEN → REFACTOR. Nunca aceite as racionalizações para pular o teste. Skill: `flow-tdd`.
4. **Dry-run e review isolados** (§3, §9): agente sem a conversa, com brief de ponteiros e acesso somente leitura ao repositório; sem pré-julgar achados. Skill: `flow-code-review`.
5. **Evals** (§10): cada fase registra métricas; o `finish` mostra o resumo; escapes viram casos dourados.
6. **Verificação antes de concluir** (§11): nenhuma afirmação de "pronto" sem a saída de um comando rodado depois da última alteração.
7. **Princípios de desenvolvimento** (§12): KISS, YAGNI, DRY, less code e subconjunto de Object Calisthenics em todo código novo.
8. **Risco e controle** (§13): flags de risco por sprint; sprint com flag para depois do audit e espera o usuário; regras de produção valem sempre.
9. **Observabilidade** (§14): todo agente lançado é registrado; cada fase termina com o bloco RESULTADO (`flow-status.sh`) e o relatório em ordem fixa.
10. **Execução paralela** (§15): workers só em blocos independentes declarados no plano e confirmados no dry-run; o worker nunca decide, devolve `BLOQUEADO`.
11. **Wireframe** (§16): quando o brainstorm marca frontend relevante, o `plan` faz o wireframe antes das sprints; inventário e decisões com você, HTML por agente, conferência por agente novo.
12. **Ações externas** (comentar issue, push, PR) só dentro do command que as declara. Nunca push em main.

## Caminhos canônicos

```
docs/Sprints/<slug>/
  PROJECT_CONTEXT.md
  WIREFRAME_<TEMA>.html (se frontend relevante)
  SPRINTS_OVERVIEW.md
  SPRINT_NN_<titulo>.md
  ADR/ADR_NNN_<decisao>.md
  reviews/WIREFRAME_INVENTORY.md, DRY_RUN_NN.md, REPORT_SPRINT_NN.md, REVIEW_SPRINT_NN.md
  metrics.jsonl, STATUS.md
```

## Peças desta skill

- `methodology.md`: as 7 fases, gates, TDD, review e evals (§0–§16)
- `security.md`: checklist de segurança do audit (superfícies sensíveis)
- `evals/GOLDEN.md`: sinais, regra para mudar o Flow e casos dourados
- `delegation.md`: quando e como delegar
- `scripts/`: `ambient.sh`, `ci-check.sh`, `flow-metrics.sh`, `flow-report.sh`, `flow-status.sh`, `worker-scope.sh`
- `templates/`: `PROJECT_CONTEXT`, `SPRINT`, `ADR`, `REVIEW_BRIEF`, `DRY_RUN_BRIEF`, `WORKER_BRIEF`, `WIREFRAME_BRIEF`, `WIREFRAME_CHECK_BRIEF`
- `hooks/`: `tdd-guard`, `no-push-main`, `no-prejudge`, `session-context` (instalados via `settings-snippet.json`)
