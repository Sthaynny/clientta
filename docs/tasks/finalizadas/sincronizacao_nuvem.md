# Finalizadas — Sync na nuvem

**Feature:** [sincronizacao_nuvem.md](../../features/sincronizacao_nuvem.md)

---

## C-201 — Repositório Firestore

- **O que fazer:** `ServiceAppointmentRepositoryRemote` em `users/{uid}/appointments`.
- **Objetivo:** Espelho na nuvem para tier Pro.
- **Impacto:** **Alto** — valor Pro.

---

## C-202 — Sync bidirecional

- **O que fazer:** Orquestrar merge local ↔ Firestore com `updatedAt`.
- **Objetivo:** Multi-dispositivo sem perda de dados.
- **Impacto:** **Alto** — valor Pro.

---

## C-203 — Regras Firestore

- **O que fazer:** Regras por `request.auth.uid` em paths do usuário.
- **Objetivo:** Segurança de dados de clientes.
- **Impacto:** **Alto** — confiança.
