# Finalizadas — Export / import backup (Pro)

Backlog da feature **C-411** — backup manual JSON.

---

## C-411 — Export e import JSON de backup

- **Status:** Implementado (v1)
- **Plano:** Pro exclusivo
- **Feature:** [export_backup.md](../../features/export_backup.md)

### Entregue

- `DataBackupService` — export via `share_plus`, import via `file_picker`
- `DataBackupParser` — envelope `schemaVersion: 1` ou JSON cru
- Gate Pro em `PlanAccessPolicy`
- UI em `/plano` com confirmação destrutiva na importação
- Pós-import: reagenda lembretes e `scheduleSync` (Pro)
- Política de privacidade — seção 2.4 (backup manual)
