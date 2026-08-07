# A fazer — Qualidade

Itens pendentes de qualidade e manutenção contínua.

---

## C-401 — Flutter analyze

- **Status:** Concluído
- **O que fazer:** Manter `flutter analyze` sem erros no branch principal.
- **Objetivo:** Evitar regressões em release.
- **Impacto:** **Alto** — manutenção.

---

## C-402 — Testes de domínio

- **Status:** Não iniciado
- **O que fazer:** Ampliar testes de ViewModels de appointments com `mocktail`.
- **Objetivo:** Refatorar com segurança.
- **Impacto:** **Médio** — manutenção.
- **Feature:** [guia_clientta.md](../../guia_clientta.md)

---

## C-407 — Teste auth signOut

- **Status:** Não iniciado
- **O que fazer:** Corrigir falha em `test/features/auth/auth_repository_test.dart` (signOut).
- **Objetivo:** Suite `flutter test` verde.
- **Impacto:** **Baixo** — CI.
