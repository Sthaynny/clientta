# Funcionalidades — Clientta

Catálogo de funcionalidades com visão de **plano Free** vs **Pro**.  
Monetização: **assinatura mensal Stripe** (tier Pro); entitlement em Firestore `users/{uid}.subscription`.

## Índice

| Funcionalidade | Arquivo | Plano principal | Status |
|----------------|---------|-----------------|--------|
| Início — painel do dia | [home_hoje.md](home_hoje.md) | Ambos | Implementado |
| Minha Agenda + formulário | [agendas.md](agendas.md) | Free (limites) / Pro | Implementado |
| Meus Clientes | [clientes.md](clientes.md) | Ambos | Implementado |
| Atendimento — histórico centralizado | [atendimento.md](atendimento.md) | Ambos | Implementado |
| Sincronização na nuvem | [sincronizacao_nuvem.md](sincronizacao_nuvem.md) | Pro | Implementado |
| Assinatura Stripe (Pro) | [assinatura_stripe.md](assinatura_stripe.md) | Pro | Implementado |
| Lembretes locais | [lembretes_locais.md](lembretes_locais.md) | Pro | Implementado |

## Comparativo Free vs Pro

| Área | Free | Pro |
|------|------|-----|
| Painel do dia | Completo | Completo |
| Cadastro de atendimentos | Até **50** ativos (configurável) | Ilimitado |
| Lista de clientes com busca | Sim | Sim |
| Histórico de negociação por cliente | Sim | Sim |
| Séries recorrentes | Até **3** séries ativas | Ilimitado |
| Sync Firestore multi-dispositivo | — | Sim |
| Export JSON backup | — | Sim (futuro) |
| Lembretes locais | — | Sim (15 min antes; configurável) |
| Suporte | Comunidade | Prioritário (futuro) |

Limites Free são enforcement no app via `PlanAccessPolicy`.

## Documentação relacionada

- [guia_clientta.md](../guia_clientta.md) — como rodar e arquitetura
- [PROPOSITO.md](../PROPOSITO.md) — visão do produto
- [PLANEJAMENTO.md](../PLANEJAMENTO.md) — fases de entrega
- [billing/readme.md](../billing/readme.md) — setup Stripe
- [legal/politica-assinatura.md](../legal/politica-assinatura.md) — regras da assinatura Pro
- [tasks/README.md](../tasks/README.md) — backlog e entregas
