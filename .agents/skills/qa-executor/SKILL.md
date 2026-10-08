---
name: qa-executor
description: Implementar, executar e analisar os casos de Camada UI, API e API-collection de uma especificação TC confirmada e revisada — Playwright para interface e regressão de API (tests/api), Bruno/Postman/Newman para collections e contratos — no worktree da frente executor, com pré-checagem, autorizações, limpeza dos dados de teste, PASS/FAIL/BLOCKED, classificação de falhas e handoff de documentação.
---

# Executor — UI, API e collections

Desenvolvedor Sênior e QA Automation Sênior (Playwright, API REST, Postman/Bruno).
Contrato comum: skill `qa-fluctus` (fontes, particularidades do backend,
usuários e sessão, classificação).

Entrada:

- especificação TC **confirmada** e com revisão `APROVADA` ou
  `APROVADA COM RESSALVAS` (`.qa/<ID>/revisao-spec.md`);
- contexto: `contexto-unificado.md` (com card) ou `cobertura.md` (construção do zero);
- IDs das camadas `UI`, `API` e `API-collection`;
- worktree `qa/<ID>/executor` — ou `executor-ui`/`executor-api` quando o
  orquestrador dividir em duas instâncias;
- usuário(s) alocado(s) em `.qa/<ID>/frentes.md`.

## 0. Pré-checagem

```bash
cd <worktree> && pwd && git branch --show-current     # qa/<ID>/executor[-ui|-api]
set -a; . ./.qa-frente.env; set +a                    # prefixo, saída, base
grep -q "confirmado em" <especificacao-TC> || echo "NÃO confirmada — parar"
grep -Eq "^Veredito: APROVADA" <raiz>/.qa/<ID>/revisao-spec.md || echo "revisão não aprovou — parar"
```

Ler na especificação: `INSTRUÇÕES PARA O TEST-EXECUTOR`, `Pré-requisitos e
pré-checagem`, `Autorizações` e `Limpeza de dados`. Ler também o contexto,
`test_users.md`, `docs/AI_CONTEXT.md` (mapa vivo — use em vez de varrer a árvore),
`~/swagger-openapi.yaml` e as collections existentes. Reaproveitar fixtures,
helpers, Page Objects e requests; não duplicar estrutura. Inspecionar código só
para confirmar um ponto que o mapa não cobre.

## 1. UI — Playwright (Camada `UI`)

- Arquivo `tests/<modulo>/<funcionalidade>.spec.js`; estender se já existir.
- Título começa pelo ID: `test('TC-5316-003 — exibe estado vazio …')`.
- Seletores: `getByRole` → `getByLabel` → `getByText` → `getByTestId`. Nada de
  classe gerada (`css-xyz`) ou XPath estrutural.
- Esperas: asserção web-first e `waitForResponse`; nunca `waitForTimeout`.
- Login pelo projeto `setup`/`storageState` existente; estado da frente em `$QA_SAIDA/.auth/`.
- Testes independentes e sem ordem; dados criados via API em fixture com
  `process.env.QA_PREFIXO`.

Cobertura de UX, conforme o caso pedir:

- **Estados**: carregando, vazio, erro, sucesso, desabilitado — visíveis e com texto útil.
- **Responsivo**: 375×812 e 1440×900; sem scroll horizontal
  (`document.documentElement.scrollWidth <= innerWidth`).
- **Tema**: `test.use({ colorScheme: 'dark' })` quando há dark mode; tooltip e legenda legíveis.
- **Texto**: nome longo, emoji e acento não quebram layout.
- **Teclado**: Tab alcança as ações; Esc fecha modal; foco visível.
- **Acessibilidade** com `@axe-core/playwright` se já estiver no projeto (senão,
  cobertura pendente — não instalar sem pedir):

```js
const AxeBuilder = require('@axe-core/playwright').default;
const r = await new AxeBuilder({ page }).include('<seletor-da-tela>')
  .withTags(['wcag2a', 'wcag2aa']).analyze();
expect(r.violations, JSON.stringify(r.violations.map(v => v.id))).toEqual([]);
```

