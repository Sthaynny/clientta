# Finalizadas — Engenharia

---

## C-002 — DeviceJsonStore offline-first

- **O que fazer:** Persistência local em `DeviceJsonStore` (JSON no dispositivo).
- **Objetivo:** Operação sem internet após instalar.
- **Impacto:** **Alto** — proposta offline-first.
- **Feature:** [guia_clientta.md](../../guia_clientta.md)

---

## C-003 — MVVM + GetIt

- **O que fazer:** Arquitetura MVVM + GetIt com repositórios por feature.
- **Objetivo:** Evolução previsível do codebase.
- **Impacto:** **Médio** — manutenção.
- **Feature:** [guia_clientta.md](../../guia_clientta.md)

---

## C-106 — Remover código obsoleto

- **O que fazer:** Remover features, rotas e widgets não utilizados.
- **Objetivo:** Codebase alinhado ao domínio CRM.
- **Impacto:** **Alto** — manutenção.

### Entregue

- Removidos widgets/enums órfãos (`CourseHub`, `NewsAppBar`, `CategoryTile`, etc.).
- Rotas CRM apenas em `app_router.dart`.
- Renomeação automática de arquivo de dados legado preservada em `DeviceJsonStore`.

---

## C-403 — Namespace clientta

- **O que fazer:** Garantir namespace `clientta` no pacote Dart e imports.
- **Objetivo:** Coerência com o produto.
- **Impacto:** **Médio** — manutenção.

### Entregue

- `pubspec.yaml` e imports Dart já em `package:clientta/`.
- `MainActivity` em `br.com.sthaynny.clientta`; labels Android/iOS = Clientta.
- `.vscode/launch.json` renomeado para `clientta`.

---

## C-404 — CI Codemagic

- **O que fazer:** Pipeline analyze + appbundle; deploy Functions em workflow separado.
- **Objetivo:** Releases confiáveis.
- **Impacto:** **Alto** — distribuição.

### Entregue

- `android-workflow`: `flutter analyze` + build AAB.
- `firebase-functions-workflow`: `npm test` + `firebase deploy --only functions,firestore:rules`.
- `firebase.json` com mapeamento de Functions e regras Firestore.
