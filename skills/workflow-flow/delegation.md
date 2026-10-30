# Flow — Delegação

Regra geral: o **agente principal executa**. Delega só quando isso melhora o resultado.

## Quando delegar

| Situação | Delegar? |
|---|---|
| Dry-run do plano (§3/§4) | **Sempre**, em agente isolado spawnado pelo `plan` |
| Audit de uma sprint (§6/§9) | **Sempre**, em agente isolado |
| Busca ampla na codebase (brainstorm) | Sim (`Explore`) |
| Gerar o HTML do wireframe e conferi-lo (§16) | Sim, com inventário aprovado; inventário e decisões ficam no fio principal |
| Implementar a sprint | Não por padrão. O fio principal conserva o contexto |
| Blocos independentes declarados no plano e confirmados no dry-run (§15) | Sim, workers em paralelo com escopo fechado |
| Decisão de design ou escopo | Nunca. Vai ao usuário (§0) |

Divida por **contexto**, não por tipo de problema: delegue o que precisa de pouco do resto do sistema e devolve resultado compacto.

## Regras de contexto

1. O subagente recebe um **brief com ponteiros** (caminhos, SHAs, perguntas), não um resumo do que o agente principal acha. Ele lê o repositório por conta própria.
2. Nunca enviar a conversa inteira.
3. Nunca enviar instruções que pré-julguem achados (o hook `no-prejudge` bloqueia).
4. O resultado do subagente é lido **na íntegra** pelo agente principal antes de agir.
5. Revisores e validadores são **somente leitura**.
6. **Todo agente lançado é registrado** (`flow-metrics.sh spawn ...`, methodology §14).

## Workers de implementação (§15)

1. Só para blocos que o `plan` declarou independentes e o `dry-run` confirmou. Árvore limpa antes de lançar.
2. `Agent` (general-purpose) por bloco, na mesma rodada, com `templates/WORKER_BRIEF.template.md` como único conteúdo do prompt.
3. O worker devolve `CONCLUIDO` ou `BLOQUEADO`. Nunca decide: dúvida não local ou irreversível vai ao usuário pelo fio principal.
4. Integração no fio principal: `scripts/worker-scope.sh`, leitura do diff na íntegra, suíte completa rodada por você, commit, `[x]` e relatório.
5. Dúvida resolvida: worker **novo** com a resposta no brief. Máximo 2 tentativas por bloco.

## Wireframe (§16)

1. Inventário de fidelidade, NOVO e desvios: **fio principal com o usuário**, nunca delegado.
2. Geração: `Agent` com `templates/WIREFRAME_BRIEF.template.md`, só depois do inventário aprovado. Escreve só o HTML de saída. `CONCLUIDO` ou `BLOQUEADO`; nunca decide componente.
3. Conferência: `Agent` **novo**, somente leitura, com `templates/WIREFRAME_CHECK_BRIEF.template.md`. Veredito `Fiel` ou `Corrigir`; máximo 2 ciclos.
4. Publicação do artifact e URL no `PROJECT_CONTEXT.md`: fio principal.

## Dry-run isolado (spawnado pelo plan)

1. Preencha `templates/DRY_RUN_BRIEF.template.md` (slug, rodada).
2. `Agent` (general-purpose) com o brief como único conteúdo do prompt.
3. Salve o retorno em `reviews/DRY_RUN_NN.md` e registre `flow-metrics.sh dry-run ...`.
4. Gaps: corrija o plano e spawne um agente **novo**. Máximo 3 rodadas; depois, usuário.

## Audit isolado

1. Salve o relatório do implementador em `reviews/REPORT_SPRINT_NN.md`.
2. Preencha `templates/REVIEW_BRIEF.template.md` (task, slug, sprint, base, head).
3. `Agent` (general-purpose) com o brief como único conteúdo do prompt.
4. Salve o retorno em `reviews/REVIEW_SPRINT_NN.md` e registre `flow-metrics.sh audit ...`.
5. Se `Needs fixes`: corrija, atualize o head, novo agente (nunca reaproveitar o contexto do revisor anterior).

## Sem orquestrador

Se não for possível spawnar agentes, o gate fica **manual**: preencha o brief, avise o usuário e aguarde.
