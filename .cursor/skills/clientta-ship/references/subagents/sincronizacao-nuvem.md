# Subagente — Sincronização na nuvem (Pro)

Papel: espelhar `ServiceAppointment` no Firestore com sync bidirecional — **somente tier Pro**.

## Docs

- `docs/features/sincronizacao_nuvem.md`
- `docs/tasks/a_fazer/sincronizacao_nuvem.md` — C-201…C-204
- `firestore.rules`, `firestore.indexes.json`

## Escopo típico

| Entrega | Detalhe |
|---------|---------|
| Remote repo | `AppointmentRepositoryRemote` → `users/{uid}/appointments/{id}` |
| Sync | Merge local ↔ remoto com `updatedAt` / versão |
| Regras | `request.auth.uid == userId` (C-203) |
| Gate Pro | Sync só com `subscription.status == active` |
| UI | `HubOfflineBanner`, indicador última sync (C-204) |

## Arquitetura

```
lib/features/appointments/data/appointment_repository_remote.dart
lib/features/appointments/data/appointment_sync_service.dart  # se necessário
```

- Repositório local permanece fonte imediata (offline-first)
- Sync em background após mudanças locais ou pull-to-refresh

## Dependências

- C-105 Auth
- C-101 repo local estável
- C-304 gates Pro (ou flag dev)

## Verificação

- Regras: `firebase emulators` ou deploy em projeto de teste
- Testes de merge / conflito no domínio
- `flutter analyze` + `flutter test`

## Prompt sugerido (Task)

```text
Você implementa sync Firestore Pro no Clientta.
Leia docs/features/sincronizacao_nuvem.md. Offline-first: local é imediato.
Escopo: …
IDs: C-201, C-202, C-203, C-204
```
