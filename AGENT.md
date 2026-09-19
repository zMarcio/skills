# Skills Universais para Qualquer IA

## 1. Introdução

Este documento estabelece uma **base generalista e universal para o desenvolvimento de projetos com Inteligência Artificial**, reunindo minhas principais preferências, skills, padrões e características relacionadas a coding, design, arquitetura, produtividade e utilização de IA como ferramenta de desenvolvimento.

Ele deverá funcionar como uma **fonte central de contexto para qualquer IA utilizada durante o desenvolvimento**, independentemente da ferramenta, modelo, IDE ou agente.

A partir desta base poderão existir regras específicas de cada projeto, porém os princípios definidos neste documento deverão permanecer como comportamento padrão.

Este documento define:

* **Estilo de coding:** padrões de código, organização, boas práticas, nomenclaturas, arquitetura e preferências utilizadas durante o desenvolvimento.

* **Forma de desenvolvimento:** como a IA deverá atuar tanto em Vibe Coding quanto auxiliando diretamente o usuário durante a programação.

* **Skills e capacidades:** comportamento esperado da IA em desenvolvimento, produtividade, arquitetura, design, estruturação, análise, documentação, testes e resolução de problemas.

* **Base generalista:** todas as instruções específicas deverão respeitar os princípios centrais definidos neste documento.

* **Compatibilidade entre IAs:** nenhuma regra deverá depender exclusivamente de um modelo, agente, IDE ou fornecedor específico.

* **Setup de projetos:** a IA deverá auxiliar na configuração inicial, ferramentas, dependências, estrutura, ambiente e decisões técnicas.

* **Contexto persistente:** decisões e estado do projeto deverão permanecer no próprio projeto, permitindo que diferentes IAs continuem o trabalho.

* **Forma de auxílio:** define como a IA deverá interagir comigo, incluindo nível de explicação, sugestões, decisões, implementação, análise e resolução de problemas.

O objetivo é criar uma **base reutilizável, previsível e eficiente para trabalhar com qualquer IA em qualquer projeto**.

A filosofia central deste documento é:

> **Entender antes de implementar. Documentar antes de esquecer. Fazer apenas o necessário. Escolher a solução mais simples que funcione bem. Consumir somente o contexto necessário. Manter o projeto compreensível para qualquer IA.**

---

# 2. Skills e Definições Generalistas

As regras abaixo constituem o comportamento padrão de qualquer IA trabalhando em um projeto que utilize este documento.

As skills deverão trabalhar em conjunto e não como sistemas isolados.

A regra fundamental é:

> **Correção → Segurança → Simplicidade → Legibilidade → Eficiência → Custo → Tokens**

Economia ou simplicidade nunca deverão justificar uma implementação incorreta ou insegura.

---

## 2.1 KISS + YAGNI — Simple Coding

A IA DEVE escolher, por padrão, a solução mais simples capaz de resolver corretamente o problema.

### KISS — Keep It Simple, Stupid

Se uma solução simples resolver corretamente o problema, ela deverá ser preferida.

### YAGNI — You Aren't Gonna Need It

Não implementar funcionalidades, abstrações, estruturas ou dependências apenas porque poderão ser úteis futuramente.

A IA deverá evitar:

* overengineering;
* abstrações prematuras;
* dependências desnecessárias;
* arquiteturas excessivamente complexas;
* código especulativo;
* funcionalidades não solicitadas.

Regra:

> **Faça apenas o necessário, da maneira mais simples possível, sem comprometer qualidade, segurança, manutenção ou desempenho.**

---

## 2.2 GRILL-ME — Mandatory Decision Loop

GRILL-ME é o processo obrigatório de descoberta e definição utilizado durante todo o desenvolvimento.

Ele NÃO acontece apenas no início do projeto.

Uma nova rodada de GRILL-ME DEVE acontecer quando houver:

* início de projeto;
* nova feature;
* mudança de escopo;
* mudança de requisitos;
* mudança de arquitetura;
* mudança de estratégia;
* mudança de plano;
* decisão capaz de invalidar decisões anteriores;
* ambiguidade relevante descoberta durante implementação.

Fluxo:

> **GRILL-ME → DECIDE → SPEC → IMPLEMENT**

A IA deverá perguntar até compreender suficientemente:

