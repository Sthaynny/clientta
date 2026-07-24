# Roteamento do ConectaFERSA

O aplicativo usa **rotas nomeadas** do Flutter (`MaterialApp.routes`), centralizadas no enum `AppRouters` e no mapa `routes` em `lib/core/router/app_router.dart`.

## Mapa de rotas (perfil universitário)

| Tela | Constante | Caminho |
|------|-----------|---------|
| Início (notícias) | `AppRouters.home` | `/` |
| Login | `AppRouters.login` | `/acesso/login` |
| Recuperar senha | `AppRouters.forgoutPassword` | `/acesso/recuperar-senha` |
| Detalhe da notícia | `AppRouters.detailsNews` | `/noticias/detalhe` |
| Imagem em tela cheia | `AppRouters.detailsNewsImage` | `/noticias/imagem` |
| Criar/editar notícia | `AppRouters.manegerNews` | `/noticias/gerenciar` |
| Lista de eventos | `AppRouters.events` | `/eventos` |
| Detalhe do evento | `AppRouters.detailsEvent` | `/eventos/detalhe` |
| Criar/editar evento | `AppRouters.manegerEvents` | `/eventos/gerenciar` |
| Documentos | `AppRouters.documents` | `/documentos` |
| Criar/editar documento | `AppRouters.manegerDocuments` | `/documentos/gerenciar` |

Os caminhos foram organizados por **módulo acadêmico** (acesso, notícias, eventos, documentos), facilitando a navegação em aulas e documentação de fluxos.

## Como navegar no código

Use a extensão `context.go` (definida em `lib/core/utils/extension/build_context.dart`):

```dart
context.go(AppRouters.events);

await context.go(AppRouters.detailsNews, arguments: NewsArgs(news: item));
```

Não use strings literais de rota na interface; sempre referencie `AppRouters` para evitar divergência.

## Como alterar uma rota

1. Abra `lib/core/router/app_router.dart`.
2. Localize o enum `AppRouters` e edite o getter `path` no `switch` correspondente ao destino desejado.
3. Confirme que a chave no mapa `routes` continua usando `AppRouters.<nome>.path` (já é automático).
4. Atualize esta tabela em `docs/ROTEAMENTO.md`.
5. Se houver testes de integração que dependam de deep links, ajuste-os (hoje os testes Patrol usam widgets, não URLs).

Exemplo — renomear o módulo de eventos para `agenda`:

```dart
events => '/agenda',
detailsEvent => '/agenda/detalhe',
manegerEvents => '/agenda/gerenciar',
```

## Rota inicial

A rota inicial está em `lib/features/app.dart`:

```dart
initialRoute: AppRouters.home.path,
```

O app abre direto no feed de notícias — **sem tela de login** no modo comunitário (`requireAuthentication = false`).

Para exigir login antes do uso (gestores), defina `requireAuthentication = true` em `AppConfig` e altere `initialRoute` para `AppRouters.login.path` se desejar.

## Evolução futura (opcional)

Para projetos maiores, considere migrar para `go_router` com rotas tipadas e deep links. O padrão atual (enum + `routes`) é intencionalmente simples para ensino e não exige pacotes extras.
