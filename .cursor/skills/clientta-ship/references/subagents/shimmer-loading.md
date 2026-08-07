# Subagente — Shimmer loading (transversal)

Papel: substituir spinners (`CircularProgressIndicator`, `DSSpinnerLoading`) por **skeletons shimmer** alinhados ao layout real de cada tela.

## Docs e regras

- `.cursor/rules/clientta-ui.mdc` — seção **Loading (shimmer)**
- `lib/features/shared/hub/hub_shimmer.dart`
- `lib/features/shared/hub/hub_loading_skeletons.dart`

## Componentes Hub

| Componente | Uso |
|------------|-----|
| `HubShimmer` | Wrapper com paleta Clientta; respeita `disableAnimations` |
| `HubShimmerBox` | Placeholder retangular dentro do shimmer |
| `HubHomeLoadingSkeleton` | Painel do dia `/` |
| `HubAppointmentListLoadingSkeleton` | Agenda `/agendas` (intro + filtros opcionais) |
| `HubClientListLoadingSkeleton` | Meus Clientes `/clientes` |
| `HubClientCareLoadingSkeleton` | Atendimento `/atendimentos` |
| `HubPlanLoadingSkeleton` | Plano `/plano` |
| `HubBootstrapLoadingSkeleton` | Bootstrap app + `AuthGate` |
| `AppLoadingWidget` | Fallback → `HubAppointmentListLoadingSkeleton` |

## Receita por feature (lista MVVM)

```dart
if (viewmodel.load.running && entries.isEmpty) {
  return const HubHomeLoadingSkeleton(); // ou skeleton da rota
}
```

- **Não** usar `CircularProgressIndicator` em telas de lista ou bootstrap.
- **Não** usar `DSSpinnerLoading` em features novas.
- Skeleton deve **imitar o layout** (cards, intro, filtros) — não spinner centralizado.
- `Semantics(label: loadingContentString)` já está nos skeletons Hub.

## Mapa feature → skeleton

| Feature | Rota | Skeleton |
|---------|------|----------|
| Home | `/` | `HubHomeLoadingSkeleton` |
| Agendas | `/agendas` | `HubAppointmentListLoadingSkeleton(showIntro: true, showFilter: true)` |
| Clientes | `/clientes` | `HubClientListLoadingSkeleton` |
| Atendimento | `/atendimentos` | `HubClientCareLoadingSkeleton` |
| Plano Pro | `/plano` | `HubPlanLoadingSkeleton` |
| Auth gate / bootstrap | — | `HubBootstrapLoadingSkeleton` |
| Nova lista | — | Reutilizar skeleton existente ou criar em `hub_loading_skeletons.dart` |

## Novo skeleton (quando necessário)

1. Montar com `HubShimmer` + `HubShimmerBox` + `HubSurface` (mesma hierarquia da tela).
2. Exportar em `hub.dart`.
3. Usar na tela com `load.running && dados.isEmpty`.
4. Atualizar esta tabela e `clientta-ui.mdc` se for padrão reutilizável.

## Verificação

- `flutter analyze lib/`
- Buscar no `lib/`: `CircularProgressIndicator`, `DSSpinnerLoading` — zero em telas de feature
- Testar com **animações reduzidas** no SO (skeleton estático, sem shimmer)

## Prompt sugerido (Task)

```text
Você implementa shimmer loading no Clientta para a feature [NOME].
Leia .cursor/skills/clientta-ship/references/subagents/shimmer-loading.md
e clientta-ui.mdc (Loading).
Substituir AppLoadingWidget/spinner por o Hub*LoadingSkeleton correto.
Não adicionar testes unitários se não pedido.
```
