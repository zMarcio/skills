---
description: QA de um card do GitHub com os agentes planejador, executor, revisor e integrador, e a cibersecurity sob demanda — contexto unificado, mapa de regressão, rodadas de perguntas, especificação revisada e confirmada por você, execução em rodadas com worktrees, revisão de código, documentação SDD e rascunhos de cards
argument-hint: <link-do-card> [repo=<caminho-do-código>] [de=<ref> para=<ref>]
model: claude-opus-5-5
---

Card: $ARGUMENTS

Você é o orquestrador. Rode da raiz principal da suíte (`~/fluctus_automatizado`
= `<raiz>`). Agentes em `.claude/agents/`: **planejador**, **executor**,
**revisor**, **integrador** e **cibersecurity**; contrato comum e mapa de fases na skill
`qa-fluctus`. Nenhum agente chama outro: só você delega e só você fala com o
usuário. Com card, o foco é **o fluxo pedido e as dependências dele**. Quem revisa
nunca é quem fez.

## 0. Preparar

- `gh auth status` ok; `<raiz>` é checkout principal (não worktree).
- `repo=` é o código do produto para diff, regressão e auditoria (opcional; sem
  ele o diff vem do PR via `gh`).
- Lista de tarefas: contexto → mapa → perguntas → revisão da spec → confirmação →
  rodadas A–D → relatório.

## 1. Contexto e mapa — planejador

1. **planejador**, fases `contexto` e `mapa`, com o link, `repo`/`de`/`para` e
   `<raiz>` → `.qa/<CARD_ID>/contexto.md`, `diff.md`, `contexto-unificado.md` e `regressao.md`.
2. Mostre ao usuário, em poucas linhas: objetivo, critérios de aceite do card (ou
   "sem CA" — o comum), itens do pedido sem mudança no código, riscos `D*` além
   do card e os itens de regressão por prioridade —
   `R1 · Alta · <item> — <motivo> — cobertura: <existe|lacuna>`.

O `contexto-unificado.md` é o contexto que o executor (todas as fases) e a
cibersecurity recebem junto com a especificação.

## 2. Rodadas de perguntas — planejador

1. Continue o mesmo planejador (SendMessage), fase `perguntas`, modo "com card".
2. `ESTADO: PERGUNTAS` → AskUserQuestion, uma por linha `Q*`, recomendada primeiro.
3. Anexe a `.qa/<CARD_ID>/decisoes.md` (único escritor: você):
   `## Rodada <n>` e `- Q1 <pergunta> → <resposta> (<data hora>)`.
4. Avise o planejador "rodada <n> respondida" e repita até `ESTADO: DEFINIDO`
   (a especificação em `~/test_cases/` sai com `Status: aguardando revisão`).

Nada de caso, worktree ou execução antes disso. Retomada: o estado está em `decisoes.md`.

## 3. Revisão da especificação — revisor

1. **revisor**, fase `spec`, com a especificação, o contexto, `regressao.md`,
   `decisoes.md` e `<raiz>` → `.qa/<CARD_ID>/revisao-spec.md`.
2. `BLOQUEADA`: bloqueios do planejador → devolva a ele (SendMessage) e revise de
   novo; do usuário → pergunte (AskUserQuestion) e registre em `decisoes.md`; de
   ambiente → mostre o que destrava. Repita até `APROVADA` ou `APROVADA COM RESSALVAS`.

## 4. Confirmação dos casos (gate obrigatório)

- Liste a especificação ao usuário, um por linha — `TC-<numero>-001 · UI · Alta · <cenário>` —
  agrupado por fase do executor (ui-api, regressão, performance), com total por
  camada, critérios `CA*`/`CC*` e itens `R*` cobertos, o que ficou fora do escopo,
  ressalvas da revisão, autorizações registradas e se a cibersecurity entra.
- Pergunte: **Confirmar** / **Ajustar** / **Cancelar**. Ajustar → registre em
  `decisoes.md`, devolva ao planejador e passe pela revisão de novo.
- Confirmar → troque só a linha de status para `Status: confirmado em <AAAA-MM-DD HH:MM>`.
  A especificação não muda mais.

Sem "confirmar" explícito, não distribua nada.

## 5. Execução e revisão em rodadas

Toda chamada ao executor leva: fase, especificação, `revisao-spec.md`,
`contexto-unificado.md`, os IDs da camada, o worktree, `<raiz>` e os usuários alocados.

1. Worktrees: `.claude/skills/qa-worktree-frentes/scripts/qa-frentes.sh criar <CARD_ID> executor regressao`
   (ou `executor-ui executor-api documentador regressao` quando valer a divisão;
   `--env` só se o usuário autorizar ligar o `.env`).
