# Mapeamento de tarefas — Clientta

Índice de trabalho para o **Clientta** (CRM de atendimentos), com **o que fazer**, **objetivo** e **impacto** por item.  
Complementa [PLANEJAMENTO.md](PLANEJAMENTO.md) (fases) e [features/README.md](features/README.md) (catálogo Free/Pro).

**Visão operacional:** [tasks/README.md](tasks/README.md) — pastas [tasks/a_fazer/](tasks/a_fazer/) e [tasks/finalizadas/](tasks/finalizadas/) com os mesmos IDs (C-001…).

**Produto:** **Clientta** — pacote Dart em migração de `university_hub` → `clientta`.  
**Monetização:** assinatura **Pro** via Stripe (Cloud Functions); entitlement em Firestore.

## Como ler a tabela

| Campo | Descrição |
|-------|-----------|
| **ID** | Identificador curto (ex. C-101) |
| **Área** | produto / engenharia / design / billing / qualidade |
| **O que fazer** | Ação concreta |
| **Objetivo** | Por que existe |
| **Impacto** | Alto / Médio / Baixo + efeito esperado |
| **Status** | Não iniciado / Em andamento / Concluído / Bloqueado |
| **Relacionado** | Link para feature ou doc |

---

## 1. Baseline (docs + arquitetura)

| ID | Área | O que fazer | Objetivo | Impacto | Status | Relacionado |
|----|------|-------------|----------|---------|--------|-------------|
| C-001 | produto | Documentação **Clientta** | Alinhar time e roadmap ao produto | Alto — direção | Concluído | [PROPOSITO.md](PROPOSITO.md) |
| C-002 | engenharia | `DeviceJsonStore` offline-first | Base de persistência local | Alto — proposta | Concluído | [guia_clientta.md](guia_clientta.md) |
| C-003 | engenharia | Arquitetura **MVVM + GetIt** | Evolução previsível | Médio — manutenção | Concluído | [guia_clientta.md](guia_clientta.md) |
| C-004 | design | Tema **HubTheme** + componentes `Hub*` | UI consistente | Médio — confiança | Concluído | [../DESIGN.md](../DESIGN.md) |

---

## 2. Fase 1 — MVP (auth + agendamentos)

| ID | Área | O que fazer | Objetivo | Impacto | Status | Relacionado |
|----|------|-------------|----------|---------|--------|-------------|
| C-101 | produto | Modelo `ServiceAppointment` + repo local | Base de domínio Clientta | Alto — núcleo | Não iniciado | [agendas.md](features/agendas.md) |
| C-102 | produto | **Painel do dia** (`/`) | Quem atender hoje | Alto — retenção | Não iniciado | [home_hoje.md](features/home_hoje.md) |
| C-103 | produto | **Minha Agenda** (`/agendas`) | Histórico e filtros | Alto — retenção | Não iniciado | [agendas.md](features/agendas.md) |
| C-104 | produto | **Formulário** (`/agendas/registrar`) | Cadastro com notas e séries | Alto — conversão | Não iniciado | [agendas.md](features/agendas.md) |
| C-105 | engenharia | **Firebase Auth** (login/cadastro) | Identidade para sync e billing | Alto — infra | Não iniciado | [guia_clientta.md](guia_clientta.md) |
| C-106 | engenharia | Remover features legadas (classes, activities) | Código alinhado ao CRM | Alto — manutenção | Não iniciado | [PLANEJAMENTO.md](PLANEJAMENTO.md) §3 |
| C-107 | produto | Ordenar painel do dia por `startTime` | Leitura natural da agenda | Médio — UX | Não iniciado | [home_hoje.md](features/home_hoje.md) |
| C-108 | produto | Diálogo de confirmação ao excluir | Evitar perda de dados | Médio — confiança | Não iniciado | [agendas.md](features/agendas.md) |
| C-109 | produto | **Onboarding** leve (offline + primeiro atendimento) | Ativar na primeira sessão | Alto — retenção | Não iniciado | [PLANEJAMENTO.md](PLANEJAMENTO.md) §3 |

