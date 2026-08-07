# Guia do projeto — Clientta

**Clientta** é um CRM de atendimentos para agentes de crédito, seguros e profissionais autônomos. Pacote Dart em migração: legado **`university_hub`** → alvo **`clientta`**. `applicationId` Android alvo: **`br.com.sthaynny.clientta`**.

## Princípios

- **Offline-first** — dados imediatos em `DeviceJsonStore` (JSON no dispositivo).
- **Sync na nuvem (Pro)** — Firebase Auth + Firestore após login e entitlement ativo.
- **Billing externo** — Stripe via Cloud Functions; app abre Checkout com `url_launcher`.
- **MVVM + GetIt** — ViewModels com `CommandBase`; repositórios encapsulam I/O.

## Como rodar (app Flutter)

```bash
flutter pub get
flutterfire configure   # Firebase (Auth, Firestore)
flutter run
```

Variáveis e config:

- `firebase_options.dart` gerado por FlutterFire (não commitar secrets de produção em repositório público sem política clara).
- Emuladores Firebase opcionais para desenvolvimento local.

## Estrutura de features (alvo)

```
lib/features/
  home/              # Painel do dia (/)
  appointments/      # Agenda + formulário (/agendas, /agendas/registrar)
  subscription/      # Plano Pro (/configuracoes/plano)
  auth/              # Login Firebase
  shared/hub/        # Componentes Hub*
lib/core/
  storage/           # DeviceJsonStore
  router/            # AppRouters
  dependecy/         # GetIt
  strings/           # strings.dart, daily_strings.dart
```

Cada feature: **model → repository (local + remote) → view model → screen**.

## Persistência local

Arquivo: `crm_appointments.json` em `getApplicationDocumentsDirectory()`.

Store: `lib/core/storage/device_json_store.dart`.

Migração: instalações legadas Sextante podem migrar de `university_hub_daily.json` — documentar script de migração na Fase 1.

## Firebase

| Serviço | Uso |
|---------|-----|
| **Auth** | Login do usuário (`uid`) |
| **Firestore** | `users/{uid}`, `users/{uid}/appointments/{id}` |
| **Functions** | Stripe callables + webhook |

Regras: leitura/escrita de appointments apenas para `request.auth.uid == resource.data.userId` (ou path sob `users/{uid}`).

## Stripe (resumo)

- **Sem** Stripe SDK no Flutter.
- Callables: ver [features/assinatura_stripe.md](features/assinatura_stripe.md).
- Setup completo: [billing/readme.md](billing/readme.md).

## CI (Codemagic)

Pipeline sugerido:

1. `flutter analyze`
2. `flutter test`
3. `flutter build appbundle` (release)
4. Deploy Functions (branch `main` ou workflow separado)

Secrets no CI: `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET` — apenas no ambiente de Functions, não no app.

## Testes

- Fixtures: `test/mock/` com `ServiceAppointment`.
- Domínio: `test/features/appointments/`.
- Não referenciar features removidas (classes, activities).

## Documentação relacionada

- [PLANEJAMENTO.md](PLANEJAMENTO.md) — fases MVP → billing
- [ROTEAMENTO.md](ROTEAMENTO.md) — rotas
- [features/README.md](features/README.md) — catálogo Free/Pro
- [../DESIGN.md](../DESIGN.md) — UI/UX
