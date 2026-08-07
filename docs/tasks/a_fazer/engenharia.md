# A fazer — Engenharia

---

## C-106 — Remover features Sextante

- **Status:** Não iniciado
- **O que fazer:** Remover `classes`, `activities`, perfil universidade e rotas legadas.
- **Objetivo:** Codebase alinhado ao domínio CRM.
- **Impacto:** **Alto** — manutenção.
- **Feature:** [PLANEJAMENTO.md](../../PLANEJAMENTO.md)

---

## C-403 — Migrar pacote a clientta

- **Status:** Não iniciado
- **O que fazer:** Renomear `university_hub` → `clientta` e atualizar imports.
- **Objetivo:** Namespace coerente com o produto.
- **Impacto:** **Médio** — manutenção.
- **Feature:** [guia_clientta.md](../../guia_clientta.md)

---

## C-404 — CI Codemagic

- **Status:** Em andamento
- **O que fazer:** Pipeline analyze + test + appbundle; deploy Functions em workflow separado.
- **Objetivo:** Releases confiáveis.
- **Impacto:** **Alto** — distribuição.
- **Feature:** [guia_clientta.md](../../guia_clientta.md)
