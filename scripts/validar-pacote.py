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

# 4. Agentes Claude Code: frontmatter e perfil referenciado
for a in sorted((ROOT / ".claude/agents").glob("*.md")):
    fm = frontmatter(a)
    if fm.get("name") != a.stem:
        erros.append(f"{a}: name difere do arquivo")
    if a.stem not in nomes:
        erros.append(f"{a}: sem registro Codex correspondente")

# 5. Skills citadas com prefixo qa-/locais precisam existir
locais = ("qa-", "spec-ready", "worktree-delivery", "delivery-evidence")
for md in list((ROOT / "agents").rglob("*.md")) + list((ROOT / ".claude").rglob("*.md")):
    for nome in re.findall(r"`([a-z][a-z0-9-]+)`", md.read_text(encoding="utf-8")):
        if nome.startswith(locais) and nome not in skills and nome not in nomes:
            erros.append(f"{md}: skill citada não existe: {nome}")

# 6. Links relativos Markdown resolvem
for md in [p for p in ROOT.rglob("*.md") if ".git" not in p.parts]:
    for alvo in re.findall(r"\]\(([^)#\s]+)(?:#[^)]*)?\)", md.read_text(encoding="utf-8")):
        if alvo.startswith(("http", "mailto:")):
            continue
        if not (md.parent / alvo).exists():
            erros.append(f"{md.relative_to(ROOT)}: link quebrado {alvo}")

# 7. Comando /qa-card cita agentes existentes
cmd = ROOT / ".claude/commands/qa-card.md"
if cmd.exists():
    for ag in ("card-reader", "test-designer", "test-executor",
               "regression-runner", "integrity-checker", "bug-reporter"):
        if ag not in nomes:
            erros.append(f"qa-card: agente {ag} não registrado")

print(f"skills={len(skills)} perfis={len(perfis)} codex={len(nomes)}")
if erros:
    print("\n".join(f"ERRO {e}" for e in erros))
    sys.exit(1)
print("OK")