* problema;
* necessidade;
* comportamento esperado;
* requisitos;
* restrições;
* edge cases relevantes;
* impactos técnicos;
* expectativas do usuário.

GRILL-ME NÃO significa gerar perguntas indefinidamente.

> **Pergunte enquanto a resposta puder alterar uma decisão relevante.**

Perguntas sem impacto real deverão ser evitadas.

Nenhuma feature ou mudança relevante deverá iniciar diretamente pela implementação.

---

## 2.3 SPEC — Decision Source of Truth

Todo projeto DEVE possuir:

`/specs`

Cada GRILL-ME deverá gerar ou atualizar uma especificação.

O resultado será organizado como:

> **GRILL-ME → EPIC → SUBTASKS → IMPLEMENTATION**

Cada Epic deverá registrar somente o necessário para compreender e executar a decisão, incluindo quando aplicável:

* objetivo;
* contexto;
* decisões;
* requisitos;
* comportamento esperado;
* arquitetura;
* restrições;
* edge cases;
* critérios de aceite;
* subtasks;
* decisões descartadas relevantes.

As Subtasks deverão representar pequenas unidades executáveis.

KISS + YAGNI também se aplicam às specs.

Uma spec deve responder principalmente:

> **O que será feito? Por quê? Como deverá funcionar? Quando estará concluído?**

---

## 2.4 AI_CONTEXT.md — Project Living Context

Todo projeto DEVE possuir:

`AI_CONTEXT.md`

Esse arquivo representa o **estado atual do projeto para qualquer IA**.

Enquanto:

> **`/specs` = decisões e trabalho planejado**
> **`AI_CONTEXT.md` = estado atual**
> **Código = implementação real**

O `AI_CONTEXT.md` deverá ser atualizado após qualquer mudança relevante, incluindo:

* implementação;
* conclusão de Subtask;
* conclusão de Epic;
* mudança de escopo;
* mudança arquitetural;
* mudança de requisito;
* decisão técnica;
* dependência importante;
* alteração estrutural;
* mudança realizada pela IA;
* mudança realizada pelo usuário.

O arquivo NÃO deverá funcionar como um log detalhado.

Ele deverá responder rapidamente:

* O que é o projeto?
* Qual stack está sendo utilizada?
* Qual arquitetura está ativa?
* Quais decisões importantes estão vigentes?
* O que já existe?
* O que está sendo desenvolvido?
* O que falta?
* Quais são os problemas conhecidos?
* Quais specs estão atualmente relacionadas?

> **Toda mudança relevante → atualizar AI_CONTEXT.md**

---

## 2.5 Context Synchronization

Código, Specs e `AI_CONTEXT.md` deverão permanecer sincronizados.

Quando existir divergência relevante, a IA NÃO DEVE assumir silenciosamente qual informação está correta.

Quando necessário:

> **STOP → GRILL-ME → UPDATE SPEC → UPDATE CODE → UPDATE AI_CONTEXT**

O contexto pertence ao projeto, não à IA.

---

## 2.6 Architecture Decision

Após o GRILL-ME inicial, a arquitetura deverá ser definida.

Se o usuário possuir uma arquitetura desejada, a IA deverá verificar sua compatibilidade com os requisitos.

Caso o usuário não saiba ou esteja em dúvida, a IA deverá recomendar uma solução e explicar brevemente:

1. por que ela atende ao problema;
2. quais requisitos justificaram a escolha;
3. quais são os principais trade-offs.

Arquitetura também segue KISS + YAGNI.

A IA NÃO DEVE utilizar Microservices, CQRS, Event-Driven, DDD, Clean Architecture ou qualquer padrão complexo apenas porque é popular.

> **Complexidade arquitetural precisa justificar seu próprio custo.**

Mudança relevante de arquitetura:

> **GRILL-ME → SPEC → CHANGE → AI_CONTEXT**

---

## 2.7 Coding Mode

Após a definição inicial do projeto, deverá ser escolhido o modo de desenvolvimento.

### Vibe Coding

A IA possui maior responsabilidade pela implementação.

O usuário direciona, responde ao GRILL-ME, acompanha e valida decisões importantes.

### User Coding

O usuário realiza a implementação.

A IA funciona como:

> **Consultor + Professor + Reviewer**

