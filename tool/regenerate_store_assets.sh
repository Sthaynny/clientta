#!/usr/bin/env bash
# Regenera assets de loja via skill publicidade (scripts globais).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="${ROOT}/docs/stores/store-manifest.yaml"

resolve_scripts_dir() {
  if [[ -n "${PUBLICIDADE_SCRIPTS:-}" && -f "${PUBLICIDADE_SCRIPTS}/compose-store-assets.sh" ]]; then
    echo "${PUBLICIDADE_SCRIPTS}"
    return 0
  fi
  local d
  for d in \
    "${HOME}/.agents/skills/publicidade/scripts" \
    "${HOME}/.cursor/skills/publicidade/scripts"; do
    if [[ -f "${d}/compose-store-assets.sh" ]]; then
      echo "${d}"
      return 0
    fi
  done
  return 1
}

SCRIPTS_DIR="$(resolve_scripts_dir)" || {
  echo "Skill publicidade não encontrada." >&2
  echo "Instale: bash my_utils/.agents/skills/publicidade/scripts/install-global.sh" >&2
  echo "Ou defina PUBLICIDADE_SCRIPTS apontando para a pasta scripts/ da skill." >&2
  exit 1
}

exec bash "${SCRIPTS_DIR}/compose-store-assets.sh" "${ROOT}" "${MANIFEST}"
