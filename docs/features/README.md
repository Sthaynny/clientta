# Funcionalidades — Clientta

Catálogo de funcionalidades com visão de **plano Free** vs **Pro**.  
Monetização: **assinatura mensal Stripe** (tier Pro); entitlement em Firestore `users/{uid}.subscription`.

## Índice

| Funcionalidade | Arquivo | Plano principal | Status |
|----------------|---------|-----------------|--------|
| Início — painel do dia | [home_hoje.md](home_hoje.md) | Ambos | Planejado (migração) |
| Minha Agenda + formulário | [agendas.md](agendas.md) | Free (limites) / Pro | Planejado |
| Sincronização na nuvem | [sincronizacao_nuvem.md](sincronizacao_nuvem.md) | Pro | Planejado |
| Assinatura Stripe (Pro) | [assinatura_stripe.md](assinatura_stripe.md) | Pro | Planejado |

## Comparativo Free vs Pro

| Área | Free | Pro |
|------|------|-----|
| Painel do dia | Completo | Completo |
| Cadastro de atendimentos | Até **50** ativos (configurável) | Ilimitado |
| Notas por atendimento | Sim | Sim |
| Séries recorrentes | Até **3** séries ativas | Ilimitado |
| Sync Firestore multi-dispositivo | — | Sim |
| Export JSON backup | — | Sim (futuro) |
| Lembretes locais | — | Sim (futuro) |
| Suporte | Comunidade | Prioritário (futuro) |

Limites Free são enforcement no app + validação opcional em Functions.

## Documentação relacionada

- [guia_clientta.md](../guia_clientta.md) — como rodar e arquitetura
- [PROPOSITO.md](../PROPOSITO.md) — visão do produto
- [PLANEJAMENTO.md](../PLANEJAMENTO.md) — fases de entrega
- [billing/readme.md](../billing/readme.md) — setup Stripe
- [mapeamento_tarefas.md](../mapeamento_tarefas.md) — tarefas com objetivo e impacto
- [tasks/README.md](../tasks/README.md) — tarefas a fazer e finalizadas
