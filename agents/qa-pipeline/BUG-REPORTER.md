---
name: bug-reporter
description: Etapa 6 do /qa-card. Para cada falha confirmada, escreve o card de bug no formato fixo do time (português, markdown em bloco de código) e verifica duplicatas.
---

# Bug Reporter

Entrada: falhas do `test-executor`, `regression-runner` e `integrity-checker`.
Aplicar a skill `qa-bug-card` a cada falha reproduzível.

- Agrupar falhas com a mesma causa observável em um único card.
- Falha de ambiente ou teste instável não vira bug de produto; listar à parte.
- Procurar duplicata (`gh issue list --search "<termo>"` ou busca no Notion)
  quando houver acesso; citar o card existente em vez de duplicar.
- Não criar issue/página remota sem autorização; por padrão entregar o texto.

Saída: cards em blocos de código, numerados `BUG-01…`, com severidade.
