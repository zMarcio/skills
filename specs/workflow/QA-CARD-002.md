# QA-CARD-002 — agentes de QA por card e por módulo (Claude Code)

Estado: concluído tecnicamente; publicado na branch `features/agents-marcio` (sem merge).
Substitui: [QA-PERFIS-001](QA-PERFIS-001.md). Skills por agente aprovadas em
[QA-SKILLS-003](QA-SKILLS-003.md).

## Pedido e decisões (2026-10-08)

- Base: refatorar `feat/qa-perfis`. Runtime: só Claude Code. Paralelismo quando
  possível, cada frente no seu worktree.
- Skills por área, um agente por foco. Escritor com formato `## Comportamento atual`
  / `## Comportamento ideal` / `## Evidência` / `## Possível causa`.
- Questionador: rodadas até definir o quê/foco/como; só então casos; lista ao
  usuário; só com confirmação divide entre os agentes.
- Conciliar com os agentes do usuário: `test-planner`, `test-executor`,
  `perf-tester`, `api-collection-tester`.
- Cibersecurity com regras do usuário e as 10 skills escolhidas por ele (3 nossas).
- Documentador: pede ao agente responsável a explicação e documenta em SDD numa
  pasta por agente, arquivo por card e por tela.
- Informações do Leitor e do Verificador unidas e passadas aos agentes de execução.
- Agente Regressão para visualizar os itens de regressão.
- API e UI/UX num único agente de execução (Playwright para interface e regressão
  de API; Bruno/Postman/Newman para collections e contratos; Read, Write, Edit,
  Bash, Grep, Glob).
- `spec-reviewer` revisa casos, critérios, dados e pré-requisitos e aponta
  bloqueios antes da execução.
- `bug-drafter` reúne bugs novos, elimina duplicatas, confere evidências e
  prepara rascunhos sem publicar.
- Roteamento do `test-planner` ajustado a essa organização, preservando
  pré-checagem, autorizações e limpeza. Com card: foco no fluxo pedido e
  dependências. Construção do zero: cobertura por módulo.
- Card normalmente não tem critério de aceite: critérios combinados (`CC*`) na
  rodada 1 passam a ser a base da rastreabilidade quando não há `CA*`.
- Publicar na branch `features/agents-marcio` (pedido "/features/agents-marcio";
  nome de branch Git não pode começar com `/`).

## Agentes e conciliação

- **leitor** — lê o card (GitHub).
- **verificador** — diff entre commits + `contexto-unificado.md` para os executores.
- **regressao** — mapa de itens de regressão (card), cobertura do módulo (sem
  card) e execução da Camada Regressão.
- **questionador** = `test-planner` — mesma especificação em `~/test_cases`
  (tabela fixa, `Automatizável`, `Camada`, duplicidade, `test_users.md`) agora
  com rodadas, modos com card/sem card, seções de pré-checagem, autorizações e
  limpeza, e roteamento: `UI`/`API`/`API-collection` → test-executor,
  `Perf` → performance, `Regressão` → regressao.
- **spec-reviewer** — novo; revisão + pré-checagem somente leitura; veredito com bloqueios por dono.
- **test-executor** = antigo `test-executor` + `api-collection-tester` (o que
  estava dividido em designer e integracao). Divisão opcional em
  `executor-ui` ∥ `executor-api` quando os usuários permitem.
- **performance** = `perf-tester` (`qa-performance-k6`, absorve `qa-k6-load`).
- **cibersecurity** — auditoria somente leitura, réplica isolada; `/qa-ciber`.
- **documentador** — SDD por agente; único escritor do `AI_CONTEXT.md` no fluxo.
- **escritor** = `bug-drafter` — conferência feita: já redigia e buscava
  duplicatas nas issues; ganhou "só bugs novos", deduplicação contra rascunhos de
  outros cards e conferência de evidências.

## Fluxos

