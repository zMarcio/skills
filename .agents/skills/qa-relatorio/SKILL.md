---
name: qa-relatorio
description: Consolidar o relatório final de QA de um card — casos executados, passou/falhou/bloqueado, regressão, integridade de dados, bugs abertos e parecer.
---

# Relatório final de QA

Consolidar somente o que foi executado. Não arredondar "bloqueado" para "passou".

```markdown
# QA — <título do card>

- Card: <link>
- Ambiente / versão: <url> / <commit|build>
- Data: <AAAA-MM-DD>
- Parecer: Apto | Apto com ressalvas | Não apto | Inconclusivo

## Resumo
- Casos: <total> — PASS <a> · FAIL <b> · BLOCKED <c> · NÃO EXECUTADO <d>
- Por camada: UI <a> · API <b> · API-collection <c> · Perf <d> · Regressão <e>
- Revisão da especificação: <veredito> · ressalvas: <n>
- Critérios (`CA*` do card ou `CC*` combinados): <atendidos>/<total>
- Regressão: <módulos> — <resultado>
- Integridade de dados: <ok | falhas | não aplicável>
- Bugs abertos: <n> (<críticos> críticos)

## Casos executados
- TC-5316-001 (CC1, UI) — PASS — <evidência>
- TC-5316-002 (CC2, API) — FAIL · BUG_APLICACAO — C1

## Regressão
- <módulo> — <suíte/comando> — <resultado>

## Integridade de dados
- <verificação> — <resultado>

## Performance
- <rota> — p95 · erro % · thresholds · baseline (ou "não aplicável")

## Segurança
- <achado> — confirmada por código | reproduzida | suspeita — severidade (ou "não aplicável")

## Documentação
- docs/testes/<agente>/<arquivo>.md — criado | atualizado

## Limpeza de dados
- <frente> — criados <n> · removidos <n> · sobra: <IDs ou "nenhuma">

## Bugs abertos
- BUG-01 — <título> — <severidade> — <link>

## Cobertura pendente e riscos
- <o que não foi testado e por quê>
```

Parecer:

- **Apto**: todos os critérios (CA/CC) passaram e nenhum bug Alto/Crítico aberto.
- **Apto com ressalvas**: critérios ok, bugs Médios/Baixos ou cobertura secundária pendente.
- **Não apto**: critério falhou ou bug Alto/Crítico aberto.
- **Inconclusivo**: bloqueios impedem avaliar critério obrigatório.

O aceite final do produto é do responsável humano; o parecer é técnico.