2. Escreva a **alocação** de usuários e rodadas em `frentes.md` (skill `qa-worktree-frentes`).
3. **Rodada A** — na mesma mensagem, em paralelo, só o que tem trabalho:
   - **executor**, fase `ui-api`: IDs `UI`, `API`, `API-collection`, worktree `…/executor`
     (ou duas instâncias: `…/executor-ui` e `…/executor-api`).
   - **cibersecurity** (se confirmada): modo "com card", `repo`, commit.
4. **Rodada B** — depois de A: **executor**, fase `regressao` (worktree `…/regressao`,
   IDs `Regressão`) e fase `performance` (IDs `Perf`, nível autorizado em
   `decisoes.md`). Duas instâncias em paralelo só se os usuários forem diferentes.
5. **Rodada C** — **revisor**, fase `codigo`, uma vez por frente que escreveu código
   (executor e performance). `REPROVADO` → achados ao executor (SendMessage), que
   corrige só o teste; revisor revisa de novo o que mudou.
6. `qa-frentes.sh status <CARD_ID>`; cada caso confirmado tem PASS/FAIL/BLOCKED/NÃO
   EXECUTADO, cada resultado tem a seção "Limpeza" e cada frente tem revisão de
   código aprovada. Sobra de dados vira pendência no relatório.

## 6. Revisão profunda e otimização — rodada D

- **integrador**, fase `otimizar`, uma vez por frente aprovada pelo revisor, no
  worktree dela (o executor já terminou). Otimiza sem mudar comportamento (prova
  antes × depois) e dá o parecer de pertinência de cada teste com base nos TCs.
- Mudança que alteraria assert, esperado ou cobertura volta ao revisor como achado.
- Propostas de remover, unir ou mover teste: pergunte ao usuário; o que ele
  aprovar o integrador aplica e o revisor confere de novo só aquilo.

## 7. Documentação e rascunhos de cards — rodada E

Em paralelo:

- **executor**, fase `documentacao`: documenta o código otimizado no worktree
  `…/executor` (ou `…/documentador` na divisão). Se voltar `ESTADO: PEDIDOS`,
  repasse ao agente responsável (SendMessage) e avise o executor quando ele responder.
- **revisor**, fase `bugs`, se houver "Falhas para o escritor": bugs novos, sem
  duplicata, evidência conferida. Achados de segurança só se o usuário pedir.

Mostre os rascunhos, cada um no seu bloco de código (a `## Evidência` é para os
prints/vídeo dele), com as duplicatas e evidências pendentes. Nada é publicado.

## 8. Integração, pre-push e relatório

- `qa-frentes.sh coletar <CARD_ID>` → patches (testes + documentação); a regressão
  não gera patch, só aviso se sobrou arquivo gerado.
- `qa-frentes.sh criar <CARD_ID> integracao` e **integrador**, fase `integrar`:
  aplica os patches no worktree `integracao`, repara conflitos (conflito de
  intenção volta a você como pergunta) e roda a fase `pre-push`.
- `.qa/<CARD_ID>/relatorio.md` com a skill `qa-relatorio` (parecer Apto / Apto
  com ressalvas / Não apto / Inconclusivo), incluindo revisões, otimizações e
  pertinência, regressão, performance, segurança, limpeza, documentação e o
  veredito de pre-push.
- Resposta final curta: parecer, contagem por resultado e por camada, itens de
  regressão com falha, rascunhos de cards, achados de segurança por classe,
  documentos criados, sobras de dados, veredito de pre-push, onde está a branch
  `qa/<CARD_ID>/integracao` e as autorizações pendentes: commit? push (só com
  PRONTO PARA PUSH)? merge na branch da suíte? remover worktrees? rodar carga
  pendente? publicar algum card? Cada ação só com "sim" explícito; push só com
  pedido próprio. Commit, push e merge autorizados são feitos pelo **integrador**
  (merge sempre com a fase `merge`, que repara conflitos).

## Regras

- Um escritor por arquivo (`qa-worktree-frentes`). Nada de execução no checkout principal.
- Collections no workspace do Postman: só você sincroniza, pelo Postman MCP, e só
  quando o usuário pedir.
- Nenhum efeito externo (issue, comentário, mensagem, escrita em produção, teste
  em homologação fora do combinado) sem autorização.
- Só `BUG_APLICACAO`/`DIVERGENCIA_CONTRATO` novos viram rascunho; o resto vai no relatório.
- Não reexecutar fase cuja entrada não mudou; em retomada, confrontar o estado
  com `git status` dos worktrees antes de continuar.
