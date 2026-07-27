# Lembretes e notificações

## Resumo

Notificações **locais** para lembrar aulas ou prazos de atividades, sem depender de servidor ou conta.

## Plano

**Pro**

### Free

- Sem agendamento de notificações no app (consulta manual no painel do dia).

### Pro

- Lembrete configurável (ex.: X minutos antes da aula ou no dia da atividade).
- Permissão de notificação solicitada apenas ao ativar o recurso.
- Limite sugerido Free N/A; Pro: lembretes ilimitados por item cadastrado.

## Status no app

**Planejado** — citado em [PROPOSITO.md](../PROPOSITO.md); dependência `flutter_local_notifications` (Fase 2.2).

## Dependências / notas técnicas

- Reagendar ao editar horário/data; cancelar ao excluir item.
- Android 13+ `POST_NOTIFICATIONS`; política de privacidade deve mencionar notificações locais.
