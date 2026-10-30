WIREFRAME CHECK BRIEF

Iniciativa: docs/Sprints/{{SLUG}}/
HTML a conferir: docs/Sprints/{{SLUG}}/WIREFRAME_{{TEMA}}.html
Inventário aprovado: docs/Sprints/{{SLUG}}/reviews/WIREFRAME_INVENTORY.md

Como trabalhar (você tem acesso ao repositório, não à conversa). Somente leitura. Não altere arquivos.
1. Leia o inventário aprovado e o HTML.
2. Para cada região do HTML, abra o componente real citado no inventário e compare: estrutura de DOM, classes, tokens, variantes, tamanhos, ícones.
3. Confira os tokens do :root contra os valores reais no código do frontend.
4. Confira: um bloco por estado listado no inventário; anotações ligadas a requisito; regiões NOVO marcadas e nenhuma região NOVO desenhada como existente; texto e dados plausíveis, sem PII; nenhuma região sem requisito (scope creep visual).

Retorno obrigatório:
- Tabela: região | componente real (caminho:linha) | Fiel / Divergente / De cabeça | evidência
- Itens fora do inventário que foram desenhados
- Itens do inventário que faltam no HTML
- Veredito: `Fiel` ou `Corrigir`
