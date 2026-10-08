#!/usr/bin/env bash
# Instala as skills e plugins externos aprovados em QA-SKILLS-003 para os agentes de QA.
#
#   scripts/instalar-skills-qa.sh <caminho-do-projeto> [--dry-run]
#
# <caminho-do-projeto>: onde o pacote de agentes foi aplicado (ex.: ~/fluctus_automatizado).
# --dry-run: só mostra os comandos.
#
# Plugins (Trail of Bits, Anthropic) ficam no escopo do usuário do Claude Code;
# skills via `npx skills` e Bruno vão para <projeto>/.claude/skills.
# systematic-debugging e verification-before-completion já vêm no pacote (.agents/skills).
set -euo pipefail

die() { echo "instalar-skills-qa: $*" >&2; exit 1; }

PROJ="" DRY=0
for a in "$@"; do
  case "$a" in
    --dry-run) DRY=1 ;;
    -*) die "opção desconhecida: $a" ;;
    *) [ -z "$PROJ" ] || die "informe um único projeto"; PROJ="$a" ;;
  esac
done
[ -n "$PROJ" ] || { sed -n '2,12p' "$0"; exit 1; }
[ -d "$PROJ" ] || die "projeto não existe: $PROJ"
PROJ=$(cd "$PROJ" && pwd)

run()    { echo "+ $*"; [ "$DRY" = 1 ] || "$@"; }
run_in() { local d="$1"; shift; echo "+ (cd $d && $*)"; [ "$DRY" = 1 ] || (cd "$d" && "$@"); }
need()   { command -v "$1" >/dev/null 2>&1 || { [ "$DRY" = 1 ] && echo "  (aviso: '$1' não encontrado)"; } || die "'$1' não encontrado no PATH"; }

pendentes=()

echo "== 1. Plugins do Claude Code"
need claude
run claude plugin marketplace add trailofbits/skills
run claude plugin marketplace add trailofbits/skills-curated
run claude plugin marketplace add anthropics/knowledge-work-plugins
# Leitor, Verificador e Escritor: gh-cli · Cibersecurity: 1–7, 11 e 12
for p in gh-cli audit-context-building static-analysis fp-check differential-review \
         variant-analysis supply-chain-risk-auditor insecure-defaults; do
  run claude plugin install "$p@trailofbits"
done
for p in openai-security-threat-model openai-security-best-practices; do
  run claude plugin install "$p@skills-curated"
done
# Questionador: testing-strategy · Test-executor: accessibility-review
run claude plugin install engineering@knowledge-work-plugins
run claude plugin install design@knowledge-work-plugins

echo "== 2. Skills no projeto (npx skills)"
need npx
run_in "$PROJ" npx --yes skills add https://github.com/mattpocock/skills --skill grilling --agent claude-code
run_in "$PROJ" npx --yes skills add grafana/skills --skill k6 --agent claude-code
run_in "$PROJ" npx --yes skills add fugazi/test-automation-skills-agents --skill playwright-regression-testing --agent claude-code

echo "== 3. Playwright CLI e a skill dele"
run npm install -g @playwright/cli@latest
run_in "$PROJ" playwright-cli install --skills

echo "== 4. Pacote do Bruno (sem licença declarada: só instalação local, nunca no pacote)"
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
run git clone --quiet --depth 1 https://github.com/bruno-collections/bruno-agent-skills "$tmp/bruno"
run mkdir -p "$PROJ/.claude/skills"
for s in bruno-test-writer bruno-collection-generator; do
  if [ "$DRY" = 1 ] || [ -d "$tmp/bruno/$s" ]; then
    run cp -R "$tmp/bruno/$s" "$PROJ/.claude/skills/"
  else
    pendentes+=("Bruno: pasta $s não encontrada no repositório — copiar manualmente")
  fi
done

echo "== 5. Manual"
pendentes+=("Flaky Test Doctor (qaskills): procure o slug em https://qaskills.sh/skills e rode 'npx @qaskills/cli add <slug>' em $PROJ")
pendentes+=("Postman MCP: já conectado na conta; nada a instalar")
for p in "${pendentes[@]}"; do echo "- $p"; done

echo "== Pronto. Abra uma nova sessão do Claude Code em $PROJ para carregar plugins e skills."
