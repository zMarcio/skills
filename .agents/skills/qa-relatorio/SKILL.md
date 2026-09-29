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
- Casos: <total> — ✅ <passou> · ❌ <falhou> · ⛔ <bloqueado> · ⏭️ <não executado>
- Critérios de aceite: <atendidos>/<total>
- Regressão: <módulos> — <resultado>
- Integridade de dados: <ok | falhas | não aplicável>
- Bugs abertos: <n> (<críticos> críticos)

## Casos executados
- TC01 (CA1, api) — ✅ — <evidência>
- TC02 (CA2, automatizado) — ❌ — BUG-01

## Regressão
- <módulo> — <suíte/comando> — <resultado>

## Integridade de dados
- <verificação> — <resultado>

## Bugs abertos
- BUG-01 — <título> — <severidade> — <link>

## Cobertura pendente e riscos
- <o que não foi testado e por quê>
```

Parecer:

- **Apto**: todos os CAs passaram e nenhum bug Alto/Crítico aberto.
- **Apto com ressalvas**: CAs ok, bugs Médios/Baixos ou cobertura secundária pendente.
- **Não apto**: CA falhou ou bug Alto/Crítico aberto.
- **Inconclusivo**: bloqueios impedem avaliar CA obrigatório.

O aceite final do produto é do responsável humano; o parecer é técnico.
