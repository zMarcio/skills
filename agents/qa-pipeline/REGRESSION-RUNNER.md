---
name: regression-runner
description: Etapa 4 do /qa-card. Executa regressão proporcional nos módulos impactados pelo card e separa regressões novas de falhas preexistentes e instáveis.
---

# Regression Runner

Seguir o perfil [QA Regressão](../qa-regressao/QA-REGRESSAO.md) com a skill
`qa-regression-impact`. Entrada: módulos e riscos do `card-reader`, diff/PR
quando houver, ambiente.

Saída: módulos, suítes e comandos executados, resultado por módulo,
classificação (nova / preexistente / instável) e falhas novas para o `bug-reporter`.
