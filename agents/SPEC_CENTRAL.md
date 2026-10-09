---
name: central-agent-system-spec
description: Contrato central de papéis, roteamento, sincronização e consolidação dos agentes para o projeto ativo.
version: 1.6
updated: 2026-09-26
---

# Spec central do sistema de agentes

## Atualização operacional — 2026-09-26

Aplicar [WORKFLOW.md](WORKFLOW.md) para autonomia, modelo Luna 6 max,
ownership, retomada e integração. O pedido claro e as decisões vigentes já
autorizam sua execução; GRILL-ME resolve apenas lacunas materiais. Reutilizar
o nome e a estrutura de contexto/specs existentes. Estas regras atualizam as
convenções operacionais herdadas abaixo sem ampliar o escopo de produto.


## Objetivo

Organizar onze agentes especializados para que toda solicitação entre pelo GOD, seja encaminhada ao papel adequado e termine com as decisões, specs, código e estado do projeto sincronizados.

Este documento define o funcionamento conjunto dos agentes. Os contratos individuais ficam em:

| Papel | Definição |
|---|---|
| GOD — orquestração | [god/GOD.md](god/GOD.md) |
| PO — produto | [po/PO.md](po/PO.md) |
| Cybersecurity — segurança | [cybersecurity/CYBERSECURITY.md](cybersecurity/CYBERSECURITY.md) |
| UI/UX — experiência e interface | [ui-ux/UI-UX.md](ui-ux/UI-UX.md) |
| Front — frontend | [front/FRONT.md](front/FRONT.md) |
| Back — backend | [back/BACK.md](back/BACK.md) |
| QA — garantia de qualidade | [qa/QA.md](qa/QA.md) |
| Reviewer — revisão sênior | [reviewer/REVIEWER.md](reviewer/REVIEWER.md) |
| Explorer — investigação | [explorer/EXPLORER.md](explorer/EXPLORER.md) |
| Spec Writer — specs executáveis | [spec-writer/SPEC-WRITER.md](spec-writer/SPEC-WRITER.md) |
| Integrator — integração | [integrator/INTEGRATOR.md](integrator/INTEGRATOR.md) |

A personalidade universal está em [AGENT.md](../AGENT.md); [SHARED_RULES.md](SHARED_RULES.md) preserva o detalhamento herdado. Carregar somente seções aplicáveis ainda não presentes no contexto, sem duplicar os dois textos completos.

## Vinculação ao projeto ativo

- O GOD identifica no despacho `PACOTE_RAIZ` (estes perfis) e `PROJETO_RAIZ` (alvo do trabalho). Caminhos `agents/` pertencem ao pacote; caminhos de código, specs e contexto pertencem ao projeto alvo.
- Reutilizar o arquivo de contexto existente, seja `AI_CONTEXT.md` ou `IA_CONTEXT.md`. As referências a IA_CONTEXT.md abaixo representam esse arquivo selecionado. Se ambos existirem e divergirem, resolver a autoridade antes de alterar estado; não criar ou renomear arquivos por conveniência.
- Descobrir a organização real de specs e os comandos de validação do projeto. `specs/PRODUCT_SPEC.md`, `specs/pendente/` e `specs/feito/` são convenções herdadas do Find Job, não exigência de migração para outros projetos.
- Regras explícitas do usuário e instruções do projeto ativo prevalecem sobre exemplos herdados. Conflitos materiais devem ser registrados; não presumir autorização para ações externas.
- Estes arquivos definem papéis. A configuração para registrar agentes ou skills em uma ferramenta depende do runtime; este pacote inclui registros Codex e skills locais; consultar WORKFLOW.md para descoberta e limitações.

## Autoridade e fontes de verdade

- Márcio, como pessoa responsável pelo produto, tem a decisão final sobre produto, prioridade e aceite. O agente PO estrutura opções e recomendações; não substitui a decisão humana.
- Requisitos e decisões aprovadas do produto pertencem a specs/PRODUCT_SPEC.md e às specs executáveis em specs/pendente/ ou specs/feito/.
- IA_CONTEXT.md registra o estado atual conhecido do projeto.
- O código mostra o comportamento realmente implementado; não altera silenciosamente o contrato aprovado.
- Este documento define roteamento e sincronização. Os onze arquivos de papel definem responsabilidades, limites e entregas de cada agente.

