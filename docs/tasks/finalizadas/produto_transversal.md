# Finalizadas — Produto (transversal)

---

## C-001 — Documentação Clientta

- **O que fazer:** Documentação **Clientta** (README, PRODUCT, DESIGN, features, tasks, billing).
- **Objetivo:** Alinhar time e roadmap ao CRM de atendimentos.
- **Impacto:** **Alto** — direção de produto.
- **Feature:** [PROPOSITO.md](../../PROPOSITO.md)

---

## C-109 — Onboarding

- **O que fazer:** Fluxo inicial orientado a primeiro atendimento.
- **Objetivo:** Reduzir abandono na primeira sessão.
- **Impacto:** **Alto** — retenção.

### Entregue

- `OnboardingScreen` com 2 páginas (offline + primeiro atendimento).
- Flag `onboardingSeen` em `AppProfileSettings`; gate em `MyApp`.
- CTA final abre `/agendas/registrar` diretamente.
