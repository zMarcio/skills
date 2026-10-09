# QA-INTEGRADOR-005 — agente integrador

Estado: concluído tecnicamente; publicado na branch `features/agents-marcio` (sem merge).
Complementa [QA-AGENTES-004](QA-AGENTES-004.md).

## Pedido (2026-10-09)

"Um agente novo que faz a revisão profunda do código, otimiza ele, fala que faz
sentido ter com base no TC e que antes do push revisa todo ele para ver se tá
funcional e em caso de merge ele é chamado para verificar e reparar qualquer conflito."

## Decisões

- Nome `integrador`: ele altera código (otimiza e repara conflitos), o que o
  revisor de propósito não faz; "verificador" já é a fase de diff do planejador.
- Entra depois da revisão de código (rodada D, `otimizar`) e antes da
  documentação, para os docs descreverem o código final; e na entrega
  (`integrar` + `pre-push`), num worktree `integracao` — nada é aplicado no
  checkout principal.
- Otimização não muda comportamento: prova antes × depois (mesmos resultados por
  ID, estável em paralelo). Mudança de assert, esperado ou cobertura volta ao revisor.
- Pertinência (mantém, redundante, camada errada, sem TC, TC sem teste) é parecer:
  remover, unir ou mover teste só com decisão do usuário.
- Conflitos: entender os dois lados antes de editar; conflito de intenção volta
  ao usuário; lockfile nunca à mão; nada de `-X ours/theirs` às cegas.
- Commit, merge e push só com autorização; nunca `--force`.
- Avulso: `/qa-integrar pre-push | merge <origem> em <destino> | otimizar <alvo>`.

## Arquivos

- `.claude/agents/integrador.md` (opus; Read, Write, Edit, Bash, Grep, Glob, Skill)
- `.agents/skills/qa-integrador/SKILL.md`
- `.claude/commands/qa-integrar.md`; `/qa-card` com rodadas D (otimizar), E
  (documentação e bugs) e entrega pelo integrador; `/qa-modulo` herda.
- `qa-frentes.sh`: frente `integracao` (destino; não é coletada como patch).
- Skills sob demanda: `code-review`, `resolving-merge-conflicts` (Matt Pocock,
  adicionada ao `instalar-skills-qa.sh`), `playwright-cli`, `systematic-debugging`,
  `verification-before-completion`.

## Validações

- `python3 scripts/validar-pacote.py` → OK (skills=23, claude=5).
- Conflito simulado: `executor-ui` e `executor-api` alterando o mesmo helper;
  patches aplicados com `git apply --3way` no worktree `integracao` → arquivo
  marcado `UU` com as duas versões e os arquivos novos das duas frentes presentes.
  Achado no teste: `git apply` simples seguido de `--3way` falha ("does not match
  index") e o `--3way` sai com 0 mesmo com conflito — a skill aplica tudo com
  `--3way` e confere conflitos por `git diff --diff-filter=U`.
- Não executado: fluxo real contra card, homologação, push de suíte.
