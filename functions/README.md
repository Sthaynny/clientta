# Cloud Functions — Clientta Billing

Stripe Billing via Cloud Functions (padrão [agendamentos](https://github.com/sthaynny/agendamentos)).

## Fluxo

1. App chama `getPlanPricing` → catálogo Pro
2. `createSubscription` → Stripe Checkout Session (ou sandbox em test mode)
3. Webhook `stripeBillingWebhook` atualiza `users/{uid}.subscription`
4. App chama `syncSubscriptionStatus` ao retornar do Checkout

## Secrets

```bash
firebase functions:secrets:set STRIPE_SECRET_KEY
firebase functions:secrets:set STRIPE_WEBHOOK_SECRET
```

Copie `functions/.secret.local.example` para `functions/.secret.local` no emulador.

## Deploy

```bash
cd functions && npm install
firebase deploy --only functions,firestore:rules
```

## Webhook (Stripe Dashboard)

Eventos: `checkout.session.completed`, `customer.subscription.updated`, `customer.subscription.deleted`, `invoice.paid`, `invoice.payment_failed`

URL: `https://southamerica-east1-<PROJECT_ID>.cloudfunctions.net/stripeBillingWebhook`
