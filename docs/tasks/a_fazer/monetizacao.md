# A fazer — Monetização

Estratégia alinhada a produtos como **cura.li**: **dois apps nas lojas** (gratuito + pago), **um único repositório** e variantes de build — **não** paywall in-app como modelo principal.

Billing, IAP e paywall **não** estão no código hoje; itens abaixo são decisão de produto, engenharia de release e loja.

---

## Modelo de negócio

| Aspecto | Decisão (alvo) |
|---------|----------------|
| **Free** | App **Sextante** (ou **Sextante Free**) na Play Store / App Store — download gratuito, núcleo offline com limites documentados. |
| **Pro** | App **Sextante Pro** — listing **separado**, preço pago na loja (compra única ou modelo definido em T-402; sem assinatura obrigatória no desenho inicial). |
| **Código** | Monorepo Flutter (`university_hub`); mesma base de features, com gates por variante. |
| **Referência** | Modelo **cura.li**: duas fichas na loja, mesmo time/repo, Pro = instalar o segundo app — não depender de desbloqueio in-app como canal principal. |

Documentação de limites por tier: [features/README.md](../../features/README.md).

---

## Um código, dois apps

| Camada | Free (exemplo) | Pro (exemplo) |
|--------|----------------|---------------|
| **Android `applicationId`** | `com.sthaynny.university_hub` (atual até renomear) | `com.sthaynny.university_hub_pro` |
| **iOS bundle ID** | mesmo padrão com sufixo `_pro` na variante paga | idem |
| **Nome na loja** | Sextante | Sextante Pro |
| **Variante de build** | Flutter **flavors** (`free` / `pro`) e/ou `--dart-define=APP_VARIANT=free\|pro` | idem |
| **Assets** | ícone e textos de loja do Free | ícone distinto (badge Pro), screenshots com features Pro |
| **Runtime** | `AppVariant.free` — limites e UI de “conheça o Pro” (link para listing) | `AppVariant.pro` — features Pro compiladas/ativas sem paywall |

Implementação técnica detalhada fica em T-407 e T-410; CI em T-408; fichas em T-409.

---

## O que fica no Free vs Pro

Tabela completa e links por feature: [features/README.md](../../features/README.md).

| Área | Free | Pro |
|------|------|-----|
| Painel do dia, grade, atividades | Sim, com **limites de volume** | Sem limites de cadastro |
| Perfil (universidade) | Sim | Sim |
| **Backup** export/import JSON | Não | Sim — [export_backup.md](../../features/export_backup.md) |
| **Notificações** locais | Não | Sim — [lembretes_notificacoes.md](../../features/lembretes_notificacoes.md) |
| Estatísticas | Não | Sim — [estatisticas_progresso.md](../../features/estatisticas_progresso.md) |
| **Temas** além do claro padrão | Não | Sim — [temas_personalizados.md](../../features/temas_personalizados.md) |
| Anexos, widgets, múltiplos semestres | Não | Sim — docs em `docs/features/` |
| Sync na nuvem | Não | Futuro explícito — [sincronizacao_nuvem.md](../../features/sincronizacao_nuvem.md) |

No app **Free**, features Pro podem aparecer como **indisponíveis** com CTA para instalar **Sextante Pro** na loja (não como tela de cobrança in-app).

---

## Tarefas

### T-402 — Preço do app Pro na loja

- **Status:** Não iniciado
- **O que fazer:** Definir **preço** do listing **Sextante Pro** (compra única na Play/App Store) e política de **promoção**; registrar experimento de preço se aplicável.
- **Objetivo:** Viabilidade econômica sem complexidade de assinatura no lançamento.
- **Impacto:** **Alto** — receita.
- **Feature:** [PRODUCT.md](../../../PRODUCT.md)

---

### T-403 — Descoberta Pro no app Free (não paywall)

- **Status:** Não iniciado
- **O que fazer:** Esboçar **pontos de descoberta** no Free (backup, lembretes, temas, stats) com link para a ficha **Sextante Pro** na loja — **sem** fluxo primário de IAP/paywall.
- **Objetivo:** UX clara que convida à instalação do segundo app sem frustrar o Free.
- **Impacto:** **Alto** — conversão para Pro.
- **Feature:** [export_backup.md](../../features/export_backup.md)

---

### T-404 — Google Play Billing / IAP (alternativa futura)