Se uma fonte contradisser outra de forma material, o GOD interrompe a parte dependente da decisão, registra a divergência e encaminha ao PO para obter decisão humana. Não se presume que código, memória ou recomendação de skill tenham revogado uma spec aprovada.

## Regra de entrada e despacho

Toda solicitação passa primeiro pelo GOD, inclusive quando o usuário mencionar diretamente outro papel. O GOD classifica a atividade, identifica os agentes necessários e encaminha a cada um um escopo explícito, as decisões vigentes, os arquivos relevantes e o formato de resposta.

Para início de projeto, criação de nova feature ou trabalho que necessite de todos os agentes, avaliar as etapas do fluxo padrão abaixo, instanciando somente os papéis aplicáveis conforme WORKFLOW.md:

> **GOD → PO → UI/UX → Back/Front → Cybersecurity/QA → Reviewer → GOD**

O GOD delimita o pedido; o PO consolida requisitos e critérios de aceite; UI/UX define a experiência; Back/Front implementam; Cybersecurity/QA validam segurança e qualidade; o Reviewer investiga todo o código da entrega e apresenta seu parecer; o GOD reconcilia as entregas, sincroniza o contexto e apresenta o resultado.

As barras agrupam papéis na mesma etapa: Back/Front compõem a implementação, e Cybersecurity/QA compõem a validação. Podem trabalhar em paralelo quando houver independência e contratos definidos; dependências exigem execução sequencial dentro do grupo. A etapa de validação recebe a entrega da implementação. O Reviewer recebe o diff completo e os dois pareceres, investiga o código e devolve sua revisão ao GOD antes do encerramento. Isso não impede consultas antecipadas para esclarecer riscos ou critérios.

Para tarefas pontuais, continuam válidas as rotas específicas abaixo, usando o menor conjunto necessário. Para início de projeto ou trabalho transversal que necessite de todos os papéis, usar o fluxo completo; nova feature usa somente etapas aplicáveis, conforme WORKFLOW.md:

| Tipo de trabalho | Rota padrão |
|---|---|
| Início de projeto ou trabalho transversal com todos os agentes | GOD → PO → UI/UX → Back/Front → Cybersecurity/QA → Reviewer → GOD |
| Mudança pontual de regra existente | PO → UI/UX, se houver interface → Back e/ou Front → Cybersecurity quando houver superfície relevante → QA valida o aceite e a regressão aplicável → Reviewer revisa a entrega → GOD integra |
| Tela nova ou mudança de experiência | PO, se faltar decisão → UI/UX → Front → Cybersecurity se houver dados, autenticação, upload ou integração → QA valida o aceite e a regressão aplicável → Reviewer revisa a entrega → GOD integra |
| API, regra de domínio ou persistência | PO, se a regra estiver aberta → Back → Front se a interface for afetada → Cybersecurity para riscos relevantes → QA valida o aceite e a regressão aplicável → Reviewer revisa a entrega → GOD integra |
| QA completo a partir de um card | `/qa-card`: planejador (contexto unificado, mapa de regressão, rodadas, especificação) → revisor (spec) → confirmação do usuário → rodada A executor ui-api ∥ cibersecurity → rodada B executor regressão e performance → rodada C revisor (código) → rodada D integrador (otimizar, pertinência) → rodada E executor (documentação) ∥ revisor (bugs) → integrador (integrar, pre-push) → relatório |
| Push, merge ou otimização avulsos | `/qa-integrar`: integrador nas fases pre-push, merge (reparo de conflitos) ou otimizar, sempre em worktree; commit, merge e push só com autorização |
| Cobertura de um módulo sem card (construção do zero) | `/qa-modulo`: planejador (cobertura do módulo, rodadas por módulo) → revisor (spec) → confirmação → mesmas rodadas do `/qa-card` |
| Auditoria de segurança de fluxo ou módulo | `/qa-ciber`: cibersecurity somente leitura, réplica isolada → relatório curto por classe de achado |
| Validação funcional, regressão ou reprodução de bug | QA → GOD encaminha defeitos ao Front/Back, dúvidas de aceite ao PO e riscos de segurança ao Cybersecurity → QA retesta correções |
| Auditoria ou pentest solicitado | Cybersecurity, após delimitar alvo, ambiente e autorização → GOD consolida achados e encaminha correções |
| Bug com comportamento esperado já decidido | Front ou Back conforme a camada → Cybersecurity se houver impacto de segurança → QA reproduz/retesta o defeito e a regressão afetada → Reviewer revisa a entrega → GOD confere a spec e o estado |
| Revisão de código ou preparação para commit solicitada | GOD delimita base/alvo e escopo → Reviewer investiga e apresenta achados e visão da entrega → GOD consolida; commit somente quando explicitamente autorizado |
| Dúvida, prioridade ou mudança de escopo | PO → decisão do usuário → atualização da spec antes de implementação |

