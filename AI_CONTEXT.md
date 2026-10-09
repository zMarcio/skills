# Estado do pacote de skills

Atualização: 2026-09-26. Preferências originais em AGENT.md preservadas; AGENTS.md
introduz o workflow autossuficiente em agents/WORKFLOW.md. Onze perfis: oito
originais e Explorer, Spec Writer, Integrator. Três skills locais cobrem specs,
worktrees e evidências. Configuração Codex preparada para gpt-6-luna/max.

Spec: specs/workflow/WORKFLOW-LUNA-001.md. Auditoria independente Luna 6 max
identificou lacunas de autonomia, ownership e registro; revisão final independente realizada; ambiguidades de roteamento e adaptador corrigidas.
O pacote também foi aplicado ao Find preservando seu histórico e guardrails.
O usuário autorizou commit no Find; não foi solicitado commit neste pacote nem push.

Atualização 2026-10-08 (QA-AGENTES-004): /qa-card, /qa-modulo e /qa-ciber só no
Claude Code com três agentes — planejador (leitor, verificador, mapa de regressão,
questionador/test-planner), executor (UI/API/collections, regressão em worktree
próprio, performance, documentação) e revisor (spec-reviewer, revisão de código,
escritor/bug-drafter) — mais cibersecurity sob demanda. Skills por fase em
.agents/skills/qa-*; mapa de fases em qa-fluctus. Skills externas aprovadas em
specs/workflow/QA-SKILLS-003.md (scripts/instalar-skills-qa.sh). Critérios: CA do
card ou CC combinados na rodada 1. Branch: features/agents-marcio.

Atualização 2026-10-09 (QA-INTEGRADOR-005): quarto agente de QA, integrador —
revisão profunda e otimização do código aprovado (sem mudar comportamento),
pertinência de cada teste frente aos TCs, integração das frentes no worktree
`integracao` com reparo de conflitos, verificação pre-push e merge; avulso via
/qa-integrar. Commit, merge e push só com autorização.
