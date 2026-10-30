---
name: flow:brainstorm
description: "Fase 1 — descobre o objetivo real, explora alternativas, identifica restrições e devolve o entendimento (primeiro não técnico, depois técnico) até haver um design aprovado. Não cria arquivos nem altera código."
argument-hint: "<demanda>"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
---

<execution_context>
Antes de prosseguir, leia `../../skills/workflow-flow/methodology.md` na seção desta fase (§1) e `../../skills/workflow-flow/delegation.md` se for delegar.
</execution_context>

<objective>
Conduzir o brainstorm de `$ARGUMENTS` até um **design aprovado**.
</objective>

<process>
1. Leia a codebase relevante (read-only) para ancorar o entendimento.
2. Descubra o objetivo real: qual problema está por trás do pedido? Pergunte apenas o que muda a decisão.
3. Proponha no mínimo 2 alternativas com prós/contras e recomende uma.
4. Liste as restrições (técnicas, contrato, segurança, prazo, compatibilidade).
5. Devolva o entendimento **nesta ordem**:
   - **Explicação não técnica**: literal, frases curtas, um assunto por vez, sem metáforas ou subentendidos; diga o que existe hoje, o que muda e o que não muda, como se fosse para um autista.
   - **Explicação técnica**: componentes, contratos, dados, riscos.
6. Peça correção do entendimento. Ajuste e devolva de novo até o usuário confirmar.
7. Entregue o design aprovado (objetivo, alternativa escolhida, restrições, fora de escopo e **toca frontend de forma relevante? sim/não**, com a tela ou o fluxo) e pare. Se sim, o `plan` fará o wireframe (§16). Próximo passo: `/flow:ambient`.
</process>

<constraints>
Não crie arquivos, branches ou issues. Não planeje sprints antes da aprovação.
</constraints>
