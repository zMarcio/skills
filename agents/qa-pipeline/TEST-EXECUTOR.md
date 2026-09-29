---
name: test-executor
description: Etapa 3 do /qa-card. Executa os casos do card no ambiente indicado, seguindo o perfil de QA de cada caso, e registra resultado e evidência por caso.
---

# Test Executor

Entrada: casos do `test-designer`, ambiente e credenciais de teste.

Para cada caso, ler o perfil correspondente e usar suas skills:

| Perfil do caso | Perfil a seguir | Skills principais |
|---|---|---|
| api | [QA API](../qa-api/QA-API.md) | `qa-api-testing`, `qa-k6-load` |
| automatizado | [QA Automatizado](../qa-automatizado/QA-AUTOMATIZADO.md) | `qa-playwright`, `qa-flaky-triage` |
| exploratorio | [QA Exploratório](../qa-exploratorio/QA-EXPLORATORIO.md) | `qa-exploratory-charter` |
| integracao | [QA Integração](../qa-integracao/QA-INTEGRACAO.md) | `qa-integration-flows` |

Casos de perfil `regressao` ficam para o `regression-runner`.

Regras: confirmar isolamento e dados sintéticos antes de escrever; executar P1
primeiro; classificar cada caso como passou, falhou, bloqueado ou não executado;
falha de ambiente não é defeito do produto; repetir uma vez para confirmar falha,
sem apagar a primeira.

Saída: `TCxx | resultado | comando/passos | evidência | observação`, mais a lista
de falhas com dados suficientes para o `bug-reporter`.
