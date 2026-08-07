# Clientta — DESIGN

## Scene

Profissional **em movimento** — corretor de seguros no estacionamento, atendente de crédito entre ligações, consultor autônomo no cliente. Luz ambiente variável, **pouco tempo**, precisa de clareza imediata: **quem**, **quando**, **o que foi discutido** e **próximo passo**.

Tom **profissional e confiável** — clareza operacional.

## Color strategy

**Restrained** com acento **azul-verde profissional** (confiança financeira + ação) + neutros frios — manter consistência entre `HubColors` e `DSColors.inicialize`.

| Token | Role | Hex (proposta Clientta) |
|-------|------|-------------------------|
| `seed` | Marca, ações primárias, FAB | `#1B6B5C` |
| `seedDark` | App bar, drawer header | `#0F4A3F` |
| `canvas` | Fundo do app | `#F4F6F8` |
| `surface` | Cards, sheets | `#FFFFFF` |
| `ink` | Texto principal | `#1A1F24` |
| `inkMuted` | Subtítulos, meta (telefone, tipo) | `#5C6670` |
| `border` | Contornos sutis | `#E2E6EA` |
| `schedule` | Bloco de horário / badge de serviço | `#2D6A8F` |
| `success` | Status concluído | `#2E7D52` |
| `warning` | Status agendado / pendente | `#C47A2A` |
| `error` | Cancelado, erro, destrutivo | herda `DSColors.error` |

## Boot (Hub wins over DS primary)

Antes de `runApp`, `main.dart` chama `DSColors.inicialize(...)`. O primário do pacote `design_system` deve ser o token `seed` do Clientta, não o azul padrão do DS.

- Em `main.dart`: `DSColors.inicialize(primaryColor: HubColors.seed, secundaryColor: HubColors.schedule)` antes de `runApp`.
- `MyApp` usa `HubTheme.light()`, que fixa `ColorScheme.primary` em `HubColors.seed`.
- Regra: **produto Hub > defaults do design_system** em qualquer token de marca.

## Primary actions

Ações principais usam **verde-azulado `seed`**, nunca o azul primário default do DS.

- FAB (`HubFab`), CTAs em `HubEmptyState`, `RefreshIndicator`, status “concluir atendimento”: `HubColors.seed`.
- Barras e cabeçalhos de destaque: `HubColors.seedDark`.
- Tipo de serviço e horário: `HubColors.schedule` — não substitui o `seed` em salvar, criar ou navegação primária.

## Typography

Design System (`DSHeadline*`, `DSBodyText`) com hierarquia fixa. Títulos de seção: `HubSectionHeader`. Data do dia: `HubDayHeader`. Nome do cliente em destaque; telefone e tipo de serviço em `inkMuted`.

## Form controls

Objetivo: vocabulário visual único entre campos DS e Material nativo.

- **Texto:** `HubTextFormField` — nome do cliente, telefone, notas multilinha.
- **Data:** `HubDateFormField` — data do atendimento.
- **Horário:** campos de texto ou picker (`startTime` / `endTime` como string `HH:mm`).
- **Tipo de serviço:** `DropdownButtonFormField` com `initialValue` + `ValueKey`.
- **Salvar / CTA:** `HubPrimaryButton` (verde `seed`, loading via `isLoading`).
- Espaçamento entre blocos: `DSSpacing.md`.

## Components (namespace `Hub*`)

Barrel: `hub.dart` em `lib/features/shared/hub/`. Preferir `HubSurface`, `HubAppointmentCard`, `HubEmptyState`, `HubAppBar`, `HubOfflineBanner`, `HubNavTile`, `HubFab`, `HubPrimaryButton`, `HubTextFormField`, `HubDateFormField`.

Cards de atendimento devem hierarquizar: **horário → nome do cliente → tipo de serviço → status**.

## Motion

150–200 ms, `Curves.easeOutCubic`. Sem animações de entrada em listas (fluxo operacional).

## Anti-patterns

Bordas laterais coloridas decorativas, gradient text, glassmorphism, cards empilhados sem hierarquia de horário. Primário azul do DS em FAB/CTA quando o `seed` Clientta está definido. Copy fora do domínio CRM na UI.