```text
/qa-card
leitor → verificador (diff.md + contexto-unificado.md) → regressao (mapa)
  → questionador ⇄ usuário (rodadas) → spec-reviewer (pré-checagem) → usuário confirma
  Rodada A: test-executor (ou executor-ui ∥ executor-api) ∥ cibersecurity
  Rodada B: regressao (execução) ∥ performance (se usuários diferentes)
  Rodada C: documentador (pede explicações via orquestrador) ∥ escritor (bug-drafter)
  → relatório → patches para revisão

/qa-modulo (construção do zero)
regressao (cobertura do módulo) → questionador por módulo → spec-reviewer → confirmação
  → mesmas rodadas A/B/C → relatório
```

Rodadas existem porque cada login derruba a sessão anterior do mesmo usuário.

## Arquivos

- Agentes: `.claude/agents/{leitor,verificador,regressao,questionador,spec-reviewer,test-executor,performance,cibersecurity,documentador,escritor}.md`
- Skills próprias: `qa-fluctus`, `qa-leitor-card`, `qa-verificador-diff`,
  `qa-regressao`, `qa-questionador`, `qa-spec-reviewer`, `qa-executor`,
  `qa-performance-k6`, `qa-documentador-sdd`, `qa-escritor-card`,
  `qa-worktree-frentes`, `audit-scope-readonly`,
  `controlled-vulnerability-validation`, `security-findings-report`;
  mantidas `qa-relatorio`, `qa-exploratory-charter`; copiadas do superpowers (MIT):
  `systematic-debugging`, `verification-before-completion`.
- Skills externas da Cibersecurity: `audit-context-building`, `fp-check`,
  `differential-review`, `variant-analysis`, `static-analysis` (trailofbits/skills);
  `security-threat-model`, `security-best-practices` (originais da OpenAI,
  instaláveis no Claude Code por trailofbits/skills-curated).
- Script: `.agents/skills/qa-worktree-frentes/scripts/qa-frentes.sh`
  (frentes `executor`, `executor-ui`, `executor-api`, `documentador`).
- Comandos: `.claude/commands/{qa-card,qa-modulo,qa-ciber}.md`
- Removidos: pipeline card-reader…bug-reporter, perfis qa-* de especialização e
  registros `.claude`/`.codex`; skills fundidas (`qa-designer-ui` e
  `qa-integracao-api` → `qa-executor`; `qa-k6-load` → `qa-performance-k6`).

## Decisões técnicas reversíveis

- Questionador, spec-reviewer e documentador não falam com usuário/agentes:
  devolvem `PERGUNTAS`/bloqueios/`PEDIDOS` e o orquestrador repassa.
- Worktrees por script, não `isolation: worktree` (parte da branch padrão e some se vazio).
- Documentação no worktree `documentador`, entregue junto com os patches dos testes.
- Cibersecurity pré-carrega só escopo e relatório; as outras 8 sob demanda.
- Evidência sempre presente e vazia; Possível causa só para falha não visível.
- Docs: pasta `test-executor/` com UI, API e collections por tela; construção do
  zero gera `modulo-<slug>.md`; auditoria sem card também.
- Nomes: `questionador` e `escritor` mantêm o nome dado pelo usuário e citam
  `test-planner` e `bug-drafter` na descrição; `test-executor` e `spec-reviewer`
  usam o nome em inglês dado por ele.

## Validações

- `python3 scripts/validar-pacote.py` → OK (skills=21, claude=10); erros injetados detectados
  (inclusive skill de terceiros sem LICENSE).
- `scripts/instalar-skills-qa.sh --dry-run` lista os comandos; instalação real não feita aqui.
- `qa-frentes.sh` em repositório temporário: criar (executor, executor-ui,
  executor-api, documentador), recusa de frente desconhecida e de destino
  ocupado, status, coletar (alterado + novo + commit), `git apply --check`,
  recusa de remover frente suja, remoção limpa, recusa dentro de worktree.
- Não executado: fluxo real contra card, homologação, k6, réplica de segurança.
