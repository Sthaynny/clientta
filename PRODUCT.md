# Clientta — PRODUCT

## Platform

adaptive (Android e iOS; web não é prioridade no MVP)

## Register

product

## One-liner

CRM de atendimentos para agentes de crédito, seguros e profissionais autônomos: painel do dia, agendas com notas e sync na nuvem — offline no celular. Tagline: *Agenda, clientes e contexto — no bolso, mesmo sem internet.*

## Audience

| Segmento | Necessidade |
|----------|-------------|
| Atendentes de crédito / seguros | Saber quem atender hoje, histórico rápido e contexto da negociação |
| Gestores de relacionamento | Linha do tempo do cliente sem planilhas dispersas |
| Profissionais autônomos em movimento | App rápido, offline, sem depender de internet instável |

## Core jobs

1. Ver atendimentos de **hoje** ordenados por horário, com atalho para concluir ou abrir histórico.
2. Manter **agenda** de clientes com tipo de serviço, data, horário e status.
3. Consultar **todos os clientes** em lista unificada com busca e abrir histórico de negociação.
4. Registrar **notas de negociação** e encontros sem agendar horário.
5. **Sincronizar** dados entre dispositivos após login (Firestore).
6. Assinar **Pro** para sync ilimitado e recursos avançados (Stripe).

## Constraints

- **Offline-first** — `DeviceJsonStore` (JSON local) como fonte imediata; sync quando online.
- **Firebase Auth** — identidade do usuário; sem senha no app além do provedor Firebase.
- **Firestore** — espelho na nuvem de `ServiceAppointment` e `EncounterNote`; entitlement em `users/{uid}.subscription`.
- **Stripe** — cobrança **fora do app Flutter** (Cloud Functions + Checkout URL); sem Stripe SDK no cliente.
- Textos de UI em `lib/core/strings/`; não hardcoded em widgets.

## Tiers

| Tier | Modelo | Inclui |
|------|--------|--------|
| **Free** | Gratuito na loja | Painel do dia, agenda local, cadastro de atendimentos com limites de volume, notas básicas |
| **Pro** | Assinatura mensal (Stripe) | Agenda sem limite, mesma conta em outro celular, avisos antes do horário, salvar dados em arquivo, suporte prioritário (futuro) |

Detalhes de limites e gates: [docs/features/README.md](docs/features/README.md).  
Billing: [docs/features/assinatura_stripe.md](docs/features/assinatura_stripe.md), [docs/billing/readme.md](docs/billing/readme.md).

## Source of truth

`docs/PROPOSITO.md`, `docs/features/README.md` e `proposta.md`
