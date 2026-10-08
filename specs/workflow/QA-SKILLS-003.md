# QA-SKILLS-003 — skills por agente

Estado: **aprovada pelo usuário em 2026-10-08**, menos `spec-to-code-compliance`
(o card normalmente não tem critério de aceite) e `reviewing-test-plan`.
Pesquisa em 2026-10-08. Fluxo e agentes: [QA-CARD-002](QA-CARD-002.md).

Como ficou ligado:

- skills nossas → `skills:` do agente (pré-carregadas);
- externas → listadas no agente como "sob demanda" (ferramenta `Skill`) ou, no
  caso do `gh-cli`, como plugin que age sozinho (hooks);
- `systematic-debugging` e `verification-before-completion` (superpowers, MIT)
  copiadas para `.agents/skills/` com `LICENSE` e `NOTICE.md`;
- demais externas → `scripts/instalar-skills-qa.sh <projeto>` (tem `--dry-run`).

Skill externa não instalada não trava o agente: ele segue e registra a ausência.

## Por agente

### 1. Leitor

* Entrada: receba o link do card do GitHub (issue, PR ou item de Project) e leia corpo, comentários, labels, PRs e commits vinculados e anexos.
* Foco: extraia objetivo, tipo, critérios de aceite quando existirem, comportamento pedido, regras de negócio, módulos, camadas, ambiente e massa.
* Sem critério de aceite (o comum): registre a ausência e liste o comportamento pedido — os critérios são combinados com você na rodada 1.
* Somente leitura: use o gh só para ler; não comente nem altere o card.
* Resultado: grave o contexto em .qa/<card>/contexto.md e repasse o código vinculado ao Verificador, que une as duas informações.

Skills: `qa-leitor-card` (nossa) · `gh-cli` (Trail of Bits, plugin).

### 2. Verificador

* Intervalo: compare o commit anterior com o atual, ou base/head do PR do card, ou o intervalo que eu informar.
* Análise: classifique o diff por área e aponte o que foi além do card, com o grep que sustenta cada impacto.
* União: junte o contexto do Leitor com o diff num contexto unificado (pedido × código, riscos, impacto e foco por agente).
* Repasse: o contexto unificado é o que todos os agentes de execução recebem junto com a especificação.
* Somente leitura: sem checkout, reset, stash ou edição de código.

Skills: `qa-verificador-diff` (nossa) · `gh-cli` (plugin).

### 3. Regressão

* Com card: monte os itens de regressão a partir do contexto unificado — telas, rotas, tabelas e componentes afetados e seus consumidores.
* Construção do zero: mapeie a cobertura do módulo tela a tela, por camada.
* Cobertura existente: cruze com a suíte, as collections, os docs de tela, os casos antigos e os bugs já corrigidos; aponte as lacunas.
* Visualização: mostre o mapa com prioridade antes das perguntas, para o escopo ser decidido.
* Execução: depois da confirmação, rode os itens escolhidos, compare com baseline e separe falha nova de preexistente.
* Somente leitura: não cria nem edita testes; lacuna vira sugestão de caso.

Skills: `qa-regressao` (nossa) · `playwright-cli` (Microsoft) ·
`playwright-regression-testing` (fugazi) · Flaky Test Doctor (qaskills) ·
`systematic-debugging` · `verification-before-completion`.

### 4. Questionador (test-planner)

* Com card: mantenha o foco no fluxo solicitado e suas dependências.
* Construção do zero: organize a cobertura por módulo, tela a tela.
* Critérios: card sem critério de aceite é o normal — proponha os critérios combinados para você confirmar, ajustar ou descartar.
* Rodadas: pergunte o que testar, o foco e como; repita até não sobrar dúvida que mude o resultado.
* Especificação: gere o arquivo de casos no formato do test-planner, com pré-checagem, autorizações e limpeza dos dados.
* Roteamento: UI, API e collections para o Test-executor; Perf para a Performance; Regressão para a Regressão.
* Gate: nada é executado sem a revisão do Spec-reviewer e a sua confirmação.

Skills: `qa-questionador` (nossa) · `grilling` (Matt Pocock) · `testing-strategy` (Anthropic, plugin engineering).

