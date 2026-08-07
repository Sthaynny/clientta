# Roteamento

Rotas definidas em `lib/core/router/app_router.dart` (`AppRouters`).

| Tela | Constante (sugerida) | Caminho |
|------|----------------------|---------|
| Início — painel do dia | `AppRouters.home` | `/` |
| Minha Agenda | `AppRouters.agendas` | `/agendas` |
| Atendimento (histórico) | `AppRouters.clientCare` | `/atendimentos` |
| Registrar atendimento | `AppRouters.appointmentForm` | `/agendas/registrar` |
| Plano / assinatura Pro | `AppRouters.planSettings` | `/plano` |

Rotas de auth (MVP), se aplicável:

| Tela | Constante (sugerida) | Caminho |
|------|----------------------|---------|
| Login | `AppRouters.login` | `/login` |
| Cadastro | `AppRouters.register` | `/cadastro` |

## Navegação

```dart
context.go(AppRouters.agendas);
context.go(AppRouters.appointmentForm, arguments: appointment);
context.go(
  AppRouters.clientCare,
  arguments: ClientCareArgs(
    clientName: appointment.clientName,
    clientPhone: appointment.clientPhone,
    serviceType: appointment.serviceType,
    appointmentId: appointment.id,
  ),
);
context.go(AppRouters.planSettings);
```

ViewModels de formulário recebem `ServiceAppointment?` via `arguments` da rota. A tela de atendimento recebe `ClientCareArgs`.

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
