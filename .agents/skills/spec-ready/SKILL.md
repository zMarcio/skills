---
name: spec-ready
description: Transformar pedido autorizado em spec executável com aceite, contratos e tarefas independentes antes de implementar ou delegar.
---

# Spec pronta para execução

Leia pedido, spec vigente e contexto. Preserve decisões existentes; GRILL-ME só
para lacunas materiais. Um pedido claro já autoriza seus requisitos, sem aprovação
extra do documento. Investigue o trecho do código que sustenta a viabilidade.

Atualize a spec existente ou crie a menor spec suficiente. Registre:

- Objetivo e origem da decisão; comportamento atual e desejado; dentro/fora.
- Entradas, saídas, estados e falhas pertinentes. Contratos compartilhados antes
  de implementar em paralelo; não inventar APIs já existentes.
- Aceite observável: cenário, ação, resultado. Associe cada critério a validação.
- Tarefas completas: dono, arquivos próprios, dependências, saída e verificação.
- Questões materiais pendentes separadas de escolhas técnicas locais.

Uma tarefa está pronta quando nenhuma decisão pendente muda seu comportamento
e suas dependências estão disponíveis. Antecipe specs das próximas tarefas sem
codificar hipóteses. Não gerar PRD, épico e histórias duplicados para ajuste pequeno.
Mudança de regra entregue recebe aditivo datado conforme convenção do projeto.
Retorne link, tarefas prontas e bloqueios ao GOD; só o escritor atribuído edita.
