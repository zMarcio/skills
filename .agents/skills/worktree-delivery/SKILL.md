---
name: worktree-delivery
description: Preparar execução paralela isolada em Git worktrees e integrar entregas com ownership e preservação de mudanças locais.
---

# Worktrees para entrega

1. Conferir raiz Git, branch, HEAD, status incluindo untracked e worktrees ativos.
   Registrar alterações anteriores. Selecionar base conhecida; HEAD não inclui
   alterações locais. Se a tarefa depende delas, preparar uma transferência
   seletiva e revisável ou trabalhar sequencialmente no checkout existente.
2. Definir branch, caminho permitido, responsável, aceite e arquivos. Criar com
   `rtk git worktree add -b <branch-nova> <caminho-novo> <base>` substituindo os
   marcadores por valores conferidos. Não reutilizar destino ocupado nem usar
   force/reset/stash para limpar. Respeitar permissões de escrita do ambiente.
3. Confirmar branch/base/cwd antes de editar. Worktrees não isolam banco, portas,
   rede ou processos. Usar fixtures sintéticas e recursos próprios por frente;
   não copiar segredos/dados reais. Contratos e lockfiles têm um único dono.
4. Retornar inventário completo: diff de commits desde a base, staged, unstaged
   e arquivos novos permitidos, com remoções/renomes e evidências. Revisar arquivos
   antes de incluí-los; nunca capturar dados ignorados indiscriminadamente.
5. Sem commit autorizado, preservar o trabalho e preparar patch das alterações
   tracked (`git diff --binary HEAD`) e inventário/cópia seletiva dos novos arquivos.
   Não aplicar esse patch sobre commits já integrados. Com commits autorizados,
   usar o intervalo explícito e entregar também qualquer alteração local restante.
6. GOD atribui candidato e ordem de integração. Conferir base do destino e escopo
   de cada frente antes de merge/cherry-pick/aplicação de patch autorizados. Para
   patches, verificar aplicação antes de modificar. Não duplicar commits/diffs.
   Resolver conflitos com os donos dos contratos. Validar o resultado combinado.
7. Não remover worktrees/branches automaticamente. Registrar destino, evidências,
   limitações e próximo passo. Commit, merge e push têm autorizações distintas;
   reutilizar as que já existem, sem repetir perguntas.

Com capacidade esgotada, concluir frentes e liberar slots antes de novas instâncias.
Um coordenador por branch usa perfis sequenciais se não houver slots adicionais.