- **Status:** Bloqueado — **não** é o modelo principal
- **O que fazer:** Manter plano técnico **Google Play Billing 8+** apenas como **alternativa futura** (app único + assinatura ou compra in-app), se o modelo dois-apps não escalar.
- **Objetivo:** Opção de pivot sem perder pesquisa de políticas.
- **Impacto:** **Baixo** no curto prazo — receita via listing pago é o caminho preferido.
- **Feature:** [PLANEJAMENTO.md](../../PLANEJAMENTO.md) §7

---

### T-405 — Anúncios

- **Status:** Bloqueado
- **O que fazer:** Avaliar **anúncios** no Free (hoje desligados); Pro permanece sem ads.
- **Objetivo:** Monetização complementar sem degradar offline.
- **Impacto:** **Baixo** — decisão futura.
- **Feature:** [PLANEJAMENTO.md](../../PLANEJAMENTO.md) §7

---

### T-406 — Enforcement Free vs Pro por variante

- **Status:** Não iniciado
- **O que fazer:** Implementar **limites Free** e rotas Pro apenas na variante `pro` (compile-time + checagens em runtime onde necessário).
- **Objetivo:** Diferenciar tiers de fato entre os dois binários.
- **Impacto:** **Alto** — proposta de valor Pro.
- **Feature:** [features/README.md](../../features/README.md)

---

### T-407 — Definir variantes Android e iOS

- **Status:** Não iniciado
- **O que fazer:** Especificar **flavors** (`free`, `pro`), `applicationId` / bundle ID, `app_name`, ícones e `AndroidManifest` / Xcode schemes; documentar comandos `flutter run` / `flutter build`.
- **Objetivo:** Base reproduzível para dois artefatos a partir de `university_hub`.
- **Impacto:** **Alto** — pré-requisito de publicação dupla.
- **Feature:** [guia_sextante.md](../../guia_sextante.md)

---

### T-408 — CI: matriz de build (Codemagic)

- **Status:** Não iniciado
- **O que fazer:** Configurar **pipeline** que gera **dois** APK/AAB (e IPA) por tag ou branch — variante `free` e `pro`, assinatura e artefatos nomeados.
- **Objetivo:** Releases sincronizados sem build manual duplicado.
- **Impacto:** **Alto** — operação de loja.
- **Feature:** [docs/stores/ENTREGA-PLAY.md](../../stores/ENTREGA-PLAY.md)

---

### T-409 — Listings duplos na loja

- **Status:** Não iniciado
- **O que fazer:** Preparar fichas **Free** e **Pro** (textos, screenshots, política de dados, cross-link “upgrade” no Free); manter em `docs/stores/`.
- **Objetivo:** Publicação e descoberta corretas dos dois apps.
- **Impacto:** **Alto** — conversão e conformidade.
- **Feature:** [docs/stores/](../../stores/)

---

### T-410 — Feature flags e gates compile-time (Pro)

- **Status:** Não iniciado
- **O que fazer:** Introduzir camada única (ex. `AppVariant` + `--dart-define`) para ramificar UI e serviços Pro; evitar código morto no Free quando possível (`if (kProVariant)` / tree shaking).
- **Objetivo:** Um código, comportamentos distintos sem bifurcar repositório.
- **Impacto:** **Alto** — manutenção e segurança do tier.
- **Feature:** [features/README.md](../../features/README.md)

---

## Riscos

| Risco | Mitigação |
|-------|-----------|
| **Dois listings** para manter (textos, screenshots, revisões) | Templates em `docs/stores/`; releases na mesma versão (T-408). |
| **Paridade de versão** Free/Pro | CI com matriz única; changelog compartilhado; mesmo `version` no `pubspec.yaml`. |
| **Usuário compra Pro e precisa instalar segundo app** | Copy claro na loja e no Free; deep link para ficha Pro; sem prometer “upgrade in-app”. |
| **Dados entre apps** | Dois `applicationId` = dois sandboxes; **backup JSON (Pro)** como ponte de migração Free → Pro — documentar no [export_backup.md](../../features/export_backup.md). |
| **Pivot para IAP único** | T-404 mantido como alternativa; não investir em paywall antes do modelo dois-apps validado. |

---

## Documentação relacionada

- [features/README.md](../../features/README.md) — catálogo Free / Pro
- [PRODUCT.md](../../../PRODUCT.md) — tiers de produto
- [PLANEJAMENTO.md](../../PLANEJAMENTO.md) — fases e backlog
- [mapeamento_tarefas.md](../../mapeamento_tarefas.md) — IDs e status
