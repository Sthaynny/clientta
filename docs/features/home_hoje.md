# Início — Painel do dia

## Resumo

Tela inicial (`/`) com **atendimentos do dia corrente**, ordenados por `startTime`. É o painel operacional “quem atender agora” — atalhos para **marcar como concluído**, **cancelar** e abrir o **histórico de atendimento** do cliente.

## Plano

**Ambos** (Free e Pro)

### Free

- Lista completa dos atendimentos de hoje (`appointmentDate == hoje`).
- Ordenação por horário de início.
- Ações rápidas: concluir, cancelar, ver atendimento.
- Banner offline quando sem rede (`HubOfflineBanner`).
- Drawer com navegação (Agenda, Clientes, Plano).

### Pro

- Mesma experiência, sem limites de volume herdados da agenda.
- Indicador de sync (última sincronização, pendências).

## UX

| Elemento | Comportamento |
|----------|---------------|
| Cabeçalho de data | `HubDayHeader` — “Hoje, 7 de agosto” |
| Card de atendimento | `HubAppointmentCard` — horário, nome, telefone, tipo de serviço, badge de status |
| Barra de ações | Horizontal na base do card: concluir, cancelar, ver atendimento |
| Toque no card | Abre `/atendimentos` — histórico centralizado de negociação |
| Status `agendado` | Ação **Concluir** e **Cancelar** |
| Status `concluido` | Notas visíveis no card; **Ver atendimento** abre histórico |
| Empty state | CTA “Registrar atendimento” → `/agendas/registrar` |
| Pull-to-refresh | Recarrega local; dispara sync se Pro + online |

## Status no app

**Implementado** — painel do dia em `features/home`. Rota `/`.

## Dependências técnicas

- `HomeViewModel` — `load`, `markComplete`, `cancelAppointment`
- Filtro: `filterTodayAppointments` — dia local + `status != cancelado`, ordenado por `startTime`
- `ListenableBuilder(listenable: viewmodel.load, ...)`
- Ver [ROTEAMENTO.md](../ROTEAMENTO.md), [agendas.md](agendas.md), [atendimento.md](atendimento.md)
