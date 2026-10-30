---
name: flow-tdd
description: Test-Driven Development do Flow (RED → GREEN → REFACTOR) com combate às racionalizações para pular teste. Use ao implementar qualquer história de uma sprint, corrigir bug ou achado de audit.
---

# TDD

Para cada história ou correção, nesta ordem:

1. **RED** — escreva o teste. Rode. Confirme que falha **pelo motivo correto** (a asserção sobre o comportamento novo, não erro de import ou sintaxe). Mostre a falha.
2. **GREEN** — escreva o mínimo para passar. Nada além do que o teste exige.
3. **REFACTOR** — melhore estrutura e nomes com os testes verdes, guiado pelos princípios do Flow (methodology §12: KISS, YAGNI, DRY com 3+ ocorrências, less code, um nível de indentação, sem `else`, sem abreviações). Não mude comportamento. Rode os testes de novo.

## Racionalizações proibidas

| Pensamento | Resposta |
|---|---|
| "Este caso é simples demais para testar" | Simples também quebra. Escreva o teste. |
| "Vou testar depois" | Depois não existe. RED primeiro. |
| "O teste existente já cobre" | Prove: rode e veja falhar sem a mudança. |
| "Primeiro preciso criar a infraestrutura" | Crie o mínimo de infraestrutura que o teste exige, então RED. |
| "O teste não precisa falhar porque sei que a implementação está correta" | Teste que nunca falhou não prova nada. Veja falhar. |

## Exceção

Docs, config e refactor puro podem usar `FLOW_SKIP_TDD=1` no commit. Diga ao usuário que usou.

O hook `tdd-guard` bloqueia commit com código de produção staged sem teste staged.
