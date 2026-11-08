# AGENTS.md

Guia para agentes de código (Claude Code, Cursor, Codex) no **Clientta**: CRM de
atendimentos para agentes de crédito, seguros e autônomos. Pacote Dart `clientta`.
Leia antes de mudar qualquer coisa. Regras completas em `.cursor/rules/*.mdc`.

## O projeto

App Flutter, **offline-first**: dados em `DeviceJsonStore` (JSON no aparelho). Firebase
Auth + Firestore para sync (Pro). Stripe só via Cloud Functions, sem SDK no app.

- MVVM + GetIt. ViewModels expõem `CommandBase`/`CommandAction` (`lib/core/utils/commands.dart`),
  não estendem `ChangeNotifier`. Ações assíncronas retornam `Result<T>`.
- Estrutura por feature: `domain/models`, `domain/repositories`, `data`, `view`. Novas features seguem `appointments`.
- Imports `package:clientta/...`; nunca relativos entre features.
- O cliente não escreve `users/{uid}.subscription`: só Functions/webhook.
- UI: componentes `Hub*` (`lib/features/shared/hub/hub.dart`), textos em `lib/core/strings/`.
- Mudança mínima correta; seguir o padrão do arquivo; não refatorar fora do escopo.
- Nova dependência precisa de justificativa no commit.

## Harness: como validar uma mudança

```bash
bash scripts/harness.sh            # quick: links de .md + CHANGELOG + flutter analyze
bash scripts/harness.sh full       # quick + flutter test
bash scripts/harness.sh docs       # só links relativos entre .md
bash scripts/harness.sh changelog  # lib/ ou functions/*.js mudou sem CHANGELOG.md?
bash scripts/harness.sh analyze    # só flutter analyze
bash scripts/harness.sh test       # só flutter test
```

Uma mudança só está pronta quando `full` passa. O CI (`.github/workflows/harness.yml`)
roda `harness.sh full` em push e PR. O hook `pre-commit` da raiz continua valendo
para formatação.

## Changelog

Toda mudança em `lib/` ou `functions/*.js` registra uma linha em **Não lançado** no
[CHANGELOG.md](CHANGELOG.md), no mesmo PR. Convenção no topo do arquivo. Tarefas
concluídas seguem em [docs/tasks/](docs/tasks/README.md).

## Documentação

| Documento | Conteúdo |
|-----------|----------|
| [docs/guia_clientta.md](docs/guia_clientta.md) | Como rodar, Firebase e arquitetura |
| [docs/features/README.md](docs/features/README.md) | Catálogo Free / Pro |
| [docs/PLANEJAMENTO.md](docs/PLANEJAMENTO.md) | Fases de entrega |
| [docs/tasks/README.md](docs/tasks/README.md) | Tarefas finalizadas e a fazer |
| [docs/ROTEAMENTO.md](docs/ROTEAMENTO.md) | Rotas do app |
| [PRODUCT.md](PRODUCT.md) · [DESIGN.md](DESIGN.md) | Produto e design |
| [docs/stores/README.md](docs/stores/README.md) | Publicação e notas de versão |
