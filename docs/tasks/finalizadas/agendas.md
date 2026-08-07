# Finalizadas — Minha Agenda

**Feature:** [agendas.md](../../features/agendas.md)

---

## C-101 — Modelo e repositório local

- **O que fazer:** `ServiceAppointment` + `AppointmentRepositoryLocal` (chave `appointments` em `clientta_data.json` via `DeviceJsonStore`).
- **Objetivo:** Base de domínio do CRM.
- **Impacto:** **Alto** — núcleo.

---

## C-103 — Lista Minha Agenda

- **O que fazer:** Tela `/agendas` agrupada por data/série com filtro por tipo de serviço.
- **Objetivo:** Histórico e navegação da agenda completa.
- **Impacto:** **Alto** — retenção.

### Entregue

- Agrupamento por data ou `seriesId` (`appointment_list_grouping.dart`).
- Filtro por `serviceType` na lista.
- `HubConfirmDialog` / `showHubChoiceDialog` para exclusão.

---

## C-104 — Formulário de atendimento

- **O que fazer:** Formulário `/agendas/registrar` com notas e séries recorrentes.
- **Objetivo:** Cadastro rápido no campo.
- **Impacto:** **Alto** — conversão de uso.

### Entregue

- Validação inline por campo (`AppointmentFormFieldErrors`).
- Séries recorrentes com `HubWeekdayChips` (4 semanas).
- Escopo de edição: só este dia / toda a série.
- Gates Free/Pro via `PlanAccessPolicy` no `AppointmentFormViewModel`.

---

## C-108 — Confirmação ao excluir

- **O que fazer:** Diálogo antes de excluir atendimento ou série.
- **Objetivo:** Evitar perda acidental de histórico.
- **Impacto:** **Médio** — confiança.
