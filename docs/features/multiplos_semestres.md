# Múltiplos semestres

## Resumo

Arquivar períodos letivos anteriores e alternar o **semestre ativo**, mantendo histórico de grades e atividades sem misturar com o período corrente.

## Plano

**Pro**

### Free

- Um único “período ativo” implícito (comportamento atual).

### Pro

- Criar/arquivar semestres (ex.: 2025.2, 2026.1).
- Alternar contexto global; export por período ([export_backup.md](export_backup.md)).

## Status no app

**Planejado** — citado como backlog em [PLANEJAMENTO.md](../PLANEJAMENTO.md) (múltiplos campi/cursos).

## Dependências / notas técnicas

- Evolução do schema JSON (array de períodos ou namespaces).
- Migração automática do formato atual para um período default.
