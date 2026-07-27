# Perfil — nome da universidade

## Resumo

Permite definir o **nome da instituição** exibido no drawer e no contexto do app, sem login. Dados salvos localmente junto ao JSON do app.

## Plano

**Ambos**

### Free

- Definir, editar e limpar o nome da universidade pelo menu lateral.
- Texto opcional (app funciona sem preencher).

### Pro

- Mesmo comportamento; futuro: múltiplos perfis acadêmicos ligados a [multiplos_semestres.md](multiplos_semestres.md).

## Status no app

**Implementado** — `AppProfileSettings` em `lib/core/storage/`, diálogo no `app_drawer.dart`.

## Dependências / notas técnicas

- Campo `universityName` no root JSON (`DeviceJsonStore`).
- Strings em `daily_strings.dart` (`universityName*`).
