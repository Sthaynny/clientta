# Propósito do Hub Universitário

## Em uma frase

**Hub Universitário** é um **auxiliar do dia a dia** para quem estuda em qualquer universidade: grade de aulas, registro de atividades e visão do que importa **hoje** — **sem login, sem servidor e sem banco de dados na nuvem**.

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

- Lembrete com notificação local (`flutter_local_notifications`)
- Exportar/importar JSON para backup
- Widget de “próxima aula”