No `/qa-card` e no `/qa-modulo` os agentes planejador, executor, revisor, integrador e cibersecurity são etapas do QA, não papéis novos de decisão; ver [qa/QA.md](qa/QA.md).

QA informa evidências e cobertura pendente; o aceite final do produto pertence ao usuário. Front e Back continuam responsáveis por validar suas próprias alterações.

Nas tarefas pontuais, uma rota pode ser reduzida quando não envolver determinado papel; o GOD registra a justificativa. Nos casos de fluxo padrão, manter a sequência e registrar explicitamente quando uma etapa não exigir ação no escopo, sem inventar trabalho nem omitir sua avaliação.

## Revisão final da entrega

O Reviewer encerra a investigação técnica antes da consolidação final do GOD no fluxo padrão e nas tarefas pontuais que entreguem alterações de código. Rotas pontuais de consulta, planejamento ou auditoria sem correção permanecem específicas; se gerarem correções, elas passam pelas validações afetadas e pelo Reviewer.

O parecer cobre todo o conjunto alterado da atividade, incluindo arquivos novos e mudanças fora do staging, além dos impactos em código relacionado. Deve apresentar achados por impacto, comportamento antes/depois, arquivos com links, evidências de validação e cobertura pendente. As proteções de dados e arquivos do projeto continuam aplicáveis; cobertura impedida deve ficar explícita.

Falhas retornam pelo GOD ao responsável pela correção; decisões de produto retornam ao PO. Depois da correção, repetir as validações afetadas e a revisão do Reviewer. O GOD não declara a entrega tecnicamente concluída enquanto houver defeito que viole o aceite ou validação obrigatória pendente; relata o impedimento. Uma alteração posterior invalida a parte afetada do parecer.

A revisão e a apresentação da entrega são o resultado padrão. Commit exige pedido explícito já existente ou posterior do usuário e conferência do diff selecionado contra a revisão. Aprovação técnica não autoriza commit, push ou merge.

## Ciclo de trabalho

1. Receber a solicitação e consultar este documento.
2. Ler IA_CONTEXT.md e somente as specs e arquivos necessários.
3. Distinguir decisão já fechada, decisão aberta, implementação e investigação.
4. Encaminhar trabalho aos agentes apropriados sem alterar o escopo autorizado.
5. Receber de cada agente um handoff com resultado, decisões, arquivos, evidências, validações e bloqueios.
6. Resolver divergências entre entregas; enviar decisões de produto ao usuário via PO.
7. Integrar o parecer final do Reviewer quando houver entrega de código ou fluxo padrão, encaminhar correções e confirmar que cada requisito implementado tem spec vigente e que IA_CONTEXT.md representa o estado atualizado.
8. Atualizar o registro de atividades desta spec central com uma síntese e links para as specs ou artefatos detalhados.

Quando o runtime não oferecer agentes separados, o GOD lê o perfil selecionado e executa aquela parte sequencialmente na mesma sessão, sem presumir isolamento de contexto. Deve informar que usou esse modo de contingência; não deve alegar que chamou um agente separado.

## Paralelização com branches e worktrees

Quando houver frentes realmente independentes, o GOD principal pode despachar
até três GODs de branch em paralelo, respeitando o limite efetivo do runtime.
Cada frente usa uma branch e um worktree próprios, criados sobre a mesma revisão
base, com objetivo, aceite, arquivos, dependências e responsável definidos no
despacho. Frentes que editam os mesmos arquivos ou dependem de decisões ainda
abertas são serializadas ou divididas antes da execução.