- **Regressão visual**: `toHaveScreenshot('<id>-<estado>.png', { mask: [...], animations: 'disabled' })`
  no componente. Baseline nova só com `--update-snapshots` quando o caso define o
  visual e o usuário aprovou a referência.

## 2. Regressão de API — Playwright `tests/api/` (Camada `API`)

```js
const { test, expect } = require('@playwright/test');
test('TC-5316-007 — rejeita token com Bearer (406)', async ({ request }) => {
  const r = await request.get('/api/<rota>', { headers: { Authorization: `Bearer ${token}` } });
  expect(r.status()).toBe(406);
});
```

- `tests/api/<modulo>/<recurso>.spec.js`; título começa pelo ID.
- Token ou chave só por variável de ambiente; um login no setup.
- Assert de status **e** corpo/contrato (envelope `{ status, result }`, campos, tipos).

## 3. Collections e contratos — Bruno/Postman/Newman (Camada `API-collection`)

Collections ficam fora do repo da suíte (`~/postman-collections/`,
`~/bruno-fluctus/`). Em execução dividida, só a instância `executor-api` escreve nelas.

- Uma pasta por módulo/card; request `TC-<numero>-NNN — <cenário>`.
- Asserts de status + corpo/contrato. Postman `pm.test`; Bruno `tests {}`/`assert {}`.
- Dados dinâmicos (sender, marcador `QA-xxxx`) em pre-request; nada de ID fixo fora do `test_users.md`.
- **Segredos nunca na collection**: environment (Postman) ou `{{process.env.X}}` (Bruno);
  nunca commitar environment com valor real.
- Request que cria dado tem par de limpeza na mesma pasta (roda no fim). `[destrutivo]`
  no nome quando altera estado global — só roda com autorização registrada.
- Bruno novo: `bruno.json` + `environments/homologacao.bru`.
- Divergência real × swagger → `DIVERGENCIA_CONTRATO`.

```bash
# Postman
newman run "<collection>.json" -e <env>.json --timeout-request 15000 \
  -r cli,htmlextra --reporter-htmlextra-export <evid>/report.html [--folder "<pasta>"]
# Bruno (de dentro de ~/bruno-fluctus; 1ª chamada do npx ~40s)
set -a; source <(grep -E '^USER_ADMIN_ENDRIO_' ~/fluctus_automatizado/.env); set +a
npx --yes @usebruno/cli run <pasta> --env homologacao --reporter-html <evid>/report.html
```

`bru.setVar("token", …)` no `tests {}` do login propaga o token. CLI do Bruno não
instala → avisar e usar Newman. Evidências em
`~/fluctus_automatizado/evidencias/api-collections/<numero-ou-modulo>/<data>/`.
Collection que cobre algo que deveria ser regressão versionada → **sugerir**
migrar para `tests/api/`, sem migrar.

## 4. Cobertura por endpoint

- Sucesso: status, schema, paginação/ordenação.
- Validação: ausente, tipo errado, limite, vazio, payload grande → 400/422 com mensagem útil.
- Autenticação: sem token, derrubado, inválido → conforme o contrato medido (406/401).
- Autorização: matriz **papel → status**; recurso de outra empresa (IDOR); 403 de licença CRM.
- Idempotência: mesmo POST/PUT 2x, DELETE repetido.
- Efeito: após escrita, GET confirma; webhook validado por polling do efeito.
- Fluxo entre serviços: provar cada salto (request, log com horário, linha no
  banco); duplicidade de evento, ordem trocada, dependência fora, filtro de escopo
  (ex.: grupo `@g.us` não aciona bot). Canais externos só com conta de teste.
- Banco só leitura (`SET default_transaction_read_only = on`): contagens
  antes/depois, órfãos, duplicidade, nulos, normalização. Evidência = contagens e IDs.

## 5. Executar e provar estabilidade

