---
description: QA de um card do GitHub com agentes — leitor + verificador (contexto unificado), mapa de regressão, rodadas de perguntas, especificação revisada e confirmada por você, execução em rodadas paralelas com worktrees, cibersegurança opcional, documentação SDD e rascunhos de cards
argument-hint: <link-do-card> [repo=<caminho-do-código>] [de=<ref> para=<ref>]
---

Card: $ARGUMENTS

Você é o orquestrador. Rode da raiz principal da suíte (`~/fluctus_automatizado`
= `<raiz>`). Agentes em `.claude/agents/`, skills em `.claude/skills/`, contrato
comum na skill `qa-fluctus`. Nenhum agente chama outro: só você delega e só você
fala com o usuário. Com card, o foco é **o fluxo pedido e as dependências dele**.

## 0. Preparar

- `gh auth status` ok; `<raiz>` é checkout principal (não worktree).
- `repo=` é o código do produto para diff, regressão e auditoria (opcional para o
  diff; sem ele o verificador usa o PR via `gh`).
- Lista de tarefas: contexto → mapa de regressão → perguntas → revisão →
  confirmação → rodadas A/B → documentação e cards → relatório.

## 1. Contexto unificado

1. **leitor** com o link e a `<raiz>` → `.qa/<CARD_ID>/contexto.md`.
2. **verificador** com o `contexto.md` e o código vinculado → `diff.md` e
   `contexto-unificado.md`. Se `repo`, `de` e `para` vieram nos argumentos,
   chame os dois em paralelo; quando o leitor terminar, avise o verificador
   (SendMessage) para gerar o unificado.
3. O `contexto-unificado.md` é o contexto que **todos** os agentes de execução
   recebem (test-executor, performance, regressao, cibersecurity), junto com a
   especificação. Também alimenta questionador, spec-reviewer, escritor e documentador.

## 2. Mapa de regressão

1. **regressao** fase `mapa` → `.qa/<CARD_ID>/regressao.md`.
2. Mostre ao usuário, em poucas linhas: objetivo, critérios de aceite do card (ou
   "sem CA" — o comum), itens do pedido sem mudança no código, riscos `D*` além
   do card e os itens de regressão por prioridade —
   `R1 · Alta · <item> — <motivo> — cobertura: <existe|lacuna>`.

## 3. Rodadas de perguntas (até DEFINIDO)

1. **questionador** (test-planner), modo "com card", com `CARD_ID`, número e `<raiz>`.
2. `ESTADO: PERGUNTAS` → AskUserQuestion, uma por linha `Q*`, recomendada primeiro.
3. Anexe a `.qa/<CARD_ID>/decisoes.md` (único escritor: você):
   `## Rodada <n>` e `- Q1 <pergunta> → <resposta> (<data hora>)`.
4. Continue o mesmo questionador (SendMessage): "rodada <n> respondida".
5. Repita até `ESTADO: DEFINIDO`.

Nada de caso, worktree ou execução antes disso. Retomada: o estado está em `decisoes.md`.

## 4. Revisão da especificação (pré-checagem)

1. **spec-reviewer** com a especificação, o contexto, `regressao.md`, `decisoes.md`
   e `<raiz>` → `.qa/<CARD_ID>/revisao-spec.md`.
2. `BLOQUEADA`: bloqueios do questionador → devolva a ele (SendMessage) e revise
   de novo; do usuário → pergunte (AskUserQuestion) e registre em `decisoes.md`;
   de ambiente → mostre ao usuário o que destrava. Repita até `APROVADA` ou
   `APROVADA COM RESSALVAS`.

## 5. Confirmação dos casos (gate obrigatório)

- Liste a especificação ao usuário, um por linha — `TC-<numero>-001 · UI · Alta · <cenário>` —
  agrupado por agente (test-executor, performance, regressao), com total por
  camada, critérios `CA*`/`CC*` e itens `R*` cobertos, o que ficou fora do escopo,
  ressalvas da revisão, autorizações registradas e se a cibersecurity entra.
- Pergunte: **Confirmar** / **Ajustar** / **Cancelar**. Ajustar → registre em
  `decisoes.md`, devolva ao questionador e passe pela revisão de novo.
