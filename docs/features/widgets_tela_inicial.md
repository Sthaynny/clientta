# Widgets na tela inicial

## Resumo

Widget do sistema (Android em v1) mostrando **próxima aula** do dia, sala e horário, atualizado a partir dos dados locais.

## Plano

**Pro**

### Free

- App aberto ou na gaveta de apps para consultar o dia ([home_hoje.md](home_hoje.md)).

### Pro

- App Widget configurável (tamanho médio/grande).
- Toque abre o **Sextante** na home ou na grade.

## Status no app

**Planejado** — Fase 2.3 em [PLANEJAMENTO.md](../PLANEJAMENTO.md).

## Dependências / notas técnicas

- `home_widget` ou API nativa Android; iOS WidgetKit como fase posterior.
- Leitura somente do JSON via canal isolado; cuidado com bateria e refresh.
