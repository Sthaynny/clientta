# Hub Universitário — DESIGN

## Scene

Estudante no corredor ou na biblioteca, consulta o celular entre aulas — luz ambiente variável, pouco tempo, precisa de clareza imediata (horário, sala, o que falta hoje).

## Color strategy

**Restrained** com acento institucional: verde semiárido (confiança, UFS/FERSA) + neutros frios (foco). Calor só em detalhes de horário (`schedule`).

| Token | Role | Hex |
|-------|------|-----|
| `seed` | Marca, ações primárias | `#1A6B52` |
| `seedDark` | App bar, drawer header | `#0F4535` |
| `canvas` | Fundo do app | `#F4F6F8` |
| `surface` | Cards, sheets | `#FFFFFF` |
| `ink` | Texto principal | `#1A1F24` |
| `inkMuted` | Subtítulos, meta | `#5C6670` |
| `border` | Contornos sutis | `#E2E6EA` |
| `schedule` | Bloco de horário | `#2D6A8F` |
| `error` | Destrutivo | herda `DSColors.error` |

## Boot (Hub wins over DS primary)

Antes de `runApp`, `main.dart` chama `DSColors.inicialize(...)`. **O primário do pacote `design_system` deve ser o verde do produto, não o azul padrão do DS.**

- Em `main.dart`: `DSColors.inicialize(primaryColor: HubColors.seed, secundaryColor: HubColors.schedule)` antes de `runApp`.
- `MyApp` usa `HubTheme.light()`, que já fixa `ColorScheme.primary` em `HubColors.seed`; a inicialização do DS precisa estar alinhada para widgets DS (`DSTextFormField`, `DSSnackBar`, botões do pacote) não herdarem azul de biblioteca.
- Regra: **produto Hub > defaults do design_system** em qualquer token de marca (primário primeiro).

## Primary actions

Ações principais e foco de marca usam **verde `seed` (`#1A6B52`)**, nunca o azul primário default do DS.

- FAB (`HubFab`), CTAs em `HubEmptyState`, `RefreshIndicator`, checkboxes selecionados e borda de foco de inputs: `HubColors.seed`.
- Barras e cabeçalhos de destaque: `HubColors.seedDark`.
- Secundário semântico de horário/bloco: `HubColors.schedule` — não substitui o verde em salvar, criar ou navegação primária.

## Typography

Design System (`DSHeadline*`, `DSBodyText`) com hierarquia fixa em rem. Títulos de seção: `HubSectionHeader`. Data do dia: `HubDayHeader`.

## Form controls

Objetivo: **vocabulário visual único** entre campos DS e controles Material nativos.

- **Texto:** `HubTextFormField` (`TextFormField` + `InputDecoration` do `HubTheme`) — não usar `DSTextFormField` em formulários Hub (evita borda dupla do pacote DS).
- **Data:** `HubDateFormField` (rótulo + valor formatado, abre `showDatePicker` no `onTap`).
- **Boolean:** `HubSwitchFormField` (mesmo contorno de dropdown/data).
- **Salvar / CTA de formulário:** `HubPrimaryButton` (verde `seed`, loading via `isLoading`).
- **Dropdowns / seleção:** `DropdownButtonFormField` (ou equivalente Material) com `InputDecoration` que herda o tema do app — ou seja, `Theme.of(context).inputDecorationTheme` definido em `HubTheme.light()` (preenchido `surface`, borda `border`, foco `seed` 1.5px).
- Não misturar estilos ad hoc (bordas/cores soltas); todos os campos usam o mesmo outline + foco verde via `inputDecorationTheme`.
- Espaçamento entre blocos: `DSSpacing.md` do DS.

## Components (namespace `Hub*`)

Barrel: `hub.dart` em `lib/features/shared/hub/`. Não usar `Card` Material cru — preferir `HubSurface`, `HubClassCard`, `HubActivityTile`, `HubEmptyState`, `HubAppBar`, `HubOfflineBanner`, `HubNavTile`, `HubFab`, `HubPrimaryButton`, `HubTextFormField`, `HubDateFormField`, `HubSwitchFormField`.

## Motion

150–200 ms, `Curves.easeOutCubic`. Sem animações de entrada em listas (produto em fluxo).

## Anti-patterns

Bordas laterais coloridas em cards, gradient text, glassmorphism decorativo, cards idênticos empilhados sem hierarquia de horário. Primário azul do DS em botões/FAB/CTA quando o verde Hub está definido no produto.
