# Subagente — Home (painel do dia)

Papel: implementar a tela inicial `/` — atendimentos de hoje, ordenados por `startTime`.

## Docs

- `docs/features/home_hoje.md`
- `docs/tasks/a_fazer/home_hoje.md` — C-102, C-107, C-204 (indicador sync)
- `lib/features/home/`

## Escopo típico

| Entrega | Detalhe |
|---------|---------|
| Filtro do dia | `appointmentDate == hoje` local; opcional ocultar cancelados |
| Ordenação | Por `startTime` (C-107) |
| Cards | `HubAppointmentCard` — horário, cliente, tipo, status |
| Ações rápidas | Concluir, editar notas, cancelar |
| Empty state | CTA → `/agendas/registrar` |
| Header | `HubDayHeader` |
| Offline | `HubOfflineBanner` quando sem rede |
| Pull-to-refresh | Recarrega local; dispara sync se Pro (quando Fase 2 existir) |

## Arquitetura

- `HomeViewModel` com `CommandBase` / `Result<T>`
- Injeta `AppointmentRepository` (local; remote quando sync ativo)
- `ListenableBuilder(listenable: viewmodel.load, ...)`
- Textos em `lib/core/strings/daily_strings.dart`

## Dependências

- `ServiceAppointment` + repo local estável (C-101)
- Opcional: `PlanAccessPolicy` para sync no refresh (Fase 3)

## Verificação

- Testes ViewModel: filtro de data, ordenação, transição de status
- `flutter analyze` + `flutter test`

## Prompt sugerido (Task)

```text
Você implementa o painel do dia do Clientta (rota /).
Leia docs/features/home_hoje.md e siga MVVM + Hub* do projeto.
Escopo: …
IDs: C-102, C-107
Não implementar sync Firestore completo nesta fatia, a menos que pedido.
```
