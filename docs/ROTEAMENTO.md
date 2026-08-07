# Roteamento

Rotas definidas em `lib/core/router/app_router.dart` (`AppRouters`).

| Tela | Constante (sugerida) | Caminho |
|------|----------------------|---------|
| Início — painel do dia | `AppRouters.home` | `/` |
| Minha Agenda | `AppRouters.appointments` | `/agendas` |
| Registrar atendimento | `AppRouters.appointmentForm` | `/agendas/registrar` |
| Plano / assinatura Pro | `AppRouters.subscriptionPlan` | `/configuracoes/plano` |

Rotas de auth (MVP), se aplicável:

| Tela | Constante (sugerida) | Caminho |
|------|----------------------|---------|
| Login | `AppRouters.login` | `/login` |
| Cadastro | `AppRouters.register` | `/cadastro` |

## Navegação

```dart
context.go(AppRouters.appointments);
context.go(AppRouters.appointmentForm, arguments: appointment);
context.go(AppRouters.subscriptionPlan);
```

ViewModels de formulário recebem `ServiceAppointment?` via `arguments` da rota.

Para alterar um caminho, edite o getter `path` no enum `AppRouters`.

## Drawer / menu

Sugestão de itens:

- Início (`/`)
- Minha Agenda (`/agendas`)
- Plano Pro (`/configuracoes/plano`) — destaque se Free
- Sair (Auth)

Configurações adicionais podem expandir sob `/configuracoes/*` sem alterar rotas núcleo.

## Deep links (futuro)

Checkout Stripe retorna ao app via URL de sucesso configurada no Dashboard Stripe; não requer rota dedicada no MVP se usar página web intermediária.
