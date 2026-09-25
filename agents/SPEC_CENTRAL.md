---
name: central-agent-system-spec
description: Contrato central de papéis, roteamento, sincronização e consolidação dos agentes para o projeto ativo.
version: 1.3
updated: 2026-09-25
---

# Spec central do sistema de agentes

## Objetivo

Organizar sete agentes especializados para que toda solicitação entre pelo GOD, seja encaminhada ao papel adequado e termine com as decisões, specs, código e estado do projeto sincronizados.

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

A personalidade universal está em [AGENT.md](../AGENT.md); [SHARED_RULES.md](SHARED_RULES.md) preserva o detalhamento herdado. Carregar somente seções aplicáveis ainda não presentes no contexto, sem duplicar os dois textos completos.

## Vinculação ao projeto ativo

- O GOD identifica no despacho `PACOTE_RAIZ` (estes perfis) e `PROJETO_RAIZ` (alvo do trabalho). Caminhos `agents/` pertencem ao pacote; caminhos de código, specs e contexto pertencem ao projeto alvo.
- Reutilizar o arquivo de contexto existente, seja `AI_CONTEXT.md` ou `IA_CONTEXT.md`. As referências a IA_CONTEXT.md abaixo representam esse arquivo selecionado. Se ambos existirem e divergirem, resolver a autoridade antes de alterar estado; não criar ou renomear arquivos por conveniência.
- Descobrir a organização real de specs e os comandos de validação do projeto. `specs/PRODUCT_SPEC.md`, `specs/pendente/` e `specs/feito/` são convenções herdadas do Find Job, não exigência de migração para outros projetos.
- Regras explícitas do usuário e instruções do projeto ativo prevalecem sobre exemplos herdados. Conflitos materiais devem ser registrados; não presumir autorização para ações externas.
- Estes arquivos definem papéis. A configuração para registrar agentes ou skills em uma ferramenta depende do runtime; este pacote não realiza essa instalação.

## Autoridade e fontes de verdade

- Márcio, como pessoa responsável pelo produto, tem a decisão final sobre produto, prioridade e aceite. O agente PO estrutura opções e recomendações; não substitui a decisão humana.
- Requisitos e decisões aprovadas do produto pertencem a specs/PRODUCT_SPEC.md e às specs executáveis em specs/pendente/ ou specs/feito/.
- IA_CONTEXT.md registra o estado atual conhecido do projeto.
- O código mostra o comportamento realmente implementado; não altera silenciosamente o contrato aprovado.
- Este documento define roteamento e sincronização. Os sete arquivos de papel definem responsabilidades, limites e entregas de cada agente.

Se uma fonte contradisser outra de forma material, o GOD interrompe a parte dependente da decisão, registra a divergência e encaminha ao PO para obter decisão humana. Não se presume que código, memória ou recomendação de skill tenham revogado uma spec aprovada.

## Regra de entrada e despacho

Toda solicitação passa primeiro pelo GOD, inclusive quando o usuário mencionar diretamente outro papel. O GOD classifica a atividade, identifica os agentes necessários e encaminha a cada um um escopo explícito, as decisões vigentes, os arquivos relevantes e o formato de resposta.

Para início de projeto, criação de nova feature ou trabalho que necessite de todos os agentes, o fluxo padrão é sempre:

> **GOD → PO → UI/UX → Back/Front → Cybersecurity/QA → GOD**

O GOD delimita o pedido; o PO consolida requisitos e critérios de aceite; UI/UX define a experiência; Back/Front implementam; Cybersecurity/QA validam segurança e qualidade; o GOD reconcilia as entregas, sincroniza o contexto e apresenta o resultado.

As barras agrupam papéis na mesma etapa: Back/Front compõem a implementação, e Cybersecurity/QA compõem a validação. Podem trabalhar em paralelo quando houver independência e contratos definidos; dependências exigem execução sequencial dentro do grupo. A etapa de validação recebe a entrega da implementação, e o GOD consolida os dois pareceres antes do encerramento. Isso não impede consultas antecipadas para esclarecer riscos ou critérios.

Para tarefas pontuais, continuam válidas as rotas específicas abaixo, usando o menor conjunto necessário. Se o pedido também for início de projeto, nova feature ou trabalho com todos os agentes, prevalece o fluxo padrão acima:

