# Flow — Methodology

Fonte de verdade do fluxo. Os commands `/flow:*` leem a seção da sua fase. Uma iniciativa = uma branch = um PR.

```
brainstorm → ambient → plan ──spawna──▶ dry-run → execute (por sprint) → audit (por sprint) → finish
   §1          §2       §3                §4          §5 + §8                §6 + §9            §7
```

Transversal: gates (§0), verificação antes de concluir (§11), evals do próprio fluxo (§10), princípios de desenvolvimento (§12), risco e controle humano (§13), observabilidade (§14), execução paralela (§15) e wireframe (§16).

## §0 Gates humanos (transversal)

**Aprovação humana é obrigatória** quando a decisão:
- é difícil de reverter;
- altera contrato, escopo, arquitetura, dados ou segurança;
- adiciona uma **dependência nova** (cadeia de suprimentos);
- toca uma preferência do usuário.

**O agente decide sozinho** quando a decisão é local e reversível. Nesse caso, registra a decisão e a justificativa no relatório (ADR se desviar do plano).

Na dúvida se é reversível: trate como difícil de reverter e pergunte.

Ações externas (comentar na issue, push, PR) só ocorrem porque o usuário invocou o command que as descreve.

Controle proporcional ao risco: sprints sem flag de risco seguem sem parar entre `execute` e `audit`; sprints com flag têm gates extras (§13).

## §1 Brainstorming

Objetivo: chegar a um **design aprovado**. Read-only: sem arquivos, branches ou issues.

1. Descobrir o objetivo real (o problema por trás do pedido).
2. Explorar alternativas de solução (mínimo 2, com prós/contras e recomendação).
3. Identificar restrições.
4. Devolver o entendimento ao usuário **nesta ordem**:
   - **Não técnico primeiro**, escrito para ser entendido por uma pessoa autista: literal, frases curtas, um assunto por vez, sem metáforas, ironia ou subentendidos; dizer o que existe hoje, o que muda e o que não muda.
   - **Técnico depois**: componentes, contratos, dados, riscos.
5. Corrigir o entendimento **antes** de planejar. Repetir até o usuário confirmar.
6. Produzir o design aprovado: objetivo, alternativa escolhida, restrições, fora de escopo e **toca frontend de forma relevante? sim/não** (qual tela ou fluxo). Sim aciona o wireframe no `plan` (§16). O brainstorm não desenha nem cria arquivos.

## §2 Ambient

1. Criar a branch `feat/<issue>-<slug>` a partir da base e confirmar que está saudável (árvore limpa, sincronizada, `ci-check` verde na base).
2. Criar a pasta `docs/Sprints/<slug>/` (com `ADR/` e `reviews/`).
3. Atrelar a branch à issue e comentar o path relativo.

Base vermelha: parar e reportar antes de seguir. Script: `scripts/ambient.sh`.

## §3 Plan

Escrever `PROJECT_CONTEXT.md` e as sprints (`SPRINTS_OVERVIEW.md` + `SPRINT_NN_<titulo>.md`). Cada sprint tem **todos** estes itens, senão o plano é inválido:

1. Arquivos exatos
2. Mudanças específicas
3. Código ou pseudocódigo necessário
4. Sequência de implementação
5. Testes
6. Resultado esperado
7. Definition of Done
8. **Flags de risco** (§13), ou `nenhuma`
9. **Paralelização** (§15): blocos independentes com arquivos exclusivos, ou `nenhuma`

**Wireframe** só quando a iniciativa altera de forma relevante fluxo, layout, interação ou contrato visual do frontend. Ajuste visual trivial não exige wireframe. Quando houver, ele é feito **antes** de escrever o `PROJECT_CONTEXT.md` e das sprints, conforme o §16, e o link vai no `PROJECT_CONTEXT.md`.

