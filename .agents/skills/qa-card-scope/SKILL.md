---
name: qa-card-scope
description: Ler um card (Notion, GitHub issue/PR ou texto colado) e extrair escopo de QA — critérios de aceite, módulos impactados, mexe em dados, riscos e perguntas abertas.
---

# Escopo de QA a partir de um card

## Entrada

URL ou ID do card. Descobrir a origem pelo formato:

- `notion.so/...` ou UUID → conector Notion (`notion-fetch`) quando disponível.
- `github.com/<org>/<repo>/issues|pull/<n>` ou `#<n>` → `gh issue view <n> --comments`
  / `gh pr view <n> --json title,body,files,commits`. PR: listar arquivos alterados.
- Texto colado → usar como está.

Sem acesso à origem, pedir o conteúdo do card. Não inventar escopo.

## Extração

1. **Objetivo**: o que muda para o usuário, em uma frase.
2. **Critérios de aceite**: copiar os explícitos; derivar implícitos só quando o card
   os descreve (ex.: "não deve duplicar"). Marcar derivados como `[derivado]`.
3. **Módulos impactados**: mapear para a árvore de features do projeto
   (ex. Fluctus: Conversas, CRM, Tickets, Dashboards, Relatórios, Ações, Cadastros,
   Configurações). Com PR, confirmar pelo diff (rotas, componentes, migrations).
4. **Camadas**: UI, API, banco, fila/worker, integração externa (WhatsApp/Baileys,
   Meta Cloud API, S3, webhooks).
5. **Mexe em dados?** `sim` se houver migration, INSERT/UPDATE/DELETE em massa,
   importação, sincronização, restore, mudança de chave/relacionamento ou
   normalização (telefone, LID, e-mail). Justificar em uma linha.
6. **Riscos**: o que pode quebrar fora do card (consumidores da rota/tabela alterada).
7. **Perguntas abertas**: ambiguidades que mudam o resultado esperado.

## Saída

```text
Card: <título> (<link>)
Objetivo:
Critérios de aceite:
  - CA1 ...
Módulos impactados:
Camadas:
Mexe em dados: sim|não — <motivo>
Perfis de QA indicados: api | automatizado | exploratorio | integracao | regressao
Riscos:
Perguntas abertas:
```

Perguntas abertas não bloqueiam casos independentes; bloqueiam só os casos que
dependem da resposta. Não tratar opinião do leitor como requisito.
