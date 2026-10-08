---
name: qa-documentador-sdd
description: Fase documentador do executor — documentar no padrão SDD os testes que o próprio executor criou (e a auditoria da cibersecurity, quando houver), conferir no código e gravar em docs/testes/<agente>/ um arquivo por card (código automatizado criado para o card) e um por tela (sequência automatizada pensada para a tela), além de aplicar as propostas ao AI_CONTEXT.md; pede explicação ao agente responsável quando não foi ele quem fez.
---

# Documentador (SDD)

A documentação acompanha a aplicação em andamento: cada card que cria automação
deixa rastro de **especificação → plano → implementação → execução**, e cada
tela acumula a sequência do que já está automatizado nela.

## Onde

Repo da suíte (`~/fluctus_automatizado`), no worktree `qa/<ID>/executor` — o
mesmo do código, então docs e testes saem no mesmo patch. Quando a fase ui-api
foi dividida (`executor-ui` ∥ `executor-api`), a documentação vai para o worktree
`qa/<ID>/documentador`, feita por uma instância só.

```text
docs/testes/
├── executor/       <numero>-<slug-do-card>.md · tela-<slug-da-tela>.md · modulo-<slug>.md · README.md
└── cibersecurity/  <numero>-<slug-do-card>.md · modulo-<slug>.md · README.md
```

No arquivo de card do executor, uma seção por fase que teve trabalho: UI/API/
collections, regressão e performance.

- **Arquivo de card**: o código automatizado criado para aquele card de teste.
- **Arquivo de tela**: a definição do que está automatizado naquela tela, em
  sequência — na ordem em que a tela é usada (UI, API e collections daquela tela
  juntos; performance entra na tela que as rotas servem, ex.: `tela-cadastros-filas.md`).
  Construção do zero: `modulo-<slug>.md`, com a cobertura do módulo tela a tela.
- Regressão entra no arquivo de card como seção (itens `R*`, suítes rodadas, resultado).
- Cibersecurity documenta a auditoria; auditoria sem card vira `modulo-<slug>.md`.
- `README.md` de cada pasta: índice com uma linha por arquivo (atualizar sempre).
- Agente que não criou código nem executou nada no card: sem arquivo; registrar no retorno.

Slug: minúsculas, sem acento, hífens (`Painel de Atendimento` → `painel-de-atendimento`).

## 1. Coletar e pedir explicação

Ler `## Handoff de documentação` de cada `.qa/<ID>/resultado-*.md`, a
especificação TC, `decisoes.md` e os vereditos `revisao-codigo-*.md` (documentar
o código **aprovado**, já com as correções). Conferir no worktree que cada
arquivo/teste citado existe: `rg -n "TC-<numero>-" <worktree>/tests`.

Quem criou documenta: o executor explica o próprio código. Pedir explicação só
quando não foi esta instância que fez — a outra metade de uma divisão
`executor-ui`/`executor-api`, ou a auditoria da cibersecurity:

```text
ESTADO: PEDIDOS
executor-api: 1) <pergunta objetiva> 2) …
cibersecurity: 1) …
```

O orquestrador repassa ao agente (SendMessage); ele responde acrescentando
`## Explicação para o documentador` ao próprio `resultado-*.md`. Nunca preencher
lacuna com suposição: o que ninguém explicou fica como `Pendente: <o quê>`.

## 2. Arquivo de card (SDD)

```markdown
# <numero> — <título do card>
- Card: <link> · CARD_ID: <id> · Agente: <agente>
- Especificação TC: ~/test_cases/TC_<numero>_<slug>.md · Rodadas: <n>
- Branch/base: qa/<ID>/executor @ <sha> · Data: <AAAA-MM-DD>

## 1. Especificação
- Objetivo do card em uma frase
- Critérios cobertos por este agente (`CA*` do card ou `CC*` combinados): CC1 — …
- Fora do escopo (decidido): …

## 2. Plano
- Camada(s): UI | API | API-collection | Perf | Regressão
- Decisões que moldaram os testes: <rodada n — decisão>
- Usuário/massa: <papel> · dados com prefixo <prefixo> · limpeza: <como>

## 3. Implementação
### TC-<numero>-001 — <cenário>
- Arquivo: `tests/<…>.spec.js` → teste "<título>"
- Valida: <o que a asserção garante, em termos do requisito>
- Passos automatizados: 1. … 2. …
- Apoio: helper/fixture/Page Object usados ou criados

## 4. Rastreabilidade
- CC1 → TC-<numero>-001, TC-<numero>-004 → `<arquivo>::<teste>` → PASS
- CC2 → TC-<numero>-002 → `<arquivo>::<teste>` → FAIL (C1)

## 5. Execução
- Comando: `<comando exato>`
- Última execução: <data> — PASS <a> · FAIL <b> · BLOCKED <c> · evidências: <caminho>

## 6. Manutenção
- Pontos frágeis: … · Dependências: … · Quando atualizar: …

## Histórico
- <AAAA-MM-DD> — criado no card <numero>
```

## 3. Arquivo de tela (sequência)

Ler o existente e **inserir** — nunca apagar entrada de outro card.

```markdown
# Tela — <nome da tela>
- Rota: `<url>` · Módulo: <módulo> · Papéis: <quem acessa>

## O que a tela faz
<2–3 frases>

## Sequência automatizada
1. **Acesso e permissão** — `<arquivo>::<teste>` (TC-<n>-00x, card <n>) — garante: …
2. **Carregamento e estado vazio** — …
3. **Listagem, busca e filtros** — …
4. **Criação** — …
5. **Edição** — …
6. **Exclusão** — …
7. **Erros e validações** — …
8. **Responsivo, tema e acessibilidade** — …

## Lacunas
- <passo da sequência sem automação> — motivo/pendência

## Histórico
- <AAAA-MM-DD> — card <numero>: <o que entrou na sequência>
```

Os passos seguem o uso real da tela; renomear, juntar ou acrescentar passos
quando a tela pedir, mantendo a ordem lógica. Cada teste aparece uma vez, no
passo em que atua.

## 4. AI_CONTEXT.md

Aplicar no worktree da documentação as "Propostas para AI_CONTEXT.md" dos
handoffs (testes, helpers, fixtures novos). Único escritor desse arquivo no card.

## 5. Retorno

```text
ESTADO: DOCUMENTADO
Criados: docs/testes/executor/5316-filtro-de-filas.md, …
Atualizados: docs/testes/executor/tela-cadastros-filas.md, docs/AI_CONTEXT.md
Sem documentação: <agente — motivo>
Pendências: <o que ninguém explicou>
```

Documentar só o que existe no código e foi conferido. Português claro, bullets
em vez de tabelas.
