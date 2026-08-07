# A fazer — Auth Firebase

**Feature:** [guia_clientta.md](../../guia_clientta.md)

---

## C-105 — Firebase Auth

- **Status:** Concluído (e-mail/senha). Google Sign-In pendente de OAuth client no `google-services.json`.
- **O que fazer:** Login e cadastro (e-mail/senha ou Google) com rotas `/login`, `/cadastro`.
- **Objetivo:** Identidade (`uid`) para Firestore e Stripe.
- **Impacto:** **Alto** — infraestrutura.
- **Feature:** [guia_clientta.md](../../guia_clientta.md)

### Entregue

- `AuthGate` com `authStateChanges()`, bootstrap de `users/{uid}` e transição animada.
- Rotas públicas `/login`, `/cadastro` via `AuthShell`; app protegido em `MyApp`.
- Repositórios `AuthRepository` / `UserRepository` (sem escrita de `subscription`).
- Logout no drawer.
- Strings CRM em `daily_strings.dart` / `strings.dart`.
- Testes: `test/features/auth/auth_repository_test.dart`.

### Pendências

- Google Sign-In: adicionar SHA-1/SHA-256 no Firebase Console e reexecutar `flutterfire configure` (OAuth client vazio em `google-services.json`).
