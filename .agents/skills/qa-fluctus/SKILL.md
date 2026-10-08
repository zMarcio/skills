---
name: qa-fluctus
description: Contrato comum dos agentes de QA no Fluctus — fontes de verdade e caminhos, camadas de teste e agente responsável, particularidades medidas do backend (login 202, token cru, 406/401/403), usuários de teste e limite de sessão, alocação de usuários entre frentes paralelas, status e classificação de falhas.
---

# Contrato de QA do Fluctus

Vale para todos os agentes do `/qa-card`. Em conflito, este arquivo cede só ao
requisito explícito do card e à decisão registrada do usuário.

## Fontes de verdade (ler antes de escrever qualquer teste)

| O quê | Onde |
|---|---|
| Contexto do card | `.qa/<CARD_ID>/contexto-unificado.md` (leitor + verificador) — todo executor lê junto com a especificação TC |
| Suíte Playwright (UI e API) | `~/fluctus_automatizado` (Playwright Test, CommonJS, sem BDD) |
| Mapa vivo do projeto | `~/fluctus_automatizado/docs/AI_CONTEXT.md` (§4.6: fatos do backend medidos ao vivo) |
| Especificações de TC | `~/test_cases/TC_<numero>_<slug>.md` (também `TC_*` e `test_case-*` antigos) |
| Dados de teste | `~/test_cases/test_users.md` — fonte única |
| Credenciais | `.env` de `~/fluctus_automatizado` — nunca imprimir nem copiar |
| Contrato de rotas | `~/swagger-openapi.yaml`, `~/swagger-hsm-openapi.json` |
| Webhook / injeção de mensagens | `~/fluctus_automatizado/docs/webhook-payloads.md` |
| Collections | Postman `~/postman-collections/` (README Newman), `~/fluctus-api-collection.json`; Bruno `~/bruno-fluctus/` |
| Carga | `~/k6-fluctus` (`README.md`, `breaking-point/README.md`, `config.js`, `helpers.js`) |
| Evidências | `~/fluctus_automatizado/evidencias/<tipo>/<numero-ou-modulo>/<data>/` |
| Documentação de testes | `~/fluctus_automatizado/docs/testes/<agente>/` (skill `qa-documentador-sdd`) |

Use o `AI_CONTEXT.md` como mapa em vez de varrer a árvore; inspecione o código
só para confirmar um ponto que ele não cobre. Executores **não** editam o
`AI_CONTEXT.md`: propõem a mudança no handoff e o documentador aplica.

## Camada → agente

| Camada (na especificação TC) | Agente | Ferramenta |
|---|---|---|
| `UI` | test-executor | Playwright browser |
| `API` | test-executor | Playwright `tests/api/` (regressão versionada) |
| `API-collection` | test-executor | Bruno/Postman/Newman (collections, contrato, smoke, exploração) |
| `Perf` | performance | k6 |
| `Regressão` | regressao | suítes e collections existentes dos itens `R*` do mapa de regressão |

Na dúvida entre `API` e `API-collection`, `API` (vira regressão no repo).
Auditoria de segurança não é camada de TC: é a frente `cibersecurity`.

## Particularidades do backend (medidas — não presumir o contrário)

- `POST /auth/v1/login` responde **202**, não 200.
- Token no header `Authorization: <token>` **cru** (com `Bearer ` → 406) ou
  `x-access-token: <token>`.
- Chave de API (`fl:ey…`, seção "Tokens" do `test_users.md`) vai em
  `fluctus-api-key: <chave>`, não em `Authorization` (lá dá 406). Prefira a chave
  ao login quando o caso permitir.
- 406 = token ausente/derrubado · 401 = tipo de usuário sem acesso ·
  403 `No CRM license seat` = licença de CRM (mecanismo separado do nível).
  Matriz de permissão é **papel → status**, nunca "permitido/negado".
