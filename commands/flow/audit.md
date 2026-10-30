---
name: flow:audit
description: "Fase 6 — review de código e auditoria de segurança (source → sink) da sprint, por agente isolado (sem a conversa, com acesso somente leitura ao repositório) a partir de um brief de ponteiros. Retorna Strengths, Issues (Critical/Important/Minor) e Task quality."
argument-hint: "<sprint> [--base <sha>] [--head <sha>]"
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
Antes de prosseguir, leia `../../skills/workflow-flow/methodology.md` na seção desta fase (§6, §9, §10, §11, §12, §13, §14) e `../../skills/workflow-flow/delegation.md` se for delegar.
</execution_context>

<objective>
Auditar a sprint `$ARGUMENTS` em um agente isolado e tratar os achados.
</objective>

<process>
1. Preencha `templates/REVIEW_BRIEF.template.md` (task, slug, sprint, base, head, flags de risco da sprint) e confirme que `reviews/REPORT_SPRINT_NN.md` existe.
2. Spawne um agente (`Agent`, general-purpose) cujo prompt é **somente** o brief. Proibido: a conversa, e frases que pré-julguem achados (o hook `no-prejudge` bloqueia). O revisor lê o repositório por conta própria (somente leitura), ancorado no diff: vizinhos só ao longo dos fluxos que o diff toca.
3. O revisor faz **duas passadas**: (1) conformidade com a spec, critério por critério, sem olhar qualidade; (2) bugs/regressões/desvios arquiteturais, qualidade/testes/erros/simplicidade, aderência aos princípios do §12 e segurança source → sink (com `security.md` se a sprint tem a flag de superfície de segurança) e, havendo wireframe, o frontend contra ele na tela real; tudo com evidência `arquivo:linha` e alternativas. `Approved` exige as duas limpas.
4. Leia o relatório na íntegra, salve em `reviews/REVIEW_SPRINT_NN.md` e registre `~/.claude/skills/workflow-flow/scripts/flow-metrics.sh spawn purpose=audit phase=audit sprint=NN brief=<caminho> result=<veredito>` e `~/.claude/skills/workflow-flow/scripts/flow-metrics.sh audit sprint=NN round=N critical=C important=I minor=M spec_gaps=S risk=<0|1> verdict=<Approved|Needs fixes>`.
5. Corrija Critical e Important (ciclo `flow-tdd`; cada correção com evidência de teste rodado, §11), registre ADR se houver desvio, atualize o head, spawne um revisor novo e repita até `Approved`. 
6. Registre o bloco RESULTADO (`~/.claude/skills/workflow-flow/scripts/flow-status.sh fase=audit status=... escopo=sprint NN riscos_aceitos=... proximo=...`).
7. **Gate de risco (§13).** Sprint **com** flag: depois do `Approved`, pare, apresente o **painel da sprint** (§14) e o relatório completo (corrigidos, Minor, riscos) e só avance com a aprovação do usuário. Sprint **sem** flag: guarde os Minor para o `finish` e siga para a próxima sprint. Critical/Important que não serão corrigidos só podem ser aceitos pelo usuário, com ADR.
</process>
