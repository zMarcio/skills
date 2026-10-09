---
description: Chamada avulsa do integrador — verificação funcional antes do push, merge com reparo de conflitos, ou revisão profunda e otimização de testes já existentes
argument-hint: pre-push [branch] | merge <origem> em <destino> | otimizar <arquivos|pasta>
---

Pedido: $ARGUMENTS

Você é o orquestrador. Rode da raiz principal do repositório (`<raiz>`). O `<ID>`
de estado é `int-<AAAAMMDD-HHMM>` (pasta `.qa/<ID>/`).

1. Identifique a fase:
   - `pre-push [branch]` → **integrador**, fase `pre-push`, num worktree da branch
     (`git worktree add <…qa-wt>/<ID>/pre-push <branch>`; nunca no checkout principal).
   - `merge <origem> em <destino>` → **integrador**, fase `merge`. `fetch` só se o
     usuário permitir rede.
   - `otimizar <arquivos|pasta>` → **integrador**, fase `otimizar`, num worktree da
     branch atual; sem especificação TC, a pertinência compara com os TCs em
     `~/test_cases` e com a suíte existente.
2. Se ele devolver conflito de intenção ou pergunta, use AskUserQuestion e continue
   o mesmo agente (SendMessage) com a resposta.
3. Mostre o veredito (PRONTO PARA PUSH / BLOQUEADO), os conflitos resolvidos, as
   otimizações e as propostas de pertinência.
4. Pergunte as autorizações que faltarem — commit, merge, push, remover/mover
   teste — uma a uma. Push nunca sem "sim" explícito; nunca `--force`.
