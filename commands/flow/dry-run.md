---
name: flow:dry-run
description: "Fase 4 — valida o plano contra o código real e o PROJECT_CONTEXT antes de executar: cobertura, dependências, interfaces, decisões em aberto, divergências e estratégia de delegação. Feito por agente isolado (spawnado pelo /flow:plan ou por este command). Read-only."
argument-hint: "[--initiative <slug>]"
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - Agent
---

<execution_context>
Antes de prosseguir, leia `../../skills/workflow-flow/methodology.md` na seção desta fase (§4, §14) e `../../skills/workflow-flow/delegation.md`.
</execution_context>

<objective>
Simular a execução do plano e detectar gaps. **Não altera código nem plano.** O único arquivo escrito é o relatório em `reviews/DRY_RUN_NN.md`.
</objective>

<process>
Quem executa o checklist é sempre um **agente isolado** (sem a conversa, com acesso somente leitura ao repositório).

- **Chamado direto pelo usuário** (revalidação): preencha `templates/DRY_RUN_BRIEF.template.md`, spawne o `Agent` (general-purpose) com só o brief, leia o relatório na íntegra, salve em `reviews/DRY_RUN_NN.md` e registre `flow-metrics.sh spawn purpose=dry-run ...` e `flow-metrics.sh dry-run ...`, depois o bloco RESULTADO (`flow-status.sh fase=dry-run ...`, §14).
- **Você é o agente spawnado** (o prompt é um DRY-RUN BRIEF): execute o checklist abaixo e devolva o relatório. Não escreva arquivos.
</process>

<checklist>
1. O PROJECT_CONTEXT está coberto pelas sprints?
2. As dependências entre módulos e sprints estão explícitas?
3. As interfaces entre frontend, backend, banco e serviços são coerentes?
4. Há decisões de arquitetura, contrato ou escopo em aberto?
5. O plano diverge do código real ou das restrições do projeto? (abra os arquivos citados e confira)
6. A estratégia de execução e delegação é adequada?
7. Cada sprint tem os itens obrigatórios (arquivos exatos, mudanças, código/pseudocódigo, sequência, testes, resultado esperado, DoD) e as flags de risco (§13), ou `nenhuma`?
8. Sprint com flag de migração de dado em produção tem plano de migração e de reversão? Há dependência nova não aprovada? Algo especulativo que viola YAGNI (§12)?
9. Wireframe (§16), se a iniciativa tem um: todo componente `NOVO` virou task em alguma sprint? O `PROJECT_CONTEXT.md` traz o link e o caminho do HTML?
10. Blocos paralelos (§15): arquivos realmente disjuntos (abra o código: imports, tipos compartilhados, barrel/index, config, lockfile, migração) e sem dependência de saída entre blocos?
</checklist>

<output>
Tabela de gaps com Critical / Important / Minor, `arquivo:linha` quando aplicável e correção sugerida. Veredito: `Pronto para executar` somente com zero decisões em aberto; caso contrário, `Volta ao plan`.
</output>
