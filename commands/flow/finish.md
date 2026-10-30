---
name: flow:finish
description: "Fase 7 — roda o CI-check (build, testes e lint de frontend e backend), cria o PR e atualiza a issue."
argument-hint: "[--base main]"
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
Antes de prosseguir, leia `../../skills/workflow-flow/methodology.md` na seção desta fase (§7, §10, §11, §13, §14) e `../../skills/workflow-flow/delegation.md` se for delegar.
</execution_context>

<objective>
Fechar a iniciativa: CI verde, PR aberto, issue atualizada.
</objective>

<process>
1. Confirme que todas as sprints têm audit `Approved` e nenhum ADR pendente.
2. Rode `~/.claude/skills/workflow-flow/scripts/ci-check.sh` agora (não reuse resultado anterior). Qualquer falha **bloqueia**: corrija e rode de novo. Só afirme "CI verde" citando a saída desta execução (§11).
3. Rode `~/.claude/skills/workflow-flow/scripts/flow-report.sh` e mostre ao usuário o resumo (commits, ADRs, resultado do CI, métricas do fluxo, sprints com flag, riscos aceitos e os Minor acumulados para triagem) e o **painel de cada sprint** (§14), e peça confirmação para publicar. Registre `flow-metrics.sh finish ci=ok` e o bloco RESULTADO (`flow-status.sh fase=finish ...`).
4. Com confirmação: `git push -u origin <branch>` (nunca para main) e `gh pr create` com título curto e corpo contendo resumo, ADRs, testes e `Closes #<issue>`.
5. Atualize a issue (`gh issue comment`) com o link do PR e o resumo entregue.
</process>

<constraints>
Push, PR e comentário são ações externas: só depois da confirmação do passo 3.
</constraints>
