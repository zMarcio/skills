#!/usr/bin/env bash
# Worktrees por frente de um card de QA.
#
#   qa-frentes.sh criar   <CARD_ID> [frente ...] [--env]   (padrão: executor documentador)
#   qa-frentes.sh status  <CARD_ID>
#   qa-frentes.sh coletar <CARD_ID>
#   qa-frentes.sh remover <CARD_ID> <frente>
#
# Rodar a partir do checkout principal da suíte de testes (ex.: fluctus_automatizado).
# Worktrees:  <pai>/<repo>.qa-wt/<CARD_ID>/<frente>   branch qa/<CARD_ID>/<frente>
# Estado:     <raiz>/.qa/<CARD_ID>/  (excluído do Git via .git/info/exclude)
# Nada é apagado sem pedido; nenhum force/reset/stash.
set -euo pipefail

die() { echo "qa-frentes: $*" >&2; exit 1; }

RAIZ=$(git rev-parse --show-toplevel 2>/dev/null) || die "rode dentro de um repositório Git"
COMUM=$(cd "$RAIZ" && git rev-parse --path-format=absolute --git-common-dir)
[ "$(cd "$RAIZ" && git rev-parse --path-format=absolute --git-dir)" = "$COMUM" ] \
  || die "rode no checkout principal, não dentro de um worktree"
NOME_REPO=$(basename "$RAIZ")
WT_BASE="$(dirname "$RAIZ")/$NOME_REPO.qa-wt"

valida_card() {
  [[ "${1:-}" =~ ^[A-Za-z0-9._-]+$ ]] || die "CARD_ID inválido: '${1:-}' (use <repo>-<número>)"
}

garante_exclude() {
  local f="$COMUM/info/exclude"
  mkdir -p "$(dirname "$f")"; touch "$f"
  for p in "/.qa/" "/.qa-frente.env" "/node_modules"; do
    grep -qxF "$p" "$f" || echo "$p" >> "$f"
  done
}

frentes_do_card() {   # lista "<caminho> <branch>" dos worktrees do card
  git -C "$RAIZ" worktree list --porcelain | awk -v pre="refs/heads/qa/$1/" '
    /^worktree /{w=substr($0,10)} /^branch /{b=substr($0,8); if (index(b,pre)==1) print w, substr(b,12)}'
}