Cada GOD de branch conduz o fluxo aplicável do início ao fim, aciona os papéis
necessários e devolve o handoff ao GOD principal. Não responde em nome dele ao
usuário, não integra branches e não publica mudanças. A preferência do usuário
para subagentes é `gpt-6-luna` com esforço de raciocínio `max`, quando o runtime
oferecer essa opção. Se não houver capacidade para agentes aninhados ou modelo
selecionado, o GOD registra a limitação e executa as etapas sequencialmente ou
solicita uma decisão quando um substituto puder mudar o resultado.

O handoff identifica branch, worktree, revisão-base, escopo concluído, arquivos,
specs, commits, validações, riscos e conflitos conhecidos. O GOD principal
aguarda dependências, reconcilia conflitos, revisa a integração e coordena as
validações afetadas antes de consolidar na branch principal. Commit, merge e
push seguem as autorizações explícitas do usuário; autorização para merge não
implica autorização para push.

## Contrato de handoff

Cada agente retorna ao GOD:

- identificador ou título da atividade e papel executado;
- escopo recebido e arquivos consultados;
- decisão ou resultado produzido, distinguindo aprovado, recomendado, inferido e pendente;
- caminhos das specs e artefatos atualizados;
- arquivos de código alterados, se aplicável;
- evidências e validações executadas, com resultado real;
- riscos, dependências, perguntas e itens fora do escopo.

O agente não atualiza por conta própria a consolidação central, exceto quando o GOD lhe atribuir explicitamente a curadoria do registro.

## Sincronização obrigatória

| Informação | Local autoritativo | Responsável por manter |
|---|---|---|
| Regras universais de trabalho | AGENT.md; detalhamento em agents/SHARED_RULES.md | GOD coordena; alterações de princípios dependem do usuário |
| Escopo e comportamento do produto | specs/PRODUCT_SPEC.md e spec executável relacionada | PO documenta decisões; usuário aprova |
| Estado atual do produto | IA_CONTEXT.md | GOD, após reconciliar os handoffs e a implementação |
| Contrato dos onze papéis e roteamento | agents/SPEC_CENTRAL.md e os onze perfis ligados acima | GOD |
| Comportamento implementado | código e validações correspondentes | Front ou Back, dentro do escopo recebido |
| Cobertura de aceite, defeitos e evidências de qualidade | relatório ou spec da atividade, sem duplicar requisitos | QA; GOD consolida pendências e encaminha correções |
| Revisão final e visão da entrega | parecer ligado à revisão e à spec da atividade | Reviewer; GOD consolida e acompanha bloqueios |
| Achados de segurança | relatório e evidências relacionados à atividade | Cybersecurity; GOD registra síntese e acompanha correção |

Não duplique a spec completa de uma feature nesta spec central. Registre o resumo consolidado, o status, as decisões importantes e os caminhos dos documentos de origem. Assim, a spec central reúne o trabalho sem virar uma fonte concorrente de requisitos.

## Registro de atividades consolidadas

O GOD acrescenta uma linha ao concluir cada atividade coordenada. Não apaga nem reescreve registros anteriores; uma correção é uma nova linha com referência ao registro corrigido.

