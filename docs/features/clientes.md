# Meus Clientes — listagem centralizada

## Resumo

Tela **Meus Clientes** (`/clientes`) que reúne todos os clientes a partir da **agenda** (`ServiceAppointment`) e do **histórico de atendimento** (`EncounterNote`). Permite buscar por nome ou telefone e abrir o histórico de negociação de cada cliente.

## Plano

**Ambos** (Free e Pro)

| Recurso | Free | Pro |
|---------|------|-----|
| Listagem de clientes | Sim | Sim |
| Busca por nome/telefone | Sim | Sim |
| Abrir histórico de atendimento | Sim | Sim |
| Próximo agendamento no card | Sim | Sim |
| Sync dos dados de origem | — | Sim (via appointments + encounterNotes) |

## Modelo agregado

### `ClientProfile`

Perfil derivado (não persistido separadamente) — calculado por `buildClientProfiles`:

| Campo | Descrição |
|-------|-----------|
| `clientKey` | Chave de agrupamento (telefone normalizado ou nome em fallback) |
| `clientName` | Nome mais recente |
| `clientPhone` | Telefone |
| `serviceType` | Tipo de serviço do registro mais recente |
| `appointmentCount` | Quantidade de agendamentos |
| `encounterCount` | Quantidade de encontros registrados |
| `lastActivityAt` | Data da última interação (agenda ou encontro) |
| `nextAppointmentDate` | Próximo agendamento `agendado` (hoje ou futuro) |
| `nextAppointmentStartTime` | Horário do próximo agendamento |

Agrupamento: `normalizeClientPhone` (`lib/features/client_care/domain/client_phone_key.dart`). Sem telefone, agrupa por nome normalizado.

## Tela (`/clientes`)

| Aspecto | Detalhe |
|---------|---------|
| Acesso | Drawer → **Meus Clientes** |
| Busca | Campo com filtro em tempo real |
| Card | `HubClientCard` — avatar com iniciais, telefone, tipo, chips de resumo, próximo horário |
| Toque no card | Abre `/atendimentos` com `ClientCareArgs` |
| Empty state | Orienta a registrar atendimentos na agenda |
| Pull-to-refresh | Recarrega e dispara sync Pro quando aplicável |

## Navegação

| Origem | Ação |
|--------|------|
| Drawer | **Meus Clientes** → `/clientes` |
| Card de cliente | Toque → `/atendimentos` |
| Voltar | Retorna ao painel do dia (`/`) |

## Dependências técnicas

- `ClientsViewModel` — `load`, `searchQuery`, `visibleProfiles`
- `buildClientProfiles` / `filterClientProfiles` — `lib/features/clients/domain/client_profile_aggregator.dart`
- `AppointmentRepository` + `EncounterNoteRepository` — fontes de dados
- `HubClientCard`, `HubClientAvatar` — `lib/features/shared/hub/hub_client_card.dart`
- Testes: `test/features/clients/client_profile_aggregator_test.dart`
- Rotas: [ROTEAMENTO.md](../ROTEAMENTO.md)

## Status no app

**Implementado** — drawer, rota `/clientes`, agregador e busca.
