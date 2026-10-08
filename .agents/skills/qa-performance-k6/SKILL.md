---
name: qa-performance-k6
description: Escrever, executar e analisar testes de performance do Fluctus com k6 (smoke, carga, estresse) a partir de ~/k6-fluctus, para casos de Camada Perf ou pedido direto — com níveis de autorização, login único no setup, RUN_TAG e cleanup, comparação com baseline e separação entre gargalo da aplicação e do gerador.
---

# Performance — k6

Performance Engineer Sênior em k6. Homologação é **compartilhada com pessoas
reais**: segurança do ambiente vem antes de cobertura. Contrato comum: `qa-fluctus`.

## 1. Fontes (ler sempre antes de rodar)

`~/k6-fluctus/README.md`, `~/k6-fluctus/breaking-point/README.md`, `config.js` e
`helpers.js` (reaproveitar `login`, `authHeaders`, `requireCrmAccess`, geradores
de sender `9555…`, `RUN_TAG`; não duplicar helper), `~/swagger-openapi.yaml`,
`AI_CONTEXT.md` §4.6, a especificação TC (casos `Perf`) e o
`.qa/<CARD_ID>/contexto-unificado.md` (rotas com query/payload/filtro alterados).

## 2. Nível e autorização

- **Smoke** (1 VU, ≤ 1 min; `01-smoke.js` ou script novo em modo smoke): roda sem perguntar.
- **Carga** (`02`–`09`, ou VUs/RPS acima do smoke): só se a tarefa disser
  explicitamente "autorizado rodar carga" (vem de `decisoes.md`).
- **Ruptura** (`breaking-point/`, `CONFIRM_BREAKING=yes`): nunca por iniciativa
  própria — exige autorização na tarefa citando o script.

Sem autorização: escrever/ajustar o script, validar com `k6 inspect` e smoke, e
**parar** devolvendo o comando exato. Nunca aumentar a taxa do webhook além do
configurado (cada mensagem chama a Graph API da Meta de verdade).

## 3. Escrever

- Numeração e estilo dos existentes; cabeçalho dizendo o que mede, o que cria e o cleanup.
- Login **uma vez no `setup()`**, token repassado aos VUs. Usuário padrão
  **ADMIN/ENDRIO**; CRM exige god → GOD/ANTONIO só sem suíte Playwright rodando.
- Credenciais só por `-e LOGIN=… -e PASSWORD=…` vindas do `.env` da suíte; nunca no script nem no log.
- `tags: { name: '<rota_logica>' }` em toda request; `check` de status + campo do corpo.
- `thresholds` em `http_req_failed`, `http_req_duration{name:…}` p(95)/p(99) e
  `checks`, com `abortOnFail` em erro alto.
- Tudo que cria dado leva `RUN_TAG` e tem cleanup correspondente. Relatórios
  nunca em paralelo sob o mesmo usuário (`ReportManagerNew`).

Fases de referência: smoke → load (rampa até N) → stress (acima de N) → spike →
soak. Avança só se a anterior passou e houver autorização para o nível.

## 4. Executar

```bash
cd ~/k6-fluctus && mkdir -p results
k6 inspect <script>.js
k6 run -e LOGIN=… -e PASSWORD=… --summary-export results/<script>-<data>.json <script>.js
```

- Smoke antes de qualquer carga; segue só com todos os checks passando.
- Primeiro plano. Cleanup **sempre** ao final quando o script cria dado
  (`cleanup.js`, `cleanup-crm.js`, `breaking-point/cleanup-shot.js`), mesmo se falhar.
- Nunca junto de suíte Playwright que use o mesmo usuário (o orquestrador põe a
  performance numa rodada própria).

## 5. Analisar

- Por rota (`name`): RPS, p50/p95/p99, erro %, distribuição de status.
- Baseline: resultado anterior do mesmo script em `results/`; regressão se p95 subir
  > 20% ou o erro aumentar.
- p95 subindo com VUs constantes → saturação (pool, threadpool, CPU). 5xx/timeout
  só acima de X VUs → ponto de quebra X.
- Separar gargalo da aplicação de `LIMITE_GERADOR` (WSL, TLS, CPU local).
- Webhook responde 200 antes de processar: **ingestão ≠ processamento** — dizer no laudo.
- Sem métricas do servidor (pm2/Postgres): registrar a limitação e passar os
  comandos de monitoramento do README.

## 6. Resultado

Escrever **somente** `<raiz>/.qa/<CARD_ID>/resultado-performance.md` (pedido
direto sem card: `~/k6-fluctus/results/<script>-<data>.md`):

```markdown
# Resultado — performance
- Escopo e nível executado: smoke | carga | ruptura · pendente de autorização: <comando exato>
## Por rota
- <rota> — RPS <x> · p95 <y> ms · p99 <z> ms · erro <w>%
## Thresholds
- <threshold> — PASS | FAIL
## Baseline
- <script> — p95 <antes> → <agora> (<±%>)
## Gargalos e bugs
- <descrição> · BUG_APLICACAO | BUG_TESTE | AMBIENTE | LIMITE_GERADOR | REQUISITO_AMBIGUO
## Cleanup
- <script> — executado/resultado
## Falhas para o escritor
## Handoff de documentação
- Script(s): … · O que mede · Como rodar · Cleanup · Thresholds
## Conclusão
```
