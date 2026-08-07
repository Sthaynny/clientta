# Finalizadas — Qualidade

---

## C-405 — Política de privacidade

- **O que fazer:** Documento legal cobrindo Auth, Firestore, Stripe e dados locais.
- **Objetivo:** Conformidade Play/App Store.
- **Impacto:** **Alto** — confiança.

### Entregue

- Política de privacidade LGPD em [politica-privacidade.md](../../legal/politica-privacidade.md).
- Política de assinatura em [politica-assinatura.md](../../legal/politica-assinatura.md).

---

## C-406 — Testes de integração

- **O que fazer:** `integration_test` do fluxo principal.
- **Objetivo:** Regressão de navegação.
- **Impacto:** **Médio** — manutenção.

### Entregue

- Scaffold em `integration_test/app_test.dart` — smoke AuthGate → home ou login.
- Rodar em Android/iOS: `flutter test integration_test -d <device>`.
