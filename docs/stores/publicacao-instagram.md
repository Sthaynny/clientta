# Publicação — Instagram pessoal

Peça para perfil pessoal (não marca): bastidores do projeto, tom de dev compartilhando aprendizado.

**Fonte visual:** prints reais + artes em `docs/stores/store-assets/`.

---

## Objetivo

- Contar a história do Clientta de forma humana
- Mostrar progresso visual (antes/depois ou telas principais)
- Gerar conversa nos comentários, não só likes

**Segmentação:** amigos, colegas de tech, profissionais curiosos sobre apps.

---

## Formato recomendado

| Opção | Spec | Quando usar |
|-------|------|-------------|
| Carrossel 4:5 | 1080×1350 por card | **Recomendado** — conta história em 4–5 cards |
| Feed quadrado | 1080×1080 | Se o grid for mais quadrado |
| Stories | 9:16 | Bastidores rápidos no dia do lançamento |

---

## Carrossel pessoal (5 cards)

### Card 1 — Gancho

**Arte:** `docs/stores/store-assets/banners/instagram/ig_01_capa.png` (skill publicidade + `store-manifest.yaml`)  
**Texto na arte:** "Passei meses construindo isso no intervalo do trabalho"

**Ideia:** rosto não obrigatório; pode ser só o celular com a Home.

---

### Card 2 — O problema

**Arte:** print `08_home_seu_dia_vazio.png` com overlay de texto simples  
**Texto:** "Quem vende serviço no dia a dia perde o fio da meada entre ligação e ligação"

---

### Card 3 — A solução (UI)

**Arte:** `phone_02_agenda.png` ou `phone_03_clientes.png`  
**Texto:** "Agenda, clientes e histórico — no bolso"

---

### Card 4 — Diferencial

**Arte:** `phone_05_offline.png`  
**Texto:** "Funciona sem internet. Sério."

---

### Card 5 — CTA

**Arte:** ícone `icon_512.png` + fundo verde marca  
**Texto:** "Em breve na Play Store · segue para acompanhar"

---

## Caption (copiar e adaptar)

```
Meses atrás comecei um projeto pra resolver uma dor que vi de perto: quem atende cliente no dia a dia não tem um lugar só pra ver quem vem hoje e o que já foi combinado.

O Clientta é um app de agenda e CRM leve — feito em Flutter, funciona offline e sincroniza na nuvem no plano Pro.

O que tem hoje:
• painel do dia
• agenda com filtro por serviço
• lista de clientes com histórico
• registro de encontros e negociações

Ainda estou polindo detalhes pra publicar na Play Store. Esse carrossel é o estado atual — feedback visual é bem-vindo.

Se você trabalha com atendimento ou curte ver projeto de dev na prática, salva esse post.

#flutter #devbr #indiedev #mobileapp #crm
```

**Variação mais curta (stories/reels caption):**

```
App de agenda offline que estou terminando. Swipe pra ver as telas →
```

---

## Stories (sequência de 3)

| Story | Conteúdo | Sticker |
|-------|----------|---------|
| 1 | Print da Home com texto "quem atendo hoje?" | enquete: "você usa planilha ou app?" |
| 2 | `phone_04_atendimento.png` | "histórico por cliente" |
| 3 | ícone + "em breve na loja" | link [quando tiver URL] ou "me segue" |

**Safe zone:** evitar texto nos 15% superior e inferior (UI do Instagram).

---

## Brief visual (heurísticas aplicadas)

- Uma ideia por card
- Headline legível em 2 s no feed
- Cores da marca: `#1B6B5C`, `#0F4A3F`, fundo `#F4F6F8`
- UI real como âncora (prints do app)
- Sem prova social inventada (estrelas, "nº 1")
- Sem glow, pills flutuantes ou gradiente roxo genérico

---

## Arquivos

```
docs/stores/store-assets/banners/instagram/
├── ig_01_capa.png          # 4:5 — gancho pessoal
└── ig_05_cta.png           # 4:5 — CTA final (opcional; card 5 pode usar ícone)
```

Cards 2–4 podem reutilizar diretamente:
- `screenshots/phone/phone_02_agenda.png`
- `screenshots/phone/phone_05_offline.png`

---

## Checklist

- [ ] Carrossel 4:5 com 4–5 cards
- [ ] Caption com hook na primeira linha
- [ ] Hashtags ≤ 5
- [ ] Responder comentários nas primeiras 2 horas
- [ ] Não prometer data de lançamento sem confirmação
- [ ] Trocar prints DEBUG por release antes do post de lançamento oficial
