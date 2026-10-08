# Execução autossuficiente

## Preferências preservadas

Correção → Segurança → Simplicidade → Legibilidade → Eficiência → Custo → Tokens.
Spec antes de implementação relevante; KISS/YAGNI; direção visual existente;
RTK; português curto com prefixo do papel real; contexto mantido no projeto.
Em Vibe Coding, executar até o aceite técnico. Em User Coding, orientar e revisar.
O pedido atual de automação adota Vibe Coding; não perguntar novamente por tarefa.

Este contrato atualiza a operação descrita nos documentos herdados. GRILL-ME é
uma avaliação de lacunas, não uma aprovação obrigatória a cada etapa. O pedido
explícito e as decisões vigentes já autorizam sua implementação. Registrar sua
origem na spec. Escolhas técnicas locais e reversíveis podem ser decididas pelo
executor dentro do contrato; perguntar apenas quando faltar decisão material de
produto, houver conflito real ou uma ação exigir autorização ainda ausente.
Enquanto aguarda, avançar no trabalho independente. Nunca aprovar hipóteses de
produto por silêncio ou transformar sugestão em requisito.

## Sequência e roteamento

1. GOD identifica projeto/worktree, pedido, status Git e alterações anteriores;
   lê o contexto vigente e a spec relevante. Reutiliza evidências ainda válidas.
2. Explorer mapeia código/contratos apenas quando a localização ou impacto forem
   incertos. PO resolve lacunas materiais; Spec Writer prepara a spec executável
   a partir de decisões já autorizadas, sem uma segunda aprovação cerimonial.
3. GOD atribui unidades completas com aceite, arquivos próprios e dependências.
   UI/UX entra quando há experiência afetada; Back/Front implementam conforme
   contrato. Mudança pequena pode ser executada com o perfil na mesma sessão.
4. QA valida comportamento; Cybersecurity cobre superfícies de risco pertinentes;
   Reviewer investiga a entrega e impactos. Etapas sem aplicação são registradas
   como tal, sem instanciar todos os papéis por padrão.
5. Integrator prepara a combinação das frentes sob coordenação do GOD. Após
   integração, QA/Reviewer reavaliam os efeitos combinados e evidências afetadas.
6. GOD reconcilia spec e contexto, entrega resumo e executa commit/merge/push
   somente conforme autorização já recebida para cada ação.

A sequência histórica PO → UI/UX → implementação → validação → Reviewer continua
válida para features; os três novos papéis apoiam suas etapas, não decidem produto.
Não exigir PRD/épico novo para correção pequena já coberta por spec existente.

## Modelo, capacidade e independência

Preferência explícita: `gpt-6-luna`, esforço `max`, inclusive nos subagentes.
Usar contexto próprio e despacho mínimo quando o runtime permitir. Não herdar
o histórico inteiro para depois afirmar que trocou o modelo. Conferir o modelo
efetivamente usado e informar indisponibilidade; não trocar silenciosamente.

Com quatro slots totais, o GOD ocupa um e mantém até três especialistas ativos.
Três GODs de branch ocupam os demais slots: executam perfis sequencialmente,
sem tentar criar uma árvore de agentes. Após receber os handoffs, encerrar os agentes de branch para liberar
capacidade; então abrir uma instância Reviewer independente. Ela pode revisar
as frentes concluídas e depois a composição final. Só GOD coordena novas delegações; GOD de branch pede vagas ao
principal. Manter um único escritor por arquivo, inclusive specs e contexto.

Reviewer deve ser outra instância quando a revisão independente for necessária.
Recebe spec, diff e evidências, investiga diretamente; o resumo do implementador
não é prova. Na contingência sequencial, declarar autorrevisão e a limitação.

## Worktrees e integração

Usar a skill `worktree-delivery` para criar ou integrar frentes. Antes de escrever,
conferir caminho absoluto, branch e revisão-base. Worktree não isola processos,
bancos, portas, rede ou arquivos externos: alocar recursos de teste por frente.
Não compartilhar banco real nem copiar `.env`/dados pessoais para worktrees.

Manter specs centrais e contexto sob propriedade do GOD. Especialistas retornam
propostas de atualização; specs de tarefa podem ter escritor explicitamente
atribuído. API, tipos, dependências e lockfiles compartilhados têm dono único.
Sem commit autorizado, entregar diff e inventário, incluindo arquivos novos;
sem merge autorizado, entregar candidato revisado. Não bloquear código/specs
por uma autorização que só será necessária para publicar ou integrar.

## Estado persistente e retomada

Para trabalho de várias etapas, GOD mantém um registro por atividade em
`specs/workflow/<id>.md` ou local equivalente existente. Campos mínimos:

```text
Pedido e origem das autorizações (commit / merge / push separadamente):
Projeto, branch, worktree, base e revisão atual:
Spec e critérios de aceite:
Estado: planejado | pronto | executando | validando | revisando |
        pronto-para-integrar | concluído | bloqueado
Tarefas: ID | responsável | arquivos | depende de | estado | evidência
Decisões: autorizadas / técnicas reversíveis / pendentes
Validações: critério | comando/cenário | resultado | revisão/diff | ambiente
Handoff e próximo passo concreto:
```

Uma tarefa fica pronta quando suas decisões materiais e entradas estão disponíveis;
concluída quando atende ao aceite e às validações aplicáveis. Bloqueio de uma
tarefa não bloqueia automaticamente as independentes. Em retomada, confrontar
o registro com status/diff/base reais; incluir mudanças não commitadas e novos
arquivos na identidade do conteúdo. HEAD sozinho não identifica uma entrega.
Não reexecutar evidências válidas nem continuar de um estado apenas presumido.

Se a mesma falha reaparecer após correção, investigar causa e mudar a hipótese;
não repetir comandos idênticos indefinidamente. Impedimento externo persistente
gera handoff com evidência, tentativas e entrada necessária. Não enfraquecer
testes nem declarar sucesso para encerrar o ciclo.

## Skills locais e instalação

| Necessidade | Skill | Principal usuário |
|---|---|---|
| Preparar spec e unidades executáveis | `spec-ready` | PO / Spec Writer |
| Isolar e combinar trabalho | `worktree-delivery` | GOD / Integrator |
| Vincular aceite, revisão e evidência | `delivery-evidence` | QA / Reviewer |
| Contrato comum do Fluctus (fontes, usuários, classificação) | `qa-fluctus` | todos os agentes de QA |
| Ler card do GitHub | `qa-leitor-card` | leitor |
| Diff entre commits e contexto unificado | `qa-verificador-diff` | verificador |
| Itens de regressão, cobertura do módulo e execução | `qa-regressao` | regressao |
| Perguntas até definir e especificação TC | `qa-questionador` | questionador (test-planner) |
| Revisão da especificação e pré-checagem | `qa-spec-reviewer` | spec-reviewer |
| UI, regressão de API e collections | `qa-executor` | test-executor |
| Performance com k6 | `qa-performance-k6` | performance |
| Auditoria de segurança | `audit-scope-readonly`, `controlled-vulnerability-validation`, `security-findings-report` + 7 externas | cibersecurity |
| Documentação SDD por agente | `qa-documentador-sdd` | documentador |
| Rascunhos de cards de bug | `qa-escritor-card` | escritor (bug-drafter) |
| Worktrees e rodadas | `qa-worktree-frentes` | orquestrador |
| Relatório e exploratório | `qa-relatorio`, `qa-exploratory-charter` | QA |
| Investigar falha e provar antes de afirmar (superpowers, MIT) | `systematic-debugging`, `verification-before-completion` | test-executor, regressao, performance |

Os agentes de QA existem só no Claude Code (`.claude/agents/`); `.claude/skills`
aponta para `.agents/skills/`; comandos `/qa-card`, `/qa-modulo` e `/qa-ciber`
em `.claude/commands/`.
Skills externas aprovadas por agente: [QA-SKILLS-003](../specs/workflow/QA-SKILLS-003.md);
instalação com `scripts/instalar-skills-qa.sh <projeto>`.

As skills locais vivem em `.agents/skills/` e os registros Codex em
`.codex/agents/`. Os perfis Markdown continuam sendo a fonte de instruções de
cada papel; os TOML apontam para eles. Copiar o pacote para outro projeto exige
preservar instruções locais e mesclar configurações, nunca sobrescrevê-las às cegas.
Configuração de projeto depende da confiança/versão do cliente e passa a valer
em novas sessões; não muda retroativamente o modelo da conversa atual.

Registro verificado na [documentação de subagentes](https://learn.chatgpt.com/docs/agent-configuration/subagents)
e [referência de configuração](https://learn.chatgpt.com/docs/config-file/config-reference)
em 2026-09-26. Catálogo local confirmou `gpt-6-luna` e `max`; isso não mede custo
ou velocidade e não garante disponibilidade em outra conta.

## Uso diário

Pedido suficiente: “GOD, implemente a spec X neste worktree e conclua validação
e revisão”. O GOD usa a rota mínima, retoma tarefas incompletas e apresenta
o resultado. Se o pedido também autorizar commit ou integração, executar essas
ações no destino indicado; push precisa de autorização própria.

Para só adiantar planejamento: “Prepare as próximas specs a partir das decisões
vigentes”. Spec Writer marca hipóteses/bloqueios; não dispara implementação sem
pedido. Agentes e skills servem à tarefa e não exigem que o usuário chame cada papel.

O Find mantém ainda `find-job-dev` como adaptador legado de implementação: recebe
uma frente Front ou Back do GOD, segue os mesmos perfis e não cria uma décima
segunda especialidade. Em novas delegações, preferir os papéis específicos.
