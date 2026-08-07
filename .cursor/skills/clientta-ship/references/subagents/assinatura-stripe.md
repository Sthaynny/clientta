# Subagente — Assinatura Stripe (app Flutter)

Papel: tela `/configuracoes/plano`, gates Free/Pro e checkout via URL — **sem Stripe SDK no Flutter**.

## Docs

- `docs/features/assinatura_stripe.md`
- `docs/tasks/a_fazer/assinatura_stripe.md` — C-303, C-304
- `lib/features/billing/`, `lib/core/plan/plan_access_policy.dart`

## Escopo típico

| Entrega | Detalhe |
|---------|---------|
| Entidade | `UserSubscription` lida de Firestore `users/{uid}.subscription` |
| Repository | `BillingRepository` → callables Cloud Functions |
| Tela plano | Preço, assinar, cancelar, sincronizar status |
| Checkout | `url_launcher` com URL de `createSubscription` |
| Return URL | `billing_return_url.dart` — deep link / web |
| Gates | Limites Free (50 ativos, 3 séries); bloqueio sync sem Pro |
| Leitura only | Cliente **não** escreve `subscription` |

## Callables (consumir, não implementar aqui)

- `getPlanPricing`
- `createSubscription`
- `syncSubscriptionStatus`
- `cancelSubscription`

## Arquitetura

```
lib/features/billing/
  domain/entities/user_subscription.dart
  domain/repositories/billing_repository.dart
  data/datasources/firebase_billing_datasource.dart
  data/repositories/billing_repository_impl.dart
  view/plan_settings_screen.dart
lib/core/plan/plan_access_policy.dart
```

## Dependências

- C-105 Auth
- C-301/C-302 Functions deployadas (ou emulador)

## Verificação

- Sandbox Stripe com chaves de teste
- `flutter analyze` + `flutter test`

## Prompt sugerido (Task)

```text
Você implementa billing no app Flutter do Clientta (C-303, C-304).
Sem flutter_stripe — apenas Cloud Functions + url_launcher.
Leia docs/features/assinatura_stripe.md e lib/features/billing/.
Escopo: …
```
