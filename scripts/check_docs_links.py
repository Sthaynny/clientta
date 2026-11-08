#!/usr/bin/env python3
"""Valida links relativos para arquivos .md (README.md, AGENTS.md, CHANGELOG.md e docs/)."""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LINK_RE = re.compile(r"\]\(([^)#\s]+\.md)(?:#[^)]*)?\)")
SKIP_DIRS = {"node_modules", ".dart_tool", "build", ".git", ".idea"}


def markdown_files() -> list[Path]:
    files = [p for p in ROOT.glob("*.md")]
    docs = ROOT / "docs"
    if docs.is_dir():
        files += [p for p in docs.rglob("*.md") if not SKIP_DIRS & set(p.parts)]
    return sorted(files)


def main() -> int:
    broken: list[tuple[Path, str]] = []
    for md in markdown_files():
        text = md.read_text(encoding="utf-8", errors="replace")
        for match in LINK_RE.finditer(text):
            target = match.group(1)
            if target.startswith(("http://", "https://", "mailto:")):
                continue
            base = ROOT if target.startswith("/") else md.parent
            if not (base / target.lstrip("/")).resolve().is_file():
                broken.append((md, target))

    if broken:
        print("Links .md quebrados:")
        for md, target in broken:
            print(f"  {md.relative_to(ROOT)} -> {target}")
        return 1
    print(f"Links de docs OK ({len(markdown_files())} arquivos).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