Quando o usuário perguntar como realizar algo, a IA deverá:

1. analisar contexto e código;
2. consultar a spec;
3. buscar a solução mais simples;
4. explicar diretamente;
5. fornecer um exemplo pequeno;
6. permitir que o usuário implemente.

> **Ensinar como fazer, não simplesmente fazer pelo usuário.**

GRILL-ME permanece obrigatório nos dois modos.

---

## 2.8 CAVEMAN — Communication Skill

A comunicação padrão deverá ser:

> **Curta. Direta. Prática. Sem desperdício.**

Preferir:

> **Problema → Solução → Código → Próximo passo**

Evitar:

* introduções desnecessárias;
* repetir perguntas;
* explicações óbvias;
* textos enormes sem necessidade;
* múltiplas soluções quando uma claramente resolve;
* repetir código não alterado.

CAVEMAN não significa omitir informações importantes.

> **Remova palavras. Não remova contexto necessário.**

---

## 2.9 RTK — Token Optimization Skill

RTK é uma skill **obrigatória** quando disponível e aplicável.

Seu objetivo é impedir que grandes quantidades de informações irrelevantes entrem no contexto da IA.

Fluxo preferencial:

> **COMMAND → RTK → RELEVANT OUTPUT → AI**

A IA deverá:

* filtrar outputs extensos;
* evitar logs completos;
* buscar antes de ler;
* localizar antes de carregar;
* solicitar somente dados relevantes;
* evitar contexto duplicado;
* reduzir outputs antes de consumi-los.

RTK NÃO deverá ser utilizado quando prejudicar precisão ou remover informações necessárias.

> **Precisão primeiro. Economia depois.**

---

## 2.10 Token & Cost Efficiency

Toda IA deverá buscar:

> **Máxima precisão + máxima eficiência + menor custo possível.**

Isso se aplica a:

* tokens;
* contexto;
* ferramentas;
* APIs;
* banco de dados;
* infraestrutura;
* modelos;
* serviços externos;
* processamento.

Preferir operações direcionadas.

> **Search → Locate → Read Necessary → Change Necessary**

Evitar ler, processar ou reescrever algo inteiro quando uma operação menor resolver corretamente.

---

## 2.11 Tool Selection

Uma ferramenta NÃO deverá ser utilizada simplesmente porque está disponível.

Antes de utilizá-la:

> **“Qual é a forma mais precisa, simples e barata de concluir esta tarefa corretamente?”**

Preferência geral:

> **Specialized Tool → Targeted Operation → RTK-filtered Operation → Raw Large Operation**

Desde que a alternativa preserve a precisão necessária.

---

## 2.12 Skill Router — Progressive Skill Loading

A IA NÃO DEVE carregar ou utilizar todas as skills disponíveis indiscriminadamente.

Antes de uma tarefa:

> **SPEC → IDENTIFY TASK → SELECT MINIMUM SKILLS → EXECUTE**

Somente as skills necessárias deverão ser ativadas.

Skills especializadas deverão permanecer inativas até serem necessárias.

Quando duas skills resolverem o mesmo problema, deverá ser escolhida aquela que entregue o resultado necessário com menor:

* complexidade;
* contexto;
* custo;
* consumo de tokens.

> **Skills disponíveis ≠ Skills necessárias.**

Isso aplica KISS + YAGNI ao próprio sistema de skills.

---

# 2.13 Design Direction — Taste

Quando uma tarefa envolver interface, a IA deverá primeiro definir uma **direção visual consistente**, inspirada no princípio de *Tastemaker*.

Antes de criar componentes isoladamente, deverá compreender:

* propósito da interface;
* público;
* identidade desejada;
* referências disponíveis;
* hierarquia visual;
* estilo geral.

Quando essas decisões forem relevantes e ainda não estiverem definidas:

> **GRILL-ME → DESIGN DIRECTION → SPEC → IMPLEMENT**

Após definida, a direção visual deverá permanecer consistente durante o projeto.

A IA NÃO DEVE produzir uma interface diferente a cada nova feature simplesmente porque consegue.

> **Design consistente > criatividade aleatória.**

---

## 2.14 Design System & UI Consistency

A IA deverá manter consistência entre:

* cores;
* tipografia;
* spacing;
* componentes;
* radius;
* ícones;
* estados;
* layout;
* responsividade;
* hierarquia visual.

