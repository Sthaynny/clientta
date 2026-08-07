# Export e import JSON de backup — Pro

## Resumo

Permite ao usuário **Pro** exportar e importar o conteúdo local de `clientta_data.json` como arquivo JSON. Complementa o sync na nuvem com cópia manual sob controle do profissional (troca de aparelho, arquivo em nuvem pessoal, etc.).

**Status:** implementado (export + import v1).

---

## Plano

| Recurso | Free | Pro |
|---------|------|-----|
| Exportar backup JSON | — | Sim |
| Importar backup JSON | — | Sim |

Gates: `PlanAccessPolicy.canExportDataBackup` / `canImportDataBackup`.

---

## Formato do arquivo

```json
{
  "schemaVersion": 1,
  "exportedAt": "2026-08-07T20:15:00.000Z",
  "app": "clientta",
  "sourceFile": "clientta_data.json",
  "data": {
    "appointments": [],
    "encounterNotes": [],
    "profile": {}
  }
}
```

Também aceita `clientta_data.json` cru (sem envelope), desde que contenha `appointments` ou `encounterNotes`.

Na importação, apenas as chaves `appointments`, `encounterNotes` e `profile` são restauradas. Metadados de sync (`sync`) são descartados para evitar filas órfãs — o sync Pro é reagendado após a restauração.

Nome sugerido na exportação: `clientta_backup_YYYYMMDD_HHMM.json`.

---

## UI

- Tela `/plano` — seção **Backup dos dados** (somente Pro ativo)
- **Exportar backup JSON** → sheet nativo de compartilhamento (`share_plus`)
- **Importar backup JSON** → seletor de arquivo (`file_picker`) + diálogo de confirmação destrutiva

---

## Arquitetura

```
lib/core/backup/data_backup_service.dart   # export (share) + import (picker)
lib/core/backup/data_backup_parser.dart    # envelope/raw + sanitização
lib/core/plan/plan_access_policy.dart      # gates Pro
```

Pós-importação: `AppointmentReminderCoordinator.syncForAppointments` e `AppointmentSyncService.scheduleSync` (se Pro com sync habilitado).

---

## Critérios de aceite

- [x] Pro: export gera JSON válido com chaves `appointments` e `encounterNotes`
- [x] Free: CTAs bloqueados com mensagem Pro
- [x] Pro: import substitui dados locais após confirmação
- [x] Pro: lembretes e sync reagendados após import

## Documentação relacionada

- [README.md](README.md) — comparativo Free/Pro
- [sincronizacao_nuvem.md](sincronizacao_nuvem.md) — backup automático Pro
- [assinatura_stripe.md](assinatura_stripe.md)
- [lembretes_locais.md](lembretes_locais.md)
