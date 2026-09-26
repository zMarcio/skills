---
name: delivery-evidence
description: Verificar aceite e revisão de uma entrega, vinculando resultados ao conteúdo e ambiente para fechar ou retomar o workflow.
---

# Evidência da entrega

Fixar spec, base, alvo, inventário e alterações locais relevantes. HEAD isolado
não prova identidade de código não commitado. Relacionar cada critério a caminho
ou cenário, comando/passos reais, resultado e ambiente. Para documentação/config,
validar sintaxe, referências e consistência; não executar suíte do produto sem motivo.

Inspecionar scripts antes de executar: respeitar dados protegidos e efeitos externos.
Validação obrigatória incompatível com isolamento fica bloqueada; executar cobertura
segura disponível e registrar o que falta. Não confundir testes dirigidos com suíte
completa, screenshot com interação ou análise estática com pentest.

Reutilizar resultados somente se conteúdo, dependências, ambiente e requisito
continuarem compatíveis. Correção e integração invalidam a cobertura afetada;
retestar esse trecho e impactos. Não repetir toda suíte sem mudança ou suspeita nova.

Reviewer recebe o conjunto completo e procura defeitos com cenário/evidência,
incluindo impactos além do diff. Separar confirmado, hipótese e melhoria opcional.
Correções voltam ao dono; revisão independente exige instância distinta. Se não
houver, registrar autorrevisão. Não criar achados cosméticos para justificar rodada.

Resultado: apto no escopo coberto / requer correções / inconclusivo. Informar
cobertura não executada e falhas preexistentes sem ocultá-las. GOD atualiza estado
e contexto após reconciliar handoffs; aptidão técnica não autoriza publicação.
