---
name: flow-code-review
description: Pedido e recebimento de code review por brief de ponteiros (REVIEW BRIEF) para um agente isolado da conversa, com acesso somente leitura ao repositório e retorno Strengths/Issues/Task quality. Use ao finalizar uma sprint, no /flow:audit, ou ao tratar achados de review.
---

# Code Review

## Pedir (agente principal)

1. Salve o relatório do implementador em `reviews/REPORT_SPRINT_NN.md`.
2. Preencha `~/.claude/skills/workflow-flow/templates/REVIEW_BRIEF.template.md`: task, slug, sprint, base, head e flags de risco. O brief só aponta; o revisor lê o repositório.
3. Spawne um `Agent` cujo prompt é **só o brief**.

**Proibido no prompt do revisor**: a conversa; qualquer frase que pré-julgue achados ("não sinalize isso", "isso não é um problema neste caso"). O hook `no-prejudge` bloqueia.

## Revisar (agente isolado)

Faça **duas passadas, sem misturar**. Passada 1: conformidade com a spec, critério por critério (Testes, Resultado esperado, DoD), com evidência. Passada 2: qualidade e segurança. `Approved` exige as duas sem Critical/Important.

Preparação: leia `PROJECT_CONTEXT.md`, a sprint, os ADRs e `git diff base..head`; abra os arquivos tocados e vizinhos. Somente leitura. O relatório do implementador são afirmações a verificar.

Passada 2 (escopo ancorado no diff; vizinhos só ao longo dos fluxos que ele toca):
1. O código está correto, simples e sustentável? Segue os princípios do methodology §12?
2. Os testes verificam comportamento real?
3. Há regressões, riscos ou trabalho extra desnecessário?
4. Segurança: algum fluxo **source → sink** sem validação ou sanitização? Com a flag de superfície de segurança, aplique `security.md`.
5. Havendo wireframe, o frontend implementado confere com ele na tela real?

Retorno obrigatório:
- **Strengths**
- **Passada 1**: tabela critério × atendido/não atendido, com evidência
- **Passada 2 — Issues**: Critical (bloqueia), Important (deve ser corrigido), Minor (pode ser triado ou adiado)
- **Task quality**: `Approved` ou `Needs fixes`
- Referências `arquivo:linha`, com evidência e alternativas de solução

## Receber (agente principal)

1. Leia o relatório inteiro. Não reaja ao resumo.
2. Verifique cada achado no código antes de corrigir; discorde com evidência quando estiver errado.
3. Corrija Critical e Important com `flow-tdd`, provando cada correção com teste rodado (methodology §11); Minor vai ao usuário para triagem.
4. Atualize o head e use um revisor novo até `Approved`. Registre cada rodada com `flow-metrics.sh audit` (inclua `spec_gaps`).
