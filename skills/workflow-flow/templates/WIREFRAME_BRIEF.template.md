WIREFRAME BRIEF

Iniciativa: docs/Sprints/{{SLUG}}/
Modo: {{MODE}}   (novo | atualizar)
Tentativa: {{ATTEMPT}}
Arquivo de saída (único arquivo que você pode criar ou alterar): docs/Sprints/{{SLUG}}/WIREFRAME_{{TEMA}}.html

Inventário de fidelidade APROVADO pelo usuário (fonte de verdade do que desenhar):
docs/Sprints/{{SLUG}}/reviews/WIREFRAME_INVENTORY.md

Estados a desenhar, um bloco navegável por estado:
{{STATES}}

Requisito do objetivo que cada região atende (para as anotações numeradas):
{{REQUIREMENTS}}

Mudanças pedidas (só no modo atualizar):
{{CHANGES}}

Resposta a dúvida anterior (se houver):
{{ANSWER}}

Como trabalhar (você tem acesso ao repositório, não à conversa):
1. Leia o inventário aprovado e, na íntegra, cada componente real nele citado (DOM, classes, variantes, tamanhos, tokens, ícones). Reproduza o que o componente emite. Nunca "no estilo de".
2. Tokens: leia os valores reais no código do frontend e mapeie para as variáveis do :root do HTML. Não invente valores. Se o frontend tem tema claro e escuro, o HTML funciona nos dois.
3. Se existir uma skill de design de artifact, carregue-a e siga o contrato de página dela.
4. HTML único, JS inline simples, sem framework e sem dependência que o componente real não use. Interatividade mínima que ajude a avaliar (abas, modal, expandir seção).
5. Anotações numeradas discretas ligando cada região ao requisito, com legenda mostrando o componente real e o caminho:linha.
6. Região NOVO (não existe no frontend): borda tracejada + selo próprio + legenda do que falta. Nunca desenhe como existente o que não existe.
7. Texto real do produto no idioma dele, com dados de exemplo plausíveis do domínio. Sem Lorem ipsum, sem Item 1/Item 2, sem PII, sem nome de cliente, sem dado de produção.
8. Acessibilidade básica preservada (papéis, foco visível, contraste).
9. Modo atualizar: edite o HTML existente só no que mudou. Não recomece.

Você NÃO pode:
- alterar código de produto nem qualquer arquivo além do HTML de saída;
- decidir componente, variante, região NOVO ou desvio entre código e design system (se o inventário não cobre algo, devolva BLOQUEADO);
- publicar artifact, fazer commit ou push.

Retorno obrigatório (formato fixo):
STATUS: CONCLUIDO | BLOQUEADO
CAMINHO: caminho do HTML
ESTADOS: lista dos estados desenhados
COMPONENTES: reais (com caminho:linha) e NOVO
NAO_REPRODUZIDO: o que não conseguiu reproduzir fiel (componente com dado ao vivo, editor rico, canvas) e por quê, ou "nada"
DUVIDAS: (se BLOQUEADO) pergunta, opções com vantagens e desvantagens, sua recomendação
