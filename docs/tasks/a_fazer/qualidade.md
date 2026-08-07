# A fazer — Qualidade

---

## C-401 — Flutter analyze

- **Status:** Em andamento
- **O que fazer:** Manter `flutter analyze` sem erros no branch principal.
- **Objetivo:** Evitar regressões em release.
- **Impacto:** **Alto** — manutenção.
- **Feature:** [PLANEJAMENTO.md](../../PLANEJAMENTO.md)

---

## C-402 — Testes de domínio

- **Status:** Não iniciado
- **O que fazer:** Testes de ViewModels de appointments com `mocktail`.
- **Objetivo:** Refatorar com segurança.
- **Impacto:** **Médio** — manutenção.
- **Feature:** [guia_clientta.md](../../guia_clientta.md)

---

## C-405 — Política de privacidade

- **Status:** Concluído
- **O que fazer:** Documento legal cobrindo Auth, Firestore, Stripe e dados locais.
- **Objetivo:** Conformidade Play/App Store.
- **Impacto:** **Alto** — confiança.
- **Feature:** [PLANEJAMENTO.md](../../PLANEJAMENTO.md)

### Entregue

- Política de privacidade LGPD em [politica-privacidade.md](../../legal/politica-privacidade.md).

---

## C-406 — Testes de integração

- **Status:** Concluído
- **O que fazer:** `integration_test` do fluxo: login → registrar → painel do dia.
- **Objetivo:** Regressão de navegação.
- **Impacto:** **Médio** — manutenção.
- **Feature:** [PLANEJAMENTO.md](../../PLANEJAMENTO.md)

### Entregue

- Smoke em `integration_test/app_test.dart` + helpers em `integration_test/test_helpers.dart`.
- AuthGate → home (`homeTodayString`) ou login (`loginWelcomeString`); onboarding pré-marcado via `AppProfileRepository`.

- **Nota:** Rodar em Android/iOS (`flutter test integration_test -d <device>`). Fluxo completo login → registrar → painel fica para iteração futura (auth real).
