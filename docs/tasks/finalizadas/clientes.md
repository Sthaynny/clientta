# Finalizadas — Meus Clientes e atendimento

**Features:** [clientes.md](../../features/clientes.md), [atendimento.md](../../features/atendimento.md)

---

## C-110 — Histórico centralizado de negociação

- **O que fazer:** Tela `/atendimentos` com timeline por cliente (`EncounterNote`).
- **Objetivo:** Contexto de negociação sem depender só de notas no agendamento.
- **Impacto:** **Alto** — retenção e follow-up.

### Entregue

- `ClientCareScreen` + `ClientCareViewModel` (`load`, `addNote`).
- `EncounterNote` persistido em `clientta_data.json` (chave `encounterNotes`).
- Composer: texto livre ou registro de sessão do dia (corpo vazio, uma vez por dia).
- Cabeçalho com avatar, telefone formatado, badge de serviço, `HubClientContactBar` (ligar / WhatsApp).
- CTA **Agendar na home** com prefill no formulário (`AppointmentFormLaunchArgs`).
- Sync Pro de `encounterNotes` no Firestore.

---

## C-112 — Meus Clientes

- **O que fazer:** Listagem centralizada de clientes no drawer com busca.
- **Objetivo:** Encontrar qualquer cliente e abrir o histórico sem passar pela agenda.
- **Impacto:** **Alto** — navegação e contexto.

### Entregue

- Rota `/clientes` (`AppRouters.clients`).
- `ClientsViewModel` + `buildClientProfiles` (agenda + encontros).
- `HubClientCard` com resumo (agendamentos, encontros, última atividade, próximo horário).
- Item **Meus Clientes** no `AppDrawer`.
- Testes do agregador em `test/features/clients/`.

---

## C-113 — Cards de atendimento e máscaras

- **O que fazer:** Melhorar exibição do cliente nos cards e formatar telefone.
- **Objetivo:** Leitura rápida no campo e ações menos confusas.
- **Impacto:** **Médio** — UX operacional.

### Entregue

- `HubAppointmentCard` com telefone, tipo de serviço em destaque e barra de ações horizontal.
- Remoção de ações duplicadas (nota rápida vs. ver atendimento).
- `formatBrPhone` e utilitários em `lib/core/utils/input_masks.dart`.
- `client_contact_launcher.dart` — ligar e abrir WhatsApp.
- Home: remoção de `updateNotes` obsoleto; card abre `/atendimentos`.
