---
name: qa-leitor-card
description: Ler um card do GitHub (issue, PR ou item de Project) com contexto completo — corpo, comentários, labels, PRs e commits vinculados, anexos — e registrar o contexto de QA em .qa/<card>/contexto.md.
---

# Leitor de card (GitHub)

Objetivo: entender o card inteiro antes de qualquer teste. Não inventar escopo;
o que não estiver no card ou nos vínculos vira pergunta aberta.

## 1. Identificar o card

Aceitar estes formatos e derivar o `CARD_ID` = `<repo>-<número>`:

- `https://github.com/<org>/<repo>/issues/<n>` → issue
- `https://github.com/<org>/<repo>/pull/<n>` → PR
- `https://github.com/orgs/<org>/projects/<p>?...&itemId=...` ou `.../views/...` →
  item de Project: abrir a issue/PR para a qual o item aponta
  (`gh project item-list <p> --owner <org> --format json` e localizar pelo `itemId`).
  Rascunho de Project sem issue: usar título/corpo do item e avisar que não há histórico.
- `<org>/<repo>#<n>` → issue ou PR (testar issue primeiro).

Sem acesso (`gh auth status` falhou, 404 de repo privado): parar e pedir ao
usuário o acesso ou o conteúdo colado. Não continuar com suposição.

## 2. Coletar (somente leitura)

```bash
# issue
gh issue view <url> --comments \
  --json number,title,body,state,labels,assignees,milestone,author,createdAt,url,comments,closedByPullRequestsReferences
# PR (o card ou PRs vinculados)
gh pr view <url> --comments \
  --json number,title,body,state,baseRefName,headRefName,mergeCommit,files,commits,reviews,comments,url
gh pr diff <url> --name-only
# timeline: referências cruzadas e PRs que mencionam o card
gh api repos/<org>/<repo>/issues/<n>/timeline --paginate \
  --jq '.[] | select(.event=="cross-referenced" or .event=="connected") | .source.issue.html_url // empty'
```

Ler também:

- **Comentários**: decisões tomadas depois do corpo valem mais que o corpo.
  Registrar quem decidiu e quando.
- **Anexos/imagens** (`user-images.githubusercontent.com`, `github.com/user-attachments`):
  listar os links com o que cada um parece mostrar pela legenda/contexto.
  Não afirmar o conteúdo de uma imagem que não foi aberta.
- **Cards citados** (`#123`, links): ler título e estado; abrir o corpo só se
  definir regra do card atual.
- **PR vinculado**: repo, base/head, commit de merge e lista de arquivos — o
  `verificador` usa isso para o diff.

## 3. Extrair

1. **Objetivo**: o que muda para o usuário, em uma frase.
2. **Tipo**: bug, melhoria, feature ou tarefa técnica.
3. **Critérios de aceite** (`CA1…`): explícitos do card/comentários. Derivados
   só quando o texto descreve o comportamento; marcar `[derivado]`. Card sem
   critério (o caso comum): escrever `Sem critérios de aceite no card` — não é
   lacuna nem bloqueio.
4. **Comportamento pedido**: cada expectativa que o texto, os comentários, os
   exemplos ou os anexos deixam claro, em uma linha cada. É a base dos critérios
   combinados (`CC*`) que o questionador propõe na rodada 1.
5. **Regras de negócio e restrições** (perfil/permissão, limites, formatos).
6. **Módulos e telas** na árvore de features do projeto (ex. Fluctus: Conversas,
   CRM/Oportunidades, Tickets, Dashboards, Relatórios, Ações, Cadastros, Configurações).
7. **Camadas**: UI, API, banco, fila/worker, integração externa (WhatsApp/Baileys,
   Meta Cloud API, S3, webhooks).
8. **Ambiente e massa**: URL de teste citada, perfis de usuário, dados necessários.
9. **Código vinculado**: repo/PR/commits para o diff (ou "não vinculado").
10. **Lacunas**: o que falta para saber o resultado esperado. Cada lacuna em uma
   linha, específica (não "requisitos pouco claros").

## 4. Saída

Escrever **somente** `<raiz-principal>/.qa/<CARD_ID>/contexto.md` (dono único):

```markdown
# Contexto — <título>
- Card: <url> · Tipo: <tipo> · Estado: <estado> · Autor: <autor>
- Lido em: <AAAA-MM-DD HH:MM>

## Objetivo
## Critérios de aceite
- CA1 — ... (origem: corpo | comentário de <autor> em <data> | [derivado])
- (ou) Sem critérios de aceite no card
## Comportamento pedido
- <expectativa clara no card> (origem: corpo | comentário | anexo)
## Regras e restrições
## Módulos e telas
## Camadas
## Ambiente e massa
## Código vinculado
- Repo: · PR: · Base/head: · Merge commit: · Arquivos: <n>
## Anexos
- <link> — <legenda/contexto>
## Decisões nos comentários
## Lacunas
- L1 — ...
```

Devolver ao orquestrador: `CARD_ID`, caminho do arquivo, nº de CAs (ou "sem CA"),
nº de itens de comportamento pedido, nº de lacunas
e o código vinculado (para o `verificador`).
