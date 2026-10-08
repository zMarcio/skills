---
name: qa-verificador-diff
description: Comparar o commit anterior com o atual (ou base/head do PR do card) e mostrar o que mudou de verdade — arquivos por área, comportamento, migrations, config, dependências e o que foi além do card — e unir isso ao contexto do leitor em .qa/<CARD_ID>/contexto-unificado.md, o arquivo que vai para todos os agentes de execução. Somente leitura no código.
---

# Verificador — o que mudou entre commits

Fase do **planejador** no `/qa-card`, logo depois da fase leitor:

1. `.qa/<CARD_ID>/diff.md` — análise detalhada do diff (dono: verificador).
2. `.qa/<CARD_ID>/contexto-unificado.md` — união do `contexto.md` do leitor com
   o diff, organizada para quem executa (dono: verificador).

Leitor e verificador rodam na mesma chamada do planejador: `contexto.md` primeiro,
depois `diff.md` e o unificado.

Nunca edita código do produto nem da suíte. Não faz checkout, reset ou stash no
repositório do usuário; usa `git -C`, `git show`, `git diff` e `gh` (leitura).
O mapa de regressão é a fase seguinte do planejador (`qa-regressao`), a partir do unificado.

## 1. Definir o intervalo

Em ordem de preferência:

1. Pedido explícito: `de=<ref> para=<ref>` (commit, tag, branch).
2. PR vinculado no `contexto.md`: base…head do PR.
   - Repo local disponível: `git -C <repo> fetch origin <base> <head>` (só se o
     usuário permitiu rede) e `git -C <repo> diff <base>...<head>`.
   - Sem clone local: `gh pr diff <url>` e `gh pr view <url> --json files,commits`.
3. Sem PR: commit anterior → atual no repo indicado: `git -C <repo> diff HEAD~1 HEAD`
   (ou `<deploy-anterior>..<deploy-atual>` se o usuário informar as versões de homologação).

Registrar no topo do `diff.md` qual intervalo foi usado e por quê. Intervalo
ambíguo (vários PRs, merge com muitos commits) → pergunta na fase questionador.

## 2. Ler o diff

```bash
git -C <repo> log --oneline --no-merges <de>..<para>
git -C <repo> diff --stat <de> <para>
git -C <repo> diff --name-status <de> <para>
git -C <repo> diff <de> <para> -- <arquivo>          # um por vez, nos relevantes
git -C <repo> grep -n "<função|rota|tabela>" <para>   # consumidores no estado atual
```

Classificar cada arquivo:

- **Rota/endpoint** (controller, router): método, caminho, payload, status, permissão.
- **Regra de domínio/serviço**: condição alterada, valor padrão, filtro.
- **Banco**: migration, model, query (coluna nova, índice, constraint, backfill).
- **UI**: componente, tela, texto, estilo, tema.
- **Integração**: fila, worker, webhook, socket, S3, WhatsApp/Baileys.
- **Config/infra**: `.env.example`, PM2/ecosystem, Docker, variáveis novas.
- **Dependência**: `package.json`/lockfile (versão subiu? major?).
- **Teste**: specs alterados/removidos (teste apagado é sinal de alerta).

## 3. `diff.md`

```markdown
# Diff — <CARD_ID>
- Repo: <repo> · Intervalo: <de>..<para> (<motivo>) · Commits: <n> · Arquivos: <n>

## Commits
- <sha> <mensagem>
## Arquivos por área
- API — `src/.../x.controller.js` — `PUT /api/x` passa a exigir `campoY`
- UI — …
- Banco — migration `<nome>` adiciona `<coluna>` NOT NULL sem default
## Consumidores encontrados
- `<função|rota|tabela>` — `git grep` achou: <arquivos>
## Perguntas para o questionador
- <ambiguidade de intervalo ou de comportamento>
```

Afirmar só o que está no diff. Impacto em consumidor é hipótese: citar o
`grep` que achou o consumidor.

## 4. `contexto-unificado.md`

União de `contexto.md` (o que o card pede) com o `diff.md` (o que o código fez).
É o único contexto que o executor (todas as fases) e a cibersecurity
recebem além da especificação TC — então precisa se sustentar sozinho.

```markdown
# Contexto unificado — <CARD_ID>
- Card: <url> · Tipo: <tipo> · Estado: <estado>
- Código: <repo> · Intervalo: <de>..<para> (<motivo>) · Commits: <n> · Arquivos: <n>
- Fontes: contexto.md (leitor) · diff.md (verificador)

## Objetivo
## Pedido × código
(critérios de aceite, se o card tiver; senão, o comportamento pedido)
- CA1 | <comportamento pedido> → `<arquivo>` / `<rota>` / tela <x> — **coberto**
- <comportamento pedido> → nenhum arquivo — **sem mudança correspondente**
## Regras e restrições
## O que mudou (resumo por área)
## Além do card (riscos)
- D1 — <mudança não pedida> — impacto possível: <módulos/consumidores> (grep: <arquivos>)
## Impacto
- Telas: … · Rotas: … · Tabelas: … · Integrações: … · Config: …
## Foco por camada
- UI/API/collections: telas, estados e componentes alterados; rotas, contratos,
  permissões e efeitos no banco alterados
- performance: rotas com query/payload/filtro alterados (ou "sem impacto")
- regressao: consumidores, módulos vizinhos e componentes compartilhados tocados
- cibersecurity: fronteiras de confiança tocadas (auth, papel, tenant, upload, webhook, segredos)
## Ambiente e massa
## Lacunas abertas
- L1 — … (do leitor) · D-L1 — … (do diff)
```

Retorno ao orquestrador: intervalo usado, nº de arquivos, nº de itens do pedido
sem mudança correspondente, nº de riscos `D*` e os caminhos dos dois arquivos.