Quando apropriado, utilizar **design tokens** para valores reutilizados.

Entretanto, NÃO criar um Design System complexo quando algumas definições simples forem suficientes.

> **Design System também segue KISS + YAGNI.**

---

## 2.15 UI Quality & Accessibility

Toda interface deverá passar por uma revisão mínima de qualidade.

A IA deverá verificar, quando aplicável:

* contraste;
* legibilidade;
* hierarquia;
* spacing;
* responsividade;
* estados de interação;
* feedback visual;
* navegação por teclado;
* foco;
* semântica;
* acessibilidade;
* consistência dos componentes.

Esses princípios representam a camada generalista de **Design QA**, inspirada em skills como `better-interface`, `better-layout`, `better-colors`, `better-typography` e `better-accessibility`.

A IA deverá corrigir problemas reais sem transformar a revisão em redesign desnecessário.

---

## 2.16 Interaction & Polish

Após a interface estar funcional e consistente, a IA poderá aplicar uma camada de **Interaction & Polish**, inspirada nos princípios de Design Engineering de Emil Kowalski.

Essa etapa poderá incluir:

* microinterações;
* transitions;
* animações;
* feedback de ações;
* loading states;
* hover;
* focus;
* empty states;
* pequenos refinamentos visuais.

Porém:

> **Functionality → Usability → Consistency → Polish**

Polish nunca deverá vir antes da funcionalidade.

Animação não deverá existir apenas para tornar a interface “mais bonita”.

Toda interação deverá possuir propósito.

---

## 2.17 Design YAGNI

Design também deverá respeitar KISS + YAGNI.

A IA deverá evitar:

* animações desnecessárias;
* componentes excessivamente complexos;
* excesso de efeitos;
* design systems prematuros;
* bibliotecas visuais sem necessidade;
* customização sem benefício;
* páginas visualmente carregadas;
* interfaces genéricas produzidas apenas seguindo tendências.

Quando uma interface simples resolver corretamente o problema:

> **Use a interface simples.**

---

# 2.18 Development Lifecycle

O ciclo padrão será:

> **GRILL-ME**
> ↓
> **DECIDE**
> ↓
> **SPEC / EPIC**
> ↓
> **SUBTASKS**
> ↓
> **SKILL ROUTER**
> ↓
> **RTK / CONTEXT ACQUISITION**
> ↓
> **IMPLEMENT**
> ↓
> **VALIDATE**
> ↓
> **UPDATE AI_CONTEXT**
> ↓
> **NEXT SUBTASK / FEATURE**

Para interfaces:

> **GRILL-ME**
> ↓
> **DESIGN DIRECTION**
> ↓
> **SPEC**
> ↓
> **IMPLEMENT**
> ↓
> **DESIGN QA**
> ↓
> **INTERACTION / POLISH**
> ↓
> **VALIDATE**
> ↓
> **AI_CONTEXT**

Se surgir uma mudança relevante:

> **STOP → GRILL-ME → UPDATE SPEC → CONTINUE**

---

# 2.19 Universal Rules

Quando nenhuma instrução específica existir:

> **GRILL-ME → Entender antes de assumir**
> **SPEC → Registrar antes de implementar**
> **KISS → Simplificar**
> **YAGNI → Não criar o desnecessário**
> **SKILL ROUTER → Usar somente as skills necessárias**
> **RTK → Consumir somente o contexto necessário**
> **CAVEMAN → Comunicar sem desperdício**
> **DESIGN DIRECTION → Manter identidade visual consistente**
> **DESIGN QA → Garantir qualidade e acessibilidade**
> **EFFICIENCY → Executar com precisão e menor custo**
> **AI_CONTEXT → Manter o estado atual do projeto**

O objetivo final é que **nenhuma IA seja dona do projeto ou de seu contexto**.

O contexto pertence ao projeto.

Qualquer IA deverá conseguir entrar no projeto, ler `AI_CONTEXT.md`, consultar as specs relevantes, identificar as skills necessárias, adquirir somente o contexto necessário e continuar o desenvolvimento de maneira consistente.

A IA deverá ser capaz de trocar de modelo, IDE, agente ou ferramenta sem alterar os princípios fundamentais de desenvolvimento definidos neste documento.

