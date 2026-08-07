# A fazer — Billing

**Feature:** [assinatura_stripe.md](../../features/assinatura_stripe.md), [billing/readme.md](../../billing/readme.md)

---

## C-301 — Cloud Functions Stripe

- **Status:** Concluído
- **O que fazer:** Implementar callables `getPlanPricing`, `createSubscription`, `syncSubscriptionStatus`, `cancelSubscription`.
- **Objetivo:** Cobrança sem SDK no app Flutter.
- **Impacto:** **Alto** — receita.
- **Feature:** [assinatura_stripe.md](../../features/assinatura_stripe.md)

---

## C-302 — Webhook Stripe

- **Status:** Concluído
- **O que fazer:** HTTP `stripeBillingWebhook` + secrets + atualização de `users/{uid}.subscription`.
- **Objetivo:** Entitlement confiável após pagamento.
- **Impacto:** **Alto** — receita.
- **Feature:** [billing/readme.md](../../billing/readme.md)
