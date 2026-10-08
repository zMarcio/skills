---
name: qa-worktree-frentes
description: Criar, acompanhar, coletar e remover os worktrees das frentes de QA (executor — opcionalmente dividido em executor-ui e executor-api — e documentador) com scripts/qa-frentes.sh, e organizar as rodadas de execução paralela respeitando o limite de sessão por usuário do Fluctus — base conhecida, prefixo de dados, pastas de saída, estado em .qa/<ID>/ e entrega por patch revisável.
---

# Worktrees e rodadas

Especialização de `worktree-delivery` para `/qa-card` e `/qa-modulo`. Frentes em
paralelo, cada uma no seu worktree; estado compartilhado no checkout principal;
um escritor por arquivo. `<ID>` é o `CARD_ID` (com card) ou `mod-<modulo>`.

## Layout

```text
~/
├── test_cases/TC_<…>.md                       questionador → congelado após confirmação
├── fluctus_automatizado/                      checkout principal (orquestrador)
│   └── .qa/<ID>/                              estado (excluído do Git)
│       ├── contexto.md                        leitor
│       ├── diff.md · contexto-unificado.md    verificador (o unificado vai para os executores)
│       ├── regressao.md | cobertura.md        regressao (mapa do card | cobertura do módulo)
│       ├── decisoes.md · frentes.md           orquestrador (frentes.md: script + alocação)
│       ├── revisao-spec.md                    spec-reviewer
│       ├── resultado-<agente>.md              cada agente o seu
│       ├── executor/ regressao/ cibersecurity/   saídas e evidências
│       ├── patches/<frente>.patch             qa-frentes.sh coletar
│       ├── cards.md                           escritor (bug-drafter)
│       └── relatorio.md                       orquestrador
└── fluctus_automatizado.qa-wt/<ID>/
    ├── executor/      qa/<ID>/executor        tests/<modulo>/…, tests/api/…
    │   (ou executor-ui/ e executor-api/ quando dividido)
    └── documentador/  qa/<ID>/documentador    docs/testes/…, docs/AI_CONTEXT.md
```

Sem worktree: regressao (só leitura; roda a suíte da raiz principal),
performance (`~/k6-fluctus`), cibersecurity (réplica própria em `.qa/…/cibersecurity/`).
Collections (`~/postman-collections`, `~/bruno-fluctus`): só o executor escreve
(na divisão, só o `executor-api`).

## Comandos

```bash
QF=.claude/skills/qa-worktree-frentes/scripts/qa-frentes.sh   # do checkout principal
$QF criar   <ID> executor documentador [--env]         # padrão
$QF criar   <ID> executor-ui executor-api documentador # divisão opcional
$QF status  <ID>
$QF coletar <ID>                                       # .qa/<ID>/patches/*.patch
$QF remover <ID> <frente>                              # só a pedido; recusa se sujo
```

`criar`: base = `HEAD` do principal (avisa se há alteração não commitada); recusa
destino/branch existentes; `node_modules` como link; `.env` só com `--env`, como
link e só se ignorado pelo Git; grava `.qa-frente.env` (`QA_CARD`, `QA_FRENTE`,
`QA_BASE`, `QA_PREFIXO`, `QA_SAIDA`, `PLAYWRIGHT_HTML_REPORT`); exclui
`/.qa/`, `/.qa-frente.env`, `/node_modules` via `.git/info/exclude`.

Não usamos `isolation: worktree` do subagent: ele parte da branch padrão (não do
`HEAD`) e some se vazio — perderíamos base, prefixo e saídas combinadas.

## Quando dividir o executor

Uma instância do `test-executor` é o padrão. Dividir em `executor-ui` ∥
`executor-api` só quando as três condições valem:

- há casos suficientes nos dois lados para compensar (ex.: 6+ de UI e 6+ de API/collections);
- os usuários de cada lado são diferentes (a UI costuma usar a suíte com
  GOD/ANTONIO; API e collections, a chave de API ou SUPERVISOR/JOSE);
- nenhum caso de um lado muda configuração global que o outro lê.

## Rodadas de execução (worktree não isola sessão)

Cada login derruba a sessão anterior do mesmo usuário (`qa-fluctus`). Antes de
disparar, o orquestrador acrescenta a alocação ao `frentes.md`:

```markdown
## Alocação
- Rodada A: test-executor — GOD/ANTONIO (suíte) + chave de API · cibersecurity — réplica
- Rodada B: regressao — usuários da suíte · performance — ADMIN/ENDRIO (smoke)
- Rodada C: documentador · escritor
```

- **A** (paralela): test-executor (ou executor-ui ∥ executor-api) ∥ cibersecurity.
- **B** (depois de A): regressao (mesmos usuários da suíte) ∥ performance — só
  juntos se os usuários forem diferentes; senão em sequência.
- **C**: documentador ∥ escritor (arquivos diferentes).
- Dois casos que mudam a mesma configuração global nunca na mesma rodada.
- Porta local, se alguém subir servidor: executor/executor-ui 3101, executor-api 3102, réplica 3190.

## Entrega

1. `status` → frentes concluídas e resultados escritos (com a seção "Limpeza").
2. `coletar` → um patch por frente (commits + não commitado + arquivos novos).
3. Revisar; aplicar no principal só com autorização:
   `git apply --check <patch> && git apply <patch>` — executor(es) e documentador
   juntos (a documentação descreve o código do executor). Conflito no mesmo
   arquivo → orquestrador resolve com as frentes, sem sobrescrever.
4. `remover` só quando o usuário pedir; branch com commits é mantida.
