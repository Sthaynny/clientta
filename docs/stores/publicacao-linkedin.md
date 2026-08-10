# Publicação — LinkedIn (projeto de aprendizado)

Estrutura detalhada para post de portfólio / aprendizado sobre o **Clientta**.  
Tom: profissional, honesto sobre o que foi aprendido — sem hype de IA.

---

## Objetivo do post

- Mostrar o projeto como case de aprendizado full-stack mobile
- Atrair conexões da área (Flutter, Firebase, produto)
- Direcionar para repositório ou Play Store quando publicado

**Segmentação:** devs mobile, product builders, profissionais de crédito/seguros que usam CRM.

---

## Formato recomendado

| Elemento | Recomendação |
|----------|--------------|
| Tipo | Post com carrossel (PDF ou 3–5 imagens) **ou** artigo longo |
| Imagens | `phone_01_home.png` … `phone_04_atendimento.png` da pasta `store-assets/screenshots/phone/` |
| Horário | Terça ou quarta, 8h–10h ou 18h–20h (Brasil) |
| CTA | Link do repo ou "comente se quiser ver o código" |

---

## Estrutura do carrossel (5 slides)

### Slide 1 — Capa

**Visual:** `phone_01_home.png` ou mockup da Home (`01_home_seu_dia.png`)

**Texto na imagem (se editar):**
```
Clientta
CRM de atendimentos offline para quem vende no dia a dia
```

**Legenda do slide:** problema + promessa em uma linha.

---

### Slide 2 — O problema

**Visual:** foto genérica de corredor/escritório **ou** print da agenda vazia (`08_home_seu_dia_vazio.png`)

**Bullets (texto no slide ou na legenda):**
- Quem atende crédito e seguros vive entre ligações
- Planilha e WhatsApp não seguram o contexto da negociação
- Internet instável no campo quebra fluxos só-online

**Frase de transição:** "Resolvi isso construindo um app que funciona sem rede."

---

### Slide 3 — O que o app faz

**Visual:** carrossel interno com 3 prints:
- `02_minha_agenda.png`
- `03_meus_clientes.png`
- `04_atendimento_historico.png`

**Bullets:**
- Painel do dia: quem vem hoje e em que horário
- Agenda com filtro por tipo de serviço
- Histórico de negociação por cliente (ligações, reuniões, combinados)

---

### Slide 4 — Stack e arquitetura

**Visual:** diagrama simples (texto no slide)

```
Flutter (MVVM + GetIt)
  ├── JSON local (offline-first)
  ├── Firebase Auth + Firestore (sync Pro)
  └── Cloud Functions + Stripe (assinatura)
```

**O que aprendi (escolher 3–4):**
- Offline-first: UI imediata em `DeviceJsonStore`, sync depois
- MVVM com `CommandBase` / `Result<T>` em vez de `ChangeNotifier` solto
- Billing fora do app: Stripe Checkout via URL, entitlement no Firestore
- Separação domain / data / view por feature (`appointments` como referência)

---

### Slide 5 — Próximos passos + CTA

**Visual:** `feature_graphic_1024x500.png` ou ícone + nome

**Texto:**
```
Em breve na Play Store.
Código aberto: [link do GitHub]
```

**CTA:** "Se você atende clientes no dia a dia, me conta o que falta nesse fluxo."

---

## Texto do post (copiar e adaptar)

### Hook (primeiras 2 linhas — aparecem antes do "ver mais")

```
Construí um CRM mobile offline para quem vende crédito, seguros e serviços no dia a dia.

Não é mais um app genérico de tarefas — é focado em quem precisa saber QUEM atender HOJE e O QUE foi combinado com cada cliente.
```

### Corpo

```
O Clientta nasceu de uma dor real: entre uma ligação e outra, o contexto da negociação se perde. Planilha no Drive, anotação no WhatsApp, agenda no Google Calendar — nada conversa entre si.

O que o app entrega hoje:

→ Painel do dia com atendimentos ordenados por horário
→ Agenda com status (agendado, concluído, cancelado)
→ Lista de clientes com busca e histórico centralizado
→ Registro de encontros sem precisar agendar horário
→ Operação offline — dados no celular, sync na nuvem no plano Pro

Stack que usei para aprender na prática:

• Flutter com MVVM, GetIt e rotas tipadas
• Persistência local em JSON (`DeviceJsonStore`)
• Firebase Auth + Firestore para sync entre aparelhos
• Stripe via Cloud Functions (sem SDK no app)

Decisões que me ensinaram mais:

1. Offline-first não é "cache" — é a fonte imediata da UI
2. Entitlement de assinatura só no servidor (webhook), nunca no cliente
3. Feature folders (`domain` / `data` / `view`) escalam melhor que pastas por tipo de arquivo

O projeto ainda está em evolução (onboarding, polish de UI, publicação na Play). Próximo passo: release na loja e feedback de quem usa no campo.

Repositório: [cole o link do GitHub]
```

### CTA final

```
Se você trabalha com atendimento a clientes ou está montando um app offline-first, comenta — troco ideia sobre arquitetura e UX de campo.
```

### Hashtags (máx. 5, opcional)

```
#Flutter #Firebase #MobileDev #Produto #OfflineFirst
```

---

## Artigo longo (alternativa ao carrossel)

Se preferir artigo no LinkedIn (~800–1200 palavras), usar esta estrutura:

| Seção | Conteúdo |
|-------|----------|
| 1. Contexto | Público-alvo (agentes de crédito/seguros) e dor |
| 2. Hipótese | "Um CRM leve no bolso, offline, resolve o dia a dia" |
| 3. Escopo do MVP | Painel do dia, agenda, clientes, atendimento |
| 4. Arquitetura | Diagrama + offline-first + sync Pro |
| 5. Desafios | Sync, limites Free, billing Stripe |
| 6. O que faria diferente | Retrospectiva honesta |
| 7. Aprendizados | 3 bullets acionáveis para outros devs |
| 8. Próximos passos | Play Store, feedback, features |

---

## Métricas para acompanhar (7 dias)

| Métrica | Meta inicial |
|---------|--------------|
| Impressões | baseline |
| Cliques no link | > 1% das impressões |
| Comentários | responder todos em 24h |
| Salvamentos | sinal de interesse em referência |

---

## Checklist antes de publicar

- [ ] Link do GitHub funcionando
- [ ] Screenshots sem dados sensíveis reais (usar "Teste Cliente")
- [ ] Não citar nota na loja ou downloads sem dado real
- [ ] Mencionar que é projeto de aprendizado, não empresa estabelecida
- [ ] Revisar tom: sem "revolucionário", "imperdível", "game changer"
