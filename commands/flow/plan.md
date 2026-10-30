---
name: flow:plan
description: "Fase 3 — escreve PROJECT_CONTEXT.md e as sprints (SPRINTS_OVERVIEW.md + SPRINT_NN_*.md) com arquivos exatos, mudanças, código/pseudocódigo, sequência, testes, resultado esperado e Definition of Done, e spawna um agente isolado para o dry-run antes do gate."
argument-hint: "[--initiative <slug>]"
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
Antes de prosseguir, leia `../../skills/workflow-flow/methodology.md` na seção desta fase (§3), as seções §4, §13, §14, §15, §16 e `../../skills/workflow-flow/delegation.md` (dry-run isolado).
</execution_context>

<objective>
Escrever o plano completo da iniciativa em `docs/Sprints/<slug>/`.
</objective>

<process>
1. Leia o `PROJECT_CONTEXT.md` (design aprovado) e o código real que será tocado.
2. **Wireframe (§16), só se o design aprovado marcou frontend relevante.** Antes de escrever o `PROJECT_CONTEXT.md`: trave telas e estados com o usuário, leia os componentes reais na íntegra, monte e salve o inventário (`reviews/WIREFRAME_INVENTORY.md`) e leve todo NOVO e desvio ao usuário. Com o inventário aprovado, spawne o agente de geração (`templates/WIREFRAME_BRIEF.template.md`) e, depois, um agente novo de conferência (`templates/WIREFRAME_CHECK_BRIEF.template.md`). Registre ambos (`~/.claude/skills/workflow-flow/scripts/flow-metrics.sh spawn purpose=wireframe` / `wireframe-check`), leia os retornos na íntegra, publique o artifact e grave a URL e o caminho no `PROJECT_CONTEXT.md`. **Gate:** só siga com o wireframe aprovado.
3. Complete o `PROJECT_CONTEXT.md` a partir de `templates/PROJECT_CONTEXT.template.md`: objetivo, design, restrições, fora de escopo, interfaces.
4. Escreva `SPRINTS_OVERVIEW.md` (ordem, dependências) e um `SPRINT_NN_<titulo>.md` por sprint, a partir de `templates/SPRINT.template.md`.
5. Cada sprint tem obrigatoriamente: arquivos exatos, mudanças específicas, código ou pseudocódigo, sequência de implementação, testes, resultado esperado, Definition of Done, **flags de risco** (§13) ou `nenhuma`, e **paralelização** (§15): blocos independentes com arquivos exclusivos, ou `nenhuma`. Na dúvida, `nenhuma`. Sem item, o plano é inválido. Planeje seguindo o §12: nada especulativo (YAGNI), a solução mais simples (KISS). Migração de dado em produção exige plano de migração e de reversão na sprint, e vai ao gate.
6. **Spawne um agente para o dry-run** (obrigatório, não é opcional): preencha `templates/DRY_RUN_BRIEF.template.md` (slug, rodada) e passe **só o brief** ao `Agent` (general-purpose). Proibido pré-julgar (hook `no-prejudge`).
7. Registre o agente (`~/.claude/skills/workflow-flow/scripts/flow-metrics.sh spawn purpose=dry-run phase=plan brief=<caminho> result=<veredito>`). Leia o relatório na íntegra, salve em `reviews/DRY_RUN_NN.md` e registre `~/.claude/skills/workflow-flow/scripts/flow-metrics.sh dry-run round=N critical=C important=I minor=M verdict=<...>`.
8. Se houver gaps Critical/Important, corrija o plano e spawne um agente **novo**. Repita até `Pronto para executar`; após 3 rodadas sem convergir, pare e leve ao usuário. Gap que exige decisão (§0) vai ao usuário.
9. Apresente o plano **já validado** ao usuário (primeiro resumo não técnico, depois técnico, com o veredito e os gaps tratados) e aguarde aprovação. Destaque ao usuário: sprints com flag (elas terão gate após o audit), planos de migração e dependências novas. Termine com o relatório em ordem fixa e o bloco RESULTADO (`~/.claude/skills/workflow-flow/scripts/flow-status.sh fase=plan status=... proximo=...`, methodology §14). Próximo passo: `/flow:execute`.
</process>