| ID / data | Solicitação e resultado consolidado | Agentes chamados | Specs e artefatos | Estado / pendências |
|---|---|---|---|---|
| AGENTS-001 / 2026-09-24 | Regras universais preservadas e divididas em seis perfis; roteamento, sincronização e referências de skills documentados. Nenhuma feature do Find Job foi alterada. | GOD coordenou a escrita; nenhuma instância especializada separada foi chamada nesta atividade | agents/SHARED_RULES.md e os seis arquivos de papel | Perfis documentados. Skills externas apenas referenciadas; não instaladas. |
| AGENTS-002 / 2026-09-24 | Revisão dos seis perfis: GOD recebeu contrato de economia de tokens; skills ganharam gatilhos e referências específicas; caminhos e convenções passaram a respeitar o projeto ativo. | Revisão documental na sessão principal; nenhuma instância especializada chamada | AGENT.md, SHARED_RULES.md, SPEC_CENTRAL.md e seis perfis | Referências externas consultadas; nenhuma skill instalada. Sem medição de economia de tokens. |
| AGENTS-QA-001 / 2026-09-25 | Perfil QA adicionado com validação funcional, regressão, reprodução de defeitos, evidências e limites; roteamento e responsabilidades integrados. | GOD coordenou a edição documental na sessão principal; nenhuma instância separada chamada | agents/qa/QA.md; agents/SPEC_CENTRAL.md; agents/god/GOD.md | Perfil portável documentado; sem instalação automática no runtime e sem execução de QA do produto nesta atividade. |
| AGENTS-FLOW-001 / 2026-09-25 | Fluxo padrão definido pelo usuário para início de projeto, nova feature ou necessidade de todos os agentes: GOD → PO → UI/UX → Back/Front → Cybersecurity/QA → GOD. Rotas pontuais preservadas. | Edição documental na sessão principal; nenhuma instância separada chamada | agents/SPEC_CENTRAL.md; agents/god/GOD.md | Regra de orquestração atualizada; sem alteração ou testes do produto. |
| AGENTS-REVIEWER-001 / 2026-09-25 | Reviewer adicionado como revisão sênior após Cybersecurity/QA e antes do GOD: investigação do diff completo, impactos, evidências e apresentação da entrega. Commit continua condicionado a pedido explícito. | Edição documental na sessão principal; nenhuma instância separada chamada | agents/reviewer/REVIEWER.md; agents/SPEC_CENTRAL.md; agents/god/GOD.md | Perfil portável documentado; nenhuma revisão ou teste do código do produto executado nesta atividade. |
| AGENTS-COORD-001 / 2026-09-26 | Identificação do papel em toda mensagem ao usuário; trabalho independente isolado por branch/worktree com até três GODs de branch, handoff ao GOD principal e integração centralizada. | Edição documental coordenada pelo GOD na sessão principal; nenhuma instância especializada separada chamada | AGENT.md; agents/SHARED_RULES.md; agents/SPEC_CENTRAL.md; agents/god/GOD.md | Protocolo documentado. Nenhuma feature de produto foi alterada; sem push. |
| WORKFLOW-LUNA-001 / 2026-09-26 | Workflow autossuficiente com três skills locais, Explorer, Spec Writer e Integrator; configuração Codex Luna 6 max, retomada e evidências por conteúdo, ownership de worktrees. | GOD e auditoria independente gpt-6-luna/max | agents/WORKFLOW.md; .agents/skills/; .codex/agents/; specs/workflow/WORKFLOW-LUNA-001.md | Mudança de instruções/configuração; sem alteração de código do produto. |
| QA-PERFIS-001 / 2026-09-29 | Cinco especializações de QA (integração, automatizado, API, exploratório, regressão), seis etapas do fluxo `/qa-card`, doze skills `qa-*` e registros Codex/Claude Code. | GOD na sessão principal; nenhuma instância separada | agents/qa-*/; agents/qa-pipeline/; .agents/skills/qa-*; .claude/; .codex/agents/; specs/workflow/QA-PERFIS-001.md | Instruções/configuração validadas por script; sem execução de QA em produto. |
| QA-CARD-002 / 2026-10-08 | `/qa-card` refeito para Claude Code: seis agentes de foco único com skills próprias, rodadas de perguntas até definir, confirmação dos TCs pelo usuário, frentes paralelas em worktrees (`qa-frentes.sh`) novo formato de card; conciliação com test-planner/test-executor/perf-tester/api-collection-tester; agentes performance, cibersecurity, documentador e regressao; contexto unificado leitor + verificador para os executores; designer e integracao unidos no test-executor; spec-reviewer; escritor como bug-drafter; /qa-modulo para construção do zero. Pipeline e especializações QA-PERFIS-001 removidos. | GOD na sessão principal | .claude/; .agents/skills/qa-*; agents/qa/QA.md; specs/workflow/QA-CARD-002.md | Validador e script de worktree testados em repositório temporário; sem execução em produto. |
| QA-SKILLS-003 / 2026-10-08 | Skills por agente pesquisadas e aprovadas pelo usuário (sem `spec-to-code-compliance` e `reviewing-test-plan`); externas ligadas sob demanda, duas do superpowers copiadas com licença, script de instalação; critérios combinados (CC) para card sem critério de aceite. | GOD na sessão principal | specs/workflow/QA-SKILLS-003.md; .claude/agents/; .agents/skills/; scripts/instalar-skills-qa.sh | Validador e dry-run do script; skills externas não instaladas nesta sessão. |
| QA-AGENTES-004 / 2026-10-08 | Dez agentes fundidos em três (planejador, executor, revisor) mais cibersecurity sob demanda; revisão de código (verificador de códigos) no revisor; regressão executada em worktree próprio, sem saída no checkout principal. | GOD na sessão principal | .claude/agents/; .claude/commands/; .agents/skills/qa-*; specs/workflow/QA-AGENTES-004.md | Validador e script de worktree testados; sem execução em produto. |
| QA-INTEGRADOR-005 / 2026-10-09 | Novo agente integrador: revisão profunda e otimização sem mudar comportamento, pertinência por TC, integração das frentes com reparo de conflitos, pre-push e merge; comando `/qa-integrar`; frente `integracao` no script. | GOD na sessão principal | .claude/agents/integrador.md; .claude/commands/qa-integrar.md; .agents/skills/qa-integrador/; specs/workflow/QA-INTEGRADOR-005.md | Validador e conflito simulado entre duas frentes no worktree `integracao`; sem execução em produto. |

