---
name: audit-scope-readonly
description: Definir o escopo de uma auditoria de segurança (com card, escopo específico ou construção do zero por módulo), decidir quando ampliar a investigação e garantir que código, configurações e dados originais fiquem intactos — com snapshot antes/depois e saídas fora do repositório auditado.
---

# Escopo e somente leitura

Primeira skill de toda auditoria. Sai daqui: modo, alvo, limites, o que pode ser
lido, onde gravar e quais skills acionar.

## 1. Modo

- **Com card**: recebe o `contexto-unificado.md` (do planejador; detalhe
  por arquivo em `diff.md`). Foco
  em objetivo, regras de negócio e critérios de aceite (ou os critérios combinados
  `CC*`, já que o card costuma não ter CA): o que o card permite,
  para quem, com quais dados.
- **Escopo específico**: um fluxo ou rota pedido pelo usuário. Analisar o fluxo,
  suas dependências e proteções.
- **Construção do zero**: um módulo inteiro sem card. Avaliação mais ampla pelas
  responsabilidades do módulo e suas integrações.

Faltou dado essencial (repo/caminho do código, commit, módulo, se há réplica
possível)? Pedir **só** o que bloqueia e seguir com o resto.

## 2. Mapa do alvo

- Entradas: rotas, webhooks, filas, uploads, sockets, jobs.
- Fronteiras de confiança: cliente → API, API → banco, API → serviço externo
  (Meta/WhatsApp, S3, Redis), tenant ↔ tenant, papel ↔ papel.
- Dados sensíveis: credenciais, tokens, telefone, conteúdo de conversa, PII.
- Proteções existentes: autenticação, autorização por papel/empresa, validação,
  rate limit, sanitização, assinatura de webhook, segredos.

## 3. Regra de ampliação

Ampliar além do escopo **somente** com relação concreta — mesmo dado, mesma
função/middleware, mesmo consumidor, mesma fronteira — e registrar em uma linha:
`Ampliado para <alvo> porque <relação verificada: arquivo/linha ou grep>`.
Semelhança de nome ou "pode ser" não amplia.

## 4. Somente leitura

Antes de começar e ao terminar, no repo auditado:

```bash
git -C <repo> rev-parse HEAD > <saida>/snapshot-antes.txt
git -C <repo> status --porcelain=v1 --untracked-files=all >> <saida>/snapshot-antes.txt
# … auditoria …
git -C <repo> rev-parse HEAD > <saida>/snapshot-depois.txt
git -C <repo> status --porcelain=v1 --untracked-files=all >> <saida>/snapshot-depois.txt
diff <saida>/snapshot-antes.txt <saida>/snapshot-depois.txt && echo "intacto"
```

- Ler com `git show`, `git diff`, `git log`, `rg`, `Read`. Sem checkout, reset,
  stash, commit, `npm install` no repo, formatter ou `--fix`.
- Ferramentas (semgrep, codeql, linters) gravam relatório e banco de análise em
  `<saida>`, nunca dentro do repo auditado.
- `.env` e segredos: não abrir; checar só existência, permissão e se estão ignorados pelo Git.
- Banco e homologação: nada de escrita. Prova dinâmica só em réplica
  (`controlled-vulnerability-validation`).
- Snapshot divergente no fim → registrar no relatório como incidente.

`<saida>` = `<raiz-suite>/.qa/<CARD_ID>/cibersecurity/` com card, ou
`<raiz-suite>/.qa/ciber-<modulo>-<AAAAMMDD>/cibersecurity/` sem card.

## 5. Escolha de skills (só as relevantes)

- Entender fluxo e dependências → `audit-context-building` (sempre no modo com card ou específico).
- Ameaças do fluxo/módulo → `security-threat-model` (construção do zero; ou fluxo com fronteira nova).
- Card com commits/PR → `differential-review`.
- Busca de falhas no código → `static-analysis`.
- Todo alerta de ferramenta ou suspeita → `fp-check` antes de virar achado.
- Achado confirmado → `variant-analysis` dentro do escopo (ampliar pela regra acima).
- Boas práticas Python, JS/TS, Go → `security-best-practices` quando o escopo tem código novo dessas linguagens.
- Dependência nova ou atualizada (`package.json`/lockfile no diff) → `supply-chain-risk-auditor`.
- Configuração, flag ou variável com valor padrão → `insecure-defaults`.
- Suspeita que precisa de prova dinâmica → `controlled-vulnerability-validation`.
- Sempre ao fim → `security-findings-report`.

Registrar no `escopo.md` quais foram acionadas e por quê; as que não foram, uma
linha cada com o motivo.

## 6. Saída

`<saida>/escopo.md`:

```markdown
# Escopo — <alvo>
- Modo: com card | escopo específico | construção do zero
- Repo/commit: <repo> @ <sha> · Snapshot: <caminho>
- Fluxo/módulo: … · Fronteiras: … · Dados sensíveis: …
- Fora do escopo: …
- Ampliações: <alvo> — <relação>
- Skills: <nome> — <motivo> · não usadas: <nome> — <motivo>
- Pendências de informação: …
```
