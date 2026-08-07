# Minha Agenda — listagem e formulário

## Resumo

Feature central do Clientta: **cadastro**, **listagem** e **edição** de atendimentos (`ServiceAppointment`). Inclui listagem agrupada (`/agendas`) e formulário (`/agendas/registrar`).

## Modelo

```dart
class ServiceAppointment {
  final String id;
  final String clientName;
  final String clientPhone;
  final String serviceType;
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;
  final String status; // agendado | concluido | cancelado
  final String? notes;
  final String? seriesId;
}
```

Persistência local: chave `appointments` em `clientta_data.json` via `AppointmentRepositoryLocal`.

## Plano

**Free** (limites) / **Pro** (ilimitado)

### Free

- CRUD de atendimentos com limites (ver [README.md](README.md)).
- Filtro por `serviceType` na lista.
- Séries recorrentes limitadas.
- Notas multilinha no formulário.

### Pro

- Sem limites de cadastro e séries.
- Sync Firestore (ver [sincronizacao_nuvem.md](sincronizacao_nuvem.md)).

## Minha Agenda (`/agendas`)

| Aspecto | Detalhe |
|---------|---------|
| Agrupamento | Por data ou por `seriesId` (séries recorrentes) |
| Filtros | Tipo de serviço (dropdown) |
| Ordenação | Data decrescente; dentro do dia por `startTime` |
| Card | `HubAppointmentCard` — horário, nome, **telefone formatado**, tipo de serviço, status |
| Ações no card | Barra horizontal: ver atendimento, editar, excluir |
| Toque no card | Abre `/atendimentos` com histórico de negociação do cliente |
| FAB | `HubFab` → `/agendas/registrar` |
| Empty state | CTA primeiro atendimento |

## Formulário (`/agendas/registrar`)

| Campo | Componente |
|-------|------------|
| Nome do cliente | `HubTextFormField` |
| Telefone | `HubTextFormField` (máscara BR via `input_masks.dart`) |
| Tipo de serviço | `DropdownButtonFormField` + presets configuráveis |
| Data | `HubDateFormField` |
| Início / fim | Texto `HH:mm` ou time picker |
| Notas | `HubTextFormField` multilinha expansível |
| Série recorrente | Chips de dias da semana (`HubWeekdayChips`, 4 semanas) |
| Salvar | `HubPrimaryButton` → `viewmodel.save.execute()` |

Prefill a partir de `/atendimentos`: `AppointmentFormLaunchArgs` com nome, telefone e tipo do cliente.

Padrão MVVM: `hydrate()` em `initState`; `save.addListener`; sucesso → `context.back(true)`.

## Séries (`seriesId`)

Atendimentos com o mesmo `seriesId` formam uma série (ex.: follow-up semanal). Ao editar série:

- Alterar **este dia** apenas, ou
- Alterar **toda a série** (diff em lote no ViewModel).

## Status no app

**Implementado** — feature principal de agendamentos do Clientta.

## Dependências técnicas

- `AppointmentsViewModel` — lista, filtros, exclusão em lote por série.
- `AppointmentFormViewModel` — validação, save local, sync queue (Pro).
- Testes: `test/features/appointments/`.
- Rotas: [ROTEAMENTO.md](../ROTEAMENTO.md).
