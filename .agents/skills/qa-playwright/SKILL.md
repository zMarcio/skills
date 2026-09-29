---
name: qa-playwright
description: Implementar, executar e verificar testes E2E com Playwright Test — estrutura, seletores estáveis, fixtures, autenticação reutilizável, dados sintéticos e checagem de flakiness.
---

# Automação E2E com Playwright

Seguir o padrão do projeto antes de criar algo novo (CommonJS ou ESM, pastas,
fixtures, sem BDD/Cucumber se o projeto não usa). Ler `playwright.config.*` primeiro.

## Implementar

- Um arquivo por funcionalidade: `tests/<modulo>/<funcionalidade>.spec.js`.
- Page objects leves só quando a tela é reutilizada em 3+ specs.
- Seletores, em ordem: `getByRole` → `getByLabel` → `getByText` → `getByTestId`.
  Evitar CSS/XPath de estrutura e classes geradas (MUI `css-xyz`).
- Esperas: asserções web-first (`await expect(loc).toBeVisible()`), nunca
  `waitForTimeout`. Aguardar resposta de rede quando o estado depende dela:
  `await page.waitForResponse(r => r.url().includes('/api/...') && r.ok())`.
- Autenticação via `storageState` em projeto `setup`; não logar em todo teste.
- Dados: criar via API no `beforeEach`/fixture e limpar no `afterEach`;
  nomes únicos (`QA-${Date.now()}`). Testes independentes da ordem.
- Um comportamento por `test`; `test.step` para legibilidade.

```js
const { test, expect } = require('@playwright/test');

test('cria fila com nome válido', async ({ page }) => {
  const nome = `QA-${Date.now()}`;
  await page.goto('/cadastros/filas');
  await page.getByRole('button', { name: 'Adicionar' }).click();
  await page.getByLabel('Nome').fill(nome);
  await page.getByRole('button', { name: 'Salvar' }).click();
  await expect(page.getByRole('row', { name: new RegExp(nome) })).toBeVisible();
});
```

Config recomendada: `trace: 'on-first-retry'`, `screenshot: 'only-on-failure'`,
`video: 'retain-on-failure'`, `retries` só em CI.

## Executar

```bash
npx playwright test                           # tudo
npx playwright test tests/cadastros --project=chromium
npx playwright test -g "cria fila"            # por nome
npx playwright test --ui                      # depuração local
npx playwright show-report
npx playwright show-trace test-results/**/trace.zip
```

## Verificar

- Novo/alterado teste passa 5x seguidas: `npx playwright test <arquivo> --repeat-each=5 --workers=1`
  e também em paralelo (`--workers=4`). Falhou alguma → skill `qa-flaky-triage`.
- O teste **falha** quando o comportamento quebra (mudar o esperado temporariamente e ver vermelho).
- Sem `test.only`, `waitForTimeout`, credenciais no código (`grep -rn "only(\|waitForTimeout" tests/`).
- Não enfraquecer assertion, pular teste ou aumentar timeout para "passar".
