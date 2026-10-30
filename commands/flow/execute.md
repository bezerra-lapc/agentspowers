---
name: flow:execute
description: "Fase 5 — implementa UMA sprint com TDD, registra decisões e desvios em ADR e, ao final, spawna um agente para rodar o audit."
argument-hint: "<sprint (número, arquivo ou título)>"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - Skill
  - Agent
---

<execution_context>
Antes de prosseguir, leia `../../skills/workflow-flow/methodology.md` na seção desta fase (§5, §8, §11, §12, §13, §14, §15) e `../../skills/workflow-flow/delegation.md` se for delegar.
</execution_context>

<objective>
Implementar a sprint `$ARGUMENTS` por completo.
</objective>

<process>
1. Leia o `PROJECT_CONTEXT.md` e o `SPRINT_NN_*.md` alvo.
2. Para **cada história**, siga a skill `flow-tdd`: RED (veja o teste falhar pelo motivo correto) → GREEN (mínimo) → REFACTOR. Racionalizações para pular teste são proibidas.
3. Aplique os princípios do §12 em todo código novo e as regras de produção do §13: corrija na fonte, sem workaround nem legado, dados preservados, nada contra produção, dependência nova só com aprovação, documentação da lib quando não a conhece. Se há wireframe e o frontend mudar, atualize o wireframe.
4. Se a sprint declara blocos independentes (§15) e cada um justifica o custo, lance **workers em paralelo** (`templates/WORKER_BRIEF.template.md`, árvore limpa antes). Worker devolve `CONCLUIDO` ou `BLOQUEADO` e nunca decide. Integre no fio principal: `~/.claude/skills/workflow-flow/scripts/worker-scope.sh`, diff de cada worker na íntegra e suíte completa rodada por você. Registre cada worker com `flow-metrics.sh spawn purpose=worker ...`.
5. Se decidir algo fora do plano, ou o plano estiver errado, **registre um ADR** (`templates/ADR.template.md`) em `ADR/` antes de seguir. Decisão de design em aberto: pare e traga ao usuário.
6. Marque as tasks `[x]` conforme concluir e rode build, lint e testes ao fim. Cada `[x]` e cada número do relatório (ex.: testes N/N) vêm de saída de comando rodado depois da última alteração (§11). Sem execução, não marque.
7. Faça commit da sprint (testes verdes). Salve o relatório do implementador em `reviews/REPORT_SPRINT_NN.md` (o que foi feito, testes N/N, commit, decisões) e registre `~/.claude/skills/workflow-flow/scripts/flow-metrics.sh execute sprint=NN stories=N adrs=N`.
8. **Spawne um agente** (`Agent`, general-purpose) para o audit, passando somente o REVIEW BRIEF (`templates/REVIEW_BRIEF.template.md`: task, slug, sprint, base, head, flags da sprint; skill `flow-code-review`). Registre o agente (`~/.claude/skills/workflow-flow/scripts/flow-metrics.sh spawn purpose=audit phase=execute sprint=NN brief=<caminho> result=...`) e o bloco RESULTADO (`~/.claude/skills/workflow-flow/scripts/flow-status.sh fase=execute status=... escopo=sprint NN ...`, §14). Ver `/flow:audit`.
</process>