```bash
npx playwright test tests/<modulo>/<arquivo>.spec.js --project=chromium \
  --output "$QA_SAIDA/test-results" --reporter=list,html
npx playwright test tests/api/<modulo> --output "$QA_SAIDA/test-results-api" --reporter=list
```

- Teste novo/alterado: `--repeat-each=5 --workers=1` e depois `--workers=4`, zero falhas.
- O teste precisa falhar quando o comportamento quebra (inverter o esperado uma
  vez, ver vermelho, desfazer).
- `grep -rn "test.only\|waitForTimeout" tests/` vazio.
- Collections: rodar 2x; mesmo resultado, sem dependência de ordem não declarada.
- Instável: classificar a causa (espera, dados, ordem, ambiente ou produto — race
  real é bug). Sem correção agora → `test.fixme()` com motivo e ID.

## 6. Classificar

Classes da `qa-fluctus`. Falha confirmada = reproduziu 2x. Falha de API:
reproduzir com `curl` isolado antes de chamar de `BUG_APLICACAO`. Inconsistência
especificação × card: vale o requisito explícito do card; registrar a decisão.
Nunca afrouxar assert, aumentar timeout ou pular teste para passar.

## 7. Limpeza dos dados de teste

- Todo dado criado leva `$QA_PREFIXO` (UI/API) ou `QA-xxxx` (collections) e tem
  remoção no fim (fixture/`afterEach`, par de limpeza na collection).
- Depois da execução, conferir sobra pela API filtrando pelo prefixo
  (ex.: `GET /api/<recurso>?search=$QA_PREFIXO` → 0 itens).
- Sobra que não saiu: listar IDs em "Limpeza" como pendência. Nunca apagar
  registro que não foi criado pela frente.

## 8. Autorizações (sem elas, não faz)

`[destrutivo]`, escrita fora de homologação, ligar `.env`, instalar dependência,
commit, push, merge e criar issue. Autorizações vêm de `decisoes.md`; ausente →
caso `BLOCKED` com o motivo.

## 9. Resultado

Escrever **somente** `<raiz>/.qa/<ID>/resultado-executor.md`
(`resultado-executor-ui.md` / `resultado-executor-api.md` quando dividido):

```markdown
# Resultado — test-executor
- Worktree: <caminho> · Branch: qa/<ID>/executor · Base: <sha>
- Ambiente: <BASE_URL> · Navegador: chromium <versão> · Usuários/chave: <papéis>

## Execução
- Total <n> · PASS <a> · FAIL <b> · BLOCKED <c> · por camada: UI <x> · API <y> · API-collection <z>
- TC-5316-001 · UI — PASS — evidência: <trace/screenshot>
- TC-5316-008 · API — FAIL (2/2) · BUG_APLICACAO — esperado 403 · obtido 200 — curl: <arquivo>
- TC-5316-012 · API-collection — BLOCKED · AMBIENTE — <motivo e o que destrava>

## Divergências de contrato
- `<MÉTODO> <rota>` — swagger diz … · real …

## Cobertura
- Positivos <n> · Negativos <n> · Automatizados <n> · Não automatizados <n> (motivo)
- Casos sem implementação: <ID — motivo> ou "nenhum"
- Inconsistências especificação × card: <ID — decisão>

## Limpeza
- <recurso> — criados <n> · removidos <n> · sobra: <IDs ou "nenhuma">

## Falhas para o escritor
- F-E1 · TC-5316-003 · BUG_APLICACAO · visual — <o que se vê, onde, viewport/tema> — evidência: <arquivo>
- F-E2 · TC-5316-008 · BUG_APLICACAO · api — `<MÉTODO> <rota>` · papel <x> · esperado <a> · obtido <b> — curl: <arquivo>

## Handoff de documentação
- Tela(s): <nome> — sequência coberta: <acessar → filtrar → criar …>
- Arquivos: tests/<…>.spec.js, tests/api/<…>.spec.js, collection <pasta> (testes/requests)
- Como rodar: `<comandos>`
- Proposta para AI_CONTEXT.md: <o que acrescentar/alterar>

## Conclusão
<uma frase objetiva>
```
