# Guia do projeto — app local para estudantes

## Princípios

- **Sem autenticação** — não há telas de login nem usuários.
- **Sem backend** — não há Firebase, API nem banco na nuvem.
- **Persistência local** — um arquivo JSON em `getApplicationDocumentsDirectory()` (`lib/core/storage/device_json_store.dart`).

Isso atende uso em sala, TCC e extensão sem custo de infraestrutura.

## Como rodar

```bash
flutter pub get
flutter run
```

Não é necessário `flutterfire configure` nem variáveis de ambiente de nuvem.

## Estrutura de features

- `features/home` — resumo do dia
- `features/classes` — grade semanal
- `features/activities` — registro de atividades

Cada feature segue **model → repository → view model → screen**.

## Backup dos dados

O arquivo `conectafersa_daily.json` fica na pasta de documentos do app no dispositivo. Para backup manual, exporte esse arquivo (funcionalidade de export pode ser adicionada depois).

## CI (Codemagic)

O workflow em `codemagic.yaml` não precisa mais de grupos Firebase. Basta Flutter analyze + build.

## Design System

Pacote Git `Sthaynny/design_system`. Para turmas offline, use fork interno no `pubspec.yaml`.