### 5. Spec-reviewer

* Casos: confira rastreabilidade aos critérios (do card ou combinados), objetivo único, passos executáveis e resultado observável.
* Dados: confirme que existem no test_users.md, que o faltante tem valor sugerido e que nada usa dado real.
* Pré-requisitos: faça a pré-checagem somente leitura de ambiente, ferramentas, credenciais (só nomes) e arquivos.
* Autorizações e limpeza: exija autorização registrada para o que precisa e limpeza para todo dado criado.
* Resultado: veredito aprovada, aprovada com ressalvas ou bloqueada, com cada bloqueio, dono e como destravar.

Skills: `qa-spec-reviewer` (nossa).

### 6. Test-executor

* Escopo: casos de UI, API e collections confirmados, num worktree próprio (ou dois, UI e API, quando os usuários permitirem).
* Interface: Playwright para fluxo, estados, responsivo, tema, teclado, acessibilidade e regressão visual.
* API: Playwright em tests/api para a regressão versionada; Bruno/Postman/Newman para collections e contratos.
* Qualidade: estabilidade provada com repetição; nunca afrouxe assert, aumente timeout ou pule teste para passar.
* Limpeza: todo dado criado com prefixo e removido no fim, com conferência de sobra.
* Resultado: PASS/FAIL/BLOCKED com classe da falha, falhas para o Escritor e handoff para o Documentador.

Ferramentas: Read, Write, Edit, Bash, Grep, Glob — e `Skill`, para usar as skills aprovadas.

Skills: `qa-executor` (nossa) · `playwright-cli` (Microsoft) ·
`systematic-debugging` · `verification-before-completion` ·
`bruno-test-writer` + `bruno-collection-generator` (Bruno) ·
`accessibility-review` (Anthropic, plugin design). Postman: Postman MCP, pelo orquestrador.

### 7. Performance

* Escopo: casos de Camada Perf ou pedido direto, a partir de ~/k6-fluctus.
* Autorização: smoke roda sem perguntar; carga só com "autorizado rodar carga"; ruptura nunca por iniciativa própria.
* Execução: login uma vez no setup, RUN_TAG em tudo que cria dado e cleanup sempre ao final.
* Análise: RPS e p95/p99 por rota, comparação com baseline (regressão acima de 20%) e separação entre gargalo da aplicação e do gerador.
* Resultado: resultado-performance.md, com o comando exato do que ficou pendente de autorização.

Skills: `qa-performance-k6` (nossa) · `k6` (Grafana) · `systematic-debugging` · `verification-before-completion`.

### 8. Cibersecurity

* Com card: receba de outro agente o contexto do card do GitHub. Foque no objetivo, regras de negócio e critérios de aceite.
* Escopo específico: analise o fluxo envolvido, suas dependências e proteções. Amplie a investigação quando houver uma relação concreta, explicando o motivo.
* Construção do zero: faça uma avaliação mais ampla por módulo, considerando suas responsabilidades e integrações.
* Somente leitura: preserve código, configurações e dados originais. Faça reproduções práticas numa réplica isolada.
* Eficiência: acione somente as skills e ferramentas relevantes. Peça informações essenciais quando faltarem.
* Resultado: entregue um relatório curto com evidências, impacto e recomendação. Diferencie falhas confirmadas por código, reproduzidas e suspeitas não validadas.

Skills (escolhidas por você): `audit-context-building`, `security-threat-model`,
`static-analysis`, `fp-check`, `differential-review`, `variant-analysis`,
`security-best-practices`, `audit-scope-readonly`, `controlled-vulnerability-validation`,
`security-findings-report` · opcionais: `supply-chain-risk-auditor`, `insecure-defaults`.

### 9. Documentador

* Explicação: peça ao agente responsável que explique o que criou; o que ninguém explicar fica como pendência, nunca suposição.
* Organização: uma pasta por agente em docs/testes/<agente>/.
* Por card: <numero>-<slug>.md com especificação, plano, implementação, rastreabilidade, execução e manutenção; na construção do zero, modulo-<slug>.md.
* Por tela: tela-<slug>.md com a sequência automatizada na ordem de uso da tela, atualizada a cada card sem apagar o que já existe.
* Resultado: documentação no worktree do documentador, entregue junto com os testes; também aplica as atualizações do AI_CONTEXT.md.