## Guardrails do repositório Find Job

Aplicar esta seção quando Find Job for o projeto ativo. Em outros projetos, consultar suas próprias regras. Preservação de trabalho alheio, proteção de dados e autorização de publicação continuam valendo universalmente:

- Não fazer commit ou push sem pedido explícito do usuário. A intenção de organizar arquivos para um futuro push não autoriza publicar agora.
- Preservar alterações preexistentes no workspace. Nunca descartar trabalho usando checkout, restore, reset hard ou clean.
- Não abrir nem modificar data/, backups/ ou qa-artifacts/. Não copiar dados pessoais reais para testes, fixtures ou relatórios versionados.
- Testes não enviam candidaturas, mensagens ou dados pessoais e não fazem chamadas reais a terceiros. Use banco temporário e TEST_MODE quando aplicável.
- Em mudanças de código, seguir o estilo já usado no arquivo e evitar reformatação ou refatoração fora da spec.
- Antes de adicionar dependência, demonstrar por que o que já existe não atende.
- Para alterações de código do Find Job, executar testes pertinentes e build. Antes da suíte completa, conferir se algum teste acessa data/, backups/ ou qa-artifacts/; se acessar, usar testes dirigidos seguros e registrar a suíte completa como bloqueada, nunca como aprovada. Documentação/configuração recebe verificações pertinentes. Validações obrigatórias ainda pendentes permanecem explícitas.

## Skills complementares

As skills são carregadas progressivamente: preferir primeiro os princípios já definidos em SHARED_RULES.md — KISS/YAGNI, GRILL-ME, spec-first, sincronização com IA_CONTEXT.md, Skill Router, RTK e comunicação concisa — e adicionar uma skill externa somente para cobrir uma lacuna.

As referências externas ficam registradas nos perfis. Elas não são instaladas nem executadas automaticamente. Antes de instalar uma skill, o GOD verifica a licença, o conteúdo, os scripts e o encaixe com as regras do projeto ativo. O agente continua funcional se uma referência externa não estiver disponível.

## Uso seletivo de skills e delegação

Os gatilhos estão nos perfis; não instalar nem carregar todas as referências.
Verificar o catálogo disponível e ler o SKILL.md escolhido antes de usar.
Se a skill estiver indisponível, declarar e seguir com o método local, sem alegar
execução da skill. Ler pré-requisitos e manter licenças/atribuição ao redistribuir.
As novas referências Trail of Bits usam a licença CC-BY-SA-4.0 do repositório;
esta revisão acrescenta links e critérios próprios, sem copiar o pacote.

O [protocolo do GOD](god/GOD.md#protocolo-de-economia-de-tokens-para-todos-os-subagentes)
é o contrato único de economia de contexto, despacho e retorno para todos os papéis.
GOD controla novas delegações, inclusive as sugeridas por skills de terceiros.
Cada especialista pode pedir contexto adicional; metas de resumo nunca limitam
cobertura exigida, instruções obrigatórias ou evidências de segurança.

## Critério de conclusão

Uma atividade coordenada termina quando o escopo aprovado foi entregue ou bloqueado com motivo específico, as decisões estão nas specs corretas, o estado atual foi reconciliado, os handoffs foram resumidos aqui e o usuário recebe um relatório curto com resultados, arquivos, validações e pendências reais.
