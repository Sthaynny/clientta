---
name: clientta-ship
description: >-
  Orquestra implementação de features do Clientta via subagentes especializados
  (home, agendas, auth, sync, billing, stripe).
  Use ao implementar funcionalidade, /clientta-ship, backlog C-xxx, ou pedir
  subagente de feature específica.
---

# Clientta Ship

Orquestrador do **Clientta**: delega a subagentes por feature.
Sempre respeitar `.cursor/rules/clientta-general.mdc` e `clientta-ui.mdc`.

## Workflow

```
Progresso:
- [ ] 1. Discovery — docs, tarefas C-xxx, código existente
- [ ] 2. Escopo — feature pedida OU próximo item do backlog
- [ ] 3. Gate — bloquear se faltar critério de aceite
- [ ] 4. Subagente — delegar via Task (prompt autocontido)
- [ ] 5. Verificação — flutter analyze + flutter test
- [ ] 6. Handoff — entregue, pendências, próximo item
```

### 1. Discovery

| Fonte | Extrair |
|-------|---------|
| `docs/features/*.md` | comportamento, Free/Pro, rotas |
| `docs/tasks/README.md` | IDs C-xxx — finalizadas e a fazer |
| `docs/PLANEJAMENTO.md` | fase e dependências |
| `lib/features/appointments/` | padrão de referência (MVVM) |
| `.cursor/rules/clientta-*.mdc` | arquitetura obrigatória |

### 2. Escolher subagente

| Feature / área | Arquivo | Task `description` |
|----------------|---------|-------------------|
| Painel do dia (`/`) | [home-hoje.md](references/subagents/home-hoje.md) | `Clientta: home-hoje` |
| Minha Agenda + formulário | [agendas.md](references/subagents/agendas.md) | `Clientta: agendas` |
| Firebase Auth | [auth-firebase.md](references/subagents/auth-firebase.md) | `Clientta: auth-firebase` |
| Sync Firestore (Pro) | [sincronizacao-nuvem.md](references/subagents/sincronizacao-nuvem.md) | `Clientta: sync` |
| Lembretes locais (Pro) | [lembretes-locais.md](references/subagents/lembretes-locais.md) | `Clientta: lembretes-locais` |
| Tela Plano Pro (app) | [assinatura-stripe.md](references/subagents/assinatura-stripe.md) | `Clientta: assinatura-stripe` |
| Cloud Functions Stripe | [billing-functions.md](references/subagents/billing-functions.md) | `Clientta: billing-functions` |
| Shimmer loading (transversal) | [shimmer-loading.md](references/subagents/shimmer-loading.md) | `Clientta: shimmer-loading` |

### 3. Delegar (Task)

1. Ler o contrato do subagente escolhido.
2. Lançar `Task` com `subagent_type: generalPurpose` e prompt contendo:
   - Papel (copiar do arquivo)
   - Escopo e IDs C-xxx
   - Paths relevantes
   - Critérios de aceite
   - Restrições (offline-first, sem Stripe SDK no Flutter, etc.)
3. Se `Task` indisponível, executar o papel no turno atual.

Após o subagente de feature, rodar localmente (ou delegar):
- `flutter analyze`
- `flutter test`

### 4. Handoff

```markdown
## Clientta Ship — ciclo
- **Subagente:** …
- **Entregue:** …
- **Arquivos:** …
- **Testes/analyze:** …
- **Tarefas C-xxx:** concluídas / pendentes
- **Próximo:** …
```

## Modos

| Modo | Acionar | Comportamento |
|------|---------|---------------|
| Feature | "implementar agendas" / C-103 | Subagente da feature |
| Pipeline | `/clientta-ship` sem escopo | Discovery → próximo C-xxx de maior impacto na fase atual |

## Anti-padrões

- Implementar sem ler doc da feature
- Stripe SDK no Flutter
- Cliente escrever `users/{uid}.subscription`
- Pular `flutter analyze` e `flutter test`

## Referências

- [discovery.md](references/discovery.md) — checklist de contexto
- [subagents/](references/subagents/) — contratos por feature
