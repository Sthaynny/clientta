# A fazer — Lembretes locais (Pro)

Backlog da feature **C-410** — notificações locais antes do atendimento.

---

## C-410 — Lembretes locais de atendimento

- **Status:** Implementado (v1)
- **Plano:** Pro exclusivo
- **Feature:** [lembretes_locais.md](../../features/lembretes_locais.md)

### Entregue

- Infra `flutter_local_notifications` + coordinator + gate Pro
- Tela `/plano`: toggle e antecedência 15/30/60 min
- Formulário: toggle global de lembretes (Pro)
- Deep link: toque na notificação → atendimento do cliente
- Sync após save/delete e no load da home/agenda

### Pendente (opcional)

- [ ] Boot receiver Android
- [ ] Atualizar política de privacidade (notificações locais)
- [ ] Testes unitários de `AppointmentReminderPolicy`
