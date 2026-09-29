---
name: qa-regression-impact
description: Selecionar e executar regressão proporcional ao impacto de uma mudança — mapear módulos afetados pelo diff, escolher suítes (smoke, API, E2E), comparar com baseline e separar falha nova de preexistente.
---

# Regressão por impacto

## 1. Mapear impacto

- Com diff: `git diff --name-only <base>...<alvo>`; para cada arquivo, achar consumidores
  (`rg -n "<função|rota|tabela>" src/`). Migration/tabela → todos os módulos que leem a tabela.
- Sem diff: usar módulos do card (skill `qa-card-scope`) + vizinhos na árvore de features.
- Componentes compartilhados (tabela, modal, picker, auth, layout) → regressão ampla.

## 2. Escolher camadas

| Impacto | Regressão mínima |
|---|---|
| Só UI de uma tela | E2E da tela + smoke |
| Endpoint/regra | collection de API do módulo + E2E dos fluxos que o consomem |
| Banco/migration | API do módulo + integridade (`qa-data-integrity`) + relatórios que leem a tabela |
| Auth/permissão/compartilhado | smoke completo + API de todos os módulos |
| Atualização de versão | smoke pós-update completo |

## 3. Executar

```bash
npx newman run <regression-collection.json> -e <env.json> --folder "<Módulo>"
npx playwright test tests/<modulo> --reporter=list,html
```

## 4. Comparar com baseline

- Guardar resultado da base (antes da mudança) quando possível: mesma suíte, mesmo ambiente.
- Falhou antes e depois → **preexistente** (registrar, não atribuir ao card).
- Passou antes e falhou depois → **regressão** → `qa-bug-card` com link do card causador.
- Instável → `qa-flaky-triage`; não conta como regressão até classificar.

## 5. Verificar

- Cada módulo impactado tem ao menos uma suíte executada ou justificativa de exclusão.
- Relatar: módulos, comandos, passou/falhou, novas × preexistentes, cobertura não executada.