**Dry-run obrigatório por agente isolado.** Assim que `PROJECT_CONTEXT.md` e todas as sprints estiverem escritos, o agente que rodou o plan **spawna um agente** para fazer o dry-run (§4), com o brief de `templates/DRY_RUN_BRIEF.template.md`. O agente do plan:

1. Lê o relatório na íntegra e salva em `reviews/DRY_RUN_NN.md`.
2. Corrige os gaps Critical e Important no plano e, se houve correção, spawna um agente **novo** (nunca reaproveita o anterior).
3. Repete até `Pronto para executar`. Após 3 rodadas sem convergir, para e leva o impasse ao usuário.
4. Gaps que dependem de decisão (§0) vão ao usuário, não são resolvidos pelo agente do plan.

Gate: apresentar o plano **já validado** (não técnico, depois técnico, com o veredito e os gaps tratados do dry-run) e aguardar aprovação.

## §4 Dry-run

Read-only, feito por agente isolado spawnado pelo `plan` (§3). `/flow:dry-run` também pode ser chamado direto para revalidar um plano existente. Verificar:

1. O PROJECT_CONTEXT está coberto pelas SPRINTS?
2. As dependências entre módulos e sprints estão explícitas?
3. As interfaces entre frontend, backend, banco e serviços são coerentes?
4. Há decisões de arquitetura, contrato ou escopo em aberto?
5. O plano diverge do código real ou das restrições do projeto? (abrir os arquivos citados)
6. A estratégia de execução e delegação é adequada?
7. Cada sprint tem os itens obrigatórios do §3, incluindo as flags de risco (§13) e a paralelização (§15)?
8. Sprint com flag `migração de dado em produção` traz plano de migração e de reversão? O plano respeita os princípios do §12 (nada especulativo)?

9. Wireframe (§16), se a iniciativa tem um: todo componente `NOVO` virou task em alguma sprint? O `PROJECT_CONTEXT.md` traz o link e o caminho do HTML?
10. Blocos paralelos (§15): os arquivos são realmente disjuntos (abra o código: imports, tipos compartilhados, barrel/index, config, lockfile, migração) e nenhum bloco depende da saída de outro?

Veredito `Pronto para executar` só com zero decisões em aberto; senão, volta ao §3.

## §5 Executing

1. O agente principal lê o `PROJECT_CONTEXT.md` e a SPRINT alvo.
2. Executa **todas** as histórias da sprint, com TDD (§8), os princípios de desenvolvimento (§12) e as regras de produção (§13: corrigir na fonte, sem workaround, sem legado, dados preservados, nada contra produção).
3. Se a sprint declara blocos independentes (§15) e vale o custo, lança **workers em paralelo**; o resto fica no fio principal. Registra decisões e desvios em **ADR** (`templates/ADR.template.md`).
4. Marca tasks `[x]`, roda build/lint/testes, faz commit com testes verdes.
5. Salva o relatório do implementador em `reviews/REPORT_SPRINT_NN.md` (o que foi feito, testes N/N, commit, decisões).
6. O agente principal **spawna um agente** para rodar o AUDIT (§6), com o brief do §9.

## §6 Audit

Revisão de código **e** auditoria de segurança, por agente isolado, em **duas passadas separadas** dentro do mesmo agente:

**Passada 1 — Conformidade com a spec.** Critério por critério (Testes, Resultado esperado, DoD da sprint): atendido ou não, com evidência. Termina antes de olhar qualidade. Critério não atendido é Critical ou Important.

**Passada 2 — Qualidade e segurança.** Escopo **ancorado no diff** da sprint: o revisor abre arquivos vizinhos só para seguir os fluxos que o diff toca (entrada → sink), nunca para varrer o repositório.

