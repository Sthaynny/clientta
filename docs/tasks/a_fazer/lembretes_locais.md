# A fazer — Lembretes locais (Pro)

Backlog da feature **C-410** — notificações locais antes do atendimento.

---

## C-410 — Lembretes locais de atendimento

- **Status:** Em preparação (infra + docs); UI pendente
- **Plano:** Pro exclusivo
- **Feature:** [lembretes_locais.md](../../features/lembretes_locais.md)
- **Objetivo:** Avisar o profissional X minutos antes de `startTime` para atendimentos `agendado`.
- **Impacto:** **Alto** — valor Pro no dia a dia offline

### Entregue (preparação)

- Validação de viabilidade documentada
- Dependências `flutter_local_notifications` + `timezone`
- Domínio: `AppointmentReminderPolicy`, `AppointmentReminderSettings`, scheduler
- Dados: `LocalAppointmentReminderScheduler`, `AppointmentReminderCoordinator`
- Gate: `PlanAccessPolicy.canScheduleLocalReminders`
- Sync no `HomeViewModel.load` (Pro)
- Permissões Android / copy iOS no manifest
- Preferências em `AppProfileSettings.appointmentReminders`

### Pendente

- [ ] UI: toggle “Lembrar antes do atendimento” no formulário (Pro)
- [ ] UI: antecedência 15 / 30 / 60 min em configurações
- [ ] Deep link ao tocar na notificação
- [ ] Teste manual Android 13+ (permissão) e iOS
- [ ] Atualizar política de privacidade (notificações locais)
- [ ] Boot receiver (opcional) para reagendar após reboot sem abrir app
- [ ] Testes unitários de `AppointmentReminderPolicy`

### Critérios de aceite

Ver [lembretes_locais.md](../../features/lembretes_locais.md#critérios-de-aceite-c-410).
