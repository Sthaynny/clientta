# A fazer — Engenharia

---

## T-205 — Build release Android

- **Status:** Em andamento
- **O que fazer:** **Build release** Android (`appbundle`) com `versionCode` incremental.
- **Objetivo:** Publicar na Play Store.
- **Impacto:** **Alto** — distribuição.
- **Feature:** [PLANEJAMENTO.md](../../PLANEJAMENTO.md) §3

---

## T-206 — Auditar AndroidManifest

- **Status:** Não iniciado
- **O que fazer:** Auditar **AndroidManifest** (permissões de mídia não usadas).
- **Objetivo:** Conformidade e revisão da loja.
- **Impacto:** **Médio** — confiança.
- **Feature:** [PLANEJAMENTO.md](../../PLANEJAMENTO.md) §3

---

## T-207 — Pipeline Codemagic

- **Status:** Em andamento
- **O que fazer:** **Codemagic**: analyze + bundle sem secrets Firebase.
- **Objetivo:** Pipeline confiável.
- **Impacto:** **Alto** — manutenção.
- **Feature:** [guia_sextante.md](../../guia_sextante.md)

---

## T-208 — Dropdown initialValue

- **Status:** Não iniciado
- **O que fazer:** Migrar `DropdownButtonFormField` deprecado para **`initialValue`**.
- **Objetivo:** Compatibilidade com SDK Flutter.
- **Impacto:** **Baixo** — manutenção.
- **Feature:** [PLANEJAMENTO.md](../../PLANEJAMENTO.md) §8

---

## T-209 — url_launcher

- **Status:** Não iniciado
- **O que fazer:** Declarar ou remover uso de **`url_launcher`**.
- **Objetivo:** `depend_on_referenced_packages` limpo.
- **Impacto:** **Baixo** — manutenção.
- **Feature:** [PLANEJAMENTO.md](../../PLANEJAMENTO.md) §8

---

## T-210 — Pacote design_system

- **Status:** Em andamento
- **O que fazer:** Acompanhar compatibilidade do **`design_system`** (Git) com o SDK.
- **Objetivo:** Evitar quebra de build.
- **Impacto:** **Médio** — manutenção.
- **Feature:** [guia_sextante.md](../../guia_sextante.md)

---

## T-211 — Remote e links do repositório

- **Status:** Não iniciado
- **O que fazer:** Atualizar **remote** e links do repositório canonical.
- **Objetivo:** Onboarding de contribuidores e CI.
- **Impacto:** **Baixo** — manutenção.
- **Feature:** [PLANEJAMENTO.md](../../PLANEJAMENTO.md) §3