- Rota inexistente pode responder HTML: testar o status antes do parse.
- Webhook (`:4000/channel/<id>`) responde 200 antes de processar: validar o
  efeito por API (polling), não pelo status do webhook.
- `ReportManagerNew` é global por usuário: relatórios do mesmo usuário nunca em paralelo.

## Usuários e sessão — o que limita o paralelismo

`limit_of_sessions = 1` + `kill_older` para quase todos: **cada login derruba a
sessão anterior do mesmo usuário**. Worktree não isola isso.

- Livres: **ADMIN/ENDRIO**, **SUPERVISOR/JOSE**.
- **GOD/ANTONIO**: usado pelo `canalGate` da suíte Playwright; CRM exige god.
- **STANDARD/JAMES/JESSE**: só sem suíte Playwright rodando.
- Um login por execução (setup/pre-request), nunca por teste ou request.

Regra de alocação (o orquestrador registra em `.qa/<CARD_ID>/frentes.md`):
**duas frentes nunca usam o mesmo usuário ao mesmo tempo.** Conflito → as frentes
rodam em rodadas diferentes. Padrão:

- test-executor → usuários exigidos pelos casos de UI (inclui GOD/ANTONIO pela
  suíte); casos de API e collections com chave de API (sem ela, SUPERVISOR/JOSE).
  Dividido em duas instâncias (`executor-ui` ∥ `executor-api`), cada uma fica com
  o seu grupo de usuários — nunca o mesmo nas duas.
- regressao → suíte de regressão (mesmos usuários da suíte) → **depois** do test-executor.
- performance → ADMIN/ENDRIO, smoke; nunca junto de suíte Playwright com o mesmo usuário.
- cibersecurity → não loga em homologação (réplica isolada).

## Critérios: CA e CC

Card do GitHub normalmente **não traz critério de aceite**. Por isso:

- `CA*` — critério de aceite escrito no card ou decidido em comentário (quando existe);
- `CC*` — critério combinado: proposto pelo questionador na rodada 1 a partir do
  comportamento pedido, das regras, dos anexos e do diff, e confirmado pelo usuário
  (fica em `decisoes.md`).

Rastreabilidade, revisão, relatório e documentação usam `CA*` ou `CC*` — o que o
card tiver. Ausência de CA não é bloqueio; ausência de critério combinado é.

## Status e classificação

Status por TC: **PASS**, **FAIL**, **BLOCKED** (e `NÃO EXECUTADO` com motivo).
Falha confirmada = reproduziu 2x. Classificar toda falha:

- `BUG_APLICACAO` — comportamento diverge do requisito (único que vira card direto)
- `BUG_TESTE` — erro no teste
- `DADO_INVALIDO` — massa errada/ausente
- `AMBIENTE` — serviço fora, lentidão, rede
- `DEPENDENCIA` — serviço/integração externa
- `REQUISITO_AMBIGUO` — card não define o esperado
- `DIVERGENCIA_CONTRATO` — resposta real ≠ swagger (vira card se o swagger for o requisito)
- `LIMITE_GERADOR` — gargalo do gerador de carga (WSL, TLS, CPU local), não da aplicação

Antes de chamar de `BUG_APLICACAO` uma falha de API, reproduzir com `curl` isolado.

## Regras invioláveis

- A especificação TC é o contrato. Inconsistência com o card: vale o requisito
  explícito do card; registrar a inconsistência e a decisão; nunca descartar um
  caso em silêncio. Não inventar requisito.
- Teste só passa se o comportamento bate com o requisito — ausência de erro não basta.
- Nunca afrouxar assert, aumentar timeout ou pular teste para passar.
- Não alterar config global nem a aplicação para o teste passar.
- Dados criados levam o prefixo da frente (`$QA_PREFIXO` / `QA-xxxx` / `RUN_TAG`)
  e têm limpeza correspondente.
- Não criar card/issue no GitHub: propor título/corpo (o escritor formata).
