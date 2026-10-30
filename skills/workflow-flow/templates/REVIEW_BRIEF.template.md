REVIEW BRIEF

Task: {{TASK}}
Iniciativa: docs/Sprints/{{SLUG}}/
Sprint: docs/Sprints/{{SLUG}}/{{SPRINT_FILE}}
Base: {{BASE}}
Head: {{HEAD}}
Relatório do implementador: docs/Sprints/{{SLUG}}/reviews/REPORT_SPRINT_{{NN}}.md
Flags de risco da sprint: {{FLAGS}}

Como trabalhar (você tem acesso ao repositório, não à conversa):
1. Leia `PROJECT_CONTEXT.md`, a sprint, os ADRs de `ADR/` e o relatório do implementador.
2. Veja a mudança com `git diff {{BASE}}..{{HEAD}}`. Abra os arquivos tocados e, dos vizinhos, só os que os fluxos do diff atravessam (entrada → sink). O diff sozinho não basta, mas não é uma varredura do repositório.
3. Trate o relatório do implementador como afirmações a verificar, não como fatos.
4. Não altere arquivos. Revisão é somente leitura.

Faça DUAS passadas, nesta ordem, sem misturar:

Passada 1 — Conformidade com a spec
Para cada critério (Testes, Resultado esperado, Definition of Done da sprint): atendido ou não atendido, com evidência (arquivo:linha ou saída de comando). Não avalie qualidade ainda.

Passada 2 — Qualidade e segurança
1. O código está correto, simples e sustentável? Segue os princípios do Flow (~/.claude/skills/workflow-flow/methodology.md §12: KISS, YAGNI, DRY, less code, Object Calisthenics adotadas)? Nomeie a regra violada e o arquivo:linha.
2. Os testes verificam comportamento real? Os tipos de teste batem com a criticidade (§13 item 8)?
3. Há regressões, riscos, workaround, código morto novo ou trabalho extra desnecessário?
4. Segurança: algum fluxo source → sink sem validação ou sanitização? Se a flag "superfície de segurança" está ativa, aplique ~/.claude/skills/workflow-flow/security.md.
5. Se há wireframe no PROJECT_CONTEXT: o frontend implementado confere com ele, na tela real?

Approved exige as duas passadas sem Critical/Important.

Retorno obrigatório:
- Strengths
- Passada 1: tabela critério × atendido/não atendido, com evidência
- Passada 2 — Issues: Critical, Important, Minor
- Task quality: Approved ou Needs fixes
- Referências no formato arquivo:linha, com evidência e alternativas de solução
