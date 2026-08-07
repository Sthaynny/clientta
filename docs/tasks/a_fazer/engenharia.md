# A fazer — Engenharia

---

## C-106 — Remover features legadas

- **Status:** Concluído
- **O que fazer:** Remover `classes`, `activities`, perfil universidade e rotas legadas.
- **Objetivo:** Codebase alinhado ao domínio CRM.
- **Impacto:** **Alto** — manutenção.
- **Feature:** [PLANEJAMENTO.md](../../PLANEJAMENTO.md)

### Entregue

- Removidos widgets/enums órfãos (`CourseHub`, `NewsAppBar`, `CategoryTile`, etc.).
- Pastas `classes` e `activities` já ausentes; rotas CRM apenas em `app_router.dart`.
- Migração de dados legada preservada em `DeviceJsonStore` (`university_hub_daily.json` → `clientta_data.json`).

---

## C-403 — Migrar pacote a clientta

- **Status:** Concluído
- **O que fazer:** Renomear `university_hub` → `clientta` e atualizar imports.
- **Objetivo:** Namespace coerente com o produto.
- **Impacto:** **Médio** — manutenção.
- **Feature:** [guia_clientta.md](../../guia_clientta.md)

### Entregue

- `pubspec.yaml` e imports Dart já em `package:clientta/`.
- `MainActivity` em `br.com.sthaynny.clientta`; labels Android/iOS = Clientta.
- `.vscode/launch.json` renomeado para `clientta`.

---

## C-404 — CI Codemagic

- **Status:** Concluído
- **O que fazer:** Pipeline analyze + appbundle; deploy Functions em workflow separado.
- **Objetivo:** Releases confiáveis.
- **Impacto:** **Alto** — distribuição.
- **Feature:** [guia_clientta.md](../../guia_clientta.md)

### Entregue

- `android-workflow`: `flutter analyze` + build AAB (sem `flutter test` no MVP inicial).
- `firebase-functions-workflow`: `npm test` + `firebase deploy --only functions,firestore:rules`.
- `firebase.json` com mapeamento de Functions e regras Firestore.
