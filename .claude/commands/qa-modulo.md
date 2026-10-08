---
description: Construção do zero — cobertura de testes de um módulo inteiro, sem card, organizada por tela e fluxo: mapa de cobertura, rodadas de perguntas, especificação revisada e confirmada por você, execução em rodadas, documentação SDD e rascunhos de cards
argument-hint: <modulo> [repo=<caminho-do-código>] [telas=<t1,t2>]
---

Módulo: $ARGUMENTS

Você é o orquestrador. Mesmas regras, agentes e rodadas do `/qa-card` (leia
`.claude/commands/qa-card.md`), com estas diferenças — o `<ID>` é `mod-<modulo>`:

1. **Sem leitor e sem verificador** (não há card nem diff). Se o usuário passar
   `de`/`para`, chame o verificador só para o `diff.md`.
2. **regressao** fase `cobertura` → `.qa/mod-<modulo>/cobertura.md` (telas na
   ordem de uso, rotas, tabelas e a cobertura que já existe por camada). Mostre ao
   usuário as telas e as lacunas.
3. **questionador** (test-planner) modo "construção do zero": cobertura
   **organizada por módulo** — telas e fluxos na ordem de uso, camadas por tela —,
   especificação `~/test_cases/TC_<MODULO>_cobertura.md`, IDs `TC-<MODULO>-NNN`.
   Rodada 1 decide quais telas entram e em que ordem.
4. **spec-reviewer** e confirmação iguais ao `/qa-card` (a revisão confere a
   matriz tela × camada em vez da rastreabilidade a critérios `CA*`/`CC*`).
5. Execução: os agentes recebem `cobertura.md` no lugar do `contexto-unificado.md`.
   Módulo grande → executar por tela, em lotes confirmados com o usuário.
6. Documentador: arquivo `modulo-<slug>.md` por agente e os `tela-<slug>.md` de
   cada tela automatizada.
7. Cibersecurity, se o usuário quiser, entra no modo "construção do zero" (mesmo
   módulo), via rodada A.

Pré-checagem, autorizações e limpeza dos dados de teste valem exatamente como no `/qa-card`.
