# Exportar e importar backup

## Resumo

Exportar o arquivo JSON local para backup manual e restaurar em outro aparelho ou após reinstalação, mantendo o princípio offline-first.

## Plano

**Pro**

### Free

- Dados permanecem apenas no dispositivo; backup manual via explorador de arquivos do sistema (sem fluxo guiado no app).
- Menção no [GUIA_UNIVERSITARIO.md](../GUIA_UNIVERSITARIO.md) sobre localização do arquivo.

### Pro

- Exportar `university_hub_daily.json` via share intent (`share_plus` ou equivalente).
- Importar com validação de schema e confirmação antes de sobrescrever.
- Histórico opcional de backups locais (backlog).

## Status no app

**Planejado** — Fase 2 em [PLANEJAMENTO.md](../PLANEJAMENTO.md) (item 2.1).

## Dependências / notas técnicas

- Arquivo: `getApplicationDocumentsDirectory()` / `device_json_store.dart`.
- Migração legada de `conectafersa_daily.json`.
- Sem upload automático para servidor.