---

## 3. Fase 2 — Sync na nuvem (Pro)

| ID | Área | O que fazer | Objetivo | Impacto | Status | Relacionado |
|----|------|-------------|----------|---------|--------|-------------|
| C-201 | engenharia | Repositório Firestore de appointments | Espelho na nuvem | Alto — Pro | Não iniciado | [sincronizacao_nuvem.md](features/sincronizacao_nuvem.md) |
| C-202 | engenharia | Sync bidirecional local ↔ Firestore | Multi-dispositivo | Alto — Pro | Não iniciado | [sincronizacao_nuvem.md](features/sincronizacao_nuvem.md) |
| C-203 | engenharia | **Regras Firestore** por `uid` | Segurança | Alto — confiança | Não iniciado | [sincronizacao_nuvem.md](features/sincronizacao_nuvem.md) |
| C-204 | design | Indicador de sync / offline na UI | Transparência operacional | Médio — UX | Não iniciado | [home_hoje.md](features/home_hoje.md) |

---

## 4. Fase 3 — Billing Stripe (Pro)

| ID | Área | O que fazer | Objetivo | Impacto | Status | Relacionado |
|----|------|-------------|----------|---------|--------|-------------|
| C-301 | billing | Callables Stripe (`getPlanPricing`, `createSubscription`, …) | Cobrança sem SDK no app | Alto — receita | Não iniciado | [assinatura_stripe.md](features/assinatura_stripe.md) |
| C-302 | billing | Webhook `stripeBillingWebhook` | Entitlement em Firestore | Alto — receita | Não iniciado | [billing/readme.md](billing/readme.md) |
| C-303 | produto | Tela **Plano Pro** (`/configuracoes/plano`) | Descoberta e gestão da assinatura | Alto — conversão | Não iniciado | [assinatura_stripe.md](features/assinatura_stripe.md) |
| C-304 | engenharia | **Gates Free/Pro** (limites + sync) | Diferenciar tiers | Alto — valor Pro | Não iniciado | [features/README.md](features/README.md) |

---

## 5. Fundação técnica contínua

| ID | Área | O que fazer | Objetivo | Impacto | Status | Relacionado |
|----|------|-------------|----------|---------|--------|-------------|
| C-401 | qualidade | `flutter analyze` sem erros | Release confiável | Alto — manutenção | Em andamento | [PLANEJAMENTO.md](PLANEJAMENTO.md) |
| C-402 | qualidade | Testes de domínio (appointments ViewModels) | Refatorar com segurança | Médio — manutenção | Não iniciado | [guia_clientta.md](guia_clientta.md) |
| C-403 | engenharia | Migrar pacote a **`clientta`** | Namespace alinhado ao produto | Médio — manutenção | Não iniciado | [guia_clientta.md](guia_clientta.md) |
| C-404 | engenharia | CI Codemagic (analyze + test + bundle) | Pipeline confiável | Alto — distribuição | Em andamento | [guia_clientta.md](guia_clientta.md) |
| C-405 | qualidade | Política de privacidade (Auth, Firestore, Stripe) | Conformidade loja | Alto — confiança | Não iniciado | [PLANEJAMENTO.md](PLANEJAMENTO.md) §6 |
| C-406 | qualidade | Testes de integração fluxo principal | Regressão de navegação | Médio — manutenção | Não iniciado | [PLANEJAMENTO.md](PLANEJAMENTO.md) |

---

## Resumo por status

| Status | Quantidade (IDs) |
|--------|------------------|
| Concluído | 4 (C-001–C-004) |
| Em andamento | 2 (C-401, C-404) |
| Não iniciado | 23 |
| Bloqueado | 0 |

**Total de tarefas listadas:** 29

---

## Manutenção

- Ao concluir entrega: atualizar **Status** e [features/README.md](features/README.md).
- Sprint: 2–3 itens de impacto **Alto** da Fase 1.

*Última atualização: agosto de 2026.*
