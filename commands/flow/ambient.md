---
name: flow:ambient
description: "Fase 2 — cria a branch da iniciativa, confirma que está saudável, cria a pasta docs/Sprints/<slug> e atrela a branch à issue comentando o path relativo."
argument-hint: "<issue> [slug]"
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
Antes de prosseguir, leia `../../skills/workflow-flow/methodology.md` na seção desta fase (§2) e `../../skills/workflow-flow/delegation.md` se for delegar.
</execution_context>

<objective>
Preparar o ambiente da iniciativa para `$ARGUMENTS`.
</objective>

<process>
1. Se não houver `slug`, derive um curto em kebab-case do título da issue (`gh issue view <n>`), e confirme com o usuário.
2. Rode `~/.claude/skills/workflow-flow/scripts/ambient.sh <issue> <slug>`. Ele cria a branch, valida árvore limpa e sincronia com a base, cria a pasta e comenta na issue.
3. Rode `~/.claude/skills/workflow-flow/scripts/ci-check.sh` para registrar a saúde da base. Se a base estiver vermelha, **pare** e reporte antes de seguir.
4. Copie o design aprovado do brainstorm para o `PROJECT_CONTEXT.md` recém-criado.
5. Reporte: branch, pasta, resultado do ci-check. Próximo passo: `/flow:plan`.
</process>

<constraints>
O comentário na issue é ação externa: o script só o executa porque o usuário invocou este comando.
</constraints>
