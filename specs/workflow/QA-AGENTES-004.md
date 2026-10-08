# QA-AGENTES-004 — três agentes de QA (planejar, executar, revisar)

Estado: concluído tecnicamente; publicado na branch `features/agents-marcio` (sem merge).
Evolui: [QA-CARD-002](QA-CARD-002.md) (fluxo e regras continuam valendo) e
[QA-SKILLS-003](QA-SKILLS-003.md) (skills aprovadas, agora agrupadas por agente).

## Pedido e decisões (2026-10-08)

- Novo agente "verificador de códigos" para validar se o que um agente fez está correto.
- Depois dele, juntar os agentes: "está muitos agentes, vamos tentar mesclar e deixar pelo menos 3".
- Escolha do usuário: **Planejar / Executar / Revisar**, com a **cibersecurity como 4º
  agente, sob demanda**.
- Regressão: adotar o ponto 3 da correção — worktree próprio, nada de execução no
  checkout principal; o rótulo "somente leitura" deixa de valer para a execução.

## Agentes

- **planejador** (opus) — fases leitor, verificador (diff + contexto unificado),
  mapa de regressão / cobertura do módulo e questionador (test-planner). Só leitura
  no código e no GitHub; escreve `.qa/<ID>/` e a especificação em `~/test_cases`.
- **executor** (sonnet) — fases ui-api (Playwright, `tests/api`, Bruno/Postman/Newman),
  regressão (worktree `regressao`, suíte na base), performance (k6, travas de
  autorização) e documentação SDD do que criou. Read, Write, Edit, Bash, Grep, Glob + Skill.
- **revisor** (opus) — fases spec (revisão e pré-checagem), código (verificador de
  códigos: diff × especificação × padrões, reexecução provando que passa e que
  falha quando deve) e bugs (bug-drafter). Não corrige código.
- **cibersecurity** (opus) — sem mudança; sob demanda e pelo `/qa-ciber`.

Quem revisa nunca é quem fez: o revisor confere o planejador (spec) e o executor (código).

## Fluxo `/qa-card`

```text
planejador: contexto → mapa → perguntas ⇄ usuário → especificação
revisor: spec → usuário confirma
Rodada A: executor ui-api (ou executor-ui ∥ executor-api) ∥ cibersecurity
Rodada B: executor regressão (worktree regressao) e performance
Rodada C: revisor código (REPROVADO → executor corrige → nova revisão)
Rodada D: executor documentação (código aprovado) ∥ revisor bugs
→ relatório → patches para revisão
```

`/qa-modulo`: começa no mapa de cobertura do módulo; o resto igual.

## O que mudou nos arquivos

- Agentes: `.claude/agents/{planejador,executor,revisor,cibersecurity}.md`; saíram
  leitor, verificador, regressao, questionador, spec-reviewer, test-executor,
  performance, documentador e escritor (viraram fases).
- Skills: todas mantidas, agora como fases (mapa em `qa-fluctus`); nova
  `qa-revisor-codigo`. `qa-regressao` executa no worktree `regressao`;
  `qa-documentador-sdd` virou fase do executor (quem criou documenta; pedido de
  explicação só para a outra instância de uma divisão ou para a cibersecurity);
  docs em `docs/testes/executor/` e `docs/testes/cibersecurity/`.
- Script: `qa-frentes.sh` aceita `regressao`; padrão `executor regressao`.
- Comandos `/qa-card`, `/qa-modulo` e `/qa-ciber` com os quatro agentes.
- Validador: agentes esperados = planejador, executor, revisor, cibersecurity.

## Skills por agente (de QA-SKILLS-003)

- planejador: `qa-fluctus`, `qa-questionador` (pré-carregadas); `qa-leitor-card`,
  `qa-verificador-diff`, `qa-regressao`, `grilling`, `testing-strategy`; plugin `gh-cli`.
- executor: `qa-fluctus`, `qa-executor`, `qa-worktree-frentes` (pré-carregadas);
  `qa-regressao`, `qa-performance-k6`, `qa-documentador-sdd`, `playwright-cli`,
  `systematic-debugging`, `verification-before-completion`, `bruno-test-writer`,
  `bruno-collection-generator`, `accessibility-review`, `k6`,
  `playwright-regression-testing`, Flaky Test Doctor, `doc-coauthoring`.
- revisor: `qa-fluctus` (pré-carregada); `qa-spec-reviewer`, `qa-revisor-codigo`,
  `qa-escritor-card`, `code-review`, `playwright-cli`, `systematic-debugging`,
  `verification-before-completion`; plugin `gh-cli`.
- cibersecurity: as 10 escolhidas pelo usuário + `supply-chain-risk-auditor`, `insecure-defaults`.

## Validações

- `python3 scripts/validar-pacote.py` → OK (skills=22, claude=4).
- `qa-frentes.sh` com a frente `regressao` em repositório temporário.
- Não executado: fluxo real contra card, homologação, k6, réplica de segurança.
