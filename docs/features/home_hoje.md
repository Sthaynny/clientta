# Início — Painel do dia

## Resumo

Tela inicial (`/`) com **atendimentos do dia corrente**, ordenados por `startTime`. É o painel operacional “quem atender agora” — atalhos para **marcar como concluído**, **adicionar notas** e abrir o formulário de novo atendimento.

## Plano

**Ambos** (Free e Pro)

### Free

- Lista completa dos atendimentos de hoje (`appointmentDate == hoje`).
- Ordenação por horário de início.
- Ações rápidas: concluir, editar notas, cancelar.
- Banner offline quando sem rede (`HubOfflineBanner`).
- Drawer com navegação (Agenda, Plano Pro).

### Pro

- Mesma experiência, sem limites de volume herdados da agenda.
- Indicador de sync (última sincronização, pendências) quando Fase 2 ativa.

## UX

| Elemento | Comportamento |
|----------|---------------|
| Cabeçalho de data | `HubDayHeader` — “Hoje, 7 de agosto” |
| Card de atendimento | Horário, nome, telefone, tipo de serviço, badge de status |
| Toque no card | Abre `/atendimentos` — histórico centralizado de negociação |
| Status `agendado` | Ação primária “Concluir” |
| Status `concluido` | Notas visíveis; ícone abre histórico de atendimento |
| Empty state | CTA “Registrar atendimento” → `/agendas/registrar` |
| Pull-to-refresh | Recarrega local; dispara sync se Pro + online |

## Status no app

**Planejado** — painel do dia em `features/home`. Rota `/`.

## Dependências técnicas

- `HomeViewModel` (ou `TodayPanelViewModel`) agrega `ServiceAppointmentRepository`.
- Filtro: `appointmentDate` no dia local + `status != cancelado` (opcional: toggle para mostrar cancelados).
- `ListenableBuilder(listenable: viewmodel.load, ...)`.
- Ver [ROTEAMENTO.md](../ROTEAMENTO.md), [agendas.md](agendas.md).
