# Subagente — Auth Firebase

Papel: login/cadastro com Firebase Auth; gate mínimo para sync e billing.

## Docs

- `docs/tasks/finalizadas/auth_firebase.md` — C-105
- `docs/guia_clientta.md`
- `lib/features/auth/`, `lib/core/config/firebase_bootstrap.dart`

## Escopo típico

| Entrega | Detalhe |
|---------|---------|
| Bootstrap | `Firebase.initializeApp` em `main.dart` / `firebase_bootstrap.dart` |
| Telas | `/login`, `/cadastro` (e-mail/senha; Google se no escopo) |
| Gate | `AuthGate` — usuário autenticado → app; senão → login |
| Persistência | `FirebaseAuth.instance.authStateChanges()` |
| Firestore path | `users/{uid}` criado no primeiro login (sem escrever `subscription`) |
| Strings | `lib/core/strings/strings.dart` |

## Arquitetura

- `lib/features/auth/view/login_screen.dart`
- `lib/features/auth/view/auth_gate.dart`
- Router: rotas públicas vs protegidas
- Offline-first: app funciona local; auth exigido conforme decisão de produto

## Regras

- **Não** colocar secrets no app
- **Não** escrever `subscription` no cliente
- uid usado em paths Firestore e linkage Stripe

## Verificação

- Fluxo manual: cadastro → login → logout
- `flutter analyze` + `flutter test` (mocks de Auth se aplicável)

## Prompt sugerido (Task)

```text
Você implementa Firebase Auth no Clientta (C-105).
Leia docs/tasks/finalizadas/auth_firebase.md e lib/features/auth/.
Escopo: …
Métodos: e-mail/senha [e Google se pedido].
```
