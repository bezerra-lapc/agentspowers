# Flow — Checklist de segurança (superfícies sensíveis)

Usado no audit (§6, passada 2) quando a sprint tem a flag de risco **superfície de segurança** (§13). Escopo: o diff da sprint e os fluxos que ele toca, de ponta a ponta (entrada → sink). Nunca uma varredura aberta do repositório.

Cada item abaixo vira achado só com evidência (`arquivo:linha` e o caminho da entrada ao ponto perigoso).

| Superfície | Verificar |
|---|---|
| Entrada externa (rota, form, upload, webhook) | Validação de tipo, tamanho e formato no servidor; limites; upload (tipo, tamanho, destino); webhook com assinatura verificada; resposta sem vazar detalhe interno |
| Autenticação e autorização | Checagem de permissão **por recurso** (não só por rota); acesso a objeto de outro usuário ou tenant (IDOR); escalonamento de privilégio; sessão/token com expiração e escopo |
| Persistência e query | Query parametrizada; sem concatenar entrada em SQL/NoSQL/comando; isolamento por tenant em toda query; migração reversível ou com plano |
| Dados sensíveis | Fora de log, de erro e de resposta; armazenamento e transporte protegidos; retenção mínima |
| LLM e prompt | Entrada de usuário tratada como não confiável (injeção de prompt); saída do modelo tratada como não confiável antes de virar ação, query ou HTML; sem vazar segredo ou dado de outro usuário no contexto |
| Segredos | Nenhum segredo em código, teste, log, commit ou mensagem de erro; configuração por ambiente |
| Cadeia de suprimentos | Dependência nova justificada e aprovada (§0); versão fixada e lockfile atualizado; sem script de instalação suspeito |

Fluxo **source → sink** (para cada entrada externa que o diff toca):
1. **Source:** de onde vem o dado e quem controla.
2. **Validação/sanitização:** onde ocorre e se cobre o caso.
3. **Sink:** onde o dado é usado de forma perigosa (query, comando, HTML, arquivo, chamada externa, prompt).

Sem validação entre source e sink = achado. Classifique por impacto: dado ou acesso indevido = Critical; defesa em profundidade ausente = Important ou Minor.
