# Sextante — PRODUCT

## Platform

adaptive

## Register

product

## One-liner

Auxiliar do dia a dia na faculdade: grade, atividades e visão do que importa hoje — offline, sem login. Tagline: *Navegue sua vida na faculdade — offline, no celular.*

## Audience

Estudantes universitários que querem organizar sala, horário e entregas sem fricção de conta ou nuvem.

## Core jobs

1. Ver aulas e atividades de hoje rapidamente.
2. Manter grade semanal com horário e sala.
3. Registrar trabalhos, provas e presenças com data e conclusão.

## Constraints

- Dados locais (`DeviceJsonStore`); sem Firebase/auth.
- Deve funcionar offline após instalação.

## Tiers (roadmap)

- **Free:** app gratuito na loja — núcleo offline (dia, grade, atividades, perfil) com limites de volume documentados.
- **Pro:** app **pago** em listing separado (**Sextante Pro**) — backup, lembretes, estatísticas, temas, anexos, widgets, múltiplos semestres; sync na nuvem apenas como futuro explícito.
- **Um código, dois apps** (flavors / `APP_VARIANT`); modelo principal **não** é paywall in-app — ver `docs/tasks/a_fazer/monetizacao.md` e `docs/features/README.md`.

## Source of truth

`docs/PROPOSITO.md` e `docs/features/README.md`
