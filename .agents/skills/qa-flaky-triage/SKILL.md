---
name: qa-flaky-triage
description: Diagnosticar teste automatizado instável (flaky) — reproduzir, classificar a causa (espera, dados, ordem, ambiente, produto) e corrigir sem mascarar.
---

# Triagem de teste instável

1. **Reproduzir a taxa**: `npx playwright test <arquivo> -g "<nome>" --repeat-each=20 --workers=1`
   e depois `--workers=4`. Anotar falhas/execuções em cada modo.
2. **Coletar**: trace, screenshot, console, requests da falha (`show-trace`).
3. **Classificar**:
   - *Espera*: ação antes do elemento/dado estar pronto → trocar por asserção web-first ou `waitForResponse`.
   - *Dados*: nome repetido, registro de outro teste, limpeza incompleta → dados únicos por teste.
   - *Ordem/paralelismo*: só falha com vários workers → estado compartilhado; isolar.
   - *Ambiente*: timeout de rede, serviço lento → registrar; não é bug do produto até provar.
   - *Produto*: race condition real (duplo clique duplica, lista pisca) → **é bug**; abrir card com `qa-bug-card`.
4. **Corrigir a causa**. Proibido: `waitForTimeout`, aumentar timeout global, `retries`
   para esconder, `test.skip` sem card vinculado.
5. **Confirmar**: repetir o passo 1; 0 falhas em 20 execuções nos dois modos.

Se não houver correção possível agora: `test.fixme()` com link do card e motivo,
e registrar no relatório como cobertura pendente.
