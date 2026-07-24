# ConectaFERSA — DESIGN

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

## Typography

Design System (`DSHeadline*`, `DSBodyText`) com hierarquia fixa em rem. Títulos de seção: `HubSectionHeader`. Data do dia: `HubDayHeader`.

## Components (namespace `Hub*`)

Local em `lib/features/shared/hub/`. Não usar `Card` Material cru — usar `HubSurface`, `HubClassCard`, `HubActivityTile`, `HubEmptyState`, `HubAppBar`, `HubOfflineBanner`, `HubNavTile`, `HubFab`.

## Motion

150–200 ms, `Curves.easeOutCubic`. Sem animações de entrada em listas (produto em fluxo).

## Anti-patterns

Bordas laterais coloridas em cards, gradient text, glassmorphism decorativo, cards idênticos empilhados sem hierarquia de horário.
