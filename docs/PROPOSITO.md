# Propósito do ConectaFERSA

## Em uma frase

**ConectaFERSA** é um **app comunitário** para o dia a dia na universidade: centraliza avisos, eventos e documentos do campus **sem exigir login**, para qualquer estudante abrir e usar na hora.

## Dores que motivam o produto

Estudantes costumam enfrentar:

1. **Informação fragmentada** — o mesmo aviso aparece em grupo de mensagem, story e mural; ninguém sabe qual fonte está atualizada.
2. **Prazos invisíveis** — semana acadêmica, palestra, inscrição em projeto extensionista passam sem que a pessoa veja a tempo.
3. **Documentos no lugar errado** — edital, formulário ou ata some no histórico do chat quando mais precisa.
4. **Calouro perdido** — sem um “ponto zero” do que está acontecendo no campus.
5. **Fricção desnecessária** — pedir conta, e-mail institucional ou senha só para **ler** um comunicado afasta quem só quer informação rápida.

O ConectaFERSA responde a isso com três pilares no mesmo app:

| Pilar | O que resolve |
|-------|----------------|
| **Notícias** | Comunicados e avisos em feed único, com filtro por categoria |
| **Eventos** | Agenda do que vai acontecer no campus |
| **Documentos** | Arquivos e links úteis (editais, modelos, materiais) |

## Princípios do app comunitário

- **Uso imediato:** abrir o app e consumir conteúdo, sem cadastro.
- **Contribuição da comunidade:** no modo padrão (`AppConfig.requireAuthentication = false`), estudantes também podem publicar e atualizar conteúdo pela interface — a turma cuida do hub (com regras de backend adequadas).
- **Sem monetização:** sem anúncios nem compras in-app no perfil universitário.
- **Modo gestão opcional:** instituições que quiserem restringir edição podem definir `requireAuthentication = true` e usar login apenas para quem administra.

## Onde isso está no código

| Conceito | Arquivo |
|----------|---------|
| Textos de missão | `lib/core/strings/app_mission.dart` |
| Login obrigatório ou não | `lib/core/config/app_config.dart` |
| Quem pode editar na UI | `lib/core/config/community_access.dart` |
| Faixa no topo das telas | `lib/features/shared/widgets/university_info_strip.dart` |
| Menu lateral | `lib/features/home/screen/components/app_drawer.dart` |

## Backend e moderação (importante)

Sem login, a **segurança real** depende das **regras do Firestore** (ou do backend escolhido). Para laboratório, pode-se usar regras abertas; em uso real com turmas grandes, combine:

- regras mais restritivas para escrita,
- moderação por representantes de curso,
- ou `requireAuthentication = true` só para quem publica.

Detalhes em [GUIA_UNIVERSITARIO.md](GUIA_UNIVERSITARIO.md).

## Mensagens oficiais do app

Definidas em `AppMission` para manter README, UI e documentação alinhados:

- **Tagline:** *O que importa no campus, em um só lugar — sem login.*
- **Resumo:** hub comunitário para quem cansou de perder aviso em grupo, prazo de evento e PDF de edital no fim do feed.
