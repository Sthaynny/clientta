# Atendimento — histórico centralizado de negociação

## Resumo

Tela de **atendimento por cliente** (`/atendimentos`) que centraliza todas as anotações de encontros e negociações em um único histórico cronológico — **sem exigir agendamento na agenda** para registrar o que aconteceu.

## Modelo

### `EncounterNote`

```dart
class EncounterNote {
  final String id;
  final String clientPhone;   // chave de agrupamento (normalizada)
  final String clientName;
  final String? serviceType;
  final String? appointmentId; // vínculo opcional com agendamento
  final String body;
  final DateTime createdAt;
  final DateTime? updatedAt;
}
```

Persistência local: chave `encounterNotes` em `clientta_data.json` via `EncounterNoteRepositoryLocal`.

### Compatibilidade com notas legadas

Notas antigas em `ServiceAppointment.notes` continuam visíveis no histórico (badge **Agendamento**), exceto quando já existir `EncounterNote` com o mesmo `appointmentId`.

## Plano

**Ambos** (Free e Pro)

| Recurso | Free | Pro |
|---------|------|-----|
| Histórico por cliente | Sim | Sim |
| Registrar encontro sem agenda | Sim | Sim |
| Notas legadas de agendamento | Sim | Sim |
| Sync Firestore de `encounterNotes` | — | Futuro |

## Tela (`/atendimentos`)

| Aspecto | Detalhe |
|---------|---------|
| Argumentos | `ClientCareArgs`: `clientName`, `clientPhone`, `serviceType?`, `appointmentId?` |
| Cabeçalho | Nome, telefone e tipo de serviço do cliente |
| Histórico | Lista cronológica (mais recente primeiro) com data/hora |
| Composer fixo | Campo multilinha + botão **Registrar encontro** |
| Empty state | Orienta a anotar sem precisar marcar horário |

## Navegação

| Origem | Ação |
|--------|------|
| Home — card do dia | Toque no card ou ícone de nota → `/atendimentos` |
| Minha Agenda | Toque no card ou ícone de atendimento → `/atendimentos` |
| Minha Agenda | Ícone editar → `/agendas/registrar` (inalterado) |

## Fluxo do atendente

1. Atender cliente (ligação, visita, WhatsApp) — **sem abrir formulário de agenda**.
2. Abrir atendimento pelo card existente ou pelo histórico do cliente.
3. Registrar encontro no composer inferior.
4. Consultar todo o histórico de negociação em um único bloco.

## Dependências técnicas

- `ClientCareViewModel` — `load`, `addNote`
- `buildCareTimeline` — agrega `EncounterNote` + notas legadas de agendamentos
- `EncounterNoteRepository` — CRUD local offline-first
- Rotas: [ROTEAMENTO.md](../ROTEAMENTO.md)

## Status no app

**Implementado** — substitui o diálogo de “observação rápida” da home por tela dedicada.
