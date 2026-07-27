# Grade horária

## Resumo

Lista **Minha grade**: visão semanal das aulas cadastradas, com cards agrupados por série ou linha legada, ordenação por dia e horário.

## Plano

**Ambos**

### Free

- Visualização completa da grade ativa.
- Edição e exclusão (com confirmação quando aplicável).
- Agrupamento de séries multi-dia em um card.

### Pro

- Mesma grade, sem teto de itens (ver limites em [disciplinas.md](disciplinas.md)).
- Futuro: filtros por dia da semana e busca por nome da disciplina.

## Status no app

**Implementado** — `features/classes` (`ClassesScreen`, `ClassScheduleGroup`).

## Dependências / notas técnicas

- Rota `/aulas`; FAB leva ao formulário `/aulas/registrar`.
- Repositório: `ClassRepositoryLocal`.
- Home usa o mesmo repositório com filtro do dia.
