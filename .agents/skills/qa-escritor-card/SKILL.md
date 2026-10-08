---
name: qa-escritor-card
description: Escritor (bug-drafter) — reunir os bugs novos confirmados por todos os agentes, eliminar duplicatas (no lote, nas issues do repositório e nos rascunhos de outros cards), conferir as evidências e preparar rascunhos de cards no formato do time — Comportamento atual, Comportamento ideal, Evidência e Possível causa — sem publicar nada automaticamente.
---

# Escritor (bug-drafter)

Entrada: seções "Falhas para o escritor" de `.qa/<ID>/resultado-{executor*,regressao,performance}.md`,
o contexto (`contexto-unificado.md` ou `cobertura.md`) e o `diff.md` (arquivo/commit).
Saída: `.qa/<ID>/cards.md` (dono único) e os mesmos rascunhos na resposta.

## 1. Reunir só bugs novos

- Entra: falha confirmada (reproduziu 2x) classificada como `BUG_APLICACAO`, ou
  `DIVERGENCIA_CONTRATO` quando o swagger é o requisito (classes em `qa-fluctus`).
- Não entra (lista à parte no fim): `BUG_TESTE`, `DADO_INVALIDO`, `AMBIENTE`,
  `DEPENDENCIA`, `LIMITE_GERADOR`, `REQUISITO_AMBIGUO`, instável, **preexistente**
  (já falhava antes — regressão marcou) e achados da `cibersecurity` (só com
  pedido do usuário: formato próprio e detalhe sensível).

## 2. Eliminar duplicatas

1. **No lote**: falhas com a mesma causa visível viram um card (citar todos os TCs).
2. **Nas issues**: `gh issue list -R <org>/<repo> --search "<termos do sintoma>" --state all --limit 20`
   e `gh issue view <n>` nos candidatos; comparar sintoma, tela/rota e causa.
   Aberta igual → não redigir; citar o link. Fechada igual → é **reabertura**:
   redigir citando a issue antiga.
3. **Nos rascunhos**: `rg -l "<sintoma|rota>" ~/fluctus_automatizado/.qa/*/cards.md`
   — rascunho de outro card ainda não publicado → citar em vez de duplicar.

Só comandos de leitura do `gh`. Nunca comentar, rotular ou fechar issue.

## 3. Conferir evidências

Para cada falha que vira card:

- O arquivo citado existe (`ls`) — trace, screenshot, vídeo, curl, log, query.
- Está sanitizado: sem token, senha, telefone, e-mail ou nome real
  (`rg -n "Bearer|fl:ey|@[a-z0-9.-]+\.[a-z]{2,}|[0-9]{10,13}" <arquivo>`).
- Mostra o problema (abrir screenshot/trace quando a falha é visual).

Evidência ausente, ilegível ou com dado sensível → o card sai marcado
`Evidência pendente: <o quê>` na lista final, e o problema é devolvido ao
orquestrador; não inventar evidência.

## 4. Formato (fixo)

Um bloco de código markdown por card. Sem título e sem outros tópicos além destes.
Bullets, não tabelas.

````markdown
```markdown
## Comportamento atual
<1–3 frases diretas: o que acontece, onde (tela/rota) e com quem (perfil).>

## Comportamento ideal
<1–3 frases diretas: o que deveria acontecer, segundo o card/CA.>

## Evidência
<!-- prints/vídeos anexados pelo QA -->

## Possível causa
<somente quando a falha não é visível em tela — ver regra abaixo>
```
````

- **Comportamento atual / ideal**: resumido e direto. Sem passos numerados, sem
  "parece que". Ideal vem do critério (`CA*`/`CC*`) ou da decisão registrada; não inventar regra.
- **Evidência**: sempre presente e vazia — é preenchida pelo usuário com prints
  ou vídeo. Só o comentário-placeholder.
- **Possível causa**: **apenas** quando a falha não dá para mostrar em print/vídeo
  — erro de API, status/contrato errado, dado inconsistente no banco,
  fila/webhook, log de servidor. Hipótese técnica em 1–3 bullets, cada uma com o
  que a sustenta (request/response sanitizado, trecho de log, query + contagem,
  arquivo/commit do `diff.md`). Escrever "provável", nunca afirmar sem prova.
  Falha visual (layout, texto, tema) não recebe esse tópico.

## 5. cards.md

```markdown
# Cards — <ID>
## C1 — <sintoma curto> (TC-5316-003, TC-5316-004 · test-executor) · evidência: ok
<bloco do card>
## C2 — <sintoma> (TC-5316-011 · regressao) · reabertura de #123 · evidência: ok
<bloco do card>

## Duplicatas (não redigidas)
- F-E4 — igual a #456 (aberta)
## Não viraram card
- TC-5316-005 — BLOCKED · AMBIENTE: <motivo>
- TC-5316-011 — preexistente (falhava antes)
## Evidência pendente
- C3 — falta o curl da falha F-E5
```

O título `## C1 — …` é só para o arquivo e a conversa; não faz parte do card.
Rascunho não é publicação: criar issue/página no GitHub ou Notion só com
autorização explícita do usuário, card a card.
