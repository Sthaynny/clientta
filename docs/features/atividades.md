# Atividades e prazos

## Resumo

Registro de entregas, estudos, provas e presenças com data, tipo e marcação de concluída. Lista ordenada com destaque para pendentes.

## Plano

**Free** (com limites) | **Pro** (sem limites)

### Free

- CRUD completo de atividades e toggle de conclusão.
- Tipos de atividade com estilo visual por categoria.
- Limite de produto sugerido: até **50** atividades não arquivadas simultaneamente.

### Pro

- Atividades ilimitadas.
- Futuro: filtros por tipo/período e lembretes ([lembretes_notificacoes.md](lembretes_notificacoes.md)).

## Status no app

**Implementado** — `features/activities`, rotas `/atividades` e `/atividades/registrar`.

## Dependências / notas técnicas

- Modelo `ActivityEntry`; `ActivityRepositoryLocal`.
- Integração com o painel do dia em [home_hoje.md](home_hoje.md).