| Tipo de trabalho | Rota padrão |
|---|---|
| Início de projeto, nova feature ou trabalho com todos os agentes | GOD → PO → UI/UX → Back/Front → Cybersecurity/QA → GOD |
| Mudança pontual de regra existente | PO → UI/UX, se houver interface → Back e/ou Front → Cybersecurity quando houver superfície relevante → QA valida o aceite e a regressão aplicável → GOD integra |
| Tela nova ou mudança de experiência | PO, se faltar decisão → UI/UX → Front → Cybersecurity se houver dados, autenticação, upload ou integração → QA valida o aceite e a regressão aplicável → GOD integra |
| API, regra de domínio ou persistência | PO, se a regra estiver aberta → Back → Front se a interface for afetada → Cybersecurity para riscos relevantes → QA valida o aceite e a regressão aplicável → GOD integra |
| Validação funcional, regressão ou reprodução de bug | QA → GOD encaminha defeitos ao Front/Back, dúvidas de aceite ao PO e riscos de segurança ao Cybersecurity → QA retesta correções |
| Auditoria ou pentest solicitado | Cybersecurity, após delimitar alvo, ambiente e autorização → GOD consolida achados e encaminha correções |
| Bug com comportamento esperado já decidido | Front ou Back conforme a camada → Cybersecurity se houver impacto de segurança → QA reproduz/retesta o defeito e a regressão afetada → GOD confere a spec e o estado |
| Dúvida, prioridade ou mudança de escopo | PO → decisão do usuário → atualização da spec antes de implementação |

QA informa evidências e cobertura pendente; o aceite final do produto pertence ao usuário. Front e Back continuam responsáveis por validar suas próprias alterações.

Nas tarefas pontuais, uma rota pode ser reduzida quando não envolver determinado papel; o GOD registra a justificativa. Nos casos de fluxo padrão, manter a sequência e registrar explicitamente quando uma etapa não exigir ação no escopo, sem inventar trabalho nem omitir sua avaliação.

## Ciclo de trabalho

1. Receber a solicitação e consultar este documento.
2. Ler IA_CONTEXT.md e somente as specs e arquivos necessários.
3. Distinguir decisão já fechada, decisão aberta, implementação e investigação.
4. Encaminhar trabalho aos agentes apropriados sem alterar o escopo autorizado.
5. Receber de cada agente um handoff com resultado, decisões, arquivos, evidências, validações e bloqueios.
6. Resolver divergências entre entregas; enviar decisões de produto ao usuário via PO.
7. Confirmar que cada requisito implementado tem spec vigente e que IA_CONTEXT.md representa o estado atualizado.
8. Atualizar o registro de atividades desta spec central com uma síntese e links para as specs ou artefatos detalhados.

Quando o runtime não oferecer agentes separados, o GOD lê o perfil selecionado e executa aquela parte sequencialmente na mesma sessão, sem presumir isolamento de contexto. Deve informar que usou esse modo de contingência; não deve alegar que chamou um agente separado.

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
| Contrato dos sete papéis e roteamento | agents/SPEC_CENTRAL.md e os sete perfis ligados acima | GOD |
| Comportamento implementado | código e validações correspondentes | Front ou Back, dentro do escopo recebido |
| Cobertura de aceite, defeitos e evidências de qualidade | relatório ou spec da atividade, sem duplicar requisitos | QA; GOD consolida pendências e encaminha correções |
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

## Guardrails do repositório Find Job

Aplicar esta seção quando Find Job for o projeto ativo. Em outros projetos, consultar suas próprias regras. Preservação de trabalho alheio, proteção de dados e autorização de publicação continuam valendo universalmente:

- Não fazer commit ou push sem pedido explícito do usuário. A intenção de organizar arquivos para um futuro push não autoriza publicar agora.
- Preservar alterações preexistentes no workspace. Nunca descartar trabalho usando checkout, restore, reset hard ou clean.
- Não abrir nem modificar data/, backups/ ou qa-artifacts/. Não copiar dados pessoais reais para testes, fixtures ou relatórios versionados.
- Testes não enviam candidaturas, mensagens ou dados pessoais e não fazem chamadas reais a terceiros. Use banco temporário e TEST_MODE quando aplicável.
- Em mudanças de código, seguir o estilo já usado no arquivo e evitar reformatação ou refatoração fora da spec.
- Antes de adicionar dependência, demonstrar por que o que já existe não atende.
- Para alterações de código do Find Job, a política do agente executor exige npm test e npm run build antes de declarar conclusão. Não inventar uma execução: registrar somente resultados que realmente ocorreram.

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