- Encontrar bugs, regressões e desvios arquiteturais.
- Verificar qualidade, testes, tratamento de erros, simplicidade e aderência aos princípios do §12.
- Avaliar segurança seguindo o fluxo completo **source → sink** (entrada externa, validação/sanitização, ponto de uso perigoso). Com a flag de risco **superfície de segurança** (§13), aplicar também `security.md`.
- Se há wireframe, conferir o frontend implementado contra ele **na tela real rodando**.
- Apresentar achados com **evidência concreta** (`arquivo:linha`) e explorar alternativas de solução.

`Approved` exige as duas passadas limpas de Critical/Important.

Classificação:

| Nível | Significado | Ação |
|---|---|---|
| Critical | Bloqueia | Corrigir antes de seguir |
| Important | Deve ser corrigido | Corrigir antes do finish |
| Minor | Pode ser triado ou adiado | Usuário decide |

Ciclo: corrigir Critical/Important (com TDD) → novo head → novo revisor → repetir até `Approved`. Depois do `Approved`, vale o gate de §13 (sprint com flag para e espera o usuário; sem flag, segue).

## §7 Finishing

1. Todas as sprints com audit `Approved` e nenhum ADR pendente.
2. Rodar `scripts/ci-check.sh`: build, testes e lint de frontend e backend. Qualquer falha bloqueia.
3. Rodar `scripts/flow-report.sh` e mostrar o resumo das métricas (§10) junto do resumo da entrega, das sprints com flag, dos riscos aceitos e dos Minor acumulados (§13).
4. Confirmação do usuário.
5. Criar PR (nunca push para main) e atualizar a issue.

## §8 Test-Driven Development

1. **RED** — escrever o teste e confirmar que falha **pelo motivo correto**.
2. **GREEN** — implementar o mínimo necessário.
3. **REFACTOR** — melhorar a estrutura sem alterar o comportamento.

Racionalizações proibidas (combater sempre):
- "este caso é simples demais para testar"
- "vou testar depois"
- "o teste existente já cobre"
- "primeiro preciso criar a infraestrutura"
- "o teste não precisa falhar porque sei que a implementação está correta"

Exceção consciente (docs, config, refactor puro): `FLOW_SKIP_TDD=1`, dita ao usuário.

## §9 Requesting Code Review

Review completa ao finalizar **cada SPRINT**. O agente principal spawna um agente e delega o audit.

O revisor é isolado da **conversa**, mas **não** do repositório. Recebe um brief curto (`templates/REVIEW_BRIEF.template.md`) com ponteiros:

- caminho da iniciativa e da sprint
- `Base`/`Head` (commits da sprint)
- caminho do relatório do implementador

e lê por conta própria: `PROJECT_CONTEXT.md`, a sprint, os ADRs, `git diff Base..Head` e os arquivos tocados e vizinhos. Isso evita o handoff com perda: o que o revisor vê não depende de um resumo montado pelo implementador. O relatório do implementador é tratado como afirmações a verificar.

O revisor é **somente leitura**.

**Proibido pré-julgar achados.** Frases como "Não sinalize isso" ou "Isso não é um problema neste caso" não entram no prompt (o hook `no-prejudge` bloqueia).

Retorno obrigatório do revisor:
- Strengths
- Passada 1 — Conformidade: tabela critério × atendido/não atendido, com evidência
- Passada 2 — Issues: Critical, Important, Minor
- Task quality: `Approved` ou `Needs fixes`
- Referências no formato `arquivo:linha`

## §10 Evals do fluxo

O Flow mede a si mesmo. Detalhes, sinais e casos dourados em `evals/GOLDEN.md`.

1. **Registrar eventos** com `scripts/flow-metrics.sh <evento> chave=valor...` em `docs/Sprints/<slug>/metrics.jsonl`:
   - `dry-run`: `round`, `critical`, `important`, `minor`, `verdict`
   - `spawn`: um por agente lançado. `purpose` (dry-run, audit, explore, worker, wireframe, wireframe-check; worker com `result=CONCLUIDO` ou `BLOQUEADO`), `phase`, `sprint`, `brief` (caminho), `result`, `duration_s` (se souber)
   - `execute`: `sprint`, `stories`, `adrs`
   - `audit`: `sprint`, `round`, `critical`, `important`, `minor`, `spec_gaps` (critérios não atendidos na passada 1), `risk` (1 se a sprint tem flag, senão 0), `verdict`
   - `escape`: `sprint`, `where`, `note` (achado depois de `Approved`: CI, PR, produção)
   - `finish`: `ci`, `pr`
