# Finalizadas — Início (painel do dia)

**Feature:** [home_hoje.md](../../features/home_hoje.md)

---

## C-102 — Painel do dia

- **O que fazer:** Implementar **painel do dia** (`/`) com atendimentos de hoje.
- **Objetivo:** Resposta imediata a “quem atender hoje”.
- **Impacto:** **Alto** — retenção.

### Entregue

- `HubDayHeader`, `HubHomeQuickActions`, `HubAppointmentCard` com barra de ações horizontal.
- Toque no card ou **Ver atendimento** abre `/atendimentos` (substitui observação rápida).
- Empty state com CTA → `/agendas/registrar`.
- Pull-to-refresh; estados loading, error e feedback via snackbar.

---

## C-107 — Ordenar por horário

- **O que fazer:** Ordenar atendimentos de hoje por `startTime`.
- **Objetivo:** Leitura natural da agenda operacional.
- **Impacto:** **Médio** — UX.

### Entregue

- `HomeViewModel.filterTodayAppointments` ordena por `startTime`; cancelados excluídos do painel.

---

## C-204 — Indicador de sync (UI)

- **O que fazer:** Exibir status offline/sync na home (Pro).
- **Objetivo:** Transparência quando sync está pendente.
- **Impacto:** **Médio** — UX.

### Entregue

- `HubOfflineBanner` com variantes offline, sync pendente e sincronizando.
- Label “última sincronização” para usuários Pro.
- `NetworkStatusPort` / `NetworkStatusService` para detecção de conectividade.
