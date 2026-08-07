# Finalizadas — Auth Firebase

**Feature:** [guia_clientta.md](../../guia_clientta.md)

---

## C-105 — Firebase Auth

- **O que fazer:** Login e cadastro (e-mail/senha ou Google) com rotas `/login`, `/cadastro`.
- **Objetivo:** Identidade (`uid`) para Firestore e Stripe.
- **Impacto:** **Alto** — infraestrutura.

### Entregue

- `AuthGate` com `authStateChanges()`, bootstrap de `users/{uid}` e transição animada.
- Rotas públicas `/login`, `/cadastro` via `AuthShell`; app protegido em `MyApp`.
- Repositórios `AuthRepository` / `UserRepository` (sem escrita de `subscription`).
- `signInWithGoogle()` via `google_sign_in` + `GoogleAuthProvider.credential`.
- Botão "Entrar com Google" em login e cadastro; erros tratados (cancelado, indisponível).
- Logout no drawer (inclui `GoogleSignIn.signOut()`).
- Strings CRM em `daily_strings.dart` / `strings.dart`.
- Testes: `test/features/auth/auth_repository_test.dart`.

### Pendências operacionais

- **Google Sign-In:** adicionar SHA-1 e SHA-256 do app Android no Firebase Console.
- Reexecutar `flutterfire configure` para popular o OAuth client em `google-services.json`.
- Habilitar provedor **Google** em Authentication → Sign-in method.
- iOS: conferir `REVERSED_CLIENT_ID` no `Info.plist` após `flutterfire configure`.