2. **Resumo** com `scripts/flow-report.sh` no `finish` (§7).
3. **Escape** vira caso dourado em `evals/GOLDEN.md`.
4. **Mudar o Flow**: uma coisa por vez, comparar casos dourados com e sem a mudança (mais de uma execução), registrar no histórico e reverter se piorar.

## §11 Verificação antes de concluir

Nenhuma afirmação de conclusão ("pronto", "passou", "corrigido", "sem regressão") sem **evidência fresca**: a saída de um comando rodado **depois** da última alteração.

1. Identifique o comando que prova a afirmação (teste, build, lint, `ci-check`, reprodução do bug).
2. Rode-o por completo, agora.
3. Leia a saída e o código de saída. Só então afirme, citando o resultado (ex.: "testes 42/42, build ok").
4. Se não rodou, diga que não rodou. Não use "deve funcionar", "provavelmente passa" nem "como antes".

Onde se aplica: fim de cada história e da sprint (§5), relatório do implementador, correção de achado do audit (§6), `finish` (§7) e qualquer resposta ao usuário que declare algo pronto.

Racionalizações proibidas:

| Pensamento | Resposta |
|---|---|
| "Mudança pequena, não precisa rodar" | Pequena também quebra. Rode. |
| "Rodei antes da última edição" | Evidência velha não vale. Rode de novo. |
| "O revisor vai pegar" | O revisor verifica, não substitui a sua verificação. |
| "O CI vai rodar mesmo" | CI vermelho depois do PR custa mais. Rode antes. |
| "Testes passam, então o critério está atendido" | Confira o critério da sprint, não só o verde. |

## §12 Princípios de desenvolvimento

Valem para todo código novo (execute, REFACTOR do TDD) e são conferidos no audit (passada 2). Em código existente que a sprint tocar: melhorar o que for alterado, nunca piorar.

**Clássicos**
- **KISS:** a solução mais simples que satisfaz os critérios de aceite vence.
- **YAGNI:** implemente só o que a sprint pede. O que não está num critério de aceite não existe. Sem abstração de uso único e sem "flexibilidade" não pedida.
- **DRY:** a lógica mora em um lugar. Extraia só a partir de **3 ocorrências concretas**.
- **Less code, best code:** menos código é menos bug. Remova o que a sprint permitir remover.
- **Cirúrgico:** toque só o necessário. Não "melhore" código adjacente. Código morto que notar: **mencione, não apague** sem permissão.

**Object Calisthenics (subconjunto adotado)**

