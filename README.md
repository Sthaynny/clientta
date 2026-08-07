<p align="center">
O <strong>Clientta</strong> é um <strong>CRM de atendimentos</strong> para quem vende crédito, seguros e serviços no dia a dia: veja <strong>quem atender hoje</strong>, organize <strong>agendas</strong>, registre <strong>notas de negociação</strong> e mantenha histórico — <strong>offline no celular</strong>, com <strong>sincronização na nuvem</strong> e plano <strong>Pro</strong> via Stripe.
</p>

<p align="center"><em>Agenda, clientes e contexto — no bolso, mesmo sem internet.</em></p>

## Documentação

| Documento | Conteúdo |
|-----------|----------|
| [docs/PROPOSITO.md](docs/PROPOSITO.md) | Visão do produto |
| [PRODUCT.md](PRODUCT.md) | Plataforma, audiência, jobs e tiers |
| [DESIGN.md](DESIGN.md) | Cena de uso, paleta e componentes |
| [docs/features/README.md](docs/features/README.md) | Catálogo Free / Pro |
| [docs/PLANEJAMENTO.md](docs/PLANEJAMENTO.md) | Fases de entrega (MVP → billing) |
| [docs/mapeamento_tarefas.md](docs/mapeamento_tarefas.md) | Mapeamento de tarefas (objetivo e impacto) |
| [docs/tasks/README.md](docs/tasks/README.md) | Tarefas por feature (a fazer / finalizadas) |
| [docs/guia_clientta.md](docs/guia_clientta.md) | Como rodar, Firebase e arquitetura |
| [docs/billing/readme.md](docs/billing/readme.md) | Stripe, secrets e webhook |
| [docs/ROTEAMENTO.md](docs/ROTEAMENTO.md) | Rotas do app |

## Stack

- **Flutter** — MVVM + GetIt, offline-first com `DeviceJsonStore`
- **Firebase** — Auth + Firestore (sync de agendamentos)
- **Stripe** — assinatura Pro via Cloud Functions (sem SDK no app)

## Migração

Este repositório evolui do produto **Sextante** (organizador universitário offline). A documentação e o roadmap refletem **Clientta**; o código pode ainda usar o pacote `university_hub` até a migração de namespaces.
