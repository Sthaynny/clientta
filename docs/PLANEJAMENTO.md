# Planejamento — próximos passos (Hub Universitário)

Documento de roteiro para evolução do app após a refatoração para **organizador universitário offline** e a identidade visual **Hub**.  
Referências: [PROPOSITO.md](PROPOSITO.md), [GUIA_UNIVERSITARIO.md](GUIA_UNIVERSITARIO.md), [ROTEAMENTO.md](ROTEAMENTO.md), [../PRODUCT.md](../PRODUCT.md), [../DESIGN.md](../DESIGN.md).

---

## 1. Estado atual (baseline)

| Área | Situação |
|------|----------|
| **Produto** | Início (hoje), grade semanal, atividades com conclusão; dados em `DeviceJsonStore` |
| **Arquitetura** | Flutter, MVVM, GetIt, repositórios locais |
| **UI** | Tema `HubTheme` + componentes `Hub*` nas telas principais |
| **Nuvem / login** | Removidos (sem Firebase, sem auth) |
| **Monetização** | Ads e compras in-app **desligados** por enquanto |
| **Publicação** | `main` no GitHub; remoto pode apontar para `university-` — conferir `git remote -v` |

---

## 2. Princípios para priorizar trabalho

1. **Offline first** — valor sem internet após instalar.
2. **Baixa fricção** — poucos passos para cadastrar aula ou atividade.
3. **Clareza do “hoje”** — início do app como painel do dia.
4. **Sem infraestrutura** — evitar backend salvo necessidade forte e documentada.
5. **Consistência Hub** — novas telas usam `lib/features/shared/hub/`, não widgets soltos.

---

## 3. Fase 0 — Estabilização (imediato)

Objetivo: build confiável e base limpa para releases na Play Store / TestFlight.

| # | Entrega | Notas |
|---|---------|--------|
| 0.1 | Commitar correções pendentes de analyzer | Formulários (`DSTextFormField`), `app_router`, remoção de `firebase_options` / `premission_service` órfãos |
| 0.2 | `flutter analyze` + testes existentes verdes | `test/features/activities`, `test/features/classes` |
| 0.3 | Build release Android | `flutter build appbundle`; `versionCode` incremental |
| 0.4 | Revisar `AndroidManifest` | Permissões de mídia ainda listadas — manter só o que o app usa hoje |
| 0.5 | Atualizar `remote` do Git | Migrar para `github.com/Sthaynny/university-` se for o canonical |
| 0.6 | Codemagic | Garantir pipeline sem secrets Firebase; analyze + bundle |

**Critério de conclusão:** AAB publicável sem erros de análise; documentação de release alinhada à versão no `pubspec.yaml`.

---

## 4. Fase 1 — Produto núcleo (curto prazo, 2–4 semanas)

Objetivo: reduzir atrito e aumentar retenção sem novas dependências pesadas.

| # | Entrega | Prioridade | Detalhe |
|---|---------|------------|---------|
| 1.1 | **Formulários Hub** | Alta | Campos de observação multilinha (API do `design_system` ou `TextFormField` temático); validação de horário |
| 1.2 | **Ordenação inteligente** | Alta | Aulas de hoje por `startTime`; atividades por data + não concluídas primeiro |
| 1.3 | **Confirmação ao excluir** | Média | Dialog antes de apagar aula/atividade |
| 1.4 | **Empty states** | Média | Revisar copy com estudantes reais (TCC/extensão) |
| 1.5 | **Onboarding leve** | Média | 1–2 telas: “dados só no celular” + atalho para cadastrar primeira aula |
| 1.6 | **Testes de ViewModel** | Média | `HomeViewModel`, `ClassesViewModel`, `ActivitiesViewModel` com `mocktail` |

---

## 5. Fase 2 — Funcionalidades planejadas no propósito (médio prazo)

Itens já citados em [PROPOSITO.md](PROPOSITO.md), mantendo **sem nuvem**.

| # | Entrega | Dependência sugerida | Escopo mínimo |
|---|---------|----------------------|---------------|
| 2.1 | **Exportar / importar JSON** | `share_plus` ou intent nativo | Backup/restore de `university_hub_daily.json` |
| 2.2 | **Lembretes locais** | `flutter_local_notifications` | Lembrete X minutos antes da aula ou na data da atividade |
| 2.3 | **Widget “próxima aula”** | Android App Widget (+ iOS se viável) | Próxima disciplina do dia com sala |
| 2.4 | **Busca / filtro** | — | Filtrar atividades por tipo ou período |

**Ordem sugerida:** 2.1 → 2.2 → 2.4 → 2.3 (widget é o mais custoso).

---

## 6. Fase 3 — Qualidade e distribuição (contínuo)

| # | Entrega |
|---|---------|
| 3.1 | Testes de integração (`integration_test/home_test.dart`) alinhados ao fluxo Hub |
| 3.2 | Patrol / testes em dispositivo para drawer e FAB |
| 3.3 | Política de privacidade (Play Console) refletindo **apenas armazenamento local** |
| 3.4 | Screenshots e descrição da loja alinhadas ao propósito (sem menção a login/nuvem) |
| 3.5 | Internacionalização (opcional) — hoje strings em `daily_strings.dart` / `strings.dart` |

---

## 7. Fase 4 — Backlog (quando houver decisão explícita)

Não priorizar até validação com usuários ou orientação do TCC.

| Item | Observação |
|------|------------|
| **Anúncios / assinatura** | Removidos em 2026-03; reintroduzir só com Billing 8+ e UX que não conflite com offline-first |
| **Sincronização na nuvem** | Contraria princípio atual; exigiria novo PROPOSITO |
| **Múltiplos campi / cursos** | Config em `AppConfig` |
| **Integração calendário ICS** | Import de grade exportada pela instituição |
| **Tema escuro** | Estender `HubTheme.dark()` |

---

## 8. Débito técnico conhecido

| Item | Ação |
|------|------|
| `DropdownButtonFormField.value` deprecado | Migrar para `initialValue` nos formulários |
| `url_launcher` usado via transitivo | Declarar dependência direta ou remover `string.dart` extension |
| `design_system` git + `DSIconData` / Flutter | Acompanhar compatibilidade do pacote com SDK Flutter do projeto |
| Permissões READ_MEDIA_* no manifest | Auditar uso real (app não parece usar galeria hoje) |
| Repositório renomeado no GitHub | Atualizar links no README e CI |

---

## 9. Como usar este documento

- **Sprint / semana:** escolher 2–3 itens da Fase 0 ou 1.
- **Antes de feature nova:** atualizar [PROPOSITO.md](PROPOSITO.md) e, se mudar UI, [DESIGN.md](../DESIGN.md).
- **Após entrega:** marcar item como feito (data + versão do app) neste arquivo ou em issues do GitHub.

---

## 10. Histórico de decisões

| Data | Decisão |
|------|---------|
| 2026-03 | App focado em grade/atividades locais; Firebase e login removidos |
| 2026-03 | Identidade visual Hub (`HubTheme`, componentes `Hub*`) |
| 2026-03 | Ads e IAP removidos temporariamente; foco em release limpo na Play Store |

---

*Última atualização: março de 2026 — revisar a cada release minor.*
