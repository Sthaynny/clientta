# A fazer — Início (painel do dia)

**Feature:** [home_hoje.md](../../features/home_hoje.md)

---

## C-102 — Painel do dia

- **Status:** Concluído
- **O que fazer:** Implementar **painel do dia** (`/`) com atendimentos de hoje.
- **Objetivo:** Resposta imediata a “quem atender hoje”.
- **Impacto:** **Alto** — retenção.
- **Feature:** [home_hoje.md](../../features/home_hoje.md)

### Entregue

- `HubDayHeader`, `HubHomeQuickActions`, `HubAppointmentCard` com ações rápidas.
- Empty state com CTA → `/agendas/registrar`.
- Pull-to-refresh; estados loading, error e feedback via snackbar.

---

## C-107 — Ordenar por horário

- **Status:** Concluído
- **O que fazer:** Ordenar atendimentos de hoje por `startTime`.
- **Objetivo:** Leitura natural da agenda operacional.
- **Impacto:** **Médio** — UX.
- **Feature:** [home_hoje.md](../../features/home_hoje.md)

### Entregue

- `HomeViewModel.filterTodayAppointments` ordena por `startTime`; cancelados excluídos do painel.

---

## C-204 — Indicador de sync (UI)

- **Status:** Concluído
- **O que fazer:** Exibir status offline/sync na home (Pro).
- **Objetivo:** Transparência quando sync está pendente.
- **Impacto:** **Médio** — UX.
- **Feature:** [home_hoje.md](../../features/home_hoje.md)

### Entregue

- `HubOfflineBanner` com variantes offline, sync pendente e sincronizando.
- Label “última sincronização” para usuários Pro.
- `NetworkStatusPort` / `NetworkStatusService` para detecção de conectividade.

### Pendências (baixa prioridade)

- Widget test da `HomeScreen` (ViewModel já coberto em `home_view_model_test.dart`).
- Migrar detecção de rede para `connectivity_plus` (hoje DNS lookup).
