WORKER BRIEF

Iniciativa: docs/Sprints/{{SLUG}}/
Sprint: docs/Sprints/{{SLUG}}/{{SPRINT_FILE}}
Bloco: {{BLOCK}}
Tentativa: {{ATTEMPT}}

Escopo fechado. Você implementa SOMENTE este bloco:
{{BLOCK_DESCRIPTION}}

Arquivos que você pode criar ou alterar (lista exaustiva, exclusiva do seu bloco):
{{ALLOWED_FILES}}

Critérios de aceite do bloco:
{{CRITERIA}}

Resposta a dúvida anterior (se houver):
{{ANSWER}}

Como trabalhar (você tem acesso ao repositório, não à conversa):
1. Leia `PROJECT_CONTEXT.md`, a sprint e o código real que o bloco toca.
2. TDD (~/.claude/skills/flow-tdd/SKILL.md): RED, GREEN, REFACTOR, para cada critério. Rode só os testes direcionados ao seu bloco.
3. Siga os princípios do Flow (~/.claude/skills/workflow-flow/methodology.md §12) e as regras de produção (§13).
4. Mostre a saída real dos comandos que rodou. Nada de "deve passar" (§11).

Você NÃO pode:
- alterar arquivo fora da lista acima (se precisar, devolva BLOQUEADO);
- fazer commit, push ou marcar `[x]` na sprint;
- decidir design, contrato, escopo, dado ou segurança;
- adicionar dependência;
- tocar produção (migração, script, comando contra ambiente real).

Diante de qualquer bifurcação que não seja local e reversível, PARE e devolva BLOQUEADO com a pergunta e as opções (vantagens e desvantagens). Não escolha em silêncio.

Retorno obrigatório (formato fixo):
STATUS: CONCLUIDO | BLOQUEADO
ARQUIVOS: lista dos arquivos alterados
TESTES: comandos rodados e a linha final real da saída de cada um
DECISOES_LOCAIS: o que decidiu (local e reversível) e por quê, ou "nenhuma"
DUVIDAS: (se BLOQUEADO) pergunta, opções com vantagens e desvantagens, sua recomendação
