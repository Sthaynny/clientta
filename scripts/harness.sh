#!/usr/bin/env bash
# Harness de validação do Clientta: as mesmas barreiras do CI.
# Uso: bash scripts/harness.sh [quick|full|docs|changelog|analyze|test]
set -euo pipefail
cd "$(dirname "$0")/.."

mode="${1:-quick}"

step() { printf '\n== %s ==\n' "$1"; }

check_docs() {
  step "links de .md (README, AGENTS, CHANGELOG e docs/)"
  python3 scripts/check_docs_links.py
}

# lib/ ou functions/*.js mudou em relação à main => CHANGELOG.md precisa mudar junto.
check_changelog() {
  step "CHANGELOG.md"
  grep -q '^## Não lançado' CHANGELOG.md \
    || { echo "CHANGELOG.md sem a seção '## Não lançado'"; exit 1; }
  local base="${CHANGELOG_BASE:-origin/main}"
  if ! git rev-parse --verify --quiet "$base" >/dev/null; then
    echo "base $base indisponível, comparação ignorada"; return 0
  fi
  local changed
  changed="$(git diff --name-only "$base"...HEAD 2>/dev/null || true)"
  if grep -qE '^(lib/|functions/.*\.js$)' <<<"$changed" && ! grep -qx 'CHANGELOG.md' <<<"$changed"; then
    echo "lib/ ou functions/*.js mudou sem CHANGELOG.md: registre em '## Não lançado'"
    exit 1
  fi
  echo "ok"
}

run_analyze() { step "flutter analyze"; flutter pub get >/dev/null; flutter analyze; }
run_tests()   { step "flutter test";    flutter test; }

case "$mode" in
  quick)     check_docs; check_changelog; run_analyze ;;
  full)      check_docs; check_changelog; run_analyze; run_tests ;;
  docs)      check_docs ;;
  changelog) check_changelog ;;
  analyze)   run_analyze ;;
  test)      run_tests ;;
  *) echo "modo desconhecido: $mode (quick|full|docs|changelog|analyze|test)"; exit 2 ;;
esac

printf '\nHarness ok (%s).\n' "$mode"
