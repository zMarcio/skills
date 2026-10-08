#!/usr/bin/env python3
"""Valida o pacote de agentes e skills: frontmatter, TOML, links e skills citadas.

Uso: python3 scripts/validar-pacote.py   (a partir da raiz do repositório)
Sai com código 1 se houver erro.
"""
import pathlib
import re
import sys
import tomllib

ROOT = pathlib.Path(__file__).resolve().parent.parent
erros: list[str] = []


def frontmatter(path: pathlib.Path) -> dict:
    texto = path.read_text(encoding="utf-8")
    m = re.match(r"^---\n(.*?)\n---\n", texto, re.S)
    if not m:
        erros.append(f"{path}: sem frontmatter")
        return {}
    campos = {}
    for linha in m.group(1).splitlines():
        if ":" in linha:
            k, v = linha.split(":", 1)
            campos[k.strip()] = v.strip()
    return campos


# 1. Skills: frontmatter com name igual à pasta e description
skills = set()
for s in sorted((ROOT / ".agents/skills").glob("*/SKILL.md")):
    fm = frontmatter(s)
    if fm.get("name") != s.parent.name:
        erros.append(f"{s}: name '{fm.get('name')}' difere da pasta")
    if not fm.get("description"):
        erros.append(f"{s}: sem description")
    skills.add(s.parent.name)

# 2. Perfis Markdown em agents/
perfis = {}
for p in sorted((ROOT / "agents").glob("*/*.md")):
    fm = frontmatter(p)
    if fm.get("name"):
        perfis[fm["name"]] = p

# 3. TOML Codex: válido, perfil referenciado existe
nomes = set()
for t in sorted((ROOT / ".codex/agents").glob("*.toml")):
    try:
        d = tomllib.loads(t.read_text(encoding="utf-8"))
    except tomllib.TOMLDecodeError as e:
        erros.append(f"{t}: TOML inválido: {e}")
        continue
    nome = d.get("name")
    if nome in nomes:
        erros.append(f"{t}: nome duplicado {nome}")
    nomes.add(nome)
    for ref in re.findall(r"agents/[\w-]+/[\w-]+\.md", d.get("developer_instructions", "")):
        if not (ROOT / ref).exists():
            erros.append(f"{t}: referência inexistente {ref}")

# 4. Agentes Claude Code: frontmatter, skills pré-carregadas e sem delegação
claude_agentes = set()
for a in sorted((ROOT / ".claude/agents").glob("*.md")):
    fm = frontmatter(a)
    if fm.get("name") != a.stem:
        erros.append(f"{a}: name difere do arquivo")
    if not fm.get("description"):
        erros.append(f"{a}: sem description")
    claude_agentes.add(a.stem)
    bloco = re.search(r"^skills:\n((?:\s+- .+\n)+)", a.read_text(encoding="utf-8"), re.M)
    if not bloco:
        erros.append(f"{a}: sem skills pré-carregadas")
    else:
        for nome in re.findall(r"- (\S+)", bloco.group(1)):
            if nome not in skills:
                erros.append(f"{a}: skill pré-carregada não existe: {nome}")
    if "Agent" not in fm.get("disallowedTools", ""):
        erros.append(f"{a}: deve bloquear Agent (só o orquestrador delega)")

# 5. Skills citadas com prefixo qa-/locais precisam existir
locais = ("qa-", "spec-ready", "worktree-delivery", "delivery-evidence",
          "audit-scope-readonly", "controlled-vulnerability-validation", "security-findings-report")
for md in list((ROOT / "agents").rglob("*.md")) + list((ROOT / ".claude").rglob("*.md")):
    for nome in re.findall(r"`([a-z][a-z0-9-]+)`", md.read_text(encoding="utf-8")):
        if nome.startswith(locais) and nome not in skills and nome not in nomes and nome not in claude_agentes:
            erros.append(f"{md}: skill citada não existe: {nome}")

# 6. Links relativos Markdown resolvem
for md in [p for p in ROOT.rglob("*.md") if ".git" not in p.parts]:
    for alvo in re.findall(r"\]\(([^)#\s]+)(?:#[^)]*)?\)", md.read_text(encoding="utf-8")):
        if alvo.startswith(("http", "mailto:")):
            continue
        if not (md.parent / alvo).exists():
            erros.append(f"{md.relative_to(ROOT)}: link quebrado {alvo}")

# 7. Comando /qa-card cita os seis agentes, e cada um existe
cmd = ROOT / ".claude/commands/qa-card.md"
agentes_card = ("leitor", "verificador", "regressao", "questionador", "spec-reviewer", "test-executor",
                "performance", "cibersecurity", "documentador", "escritor")
if cmd.exists():
    texto = cmd.read_text(encoding="utf-8")
    for ag in agentes_card:
        if ag not in claude_agentes:
            erros.append(f"qa-card: agente {ag} não existe em .claude/agents")
        if f"**{ag}**" not in texto:
            erros.append(f"qa-card: agente {ag} não é acionado no comando")

# 8. Cibersecurity cita as 10 skills escolhidas; as 7 externas não precisam estar no repo
EXTERNAS = ("audit-context-building", "security-threat-model", "static-analysis", "fp-check",
            "differential-review", "variant-analysis", "security-best-practices")
PROPRIAS = ("audit-scope-readonly", "controlled-vulnerability-validation", "security-findings-report")
ciber = ROOT / ".claude/agents/cibersecurity.md"
if ciber.exists():
    texto = ciber.read_text(encoding="utf-8")
    for s in EXTERNAS + PROPRIAS:
        if f"`{s}`" not in texto:
            erros.append(f"cibersecurity: skill {s} não citada")
    for s in PROPRIAS:
        if s not in skills:
            erros.append(f"cibersecurity: skill própria {s} ausente em .agents/skills")

# 9. Skills de terceiros copiadas (têm NOTICE.md) precisam trazer a LICENSE
for notice in sorted((ROOT / ".agents/skills").glob("*/NOTICE.md")):
    if not (notice.parent / "LICENSE").exists():
        erros.append(f"{notice.parent.relative_to(ROOT)}: skill de terceiros sem LICENSE")

# 10. Script de worktree executável e com sintaxe válida
import os, subprocess
for sh in (ROOT / ".agents/skills/qa-worktree-frentes/scripts/qa-frentes.sh",
           ROOT / "scripts/instalar-skills-qa.sh"):
    if not sh.exists():
        erros.append(f"{sh.relative_to(ROOT)}: ausente")
        continue
    if not os.access(sh, os.X_OK):
        erros.append(f"{sh.relative_to(ROOT)}: sem permissão de execução")
    if subprocess.run(["bash", "-n", str(sh)]).returncode != 0:
        erros.append(f"{sh.relative_to(ROOT)}: erro de sintaxe")

print(f"skills={len(skills)} perfis={len(perfis)} codex={len(nomes)} claude={len(claude_agentes)}")
if erros:
    print("\n".join(f"ERRO {e}" for e in erros))
    sys.exit(1)
print("OK")
