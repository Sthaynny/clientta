# Funcionalidades — Sextante

Catálogo de funcionalidades do app com visão de **plano Free** vs **Pro**.  
**Arquitetura de monetização alvo:** dois apps nas lojas (**Sextante** gratuito e **Sextante Pro** pago), **um repositório** com variantes de build (estilo cura.li) — ver [tasks/a_fazer/monetizacao.md](../tasks/a_fazer/monetizacao.md). Hoje só existe um binário publicável e **não** há paywall nem cobrança in-app ([PLANEJAMENTO.md](../PLANEJAMENTO.md)).

## Índice

| Funcionalidade | Arquivo | Plano principal | Status |
|----------------|---------|-----------------|--------|
| Início — Seu dia | [home_hoje.md](home_hoje.md) | Ambos | Implementado |
| Cadastro de disciplinas | [disciplinas.md](disciplinas.md) | Free (limites) / Pro | Implementado |
| Grade horária | [grade_horaria.md](grade_horaria.md) | Ambos | Implementado |
| Atividades e prazos | [atividades.md](atividades.md) | Free (limites) / Pro | Implementado |
| Nome da universidade | [perfil_universidade.md](perfil_universidade.md) | Ambos | Implementado |
| Exportar / importar backup | [export_backup.md](export_backup.md) | Pro | Planejado |
| Lembretes e notificações | [lembretes_notificacoes.md](lembretes_notificacoes.md) | Pro | Planejado |
| Estatísticas e progresso | [estatisticas_progresso.md](estatisticas_progresso.md) | Pro | Planejado |
| Temas personalizados | [temas_personalizados.md](temas_personalizados.md) | Pro | Planejado |
| Materiais e anexos | [materiais_anexos.md](materiais_anexos.md) | Pro | Planejado |
| Widgets na tela inicial | [widgets_tela_inicial.md](widgets_tela_inicial.md) | Pro | Planejado |
| Múltiplos semestres | [multiplos_semestres.md](multiplos_semestres.md) | Pro | Planejado |
| Sincronização na nuvem | [sincronizacao_nuvem.md](sincronizacao_nuvem.md) | Pro (futuro) | Planejado |

## Comparativo Free vs Pro (visão de produto)

| Área | Free | Pro |
|------|------|-----|
| Painel do dia, grade e atividades | Uso completo com limites de volume | Sem limites de cadastro |
| Perfil (nome da universidade) | Sim | Sim |
| Série de aulas em vários dias | Sim | Sim |
| Backup JSON export/import | — | Sim |
| Notificações locais | — | Sim |
| Estatísticas de conclusão | — | Sim |
| Temas além do padrão Sextante (`HubTheme` claro) | Tema claro padrão | Paletas / escuro estendido |
| Anexos por aula/atividade | — | Sim |
| Widget Android (próxima aula) | — | Sim |
| Arquivar vários semestres | Um período ativo | Vários períodos |
| Sync na nuvem | — | Futuro; fora do escopo offline atual |

## Documentação relacionada

- [guia_sextante.md](../guia_sextante.md) — como rodar e arquitetura
- [PROPOSITO.md](../PROPOSITO.md) — visão do produto
- [PLANEJAMENTO.md](../PLANEJAMENTO.md) — fases de entrega
- [mapeamento_tarefas.md](../mapeamento_tarefas.md) — tarefas com objetivo, impacto e status
- [tasks/README.md](../tasks/README.md) — tarefas **a fazer** e **finalizadas**, agrupadas por feature
