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
| **Início** | Atendimentos de hoje ordenados por horário; atalho para concluir e anotar |
| **Minha Agenda** | Listagem agrupada por data ou série; filtro por tipo de serviço |
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
| `notes` | Bloco de anotações da negociação |
| `seriesId` | Opcional — vínculo em séries recorrentes |

Persistência local: `crm_appointments.json` via `DeviceJsonStore`.

## Rotas

| Tela | Caminho |
|------|---------|
| Início (painel do dia) | `/` |
| Minha Agenda | `/agendas` |
| Registrar atendimento | `/agendas/registrar` |
| Plano / assinatura | `/configuracoes/plano` |

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
