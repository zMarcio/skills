---
name: qa-regressao
description: Mapear e mostrar os itens de regressão de um card — telas, rotas, tabelas e componentes afetados pelo diff e seus consumidores, cruzados com a cobertura existente (suíte Playwright, collections, docs de tela, TCs antigos, bugs anteriores) —, mapear a cobertura de um módulo inteiro na construção do zero e, depois da confirmação, executar os casos de Camada Regressão comparando com baseline e separando falha nova de preexistente.
---

# Regressão — itens de regressão

Três fases:

- **mapa** (`/qa-card`, antes das perguntas): a partir de `contexto-unificado.md`,
  montar `.qa/<CARD_ID>/regressao.md` — os itens que podem ter quebrado, com a
  cobertura que já existe e as lacunas. O questionador usa o mapa e o usuário
  decide o escopo.
- **cobertura** (`/qa-modulo`, construção do zero): montar
  `.qa/mod-<modulo>/cobertura.md` — telas, rotas e tabelas do módulo com a
  cobertura existente por camada. É o contexto do questionador e dos executores.
- **execução** (rodada B): rodar os casos `Camada = Regressão` confirmados.

Somente leitura no código do produto e na suíte: não cria nem edita teste.
Lacuna de cobertura vira sugestão de caso novo para o questionador.

## 1. Levantar itens

Do `contexto-unificado.md` (seções Impacto, Além do card e Foco por agente) e
do `diff.md` (arquivos e consumidores):

- Consumidores no estado atual do código: `git -C <repo> grep -n "<rota|função|tabela|componente>" <para>`.
- Componente compartilhado (tabela, modal, picker, auth, layout, socket) → regressão ampla.
- Migration/tabela → todos os módulos que leem a tabela, relatórios e dashboards.
- Permissão/auth → smoke de todos os papéis.
- Dependência com versão nova → smoke dos fluxos que a usam.

## 2. Cruzar com a cobertura existente

```bash
rg -l "<tela|rota|seletor>" ~/fluctus_automatizado/tests                 # specs
npx playwright test --list --grep "<modulo|tela>"                          # testes por nome
rg -l "<tela>" ~/fluctus_automatizado/docs/testes/*/tela-*.md               # sequência da tela
rg -l "<rota>" ~/postman-collections ~/bruno-fluctus                       # collections
rg -l "<tela|rota>" ~/test_cases                                           # TCs antigos
gh issue list -R <org>/<repo> --search "<módulo>" --state all --limit 20   # bugs anteriores
```

Bug já corrigido no mesmo ponto é item de prioridade Alta (regressão clássica).
Playwright `--only-changed=<ref>` só ajuda quando a suíte está no mesmo repo do
código alterado; na suíte separada, vale o cruzamento acima.

## 3. Priorizar

- **Alta**: fluxo essencial tocado direto; bug já corrigido no mesmo ponto; dado,
  permissão ou integração externa.
- **Média**: consumidor indireto; componente compartilhado.
- **Baixa**: cosmético; área só lida pelo código alterado.

## 4. Mapa (saída da fase mapa)

`.qa/<CARD_ID>/regressao.md` (dono único):

```markdown
# Itens de regressão — <CARD_ID>
- Base: contexto-unificado.md · Intervalo: <de>..<para>
- Resumo: <n> itens (Alta <a> · Média <b> · Baixa <c>) · sem cobertura <d>

## Itens
- R1 · Alta · Tela Cadastros > Filas — motivo: `queue.service.js` mudou o filtro de perfis (D1)
  - Cobertura: tests/cadastros/filas.spec.js (6 testes) · tela-cadastros-filas.md passos 3–5
  - Lacuna: edição de fila com perfil god sem teste
  - Comando: `npx playwright test tests/cadastros/filas.spec.js --project=chromium`
- R2 · Média · `GET /api/queues` — consumidor: Dashboard de filas
  - Cobertura: collection Postman "Filas" (4 requests) · Lacuna: nenhuma

## Sem cobertura (sugestão de caso para o questionador)
- R1 — editar fila com perfil god mantém os usuários vinculados
```

Retorno ao orquestrador: itens por prioridade, quantos sem cobertura e o caminho —
o orquestrador mostra o mapa ao usuário antes das rodadas de perguntas.

## 5. Cobertura do módulo (construção do zero)

Fontes do módulo: seção do módulo no `AI_CONTEXT.md` (mapa de features), rotas do
`~/swagger-openapi.yaml` (por tag/prefixo), `docs/testes/*/tela-*.md`, pastas de
`tests/` e `tests/api/`, collections e `~/test_cases`. Sem acesso ao código do
produto, o mapa vem só dessas fontes — dizer isso no topo.

`.qa/mod-<modulo>/cobertura.md` (dono único):

```markdown
# Cobertura — módulo <nome>
- Fontes: AI_CONTEXT §<n> · swagger (<n> rotas) · docs de tela · suíte · collections

## Telas (na ordem de uso)
- T1 · <tela> — rota `<url>` — papéis: …
  - UI: tests/<…>.spec.js (<n> testes) | sem cobertura
  - API: tests/api/<…> | collection "<pasta>" | sem cobertura
  - Perf: <script> | não se aplica
## Rotas sem tela
- `<MÉTODO> <rota>` — cobertura: …
## Tabelas e integrações
- <tabela/integração> — quem lê/escreve
## Lacunas
- T1 — criação sem teste de UI; T2 — sem regressão de API
```

## 6. Execução (rodada B)

Casos `Camada = Regressão` da especificação confirmada (cada caso cita os `R*`).
Usuários alocados em `frentes.md` — a suíte usa os mesmos usuários do test-executor,
por isso esta fase roda depois dele.

```bash
cd ~/fluctus_automatizado
npx playwright test <specs dos itens> --project=chromium \
  --output .qa/<CARD_ID>/regressao/test-results --reporter=list,html
newman run <collection> -e <env> --folder "<pasta>" -r cli,htmlextra \
  --reporter-htmlextra-export .qa/<CARD_ID>/regressao/<pasta>.html
```

Baseline, em ordem: último relatório do CI ou execução salva; resultado do mesmo
teste na versão anterior (se houver ambiente dela); histórico do spec (`git log -p`).

- falhou antes e depois → **preexistente** (não é do card)
- passou antes, falha agora → **regressão** → escritor
- sem baseline → **falha atual sem baseline** → escritor, marcada assim
- instável → repetir 3x; só vira falha se reproduzir

## 7. Resultado

`.qa/<CARD_ID>/resultado-regressao.md`:

```markdown
# Resultado — regressao
- Intervalo: <de>..<para> · Baseline: <fonte ou "nenhuma"> · Usuários: <papéis>
## Execução
- Total · PASS · FAIL · BLOCKED
- TC-5316-010 (R1) — PASS — `<comando>`
- TC-5316-011 (R2) — FAIL · regressão · BUG_APLICACAO — <teste> — evidência: <caminho>
## Itens não executados
- R3 — <motivo>
## Falhas para o escritor
- F-R1 · TC-5316-011 · BUG_APLICACAO · regressão — <o que quebrou> — commit suspeito: <sha> <arquivo>
## Handoff de documentação
- Itens, suítes e comandos rodados, baseline usada, lacunas que ficaram
## Conclusão
```
