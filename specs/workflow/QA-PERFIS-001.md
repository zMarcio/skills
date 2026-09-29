# QA-PERFIS-001 — perfis e skills de QA

Estado: concluído tecnicamente; sem commit/push autorizado.

## Pedido e autorização

Em 2026-09-29 o usuário pediu skills de QA baseadas no trabalho real (Fluctus:
Playwright, Postman/Bruno, k6, PostgreSQL, cards de bug V25), cinco perfis de QA
(integração, automatizado, API, exploratório, regressão), um agente por perfil
com skills para implementar, testar e verificar, e o comando `/qa-card` com as
etapas card-reader, test-designer, test-executor, regression-runner,
integrity-checker e bug-reporter.

## Decisões

- Perfis são especializações do QA existente, não novos papéis de decisão;
  herdam limites, severidade e handoff de agents/qa/QA.md.
- Etapas do `/qa-card` ficam em agents/qa-pipeline/ e delegam aos perfis.
- Skills em `.agents/skills/qa-*`; `.claude/skills` é link para o mesmo diretório.
- Registros duplos: `.codex/agents/*.toml` (Luna 6 max) e `.claude/agents/*.md`
  (modelo herdado da sessão). card-reader, test-designer e bug-reporter são
  somente leitura.
- Sem IDs de workspace, URLs internas ou dados reais versionados nas skills.
- Card de bug segue o formato fixo do usuário (português, bloco de código).

## Aceite

1. Cinco perfis e seis etapas existem, com frontmatter válido e registros Codex/Claude.
2. Todas as skills citadas nos perfis existem; todos os links relativos resolvem.
3. TOML válido; nomes de agente únicos.
4. `/qa-card` preserva o texto do usuário e define paralelismo, bloqueios e relatório.

Validação: `python3 scripts/validar-pacote.py`.
