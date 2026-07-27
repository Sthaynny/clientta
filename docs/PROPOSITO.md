# Propósito do Sextante

## Em uma frase

**Sextante** é um **auxiliar do dia a dia** para quem estuda em qualquer universidade: grade de aulas, registro de atividades e visão do que importa **hoje** — **sem login, sem servidor e sem banco de dados na nuvem**.

Os dados ficam em um **arquivo JSON no próprio celular** (`DeviceJsonStore`).

## Dores do estudante

1. **Sala e horário** — em semanas atípicas, não lembrar onde é a aula.
2. **Entregas e provas** — anotar em um lugar só, em vez de prints perdidos no chat.
3. **Rotina fragmentada** — listas soltas no WhatsApp e na galeria.
4. **Fricção** — não querer criar conta ou depender de internet só para organizar a semana.

## O que o app faz hoje

| Função | Descrição |
|--------|-----------|
| **Início** | Aulas de hoje + atividades de hoje |
| **Minha grade** | Cadastro de disciplinas por dia da semana, horário e sala |
| **Minhas atividades** | Trabalhos, estudos, provas e presenças, com data e “concluída” |
| **Perfil** | Nome da universidade no menu (opcional, local) |

Catálogo **Free / Pro** e modelo alvo **dois apps na loja** (um repositório): [features/README.md](features/README.md), [tasks/a_fazer/monetizacao.md](tasks/a_fazer/monetizacao.md).

## Rotas

| Tela | Caminho |
|------|---------|
| Início | `/` |
| Grade | `/aulas` |
| Registrar aula | `/aulas/registrar` |
| Atividades | `/atividades` |
| Registrar atividade | `/atividades/registrar` |

Detalhes em [ROTEAMENTO.md](ROTEAMENTO.md).

Roteiro de evolução: [PLANEJAMENTO.md](PLANEJAMENTO.md).

## Arquitetura

```
Flutter (MVVM + GetIt)
  └── DeviceJsonStore (arquivo local)
        ├── ClassRepositoryLocal
        └── ActivityRepositoryLocal
```

Não há Firebase, autenticação nem Firestore.

## Evoluções possíveis (sem nuvem)

Itens abaixo estão detalhados em `docs/features/`; a maioria está no tier **Pro** do roadmap de produto:

- [Lembretes locais](features/lembretes_notificacoes.md) (`flutter_local_notifications`)
- [Exportar/importar JSON](features/export_backup.md)
- [Widget “próxima aula”](features/widgets_tela_inicial.md)

Sincronização na nuvem: apenas [futuro explícito](features/sincronizacao_nuvem.md), fora do escopo offline atual.
