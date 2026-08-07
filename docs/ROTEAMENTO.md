# Roteamento

Rotas definidas em `lib/core/router/app_router.dart` (`AppRouters`).

| Tela | Constante | Caminho |
|------|-----------|---------|
| Início — painel do dia | `AppRouters.home` | `/` |
| Minha Agenda | `AppRouters.agendas` | `/agendas` |
| Meus Clientes | `AppRouters.clients` | `/clientes` |
| Atendimento (histórico) | `AppRouters.clientCare` | `/atendimentos` |
| Registrar atendimento | `AppRouters.appointmentForm` | `/agendas/registrar` |
| Plano / assinatura Pro | `AppRouters.planSettings` | `/plano` |

Rotas de auth (fora do `MyApp` principal — gated por `AuthGate`):

| Tela | Constante | Caminho |
|------|-----------|---------|
| Login | `AuthRouters.login` | `/login` |
| Cadastro | `AuthRouters.register` | `/cadastro` |

## Navegação

```dart
context.go(AppRouters.agendas);
context.go(AppRouters.clients);
context.go(AppRouters.appointmentForm, arguments: appointment);
context.go(
  AppRouters.appointmentForm,
  arguments: AppointmentFormLaunchArgs.prefill(
    clientName: profile.clientName,
    clientPhone: profile.clientPhone,
    serviceType: profile.serviceType,
  ),
);
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

ViewModels de formulário recebem `ServiceAppointment?` ou `AppointmentFormLaunchArgs` via `arguments` da rota. A tela de atendimento recebe `ClientCareArgs`.

Para alterar um caminho, edite o getter `path` no enum `AppRouters`.

## Drawer / menu

Itens atuais (`AppDrawer`):

- **Seu dia de atendimentos** (`/`)
- **Minha Agenda** (`/agendas`)
- **Meus Clientes** (`/clientes`)
- **Plano e assinatura** (`/plano`)
- **Sair** (Auth)

## Deep links (futuro)

Checkout Stripe retorna ao app via URL de sucesso configurada no Dashboard Stripe; não requer rota dedicada no MVP se usar página web intermediária.
