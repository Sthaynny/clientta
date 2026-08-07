# Finalizadas — Billing (Stripe)

**Feature:** [assinatura_stripe.md](../../features/assinatura_stripe.md), [billing/readme.md](../../billing/readme.md)

---

## C-301 — Cloud Functions Stripe

- **O que fazer:** Callables `getPlanPricing`, `createSubscription`, `syncSubscriptionStatus`, `cancelSubscription`.
- **Objetivo:** Cobrança sem SDK no app Flutter.
- **Impacto:** **Alto** — receita.

---

## C-302 — Webhook Stripe

- **O que fazer:** HTTP `stripeBillingWebhook` + secrets + atualização de `users/{uid}.subscription`.
- **Objetivo:** Entitlement confiável após pagamento.
- **Impacto:** **Alto** — receita.

---

## C-303 — Tela Plano Pro

- **O que fazer:** UI `/configuracoes/plano` com preço, assinar, cancelar, sync status.
- **Objetivo:** Descoberta e gestão da assinatura Pro.
- **Impacto:** **Alto** — conversão.

---

## C-304 — Gates Free/Pro

- **O que fazer:** Enforcement de limites Free e bloqueio de sync sem entitlement.
- **Objetivo:** Diferenciar tiers de forma clara.
- **Impacto:** **Alto** — valor Pro.

---

## C-305 — Cancelamento automático por inatividade

- **O que fazer:** Job agendado + rastreamento de `lastActivityAt` + política documentada.
- **Objetivo:** Cancelar assinaturas Pro sem uso por 2 meses.
- **Impacto:** **Médio** — retenção e custo operacional.
- **Política:** [politica-assinatura.md](../../legal/politica-assinatura.md)
