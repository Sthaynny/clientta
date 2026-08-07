# A fazer — Sync na nuvem

**Feature:** [sincronizacao_nuvem.md](../../features/sincronizacao_nuvem.md)

---

## C-201 — Repositório Firestore

- **Status:** Concluído
- **O que fazer:** `ServiceAppointmentRepositoryRemote` em `users/{uid}/appointments`.
- **Objetivo:** Espelho na nuvem para tier Pro.
- **Impacto:** **Alto** — valor Pro.
- **Feature:** [sincronizacao_nuvem.md](../../features/sincronizacao_nuvem.md)

---

## C-202 — Sync bidirecional

- **Status:** Concluído
- **O que fazer:** Orquestrar merge local ↔ Firestore com `updatedAt`.
- **Objetivo:** Multi-dispositivo sem perda de dados.
- **Impacto:** **Alto** — valor Pro.
- **Feature:** [sincronizacao_nuvem.md](../../features/sincronizacao_nuvem.md)

---

## C-203 — Regras Firestore

- **Status:** Concluído
- **O que fazer:** Regras por `request.auth.uid` em paths do usuário.
- **Objetivo:** Segurança de dados de clientes.
- **Impacto:** **Alto** — confiança.
- **Feature:** [sincronizacao_nuvem.md](../../features/sincronizacao_nuvem.md)
