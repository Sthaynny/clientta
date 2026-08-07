# Subagente — Billing Cloud Functions (Stripe backend)

Papel: implementar callables e webhook Stripe em `functions/` — backend da assinatura Pro.

## Docs

- `docs/tasks/a_fazer/billing.md` — C-301, C-302
- `docs/billing/readme.md`
- `functions/` — `index.js`, `billing.js`, `pricing.js`, `stripe_client.js`

## Escopo típico

| Entrega | Detalhe |
|---------|---------|
| Callables | `getPlanPricing`, `createSubscription`, `syncSubscriptionStatus`, `cancelSubscription` |
| Webhook | `stripeBillingWebhook` → atualiza `users/{uid}.subscription` |
| Secrets | Stripe keys via Firebase secrets — nunca no repo |
| Idempotência | `stripe_idempotency.js` para eventos duplicados |
| Customer | Link `stripeCustomerId` em `users/{uid}` |

## Regras

- Auth obrigatória nas callables (`context.auth.uid`)
- Cliente Flutter **não** escreve `subscription`
- Preços em `pricing.js` ou Stripe Products — documentar em `docs/billing/`
- Testar com Stripe CLI: `stripe listen --forward-to …`

## Verificação

```bash
cd functions && npm test   # se houver
firebase emulators:start --only functions
```

- Webhook atualiza Firestore em evento `checkout.session.completed` / `customer.subscription.*`
- Deploy separado do app (CI C-404)

## Prompt sugerido (Task)

```text
Você implementa Cloud Functions Stripe do Clientta (C-301, C-302).
Trabalhe em functions/. Leia docs/billing/readme.md.
Secrets só via Firebase — não commitar chaves.
Escopo: …
```
