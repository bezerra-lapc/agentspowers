DRY-RUN BRIEF

Iniciativa: docs/Sprints/{{SLUG}}/
Rodada: {{ROUND}}

Como trabalhar (você tem acesso ao repositório, não à conversa):
1. Leia `PROJECT_CONTEXT.md`, `SPRINTS_OVERVIEW.md` e todos os `SPRINT_NN_*.md`.
2. Abra no código real todo arquivo, função e interface citados pelo plano.
3. Somente leitura. Não altere arquivos.

Checklist:
1. O PROJECT_CONTEXT está coberto pelas sprints?
2. As dependências entre módulos e sprints estão explícitas?
3. As interfaces entre frontend, backend, banco e serviços são coerentes?
4. Há decisões de arquitetura, contrato ou escopo em aberto?
5. O plano diverge do código real ou das restrições do projeto?
6. A estratégia de execução e delegação é adequada?
7. Cada sprint tem os itens obrigatórios (arquivos exatos, mudanças, código/pseudocódigo, sequência, testes, resultado esperado, DoD) e as flags de risco (methodology §13), ou `nenhuma`?
8. Sprint com flag de migração de dado em produção tem plano de migração e de reversão? Há dependência nova não aprovada? Algo especulativo que viola YAGNI (§12)?
9. Se há wireframe (`PROJECT_CONTEXT.md` traz o link): todo componente NOVO do `reviews/WIREFRAME_INVENTORY.md` virou task em alguma sprint?
10. Blocos paralelos (§15): os arquivos são realmente disjuntos e sem dependência de saída entre blocos?

Retorno obrigatório:
- Tabela de gaps: Critical / Important / Minor, com arquivo:linha e correção sugerida
- Veredito: `Pronto para executar` (somente com zero decisões em aberto) ou `Volta ao plan`