cmd_criar() {
  local card="$1"; shift; valida_card "$card"
  local env=0 frentes=()
  for a in "$@"; do
    case "$a" in
      --env) env=1 ;;
      executor|executor-ui|executor-api|documentador) frentes+=("$a") ;;
      *) die "frente desconhecida: $a (executor|executor-ui|executor-api|documentador)" ;;
    esac
  done
  [ ${#frentes[@]} -gt 0 ] || frentes=(executor documentador)

  local base; base=$(git -C "$RAIZ" rev-parse HEAD)
  if [ -n "$(git -C "$RAIZ" status --porcelain --untracked-files=normal -- . ':!.qa')" ]; then
    echo "AVISO: checkout principal tem alterações não commitadas; elas NÃO entram nos worktrees (base = HEAD $base)." >&2
  fi
  garante_exclude
  local estado="$RAIZ/.qa/$card"; mkdir -p "$estado"

  for f in "${frentes[@]}"; do
    local dest="$WT_BASE/$card/$f" br="qa/$card/$f"
    [ -e "$dest" ] && die "destino já existe: $dest (use status/coletar; não reaproveito destino ocupado)"
    git -C "$RAIZ" show-ref --verify --quiet "refs/heads/$br" && die "branch já existe: $br"
    git -C "$RAIZ" worktree add -q -b "$br" "$dest" "$base"
    [ -d "$RAIZ/node_modules" ] && ln -s "$RAIZ/node_modules" "$dest/node_modules"
    if [ "$env" = 1 ]; then
      [ -f "$RAIZ/.env" ] || die "--env pedido mas $RAIZ/.env não existe"
      git -C "$dest" check-ignore -q .env || die ".env não está ignorado pelo Git; não vou ligá-lo"
      ln -s "$RAIZ/.env" "$dest/.env"           # link, nunca cópia
    fi
    local saida="$estado/$f"; mkdir -p "$saida"
    local prefixo; prefixo=$(echo "qa-$card-$f" | tr '[:upper:]' '[:lower:]')
    cat > "$dest/.qa-frente.env" <<EOF
QA_CARD=$card
QA_FRENTE=$f
QA_BASE=$base
QA_PREFIXO=$prefixo
QA_SAIDA=$saida
QA_RAIZ_PRINCIPAL=$RAIZ
PLAYWRIGHT_HTML_REPORT=$saida/report
PLAYWRIGHT_HTML_OPEN=never
EOF
    echo "criada  $f  $dest  ($br @ ${base:0:7})"
  done
  cmd_status "$card" > "$estado/frentes.md"
}

cmd_status() {
  local card="$1"; valida_card "$card"
  echo "# Frentes — $card"
  echo
  local achou=0
  while read -r wt br; do
    [ -n "$wt" ] || continue; achou=1
    local base="?" commits sujo
    [ -f "$wt/.qa-frente.env" ] && base=$(sed -n 's/^QA_BASE=//p' "$wt/.qa-frente.env")
    commits=$(git -C "$wt" rev-list --count "${base}..HEAD" 2>/dev/null || echo "?")
    sujo=$(git -C "$wt" status --porcelain | wc -l | tr -d ' ')
    echo "- ${br##*/} · $wt · branch $br · base ${base:0:7} · commits $commits · alterações $sujo"
  done < <(frentes_do_card "$card")
  [ "$achou" = 1 ] || echo "- nenhuma frente criada"
}

cmd_coletar() {
  local card="$1"; valida_card "$card"
  local destino="$RAIZ/.qa/$card/patches"; mkdir -p "$destino"
  while read -r wt br; do
    [ -n "$wt" ] || continue
    local f=${br##*/} base out
    base=$(sed -n 's/^QA_BASE=//p' "$wt/.qa-frente.env")
    out="$destino/$f.patch"
    {
      git -C "$wt" diff --binary "$base" -- . ':!.qa-frente.env' ':!node_modules' ':!.env'
      git -C "$wt" ls-files --others --exclude-standard -z | while IFS= read -r -d '' novo; do
        git -C "$wt" diff --binary --no-index /dev/null "$novo" || true
      done
    } > "$out"
    local n; n=$(grep -c '^diff --git' "$out" || true)
    echo "coletado $f → $out ($n arquivo(s); commits na frente: $(git -C "$wt" rev-list --count "$base..HEAD"))"
  done < <(frentes_do_card "$card")
  echo "Aplicar no destino (depois de revisar): git apply --check <patch> && git apply <patch>"
}

cmd_remover() {
  local card="$1" f="${2:-}"; valida_card "$card"
  [ -n "$f" ] || die "informe a frente a remover"
  local wt="$WT_BASE/$card/$f" br="qa/$card/$f"
  [ -d "$wt" ] || die "worktree não existe: $wt"
  [ -z "$(git -C "$wt" status --porcelain)" ] \
    || die "$f tem alterações não commitadas; rode 'coletar' e decida antes de remover"
  local base; base=$(sed -n 's/^QA_BASE=//p' "$wt/.qa-frente.env")
  rm -f "$wt/.qa-frente.env"; [ -L "$wt/node_modules" ] && rm "$wt/node_modules"; [ -L "$wt/.env" ] && rm "$wt/.env"
  git -C "$RAIZ" worktree remove "$wt"
  if [ "$(git -C "$RAIZ" rev-list --count "$base..$br")" = 0 ]; then
    git -C "$RAIZ" branch -d "$br" >/dev/null && echo "removido $f (worktree e branch sem commits)"
  else
    echo "removido worktree de $f; branch $br mantida (tem commits)"
  fi
}

acao="${1:-}"; shift || true
case "$acao" in
  criar)   [ $# -ge 1 ] || die "uso: criar <CARD_ID> [frente ...] [--env]"; cmd_criar "$@" ;;
  status)  [ $# -eq 1 ] || die "uso: status <CARD_ID>"; cmd_status "$1" ;;
  coletar) [ $# -eq 1 ] || die "uso: coletar <CARD_ID>"; cmd_coletar "$1" ;;
  remover) [ $# -eq 2 ] || die "uso: remover <CARD_ID> <frente>"; cmd_remover "$1" "$2" ;;
  *) sed -n '2,12p' "$0"; exit 1 ;;
esac
