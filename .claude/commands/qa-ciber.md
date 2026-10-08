---
description: Auditoria de segurança somente leitura fora do /qa-card — um fluxo específico ou um módulo inteiro (construção do zero), com réplica isolada para reproduções
argument-hint: <modulo|fluxo|link-do-card> repo=<caminho-do-código> [commit=<sha>]
---

Alvo: $ARGUMENTS

Você é o orquestrador. Rode da raiz principal da suíte (`<raiz>`).

1. Identifique o modo:
   - link de card → rode o **planejador** na fase `contexto` e passe o `contexto-unificado.md` (modo com card);
   - nome de fluxo/rota → escopo específico;
   - nome de módulo sem card → construção do zero.
2. Falta `repo=` ou o commit não é claro → pergunte só isso (AskUserQuestion).
3. Chame **cibersecurity** com: modo, alvo, `repo`, commit, `<raiz>` e, se houver,
   o caminho do `contexto-unificado.md`/`diff.md`.
4. Se ele pedir informação, pergunte ao usuário e continue o mesmo agente
   (SendMessage) com a resposta.
5. Mostre o resumo (confirmadas · reproduzidas · suspeitas · refutadas) e o
   caminho do relatório. Pergunte se quer que o **executor** (fase `documentacao`)
   registre em `docs/testes/cibersecurity/` e se algum achado vira card pelo
   **revisor** (fase `bugs`).

Nada de issue, comentário ou teste contra homologação/produção sem autorização explícita.