Skills: `qa-documentador-sdd` (nossa) · `doc-coauthoring` (Anthropic) · Spec Kit só como referência.

### 10. Escritor (bug-drafter)

* Bugs novos: reúna as falhas confirmadas de todos os agentes; preexistente, ambiente e teste ficam fora.
* Duplicatas: elimine no lote, nas issues do repositório e nos rascunhos de outros cards; issue fechada igual vira reabertura.
* Evidências: confira se existem, estão sanitizadas e mostram o problema; o que faltar sai como pendente.
* Formato: Comportamento atual, Comportamento ideal, Evidência (para os seus prints/vídeo) e Possível causa quando a falha não é visível.
* Publicação: só rascunhos; nada vai para o GitHub sem sua autorização, card a card.

Skills: `qa-escritor-card` (nossa) · `gh-cli` (plugin).

## Descartadas

- `spec-to-code-compliance` (Trail of Bits) — retirada pelo usuário: card normalmente não tem critério de aceite.
- `reviewing-test-plan` (bm629) — retirada pelo usuário.
- Não recomendadas na pesquisa: Playwright Test Agents (healer pode pular teste),
  `webapp-testing` (Python, apps locais), `api-builder` do Postman (constrói API, não roda Newman),
  `regression-testing` do agentic-qe (preso ao framework), `brainstorming` do
  superpowers (sobrepõe o `grilling`), `github-issue-dedupe` da Warp (comenta sozinho; alerta do Snyk).

## Instalação

`scripts/instalar-skills-qa.sh <projeto> [--dry-run]`:

- plugins: `trailofbits` (gh-cli, audit-context-building, static-analysis, fp-check,
  differential-review, variant-analysis, supply-chain-risk-auditor, insecure-defaults),
  `skills-curated` (openai-security-threat-model, openai-security-best-practices),
  `knowledge-work-plugins` (engineering, design);
- `npx skills add`: grilling, k6, playwright-regression-testing;
- `@playwright/cli` + `playwright-cli install --skills`;
- Bruno: clone e cópia local de bruno-test-writer e bruno-collection-generator
  (sem licença declarada — nunca vendorizar no pacote);
- manual: Flaky Test Doctor (slug no qaskills.sh).

Licenças: Trail of Bits CC-BY-SA-4.0; Microsoft, Grafana e Anthropic Apache-2.0;
Matt Pocock, superpowers e Spec Kit MIT; Bruno sem licença declarada.

## Fontes

- [trailofbits/skills](https://github.com/trailofbits/skills) · [marketplace.json](https://raw.githubusercontent.com/trailofbits/skills/main/.claude-plugin/marketplace.json) · [trailofbits/skills-curated](https://github.com/trailofbits/skills-curated)
- [openai/skills (descontinuado)](https://github.com/openai/skills)
- [microsoft/playwright-cli](https://github.com/microsoft/playwright-cli) · [Playwright Test Agents](https://playwright.dev/docs/test-agents)
- [obra/superpowers](https://github.com/obra/superpowers)
- [mattpocock/skills](https://github.com/mattpocock/skills) · [grilling](https://skills.sh/mattpocock/skills/grilling)
- [grafana/skills — k6](https://claudeskills.info/zh-hant/skills/grafana/skills/k6/)
- [Bruno — agent skills](https://blog.usebruno.com/bringing-agent-skills-to-bruno-workflows) · [bruno-agent-skills](https://github.com/bruno-collections/bruno-agent-skills)
- [postmanlabs/skills](https://github.com/postmanlabs/skills) · [Postman MCP](https://github.com/postmanlabs/postman-mcp-server)
- [anthropics/skills](https://github.com/anthropics/skills) · [knowledge-work-plugins](https://github.com/anthropics/knowledge-work-plugins)
- [github/spec-kit](https://github.com/github/spec-kit)
- [playwright-regression-testing](https://claudeskills.info/skills/fugazi/test-automation-skills-agents/playwright-regression-testing/) · [qaskills.sh](https://qaskills.sh/skills)
