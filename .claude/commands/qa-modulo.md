---
description: Construção do zero — cobertura de testes de um módulo inteiro, sem card, organizada por tela e fluxo, com os agentes planejador, executor, revisor e integrador: mapa de cobertura, rodadas de perguntas, especificação revisada e confirmada por você, execução em rodadas, revisão de código, documentação SDD e rascunhos de cards
argument-hint: <modulo> [repo=<caminho-do-código>] [telas=<t1,t2>]
model: claude-opus-5-5
---

Módulo: $ARGUMENTS

Você é o orquestrador. Mesmas regras, agentes e rodadas do `/qa-card` (leia
`.claude/commands/qa-card.md`), com estas diferenças — o `<ID>` é `mod-<modulo>`:

1. **planejador** começa na fase `mapa`, modo cobertura → `.qa/mod-<modulo>/cobertura.md`
   (telas na ordem de uso, rotas, tabelas e a cobertura que já existe por camada).
   Sem fase `contexto` (não há card); se o usuário passar `de`/`para`, ele faz só o `diff.md`.
   Mostre ao usuário as telas e as lacunas.
2. **planejador**, fase `perguntas`, modo "construção do zero": cobertura
   **organizada por módulo** — telas e fluxos na ordem de uso, camadas por tela —,
   especificação `~/test_cases/TC_<MODULO>_cobertura.md`, IDs `TC-<MODULO>-NNN`.
   Rodada 1 decide quais telas entram e em que ordem.
3. **revisor**, fase `spec`, e confirmação iguais ao `/qa-card` (a revisão confere a
   matriz tela × camada em vez da rastreabilidade a critérios `CA*`/`CC*`).
4. Execução: o executor recebe `cobertura.md` no lugar do `contexto-unificado.md`.
   Módulo grande → executar por tela, em lotes confirmados com o usuário.
5. Documentação: `modulo-<slug>.md` e os `tela-<slug>.md` de cada tela automatizada,
   em `docs/testes/executor/`.
6. Cibersecurity, se o usuário quiser, entra no modo "construção do zero" (mesmo
   módulo), na rodada A.

Pré-checagem, autorizações, limpeza dos dados de teste, revisão de código e as
fases do integrador (otimizar, integrar, pre-push) valem exatamente como no `/qa-card`.