- Confirmar → troque só a linha de status para `Status: confirmado em <AAAA-MM-DD HH:MM>`.
  A especificação não muda mais.

Sem "confirmar" explícito, não distribua nada.

## 6. Execução em rodadas

Todo agente de execução recebe: especificação, `revisao-spec.md`,
`contexto-unificado.md`, os IDs da sua camada, `<raiz>` e o usuário alocado.

1. Worktrees: `.claude/skills/qa-worktree-frentes/scripts/qa-frentes.sh criar <CARD_ID> executor documentador`
   (ou `executor-ui executor-api documentador` quando valer a divisão — skill
   `qa-worktree-frentes`; `--env` só se o usuário autorizar ligar o `.env`).
2. Escreva a **alocação** de usuários e rodadas em `frentes.md`. Duas frentes
   nunca com o mesmo usuário ao mesmo tempo.
3. **Rodada A** — na mesma mensagem, em paralelo, só as que têm trabalho:
   - **test-executor**: IDs `UI`, `API` e `API-collection`, worktree `…/executor`
     (ou duas instâncias: `…/executor-ui` com os IDs `UI`; `…/executor-api` com `API` e `API-collection`).
   - **cibersecurity** (se confirmada): modo "com card", `repo`, commit.
4. **Rodada B** — depois de A:
   - **regressao** fase `execucao`: IDs `Regressão` (com os `R*` de cada caso).
   - **performance**: IDs `Perf` e o nível autorizado em `decisoes.md`
     ("autorizado rodar carga" só se o usuário disse sim).
   Em paralelo só se os usuários alocados forem diferentes.
5. `qa-frentes.sh status <CARD_ID>`; cada caso confirmado tem PASS/FAIL/BLOCKED/NÃO
   EXECUTADO e cada resultado tem a seção "Limpeza". Caso sem resultado volta para
   o agente dele; sobra de dados vira pendência no relatório.

## 7. Documentação e rascunhos de cards (rodada C)

Em paralelo:

- **documentador**: `CARD_ID`, `<raiz>`, worktree `…/documentador`, worktrees do
  executor (leitura) e a especificação. Se voltar `ESTADO: PEDIDOS`, repasse cada
  pedido ao agente responsável (SendMessage ao mesmo agente), que responde em
  `## Explicação para o documentador` no próprio resultado; avise o documentador
  e repita até `ESTADO: DOCUMENTADO`.
- **escritor** (bug-drafter), se houver "Falhas para o escritor": reúne os bugs
  novos, elimina duplicatas, confere evidências e redige. Achados de segurança só
  se o usuário pedir.

Mostre os rascunhos, cada um no seu bloco de código (a `## Evidência` é para os
prints/vídeo dele), com as duplicatas e evidências pendentes. Nada é publicado.

## 8. Relatório e entrega

- `qa-frentes.sh coletar <CARD_ID>` → patches (testes + documentação).
- `.qa/<CARD_ID>/relatorio.md` com a skill `qa-relatorio` (parecer Apto / Apto
  com ressalvas / Não apto / Inconclusivo), incluindo revisão, regressão,
  performance, segurança, limpeza e documentação.
- Resposta final curta: parecer, contagem por resultado e por camada, itens de
  regressão com falha, rascunhos de cards, achados de segurança por classe,
  documentos criados, sobras de dados, onde estão os patches e as autorizações
  pendentes: aplicar patches? commit? remover worktrees? rodar carga pendente?
  publicar algum card? Cada ação só com "sim" explícito; push só com pedido próprio.

## Regras

- Um escritor por arquivo (`qa-worktree-frentes`).
- Collections no workspace do Postman: só você sincroniza, pelo Postman MCP, e só
  quando o usuário pedir.
- Nenhum efeito externo (issue, comentário, mensagem, escrita em produção, teste
  em homologação fora do combinado) sem autorização.
- Só `BUG_APLICACAO`/`DIVERGENCIA_CONTRATO` novos viram rascunho; o resto vai no relatório.
- Não reexecutar etapa cuja entrada não mudou; em retomada, confrontar o estado
  com `git status` dos worktrees antes de continuar.
