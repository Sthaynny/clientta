# Cloud Functions — Clientta

Backend Firebase do Clientta (billing Stripe e políticas de assinatura).

**Setup completo:** [docs/billing/readme.md](../docs/billing/readme.md)  
**Arquitetura da feature:** [docs/features/assinatura_stripe.md](../docs/features/assinatura_stripe.md)

## Comandos rápidos

```bash
cd functions && npm install
npm test
firebase deploy --only functions,firestore:rules
```

Secrets: `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET` — ver guia de billing.
