# Estado do pacote de skills

Atualização: 2026-09-26. Preferências originais em AGENT.md preservadas; AGENTS.md
introduz o workflow autossuficiente em agents/WORKFLOW.md. Onze perfis: oito
originais e Explorer, Spec Writer, Integrator. Três skills locais cobrem specs,
worktrees e evidências. Configuração Codex preparada para gpt-6-luna/max.

Spec: specs/workflow/WORKFLOW-LUNA-001.md. Auditoria independente Luna 6 max
identificou lacunas de autonomia, ownership e registro; revisão final independente realizada; ambiguidades de roteamento e adaptador corrigidas.
O pacote também foi aplicado ao Find preservando seu histórico e guardrails.
O usuário autorizou commit no Find; não foi solicitado commit neste pacote nem push.

Atualização 2026-10-08 (QA-CARD-002): /qa-card, /qa-modulo e /qa-ciber só no
Claude Code com dez agentes (leitor, verificador, regressao, questionador/
test-planner, spec-reviewer, test-executor, performance, cibersecurity,
documentador, escritor/bug-drafter); contrato comum qa-fluctus; leitor +
verificador geram contexto-unificado.md para os executores; worktrees e rodadas
via qa-worktree-frentes. Absorve test-planner, test-executor, perf-tester e
api-collection-tester. Substitui QA-PERFIS-001. Skills por agente aprovadas em
specs/workflow/QA-SKILLS-003.md (externas via scripts/instalar-skills-qa.sh;
systematic-debugging e verification-before-completion copiadas do superpowers, MIT).
Critérios: CA do card ou CC combinados na rodada 1. Branch: features/agents-marcio.
