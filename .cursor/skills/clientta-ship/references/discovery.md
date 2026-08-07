# Discovery — Clientta

Checklist antes de delegar a um subagente.

## Stack

- Flutter MVVM + `CommandBase` / `Result<T>`
- GetIt em `lib/core/dependecy/dependency.dart`
- Persistência local: `DeviceJsonStore` → `crm_appointments.json`
- Firebase Auth + Firestore (sync Pro)
- Stripe via Cloud Functions (`functions/`), checkout com `url_launcher`

## Padrão de feature (referência: `appointments`)

```
lib/features/<feature>/
  domain/models/
  domain/repositories/
  data/
  view/
```

## Rotas núcleo

| Rota | Feature |
|------|---------|
| `/` | home-hoje |
| `/agendas` | agendas |
| `/agendas/registrar` | agendas |
| `/login`, `/cadastro` | auth-firebase |
| `/configuracoes/plano` | assinatura-stripe |

## Backlog por fase (PLANEJAMENTO.md)

| Fase | Foco | IDs principais |
|------|------|----------------|
| 1 MVP | auth + agendamentos locais | C-101…C-109 |
| 2 Pro | sync Firestore | C-201…C-204 |
| 3 Pro | billing Stripe | C-301…C-305 |
| Contínuo | qualidade + legado | C-401…C-404, C-106, C-403 |

## Verificação obrigatória

```bash
flutter analyze
flutter test
```
