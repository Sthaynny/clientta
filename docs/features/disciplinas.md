# Cadastro de disciplinas

## Resumo

Formulário para registrar disciplinas na grade: nome, dias da semana (chips), horário, sala e observações. Suporta **série** (mesma matéria em vários dias) via `seriesId`.

## Plano

**Free** (com limites) | **Pro** (sem limites)

### Free

- Cadastro e edição de aulas com validação de horário.
- Série em vários dias no mesmo fluxo (implementado).
- Limite de produto sugerido: até **15** linhas de grade (contando cada dia de uma série) e até **8** séries distintas.

### Pro

- Cadastro ilimitado de disciplinas e séries.
- Prioridade em melhorias de formulário (presets de turno noturno, etc.).

## Status no app

**Implementado** — `features/classes` (formulário e repositório local).

## Dependências / notas técnicas

- Modelo `ClassEntry` + `seriesId` opcional; persistência em `DeviceJsonStore`.
- Brief de UX: [design-brief-class-multi-day.md](../design-brief-class-multi-day.md).
- Listagem agrupada: [grade_horaria.md](grade_horaria.md).
