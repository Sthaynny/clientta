# Billing — Stripe setup (Clientta)

Guia operacional para configurar cobrança **Pro** do Clientta. Padrão: **Cloud Functions + Firestore entitlement**, sem Stripe SDK no Flutter (igual ao projeto agendamentos).

## Pré-requisitos

- Projeto Firebase com Blaze (Functions + Firestore)
- Conta Stripe (Dashboard)
- CLI: `firebase-tools`, Node 20+ para Functions

## 1. Produto e preço no Stripe

1. Dashboard Stripe → **Products** → Create product **Clientta Pro**.
2. Adicionar preço **recurring** mensal (ex.: BRL).
3. Anotar `price_...` (live) e criar preço de teste em modo sandbox.

## 2. Secrets (Cloud Functions)

Configurar via Firebase CLI — **nunca** no app Flutter:

```bash
firebase functions:secrets:set STRIPE_SECRET_KEY
firebase functions:secrets:set STRIPE_WEBHOOK_SECRET
```

| Secret | Conteúdo |
|--------|----------|
| `STRIPE_SECRET_KEY` | `sk_test_...` ou `sk_live_...` |
| `STRIPE_WEBHOOK_SECRET` | `whsec_...` do endpoint webhook |

Opcional: `STRIPE_PRO_PRICE_ID` se não retornado dinamicamente por `getPlanPricing`.

### Codemagic / CI

Adicionar secrets no grupo de Functions deploy; não incluir em `codemagic.yaml` do app Flutter.

## 3. Deploy das Functions

Estrutura sugerida em `functions/src/`:

- `stripe/getPlanPricing.ts`
- `stripe/createSubscription.ts`
- `stripe/syncSubscriptionStatus.ts`
- `stripe/cancelSubscription.ts`
- `stripe/stripeBillingWebhook.ts`

```bash
cd functions
npm install
firebase deploy --only functions
```

## 4. Webhook Stripe

1. Dashboard → Developers → Webhooks → Add endpoint.
2. URL: `https://<region>-<project>.cloudfunctions.net/stripeBillingWebhook`
3. Eventos: `checkout.session.completed`, `customer.subscription.*`, `invoice.payment_failed`
4. Copiar **Signing secret** → `STRIPE_WEBHOOK_SECRET`.

Para desenvolvimento local:

```bash
stripe listen --forward-to localhost:5001/<project>/<region>/stripeBillingWebhook
```

## 5. Firestore entitlement

Documento `users/{uid}`:

```json
{
  "subscription": {
    "status": "active",
    "stripeCustomerId": "cus_xxx",
    "stripeSubscriptionId": "sub_xxx",
    "priceId": "price_xxx",
    "currentPeriodEnd": "<Timestamp>",
    "cancelAtPeriodEnd": false
  }
}
```

**Regras:** cliente autenticado pode **ler** `users/{uid}`; **escrita** em `subscription` apenas via Admin SDK (Functions/webhook).

## 6. Fluxo no app

1. Usuário autenticado abre `/configuracoes/plano`.
2. App chama `getPlanPricing` → exibe preço.
3. CTA “Assinar Pro” → `createSubscription` → `checkoutUrl`.
4. `url_launcher` abre Checkout.
5. Após pagamento, webhook atualiza Firestore.
6. App chama `syncSubscriptionStatus` ou listener em `users/{uid}`.
7. Features Pro (sync) liberadas.

URLs de retorno Checkout (Dashboard Stripe):

- Success: `https://clientta.app/plano/sucesso` ou deep link customizado
- Cancel: `https://clientta.app/plano/cancelado`

## 7. Cancelamento

- App chama `cancelSubscription`.
- Function cancela na Stripe (`cancel_at_period_end` recomendado).
- Webhook atualiza status; app reflete na UI.

## 8. Testes

| Caso | Verificação |
|------|-------------|
| Checkout sandbox | `subscription.status == active` no Firestore |
| Pagamento falho | `past_due` ou `canceled` após `invoice.payment_failed` |
| Free user | Sync bloqueado; limites de agenda aplicados |
| Webhook replay | Idempotência por `event.id` na Function |

## 9. Checklist de produção

- [ ] Trocar `sk_test` por `sk_live` nos secrets
- [ ] Webhook live com secret distinto
- [ ] Regras Firestore revisadas
- [x] Política de privacidade menciona Stripe e Firebase
- [ ] Página de plano sem expor secrets ou price IDs sensíveis em logs

## Documentação relacionada

- [features/assinatura_stripe.md](../features/assinatura_stripe.md)
- [features/sincronizacao_nuvem.md](../features/sincronizacao_nuvem.md)
- [guia_clientta.md](../guia_clientta.md)
