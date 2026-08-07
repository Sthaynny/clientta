# Propósito do Clientta

## Em uma frase

**Clientta** é um **CRM de atendimentos** para agentes de crédito, seguros e profissionais autônomos: painel do **dia**, **agenda** de clientes, **notas de negociação** e **sincronização na nuvem** — com operação **offline-first** no celular.

## Dores do público

1. **Quem atender hoje** — sem abrir planilha ou WhatsApp para ver a agenda do dia.
2. **Contexto da negociação** — propostas, objeções e follow-up perdidos entre ligações.
3. **Mobilidade** — internet instável em campo; o app precisa funcionar sem rede.
4. **Histórico disperso** — séries de reuniões (ex.: follow-up semanal) sem vínculo claro.
5. **Multi-dispositivo** — trocar de celular sem perder cadastros (sync Pro).

## O que o app entrega

| Função | Descrição |
|--------|-----------|
| **Início** | Atendimentos de hoje ordenados por horário; atalho para concluir e abrir histórico de atendimento |
| **Minha Agenda** | Listagem agrupada por data ou série; filtro por tipo de serviço |
| **Meus Clientes** | Lista unificada de clientes (agenda + encontros); busca; abre histórico de atendimento |
| **Atendimento** | Histórico centralizado de negociação por cliente; registrar encontros sem agendar |
| **Registrar atendimento** | Cliente, telefone, tipo, data, horários, notas, série recorrente |
| **Sync na nuvem** | Firestore após login (tier Pro) |
| **Plano Pro** | Assinatura Stripe para sync e recursos avançados |

Catálogo **Free / Pro**: [features/README.md](features/README.md).

## Modelo de dados

Entidade principal: `ServiceAppointment`

| Campo | Descrição |
|-------|-----------|
| `id` | Identificador único |
| `clientName` | Nome do cliente |
| `clientPhone` | Telefone |
| `serviceType` | Ex.: Empréstimo Consignado, Seguro Auto |
| `appointmentDate` | Data do atendimento |
| `startTime` / `endTime` | Horário (string `HH:mm`) |
| `status` | `agendado`, `concluido`, `cancelado` |
| `notes` | Bloco de anotações da negociação (legado; ver `EncounterNote`) |
| `seriesId` | Opcional — vínculo em séries recorrentes |

Entidade complementar: `EncounterNote` — anotações de encontros/negociações por cliente (`clientPhone`), com histórico na tela `/atendimentos`. Persistência local: chave `encounterNotes` em `clientta_data.json`.

Agregado de UI: `ClientProfile` — perfil derivado por cliente (telefone como chave), montado a partir de agendamentos e encontros para a tela `/clientes`. Não é persistido separadamente.

Persistência local de agendamentos: chave `appointments` em `clientta_data.json` via `DeviceJsonStore`.

## Rotas

| Tela | Caminho |
|------|---------|
| Início (painel do dia) | `/` |
| Minha Agenda | `/agendas` |
| Meus Clientes | `/clientes` |
| Atendimento (histórico do cliente) | `/atendimentos` |
| Registrar atendimento | `/agendas/registrar` |
| Plano / assinatura | `/plano` |

Detalhes em [ROTEAMENTO.md](ROTEAMENTO.md).

## Arquitetura

```
Flutter (MVVM + GetIt)
  ├── DeviceJsonStore (JSON local, offline-first)
  │     └── ServiceAppointmentRepositoryLocal
  ├── Firebase Auth (identidade)
  ├── Firestore (sync de agendamentos — Pro)
  └── Cloud Functions + Stripe (assinatura Pro)
        └── users/{uid}.subscription (entitlement)
```

Guia técnico: [guia_clientta.md](guia_clientta.md).

## Evolução

Roteiro de fases: [PLANEJAMENTO.md](PLANEJAMENTO.md).