| # | Regra | Escopo |
|---|---|---|
| 1 | Um nível de indentação por método | Todo código. Extraia a lógica interna ou use early return. |
| 2 | Sem `else` | Todo código. Early return e guard clause. |
| 3 | Envolver primitivos | Só na camada de domínio e só quando o valor tem **invariante** (CPF, e-mail, prazo, id com formato). `string` sem regra não vira objeto de valor. |
| 4 | Coleções em classes próprias | Só quando a coleção carrega regra própria (ordenação, unicidade, limite). |
| 6 | Sem abreviações | Todo código. Nome autoexplicativo dispensa comentário. |
| 7 | Entidades pequenas | Sinal para dividir, não lei: método acima de ~20 linhas ou classe acima de ~150 pedem justificativa ou extração. |
| 9 | Sem getters/setters (Tell, Don't Ask) | Só na camada de domínio. Não vale para DTO, adapter e mapeamento de ORM. |

Descartadas: *um ponto por linha* e *no máximo duas variáveis de instância* (brigam com builders, ORM fluente e injeção de dependência).

**Critério de correção.** Estar no `CLAUDE.md`, na sprint ou já no código não torna algo correto. O critério é o que resolve o problema **na fonte**, sem workaround e sem dívida técnica, no formato mais simples que o resolve por completo. Se o existente (ou a própria sprint) estiver errado, explique de forma curta qual formato recomenda e por quê, e **traga para o usuário**; não aplique sozinho (§0).

## §13 Risco e controle humano

Objetivo: fluidez no caminho comum, parada onde um erro custa caro em produção.

**Flags de risco.** O `plan` lista, em cada sprint, as que se aplicam (ou `nenhuma`):

| Flag | Quando |
|---|---|
| Lógica crítica | Cálculo, regra de domínio, pagamento |
| Superfície de segurança | Entrada externa (rota, form, upload, webhook), autenticação/autorização, persistência ou query, dados sensíveis, LLM/prompt |
| Migração de dado em produção | Muda schema, formato ou local de dado que já existe em produção |
| API pública ou contrato | Muda interface consumida por fora |
| Frontend novo | Tela ou componente novo |

O `dry-run` confere as flags. O `audit` não aceita sprint com superfície de segurança sem aplicar `security.md`.

**Controle por risco**

| | Sprint **sem** flag | Sprint **com** flag |
|---|---|---|
| Entre execute e audit | Segue sozinho | Segue sozinho |
| Critical/Important | O agente corrige (ciclo até `Approved`) | Idem |
| Depois de `Approved` | Segue para a próxima sprint | **Para.** O usuário lê o relatório do audit (inclusive Minor e o que foi corrigido) e aprova antes da próxima sprint |
| Minor | Acumulam e vão ao usuário no `finish` | Vão ao usuário no gate da sprint |

**Regras de produção (valem sempre)**

1. **Risco aceito é do usuário.** Só o usuário aceita Critical/Important sem correção, e fica registrado em ADR com o motivo.
2. **Nunca tocar produção.** O agente não executa migração, script ou comando contra ambiente de produção. Gera o plano e os comandos; o usuário executa.
3. **Dados preservados.** Mudança de schema, formato ou local de dado traz migração dos dados existentes e plano de reversão, aprovados no gate do `plan`. Perda ou descarte de dado nunca é implícito.
4. **Sem legado de código.** A implementação nova substitui a anterior. Sem código morto nem compatibilidade não pedida.
5. **Corrigir na fonte.** Sem workaround, sem `eslint-disable`/`type: ignore` silencioso. Supressão só com motivo escrito e aprovada pelo usuário.
6. **Hook que rejeita é sinal.** Nunca `--no-verify` nem trocar `core.hooksPath` (o hook `no-push-main` bloqueia). Corrija a causa; se o hook parecer errado, pare e fale com o usuário.
7. **Dependência nova** é decisão do usuário (§0).
8. **Testes por criticidade.** Lógica isolável: unitário. A história cruza camadas reais: integração sem mock no ponto validado. Fluxo crítico (autenticação, autorização, pagamento, dados sensíveis): e2e. Toda sprint termina com a suíte de regressão completa passando (§11).
9. **Documentação da lib.** Antes de usar API de biblioteca que você não conhece na versão do projeto, consulte a documentação oficial dessa versão. Não confie na memória.
10. **Frontend com wireframe.** O `execute` mantém o wireframe atualizado quando o frontend muda; o `audit` confere a tela real contra ele.

## §14 Observabilidade

O humano precisa enxergar o que aconteceu sem reler conversa nem relatórios de agente. Três peças, todas leves.

**1. Todo agente lançado é registrado.** Ao spawnar (dry-run, audit, explore, worker), registre `scripts/flow-metrics.sh spawn purpose=<...> phase=<...> sprint=NN brief=<caminho> result=<resumo curto>`. O `flow-report.sh` lista os agentes e o resultado de cada um.

**2. Bloco RESULTADO ao fim de cada fase.** O agente principal roda `scripts/flow-status.sh fase=<...> status=<aprovado|bloqueado|aguardando-decisao> escopo=... base=<sha> pendencias=... decisoes_tomadas=... riscos_aceitos=... agentes=... alterados=... proximo=...`, que anexa o bloco em `docs/Sprints/<slug>/STATUS.md`, e mostra o mesmo bloco ao usuário. Valores ausentes saem como `nenhum`.

**3. Relatório ao usuário em ordem fixa**, simples e objetivo:
1. Resultado atual
2. Histórias e critérios concluídos
3. Evidências (testes, lint, build) e o que significam (§11)
4. Decisões tomadas pelo agente (com motivo) e decisões submetidas ao usuário
5. Bloqueios, riscos e próximos passos
6. **Ação necessária do usuário**: diga explicitamente se há (ou "nenhuma")

**Painel da sprint** (nos gates do §13 e no `finish`): uma tabela por sprint com *feito* (histórias, testes N/N), *agentes* (quantos, para quê), *achados* (C/I/M na 1ª rodada → no `Approved`), *corrigido*, *riscos aceitos*, *depende de você*. Monte-o a partir do `flow-report.sh` e do `STATUS.md`, não de memória.

## §15 Execução paralela com workers

Para ganhar velocidade em sprint grande sem perder controle. Subagente de implementação só para **escopo fechado**, nunca para julgamento (alinhado ao artigo da Anthropic: dividir por contexto, trabalho paralelo e independente, resultado compacto).

**Quando usar** (todas as condições):
1. O `plan` declarou na sprint **dois ou mais blocos independentes** (seção Paralelização), com arquivos exclusivos de cada bloco e sem dependência de saída entre eles.
2. O `dry-run` confirmou a disjunção abrindo o código (imports, tipos compartilhados, barrel/index, config, lockfile, migração).
3. Cada bloco justifica o custo de um agente. Bloco trivial o fio principal faz sozinho.
4. A sprint **não** tem flag de migração de dado em produção no bloco paralelizado. Esse trabalho fica no fio principal.

**Como**
1. Árvore limpa antes de lançar (commit do que já existe).
2. Um worker por bloco, lançados **na mesma rodada** (paralelo), cada um com o `templates/WORKER_BRIEF.template.md`: bloco, lista exaustiva de arquivos permitidos, critérios, o que não pode fazer e o formato de retorno.
3. Worker faz TDD e roda **só os testes direcionados**. Não faz commit, não marca `[x]`, não decide design, não adiciona dependência, não toca produção.
4. Retorno fixo: `STATUS: CONCLUIDO | BLOQUEADO`, arquivos, testes (saída real), decisões locais, dúvidas.

**Escalonamento (o worker nunca decide)**
- `BLOQUEADO` com dúvida: o fio principal resolve se for local e reversível (§0) e registra; se não for, leva ao usuário com as opções.
- Resolvida a dúvida, lança um worker **novo** para o bloco, com a resposta no brief (tentativa 2). Após 2 tentativas, o fio principal faz o bloco sozinho.

**Integração (sempre no fio principal)**
1. Rode `scripts/worker-scope.sh <lista-de-todos-os-arquivos-permitidos>`. Arquivo fora do escopo = rejeitar o resultado e investigar.
2. Leia o diff de cada worker **na íntegra**. Não reaja ao resumo.
3. Rode a suíte completa, build e lint (§11) e confirme os números por conta própria; o teste do worker não vale como prova.
4. Marque `[x]`, registre ADR, faça o commit e escreva o relatório do implementador. Isso nunca sai do fio principal.
5. Registre cada worker (`flow-metrics.sh spawn purpose=worker ... result=CONCLUIDO|BLOQUEADO`).

**Medir.** Compare, com e sem workers, a duração da sprint, as rodadas de audit e os escapes (`evals/GOLDEN.md`). Taxa alta de `BLOQUEADO` ou de rejeição por escopo = o plano está declarando blocos que não são independentes.

## §16 Wireframe

Para avaliar uma decisão de frontend **antes** de escrever as sprints. Só quando o brainstorm marcou que a iniciativa toca frontend de forma relevante (§1, §3). O wireframe existe para avaliar uma decisão, e só vale se for **fiel ao produto**: o que você vê é o que o frontend vai renderizar. Fidelidade acima de beleza.

**Quem faz o quê.** A parte que exige julgamento e conversa fica com o fio principal e com você. A parte de produzir o HTML, que é escopo fechado e de saída grande, vai a agentes.

1. **Travar o que desenhar** (fio principal + usuário). Qual tela, qual fluxo, qual persona, quais estados (vazio, preenchido, carregando, erro, permissão negada, modal de confirmação). Recorte ambíguo: pare e pergunte.
2. **Localizar e ler** (fio principal). Localize telas vizinhas e componentes candidatos (`Explore` só para caminhos, se a busca for ampla). **Todo componente que entra no wireframe é aberto e lido na íntegra pelo fio principal** (DOM, classes, variantes, tokens). Leia o `CLAUDE.md` e os docs de design system do repositório, se existirem, e a documentação oficial da versão da lib de UI quando precisar.
3. **Inventário de fidelidade** (fio principal + usuário). Tabela: região | componente real | `caminho:linha` | variante/tamanho | status (existe / **NOVO**). Salve em `reviews/WIREFRAME_INVENTORY.md`. **Todo NOVO e todo desvio entre código e design system param aqui**: opções com vantagens e desvantagens, recomendação, e espera a sua escolha (§0). Não invente componente; não desenhe como existente o que não existe.
4. **Gerar o HTML** (agente, `templates/WIREFRAME_BRIEF.template.md`). Só depois do inventário aprovado. O agente escreve apenas `docs/Sprints/<slug>/WIREFRAME_<TEMA>.html`, reproduz o que cada componente real emite, mapeia tokens reais, desenha um bloco navegável por estado, anotações numeradas ligadas ao requisito, regiões NOVO marcadas, dados plausíveis sem PII. Não altera código de produto, não decide, devolve `CONCLUIDO` ou `BLOQUEADO`.
5. **Conferir** (agente novo, `templates/WIREFRAME_CHECK_BRIEF.template.md`). Somente leitura: compara cada região do HTML com o componente real e o inventário. Veredito `Fiel` ou `Corrigir`. `Corrigir`: novo agente de geração em modo atualizar, no máximo 2 ciclos; depois o fio principal conclui ou leva a você.
6. **Publicar** (fio principal). Publique o HTML como artifact, privado por padrão, se houver ferramenta de artifact. A URL é entregável: vai para a seção Wireframe do `PROJECT_CONTEXT.md`, junto do caminho do `.html`. Ajuste posterior: edite o HTML versionado e republique **na mesma URL**, nunca um artifact novo.
7. **Gate.** Apresente o link, os estados, o inventário final (reais × NOVO), os desvios e as decisões pendentes. Só avance para o resto do `plan` com o wireframe aprovado. Cada NOVO vira task nas sprints.

**Depois do plano.** O `execute` implementa o frontend com base no wireframe e o **mantém atualizado** quando o frontend muda (fio principal edita o HTML e republica na mesma URL, sem recomeçar). O `audit` confere o frontend implementado contra ele, na tela real.

**Regras.** Wireframe não altera código de produto. Não é a spec: critérios de aceite nascem nas sprints. Divergência futura entre wireframe e sprint se resolve pelo usuário, não em silêncio. Sem dado real nos exemplos. Registre cada agente (`flow-metrics.sh spawn purpose=wireframe` ou `wireframe-check`).
