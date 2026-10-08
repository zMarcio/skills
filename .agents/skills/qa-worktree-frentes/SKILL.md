---
name: qa-worktree-frentes
description: Criar, acompanhar, coletar e remover os worktrees das frentes de QA (executor — opcionalmente dividido em executor-ui e executor-api —, regressao e documentador) com scripts/qa-frentes.sh, e organizar as rodadas de execução respeitando o limite de sessão por usuário do Fluctus — base conhecida, prefixo de dados, pastas de saída, estado em .qa/<ID>/ e entrega por patch revisável.
---

# Worktrees e rodadas

Especialização de `worktree-delivery` para `/qa-card` e `/qa-modulo`. Cada frente
que grava arquivos tem o seu worktree; estado compartilhado no checkout principal;
um escritor por arquivo. `<ID>` é o `CARD_ID` (com card) ou `mod-<modulo>`.

**Nada de execução no checkout principal**: relatório, traces, sessão salva e
cópias temporárias ficam no worktree da frente ou em `.qa/<ID>/`.

## Layout

```text
~/
├── test_cases/TC_<…>.md                       planejador → congelado após confirmação
├── fluctus_automatizado/                      checkout principal (orquestrador)
│   └── .qa/<ID>/                              estado (excluído do Git)
│       ├── contexto.md · diff.md · contexto-unificado.md   planejador (o unificado vai para executor e cibersecurity)
│       ├── regressao.md | cobertura.md        planejador (mapa do card | cobertura do módulo)
│       ├── decisoes.md · frentes.md           orquestrador (frentes.md: script + alocação)
│       ├── revisao-spec.md · revisao-codigo-<frente>.md · cards.md   revisor
│       ├── resultado-executor*.md · resultado-regressao.md · resultado-performance.md   executor
│       ├── resultado-cibersecurity.md         cibersecurity
│       ├── executor/ regressao/ revisao-codigo/ cibersecurity/   saídas e evidências
│       ├── patches/<frente>.patch             qa-frentes.sh coletar
│       └── relatorio.md                       orquestrador
└── fluctus_automatizado.qa-wt/<ID>/
    ├── executor/      qa/<ID>/executor        tests/…, tests/api/…, docs/testes/executor/, docs/AI_CONTEXT.md
    │   (ou executor-ui/ e executor-api/ + documentador/ quando dividido)
    └── regressao/     qa/<ID>/regressao       suíte na base; só execução, sem mudança de código
```

Sem worktree: performance (`~/k6-fluctus`), cibersecurity (réplica própria em
`.qa/…/cibersecurity/`), revisor (lê os worktrees; saídas em `.qa/<ID>/`).
Collections (`~/postman-collections`, `~/bruno-fluctus`): só o executor escreve
(na divisão, só o `executor-api`).

## Comandos

```bash
QF=.claude/skills/qa-worktree-frentes/scripts/qa-frentes.sh   # do checkout principal
$QF criar   <ID> executor regressao [--env]                          # padrão
$QF criar   <ID> executor-ui executor-api documentador regressao     # divisão opcional
$QF status  <ID>
$QF coletar <ID>                                                     # .qa/<ID>/patches/*.patch
$QF remover <ID> <frente>                                            # só a pedido; recusa se sujo
```

`criar`: base = `HEAD` do principal (avisa se há alteração não commitada); recusa
destino/branch existentes; `node_modules` como link; `.env` só com `--env`, como
link e só se ignorado pelo Git; grava `.qa-frente.env` (`QA_CARD`, `QA_FRENTE`,
`QA_BASE`, `QA_PREFIXO`, `QA_SAIDA`, `PLAYWRIGHT_HTML_REPORT`); exclui
`/.qa/`, `/.qa-frente.env`, `/node_modules` via `.git/info/exclude`.

O worktree `regressao` é a suíte na base, sem o código novo do card — a regressão
roda os testes existentes como estavam. Ela não gera patch: o `coletar` só avisa
se sobrou arquivo gerado ali.

Não usamos `isolation: worktree` do subagent: ele parte da branch padrão (não do
`HEAD`) e some se vazio — perderíamos base, prefixo e saídas combinadas.

## Quando dividir a fase ui-api

Uma instância do executor é o padrão. Dividir em `executor-ui` ∥ `executor-api`
só quando as três condições valem:

- há casos suficientes nos dois lados (ex.: 6+ de UI e 6+ de API/collections);
- os usuários de cada lado são diferentes (UI com a suíte e GOD/ANTONIO; API e
  collections com a chave de API ou SUPERVISOR/JOSE);
- nenhum caso de um lado muda configuração global que o outro lê.

Na divisão, a documentação vira uma chamada à parte no worktree `documentador`.

## Rodadas (worktree não isola sessão)

Cada login derruba a sessão anterior do mesmo usuário (`qa-fluctus`). Antes de
disparar, o orquestrador acrescenta a alocação ao `frentes.md`:

```markdown
## Alocação
- Rodada A: executor ui-api — GOD/ANTONIO (suíte) + chave de API · cibersecurity — réplica
- Rodada B: executor regressão — usuários da suíte · executor performance — ADMIN/ENDRIO (smoke)
- Rodada C: revisor código — usuários da frente revisada
- Rodada D: executor documentação · revisor bugs
```

- **A**: executor fase ui-api (ou executor-ui ∥ executor-api) ∥ cibersecurity.
- **B** (depois de A): executor fase regressão e fase performance — mesma instância
  em sequência, ou duas instâncias em paralelo se os usuários forem diferentes.
- **C**: revisor fase código, frente a frente; REPROVADO volta ao executor e é
  revisado de novo só no que mudou.
- **D**: executor fase documentação (sobre o código aprovado) ∥ revisor fase bugs.
- Dois casos que mudam a mesma configuração global nunca na mesma rodada.
- Porta local, se alguém subir servidor: executor/executor-ui 3101, executor-api 3102, réplica 3190.

## Entrega

1. `status` → frentes concluídas, resultados com a seção "Limpeza", revisões de código aprovadas.
2. `coletar` → um patch por frente (commits + não commitado + arquivos novos).
3. Revisar; aplicar no principal só com autorização:
   `git apply --check <patch> && git apply <patch>` — executor(es) e documentador
   juntos. Conflito no mesmo arquivo → orquestrador resolve com as frentes, sem sobrescrever.
4. `remover` só quando o usuário pedir; branch com commits é mantida.
