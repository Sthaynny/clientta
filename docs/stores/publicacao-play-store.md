# Publicação — Google Play Store (Clientta)

Pacote completo para colar no Google Play Console.  
**Fonte visual:** prints reais em `docs/stores/prints/`.  
**Identidade:** verde `#1B6B5C` / `#0F4A3F` (DESIGN.md).

---

## Copy da ficha

### Nome do app

```
Clientta
```

### Breve descrição (78/80)

```
Agenda de atendimentos offline. Veja quem vem hoje e anote cada negociação.
```

### Descrição completa

```
Você atende crédito, seguros ou clientes no dia a dia e não pode perder o fio da meada entre uma ligação e outra.

O Clientta organiza sua rotina em um só lugar:

• Painel do dia — veja quem vem hoje, em que horário e o status de cada atendimento
• Minha Agenda — todos os agendamentos por data, com filtro por tipo de serviço
• Meus Clientes — lista unificada com busca por nome ou telefone
• Atendimento — histórico de ligações, reuniões e o que foi combinado com cada cliente
• Registrar encontros — anote negociações sem precisar agendar horário

Funciona sem internet. Seus dados ficam no celular e você usa o app no ritmo do campo.

No plano Pro, a mesma conta sincroniza em outro aparelho, com backup dos dados e avisos antes do horário.

Para quem vende serviços em movimento e precisa de clareza: quem, quando e o que foi discutido.

Baixe grátis e comece pelo painel do dia.
```

### Categoria sugerida

Produtividade (ou Negócios)

### Tags / palavras-chave (uso interno, não campo oficial)

agenda, atendimento, CRM, clientes, seguros, crédito, offline, corretor, vendedor

---

## Headlines do carrossel (screenshots promocionais)

| # | Arquivo | Headline na arte | Print base |
|---|---------|------------------|------------|
| 1 | `phone_01_home.png` | Veja quem atender hoje | `01_home_seu_dia.png` |
| 2 | `phone_02_agenda.png` | Agenda e clientes organizados | `02_minha_agenda.png` |
| 3 | `phone_03_clientes.png` | Histórico de cada negociação | `03_meus_clientes.png` |
| 4 | `phone_04_atendimento.png` | Registre sem perder contexto | `04_atendimento_historico.png` |
| 5 | `phone_05_offline.png` | Funciona mesmo sem internet | `01_home_seu_dia.png` |

### Legendas opcionais (Console)

1. Painel do dia com atendimentos ordenados por horário.
2. Agenda completa com filtro por tipo de serviço.
3. Lista de clientes com próximo horário e histórico.
4. Anote encontros e negociações por cliente.
5. Opera offline — dados salvos no celular.

---

## Assets gerados

```
docs/stores/store-assets/
├── icon/
│   ├── icon_512.png          # Google Play
│   └── icon_1024.png         # App Store Connect
├── feature_graphic/
│   └── feature_graphic_1024x500.png
└── screenshots/
    ├── phone/                # Promocionais 1080×1920 (Play)
    │   ├── phone_01_home.png … phone_05_offline.png
    ├── tablet_7/             # UI em tablet 7" — 1920×1080 landscape
    │   └── tablet_01…04
    ├── tablet_10/            # UI em tablet 10" — 2560×1440 landscape
    │   └── tablet_01…04
    └── app_store/
        ├── iphone/           # 1290×2796 (6.7")
        └── ipad/             # 2048×2732 (12.9" iPad Pro)
```

| Arquivo | Spec | Descrição |
|---------|------|-----------|
| `icon_512.png` | **512×512** | Ícone Google Play |
| `icon_1024.png` | **1024×1024** | Ícone App Store Connect |
| `feature_graphic_1024x500.png` | 1024×500 | Banner horizontal com print da Home |
| `phone_01…05` | 1080×1920 (9:16) | Screenshots promocionais com headline |
| `tablet_7/tablet_01…04` | **1920×1080** (16:9) | Tablet 7" — só UI, sem headline |
| `tablet_10/tablet_01…04` | **2560×1440** (16:9) | Tablet 10" — só UI, sem headline |
| `app_store/iphone/*` | 1290×2796 | iPhone 6.7" (upscale dos phone) |
| `app_store/ipad/*` | 2048×2732 | iPad 12.9" portrait |

Regenerar artes: `bash tool/regenerate_store_assets.sh` (skill publicidade + `docs/stores/store-manifest.yaml`).

---

## Checklist de publicação (Play Console)

### Conta e app
- [ ] Conta de desenvolvedor Google Play ativa (taxa única)
- [ ] App criado no Console com package name do projeto
- [ ] Política de privacidade publicada: `https://sthaynny.github.io/pages-public/clientta/privacidade/`
- [ ] URL de exclusão de conta: `https://sthaynny.github.io/pages-public/clientta/exclusao-de-conta/`
- [ ] Política de assinatura Pro: `https://sthaynny.github.io/pages-public/clientta/assinatura/`

### Ficha da loja (pt-BR)
- [ ] Nome: Clientta
- [ ] Breve descrição (≤80 caracteres)
- [ ] Descrição completa
- [ ] Ícone 512×512 enviado (`icon/icon_512.png`)
- [ ] Feature graphic 1024×500 enviado
- [ ] Mínimo 4 screenshots telefone (1080×1920) — usar `phone_01` a `phone_04`
- [ ] Tablet 7": mínimo 4 screenshots (1920×1080) — `screenshots/tablet_7/tablet_01…04`
- [ ] Tablet 10": mínimo 4 screenshots (2560×1440) — `screenshots/tablet_10/tablet_01…04`
- [ ] Categoria: Produtividade
- [ ] Classificação de conteúdo preenchida
- [ ] Público-alvo e país de distribuição definidos

### Técnico
- [ ] AAB assinado (`flutter build appbundle`)
- [ ] `google-services.json` configurado
- [ ] Teste em dispositivo real antes do envio
- [ ] Assinatura Pro: produto Stripe ativo e webhook funcionando

### Assinaturas (se Pro no lançamento)
- [ ] Produto de assinatura criado no Play Console
- [ ] Preço alinhado ao Stripe
- [ ] Texto de renovação/cancelamento na ficha

### Promoção (opcional)
- [ ] ≥4 screenshots com lado ≥1080 px (elegibilidade promoção)
- [ ] Vídeo YouTube 15–30 s (roteiro abaixo)

---

## Roteiro de vídeo (opcional, 20 s)

| Tempo | Cena | Texto na tela |
|-------|------|---------------|
| 0–3 s | Home com agendamento | "Quem você atende hoje?" |
| 3–8 s | Minha Agenda | "Tudo na agenda" |
| 8–13 s | Meus Clientes → Atendimento | "Contexto de cada cliente" |
| 13–17 s | Registrar encontro | "Anote na hora" |
| 17–20 s | Logo + CTA | "Clientta — baixe grátis" |

---

## Variações A/B (teste de breve descrição)

**A (atual):** Agenda de atendimentos offline. Veja quem vem hoje e anote cada negociação.

**B:** CRM no bolso para quem vende crédito e seguros. Funciona sem internet.

**C:** Painel do dia, agenda e histórico por cliente. Offline no celular.

---

## Notas

- Não inventar nota na loja, número de downloads ou depoimentos.
- Prints com banner DEBUG: aceitável em teste interno; para produção, capturar build release sem debug.
- Preço Pro: [CONFIRMAR] conforme configuração Stripe atual.
