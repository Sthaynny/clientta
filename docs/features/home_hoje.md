# Início — Seu dia

## Resumo

Tela inicial com aulas e atividades do dia atual, atalhos para cadastro e navegação pelo menu Hub. É o painel “o que importa hoje”.

## Plano

**Ambos**

### Free

- Painel completo: aulas de hoje, atividades de hoje, cabeçalho com data e missão do app.
- Atalhos rápidos para registrar aula ou atividade.
- Banner offline quando aplicável.

### Pro

- Mesma experiência do Free, sem restrições de volume herdadas das outras features (disciplinas/atividades).
- Espaço reservado para personalização futura do painel (ordem de seções, widgets — ver [widgets_tela_inicial.md](widgets_tela_inicial.md)).

## Status no app

**Implementado** — `features/home`, rota `/`.

## Dependências / notas técnicas

- `HomeViewModel` agrega `ClassRepository` e `ActivityRepository`.
- Filtro de aulas: `weekday == DateTime.now().weekday`.
- Atividades: data igual ao dia corrente.
- Ver [ROTEAMENTO.md](../ROTEAMENTO.md).
