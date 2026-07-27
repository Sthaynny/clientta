# Guia do projeto — Sextante

**Sextante** é o nome do produto: um organizador offline para estudantes de qualquer universidade (pacote técnico `university_hub`). A metáfora do sextante remete a orientar-se na graduação — grade, entregas e o que importa hoje — sem depender de sistemas da instituição.

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

Detalhamento de funcionalidades, status e roadmap **Free / Pro** (assinatura ainda não implementada no app): [features/README.md](features/README.md).

## Backup dos dados

O arquivo `university_hub_daily.json` fica na pasta de documentos do app no dispositivo. Instalações antigas migram automaticamente de `conectafersa_daily.json`. Para backup manual, exporte esse arquivo; fluxo guiado no app está previsto no plano **Pro** ([features/export_backup.md](features/export_backup.md)).

## CI (Codemagic)

O workflow em `codemagic.yaml` não precisa mais de grupos Firebase. Basta Flutter analyze + build.

## Planejamento

Próximos passos e fases de entrega: [PLANEJAMENTO.md](PLANEJAMENTO.md).

## Design System

Pacote Git `Sthaynny/design_system`. Para turmas offline, use fork interno no `pubspec.yaml`.
