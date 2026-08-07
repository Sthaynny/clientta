# Subagente — Agendas (lista + formulário)

Papel: CRUD de `ServiceAppointment` em `/agendas` e `/agendas/registrar`.

## Docs

- `docs/features/agendas.md`
- `docs/tasks/finalizadas/agendas.md` — C-101, C-103, C-104, C-108
- `lib/features/appointments/` (padrão de referência)

## Escopo típico

| Entrega | Detalhe |
|---------|---------|
| Modelo | `ServiceAppointment` imutável, fromMap/toMap/copyWith |
| Repo local | `clientta_data.json` via `DeviceJsonStore` |
| Lista `/agendas` | Agrupamento por data/série; filtro `serviceType`; FAB |
| Formulário | Cliente, telefone, tipo, data, horários, notas, `seriesId` |
| Validação | `appointment_form_validation.dart` |
| Exclusão | Diálogo de confirmação (C-108) |
| Limites Free | Enforcement via `PlanAccessPolicy` (C-304, quando billing ativo) |

## Componentes UI

- `HubTextFormField`, `HubDateFormField`, `HubTimeFormField`
- `DropdownButtonFormField` com `initialValue` + `ValueKey` (não usar API deprecated)
- `HubFab`, `HubEmptyState`, `HubAppointmentCard`
- Loading lista: `HubAppointmentListLoadingSkeleton` (ver [shimmer-loading.md](shimmer-loading.md))

## Arquitetura

```
lib/features/appointments/
  domain/models/service_appointment.dart
  domain/repositories/appointment_repository.dart
  data/appointment_repository_local.dart
  view/appointments_screen.dart + appointments_view_model.dart
  view/appointment_form_screen.dart + appointment_form_view_model.dart
```

- Form ViewModel via `app_router.dart` + `arguments: ServiceAppointment?`
- GetIt: singleton repo; factory para list ViewModel

## Verificação

- `test/features/appointments/service_appointment_test.dart`
- Testes de validação e ViewModel
- `flutter analyze` + `flutter test`

## Prompt sugerido (Task)

```text
Você implementa Minha Agenda do Clientta (rotas /agendas e /agendas/registrar).
Siga lib/features/appointments/ como padrão. Leia docs/features/agendas.md.
Escopo: …
IDs: C-101, C-103, C-104, C-108
```
