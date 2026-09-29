---
name: qa-bug-card
description: Escrever card de bug em português no formato fixo do time (Título, Ambiente, Passos, Comportamento atual/ideal, Hipótese de causa raiz, Evidências, Severidade), em markdown dentro de bloco de código.
---

# Card de bug

## Antes de escrever

- Reproduzir ao menos 2 vezes; registrar frequência (sempre, 3/5, intermitente).
- Reduzir aos passos mínimos. Remover passos que não mudam o resultado.
- Confirmar que não é falha de ambiente (serviço fora, dado de teste inválido).
- Procurar duplicata no backlog antes de abrir.

## Formato (ordem fixa, não alterar)

Entregar em bloco de código markdown. Usar bullets, não tabelas.

```markdown
## Título
<Módulo> — <sintoma curto e específico>

## Ambiente
- URL/ambiente:
- Versão/branch/commit:
- Navegador/cliente:
- Usuário/perfil de teste:

## Passos para reprodução
1.
2.

## Comportamento atual
-

## Comportamento ideal
-

## Hipótese de causa raiz
- <hipótese> — evidência que sustenta: <log, request, query>

## Evidências
- Print/vídeo:
- Request/response (sanitizado):
- Log/console:

## Severidade
<Crítica|Alta|Média|Baixa> — <impacto em uma linha>
```

## Severidade

- **Crítica**: perda/corrupção de dados, exposição, fluxo essencial indisponível.
- **Alta**: requisito essencial falha sem alternativa.
- **Média**: falha parcial com contorno.
- **Baixa**: visual/interação com impacto pequeno.

Hipótese de causa é hipótese: indicar a evidência e não afirmar sem prova.
Sanitizar tokens, telefones, e-mails e nomes reais das evidências.
