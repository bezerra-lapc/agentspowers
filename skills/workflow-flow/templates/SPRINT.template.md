# SPRINT NN — <título>

## Dependências
<sprints/módulos que precisam estar prontos>

## Arquivos exatos
- `<caminho>` — <criar|alterar>

## Mudanças específicas
1. <mudança>

## Código ou pseudocódigo
```
<trecho>
```

## Sequência de implementação
1. <passo> (teste primeiro)

## Testes
- [ ] <caso: sucesso>
- [ ] <caso: erro>
- [ ] <caso: parcial/limite>

## Flags de risco
<lógica crítica | superfície de segurança | migração de dado em produção | API pública ou contrato | frontend novo | nenhuma> (methodology §13)
Se migração de dado em produção: plano de migração e de reversão aqui.

## Paralelização
<blocos independentes que podem ir a workers em paralelo, ou `nenhuma`>
- Bloco A: histórias <...>; arquivos exclusivos: `<caminho>`; depende de: nada
- Bloco B: ...
Critério: arquivos disjuntos (inclusive config, barrel/index, tipos compartilhados, lockfile, migração) e nenhum bloco depende da saída de outro. Dúvida = `nenhuma`.

## Resultado esperado
<comportamento observável>

## Definition of Done
- [ ] Testes RED→GREEN→REFACTOR registrados
- [ ] Build, lint e testes verdes
- [ ] Princípios do §12 aplicados (KISS, YAGNI, DRY, Calisthenics)
- [ ] ADR para cada desvio
- [ ] Audit `Approved`
