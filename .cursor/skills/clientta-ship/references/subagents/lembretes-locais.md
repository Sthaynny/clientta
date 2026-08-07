# Subagente — Lembretes locais (Pro)

Papel: notificações locais antes do atendimento — **somente Pro**, sem push remoto.

## Docs

- `docs/features/lembretes_locais.md`
- `docs/tasks/a_fazer/lembretes_locais.md` — C-410
- `lib/features/appointments/domain/reminders/`
- `lib/core/plan/plan_access_policy.dart`

## Escopo típico

| Entrega | Detalhe |
|---------|---------|
| Policy | `AppointmentReminderPolicy` — elegibilidade, `fireAt`, `notificationId` |
| Scheduler | `LocalAppointmentReminderScheduler` — `flutter_local_notifications` |
| Coordinator | `AppointmentReminderCoordinator` — gate Pro + sync com agenda |
| Settings | `AppProfileSettings.appointmentReminders` em JSON local |
| Gate | `PlanAccessPolicy.canScheduleLocalReminders` |
| Sync | `HomeViewModel.load` reconcilia alarmes |

## Restrições

- **Pro only** — Free não agenda; cancelar todos se perder entitlement
- Offline-first — sem Firestore para alarmes
- Não usar FCM / push na nuvem nesta feature
- Strings em `daily_strings.dart`

## Verificação

- Teste manual: atendimento em +2h, lead 15 min, notificação dispara
- `flutter analyze`

## Prompt sugerido (Task)

```text
Você implementa lembretes locais do Clientta (C-410).
Leia docs/features/lembretes_locais.md.
Pro only via PlanAccessPolicy. Sem push remoto.
Escopo: …
```
