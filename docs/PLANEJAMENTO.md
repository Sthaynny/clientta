# Planejamento — Clientta

Documento de roteiro para evolução do **Clientta**.  
Referências: [PROPOSITO.md](PROPOSITO.md), [guia_clientta.md](guia_clientta.md), [ROTEAMENTO.md](ROTEAMENTO.md), [features/README.md](features/README.md), [tasks/README.md](tasks/README.md), [../PRODUCT.md](../PRODUCT.md), [../DESIGN.md](../DESIGN.md).

---

## 1. Estado atual (baseline)

| Área | Situação |
|------|----------|
| **Produto** | Documentação Clientta; domínio CRM de atendimentos |
| **Arquitetura** | Flutter MVVM + GetIt + `DeviceJsonStore` |
| **UI** | Tema `HubTheme` + componentes `Hub*` |
| **Auth / sync** | Implementado — Firebase Auth + Firestore sync (Pro) |
| **Billing** | Implementado — Stripe via Cloud Functions |
| **Pacote Dart** | `clientta` |

---

## 2. Princípios para priorizar trabalho

1. **Offline first** — valor sem internet após instalar; sync é complemento Pro.
2. **Baixa fricção** — poucos passos para registrar um atendimento.
3. **Clareza do “hoje”** — início do app como painel operacional do dia.
4. **Segurança de dados** — Auth Firebase; regras Firestore por `uid`.
5. **Billing fora do app** — Stripe Checkout via URL; entitlement em Firestore.
6. **Consistência de UI** — novas telas usam componentes `Hub*` em `lib/features/shared/hub/`.

---

## 3. Fase 1 — MVP (auth + agendamentos locais)

Objetivo: app utilizável no dia a dia sem sync nem cobrança.

| # | Entrega | Notas |
|---|---------|--------|
| 1.1 | Modelo `ServiceAppointment` + repositório local | `clientta_data.json` (chave `appointments`) |
| 1.2 | **Home** — painel do dia | Ordenação por `startTime`; ações concluir / notas |
| 1.3 | **Minha Agenda** — lista agrupada | Filtro por `serviceType` |
| 1.4 | **Formulário** `/agendas/registrar` | Cliente, telefone, tipo, data, horários, notas, `seriesId` |
| 1.4b | **Atendimento** `/atendimentos` | Histórico de negociação por cliente; registrar encontros sem agenda; ligar/WhatsApp |
| 1.4c | **Meus Clientes** `/clientes` | Lista unificada com busca; abre histórico de atendimento |
| 1.5 | Firebase **Auth** (e-mail/senha ou Google) | Gate mínimo para futuro sync |
| 1.6 | Remover código obsoleto | Features e rotas não utilizadas |
| 1.7 | `flutter analyze` + testes de domínio | ViewModels de appointments |

**Critério de conclusão:** fluxo completo offline (criar → listar → concluir → anotar) com login opcional ou obrigatório conforme decisão de produto.

---

## 4. Fase 2 — Sincronização na nuvem (Pro)

Objetivo: backup automático e multi-dispositivo.

| # | Entrega | Dependência |
|---|---------|-------------|
| 2.1 | `ServiceAppointmentRepositoryRemote` (Firestore) | Auth |
| 2.2 | Sync bidirecional local ↔ nuvem | Repositório local estável |
| 2.3 | Regras Firestore `appointments/{id}` por `uid` | Firebase project |
| 2.4 | Indicador de sync / offline na UI | `HubOfflineBanner` |
| 2.5 | Gate Pro — sync só com entitlement ativo | Fase 3 ou flag de dev |

Detalhe: [features/sincronizacao_nuvem.md](features/sincronizacao_nuvem.md).

---

## 5. Fase 3 — Billing Stripe (Pro)

Objetivo: monetização por assinatura mensal.

| # | Entrega | Notas |
|---|---------|--------|
| 3.1 | Cloud Functions callables | `getPlanPricing`, `createSubscription`, etc. |
| 3.2 | Webhook `stripeBillingWebhook` | Atualiza `users/{uid}.subscription` |
| 3.3 | Tela `/plano` | `url_launcher` para Checkout |
| 3.4 | Sandbox com chaves de teste | Ver [billing/readme.md](billing/readme.md) |
| 3.5 | Cancelamento e sync de status | `cancelSubscription`, `syncSubscriptionStatus` |

Detalhe: [features/assinatura_stripe.md](features/assinatura_stripe.md).

---

## 6. Fase 4 — Polish e distribuição

| # | Entrega |
|---|---------|
| 4.1 | Onboarding (valor offline + primeiro atendimento) |
| 4.2 | Empty states e copy validada com usuários reais |
| 4.3 | Lembretes locais (`flutter_local_notifications`) — Pro | Concluído — [lembretes_locais.md](features/lembretes_locais.md) |
| 4.4 | Export JSON de backup — Pro | Concluído — [export_backup.md](features/export_backup.md) |
| 4.5 | Testes de integração e Patrol |
| 4.6 | Política de privacidade (Auth, Firestore, Stripe, lembretes, backup) | Parcial — [politica-privacidade.md](legal/politica-privacidade.md) |
| 4.7 | Listing Play Store / App Store |

---

## 7. Débito técnico conhecido

| Item | Ação |
|------|------|
| `DropdownButtonFormField` deprecado | `initialValue` + `ValueKey` |
| Secrets Stripe / Firebase | Apenas em Cloud Functions e CI, nunca no app |

---

## 8. Histórico de decisões

| Data | Decisão |
|------|---------|
| 2026-08 | Tela **Meus Clientes** (`/clientes`) e cards com telefone e ações de contato |
| 2026-08 | Produto redefinido como **Clientta** (CRM de atendimentos) |
| 2026-08 | Firebase Auth + Firestore **no escopo** (sync Pro) |
| 2026-08 | Billing **Stripe** via Cloud Functions (sem SDK Flutter) |
| 2026-03 | Baseline offline-only, sem nuvem |

---

*Última atualização: agosto de 2026 — revisar a cada release minor.*
