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
- **Nota:** Scaffold em `integration_test/app_test.dart` — smoke AuthGate → home ou login. Onboarding marcado via `AppProfileRepository`. Rodar em Android/iOS (`flutter test integration_test -d <device>`). Fluxo completo login → registrar → painel fica para iteração futura (auth real).
