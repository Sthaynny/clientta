# Roteamento

Rotas definidas em `lib/core/router/app_router.dart` (`AppRouters`).

| Tela | Constante | Caminho |
|------|-----------|---------|
| Início | `AppRouters.home` | `/` |
| Grade de aulas | `AppRouters.classes` | `/aulas` |
| Formulário de aula | `AppRouters.classForm` | `/aulas/registrar` |
| Lista de atividades | `AppRouters.activities` | `/atividades` |
| Formulário de atividade | `AppRouters.activityForm` | `/atividades/registrar` |

Navegação:

```dart
context.go(AppRouters.classes);
context.go(AppRouters.classForm, arguments: classEntry);
```

Para alterar um caminho, edite o getter `path` no enum `AppRouters`.
