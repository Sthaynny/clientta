# Estatísticas e progresso

## Resumo

Visão de desempenho acadêmico pessoal: taxa de conclusão de atividades, distribuição por tipo e tendências semanais — apenas com dados já no dispositivo.

## Plano

**Pro**

### Free

- Indicadores básicos na lista (pendente/concluída) sem tela dedicada.

### Pro

- Tela de resumo: % concluídas no período, gráficos simples, streak de dias com tarefas feitas.
- Export opcional dos números (CSV) junto com [export_backup.md](export_backup.md).

## Status no app

**Planejado** — backlog de produto; sem módulo no código.

## Dependências / notas técnicas

- Cálculos derivados de `ActivityRepository`; sem analytics de terceiros obrigatório.
- Manter performance com JSON local (agregação em memória).
