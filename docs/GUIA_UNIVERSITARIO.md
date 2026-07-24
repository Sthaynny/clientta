# Guia universitário — ConectaFERSA sem recursos pagos

Este guia descreve como o **ConectaFERSA** (`ufersa_hub`) funciona como **app comunitário** para o dia a dia na universidade: notícias, eventos e documentos **sem login obrigatório**, sem monetização e com dependências adequadas a laboratório e extensão.

A motivação do produto (dores dos estudantes) está em [PROPOSITO.md](PROPOSITO.md).

## Visão da arquitetura

```
Flutter (MVVM + GetIt)
    ├── UI (features/*)
    ├── AppRouters (navegação)     → docs/ROTEAMENTO.md
    ├── AppConfig (perfil)         → lib/core/config/app_config.dart
    ├── CommunityAccess (sem login)→ lib/core/config/community_access.dart
    └── Repositórios
            ├── Auth (opcional — só se requireAuthentication)
            └── Dados (Cloud Firestore via FirebaseService)
```

A separação em **repositório + serviço** permite trocar o backend sem reescrever telas.

## Perfil do aplicativo

Em `lib/core/config/app_config.dart`:

| Configuração | Perfil `university` (padrão) | Perfil `production` |
|--------------|------------------------------|---------------------|
| Login obrigatório | **Não** (`requireAuthentication = false`) | Configurável |
| Anúncios (Google Mobile Ads) | Desligado | Pode ser reativado manualmente* |
| Compras in-app | Desligado | Pode ser reativado manualmente* |

\* Os pacotes `google_mobile_ads` e `in_app_purchase` foram **removidos** do `pubspec.yaml` na versão universitária.

**Padrão atual:** `AppProfile.university` + comunidade aberta.

### Reativar login (gestores)

Em `lib/core/config/app_config.dart`, defina:

```dart
static const bool requireAuthentication = true;
```

O menu lateral volta a exibir **Login** e **Sair**; apenas usuários autenticados veem ações de criar/editar/excluir.

## O que foi removido (recursos pagos / comerciais)

| Recurso | Motivo | Substituição no perfil universitário |
|---------|--------|--------------------------------------|
| Google Mobile Ads | Monetização; conta AdMob; políticas de loja | `UniversityInfoStrip` (faixa informativa local) |
| In-app purchase | Produto pago na Play/App Store | Conteúdo liberado para toda a comunidade |
| IDs de anúncio em `AdHelper` | Vinculados a conta comercial | Código removido |

## Backend e custos

### Firebase (Firestore; Auth opcional)

O projeto usa **Cloud Firestore** para dados compartilhados. **Firebase Authentication** só é necessário se `requireAuthentication = true`.

**Configuração para alunos:**

1. Crie um projeto no [Firebase Console](https://console.firebase.google.com/) (plano Spark).
2. Instale a CLI: `dart pub global activate flutterfire_cli`
3. Na raiz do repositório: `flutterfire configure`
4. Isso gera `lib/firebase_options.dart` e `android/app/google-services.json` (não versionados).
5. Use `lib/firebase_options.example.dart` como referência do formato.

**Regras Firestore (comunidade sem login):** para leitura e escrita abertas em ambiente de turma, ajuste as regras no console — em produção, prefira limitar escrita ou usar `requireAuthentication = true` para editores. Exemplo apenas para laboratório (não use em produção pública):

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
``` o arquivo `codemagic.yaml` injeta `google-services.json` e `firebase_options.dart` via variáveis de ambiente — adequado para builds institucionais, sem expor segredos no Git.

### Alternativas gratuitas ao Firebase (trabalhos avançados)

Não há implementação pronta no repositório; a troca é feita criando novas classes de repositório:

| Necessidade | Alternativa open source / gratuita |
|-------------|-----------------------------------|
| Autenticação | [Supabase](https://supabase.com/) (tier free), ou API própria com JWT em servidor da universidade |
| Banco de dados | PostgreSQL (servidor da instituição), Supabase, ou [Appwrite](https://appwrite.io/) self-hosted |
| Armazenamento de arquivos | MinIO self-hosted, ou bucket institucional |

Passos gerais:

1. Criar `AuthRepositoryLocal` / `NewsRepositoryLocal` implementando as interfaces em `domain/repositories`.
2. Registrar no `setup()` de `lib/core/dependecy/dependency.dart` em vez das implementações `*Remote`.
3. Remover `firebase_*` e `cloud_firestore` do `pubspec.yaml` quando não forem mais usados.

## Design System externo

O pacote `design_system` vem de um repositório Git público (`Sthaynny/design_system`). Não é pago; para aulas offline, faça fork do repositório e aponte o `pubspec.yaml` para o fork interno da turma.

## Como rodar localmente (turma)

```bash
git clone <url-do-repositorio>
cd ufersa_hub
flutter pub get
flutterfire configure   # ou copie credenciais fornecidas pelo professor
flutter run
```

Sem Firebase configurado, o app pode falhar na inicialização do `Firebase.initializeApp()` — configure o projeto de laboratório antes da primeira execução.

## Publicação em lojas (opcional)

Publicar na Google Play exige **taxa única** de desenvolvedor (conta comercial). Para avaliação em disciplina, prefira:

- APK/AAB distribuído internamente (Firebase App Distribution, link direto, ou dispositivo via USB).
- Emulador Android no laboratório.

O workflow Codemagic atual publica na Play (`google_play`); comente o bloco `publishing` se a turma não usar loja paga.

## Checklist do professor / monitor

- [ ] Projeto Firebase Spark criado para a turma
- [ ] Regras de segurança do Firestore revisadas (não deixar leitura/escrita abertas em produção)
- [ ] `AppConfig.profile` = `university` e `requireAuthentication` = `false` (comunidade aberta)
- [ ] Rotas documentadas em `docs/ROTEAMENTO.md`
- [ ] Sem pacotes de anúncios ou IAP no `pubspec.yaml`

## Referências no código

- Rotas: `lib/core/router/app_router.dart`
- Injeção de dependências: `lib/core/dependecy/dependency.dart`
- Configuração de perfil: `lib/core/config/app_config.dart`
- Exemplo Firebase: `lib/firebase_options.example.dart`
