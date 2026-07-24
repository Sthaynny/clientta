# Guia universitário — ConectaFERSA sem recursos pagos

Este guia descreve como o **ConectaFERSA** (`ufersa_hub`) foi orientado para uso como **facilitador acadêmico**: notícias, eventos e documentos da comunidade universitária, sem monetização nem dependências comerciais obrigatórias.

## Visão da arquitetura

```
Flutter (MVVM + GetIt)
    ├── UI (features/*)
    ├── AppRouters (navegação)     → docs/ROTEAMENTO.md
    ├── AppConfig (perfil)         → lib/core/config/app_config.dart
    └── Repositórios
            ├── Auth (Firebase Auth)
            └── Dados (Cloud Firestore via FirebaseService)
```

A separação em **repositório + serviço** permite trocar o backend sem reescrever telas.

## Perfil do aplicativo

Em `lib/core/config/app_config.dart`:

| Configuração | Perfil `university` (padrão) | Perfil `production` |
|--------------|------------------------------|---------------------|
| Anúncios (Google Mobile Ads) | Desligado | Pode ser reativado manualmente* |
| Compras in-app | Desligado | Pode ser reativado manualmente* |

\* Os pacotes `google_mobile_ads` e `in_app_purchase` foram **removidos** do `pubspec.yaml` na versão universitária. Reativar monetização exige readicionar dependências e código legado (não recomendado em projetos de curso).

**Padrão atual:** `AppProfile.university`.

## O que foi removido (recursos pagos / comerciais)

| Recurso | Motivo | Substituição no perfil universitário |
|---------|--------|--------------------------------------|
| Google Mobile Ads | Monetização; conta AdMob; políticas de loja | `UniversityInfoStrip` (faixa informativa local) |
| In-app purchase | Produto pago na Play/App Store | Funcionalidades liberadas para todos os usuários autenticados |
| IDs de anúncio em `AdHelper` | Vinculados a conta comercial | Código removido |

## Backend e custos

### Firebase (Auth + Firestore)

O projeto ainda usa **Firebase**, que possui plano **Spark gratuito** adequado a protótipos e turmas pequenas, com limites documentados pela Google.

**Configuração para alunos:**

1. Crie um projeto no [Firebase Console](https://console.firebase.google.com/) (plano Spark).
2. Instale a CLI: `dart pub global activate flutterfire_cli`
3. Na raiz do repositório: `flutterfire configure`
4. Isso gera `lib/firebase_options.dart` e `android/app/google-services.json` (não versionados).
5. Use `lib/firebase_options.example.dart` como referência do formato.

**CI (Codemagic):** o arquivo `codemagic.yaml` injeta `google-services.json` e `firebase_options.dart` via variáveis de ambiente — adequado para builds institucionais, sem expor segredos no Git.

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
- [ ] `AppConfig.profile` = `university`
- [ ] Rotas documentadas em `docs/ROTEAMENTO.md`
- [ ] Sem pacotes de anúncios ou IAP no `pubspec.yaml`

## Referências no código

- Rotas: `lib/core/router/app_router.dart`
- Injeção de dependências: `lib/core/dependecy/dependency.dart`
- Configuração de perfil: `lib/core/config/app_config.dart`
- Exemplo Firebase: `lib/firebase_options.example.dart`
