---
name: security-findings-report
description: Registrar o resultado de uma auditoria de segurança num relatório curto — por achado, classe (confirmada por código, reproduzida, suspeita não validada), severidade por impacto, local, evidência, impacto e recomendação — mais falsos positivos refutados e cobertura não examinada.
---

# Relatório de achados

Curto. Quem lê precisa saber o que é real, quanto importa e o que fazer.

## Classes (nunca misturar)

- **Confirmada por código**: caminho entrada → uso rastreado no código, controle
  ausente ou contornável demonstrado por leitura (arquivo:linha), `fp-check` passou.
- **Reproduzida**: provada na réplica (`controlled-vulnerability-validation`) com evidência.
- **Suspeita não validada**: indício sem prova; dizer o que falta para validar.

Falso positivo refutado não é achado: vai na lista própria, uma linha cada.

## Severidade

Por impacto e alcance comprovados, não por checklist: Crítica (dados de outra
empresa, execução de código, tomada de conta), Alta (escalada de papel, PII
exposta a usuário autenticado), Média (precisa de condição extra), Baixa
(defesa em profundidade). Suspeita não recebe severidade final — só "potencial".

## Formato

`<saida>/relatorio.md` (com card também copiar como `.qa/<CARD_ID>/resultado-cibersecurity.md`):

```markdown
# Segurança — <alvo>
- Modo: … · Repo @ commit: … · Data: …
- Resumo: <n> confirmadas · <n> reproduzidas · <n> suspeitas · <n> refutadas
- Repo original intacto: sim | não (<detalhe>)

## Achados
### A1 — <título> · <Crítica|Alta|Média|Baixa> · Confirmada por código
- Onde: `src/…/x.controller.js:42` (`PUT /api/x/:id`)
- Evidência: <trecho curto ou referência, sanitizado>
- Impacto: <quem consegue o quê>
- Recomendação: <correção mínima> · Reteste: <como provar a correção>
- Referência: CWE-<n> / OWASP <cat> (só se o mapeamento for sustentado)

### A2 — … · Reproduzida
- Réplica: <sha> · Passos: … · Evidência: <arquivo>

### S1 — … · Suspeita não validada · potencial <Alta>
- Indício: … · Falta para validar: …

## Refutados
- <alerta> — <por que não é real>

## Cobertura
- Examinado: … · Não examinado: … (motivo) · Ampliações: …
```

Sanitizar token, senha, telefone, e-mail, nome real. Não publicar nem abrir
issue: achado de segurança só sai do relatório com autorização do usuário.
