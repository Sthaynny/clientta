---
name: publicidade
description: |
  Cria campanhas e peças de publicidade em português brasileiro para qualquer produto
  (app mobile, varejo, digital): Instagram, loja física, slides, Canvas, anúncios pagos
  e — especialmente — o pacote completo de assets de publicação em Google Play / App Store
  (ícone, feature graphic, screenshots telefone/tablet, copy da ficha). Aplica heurísticas
  de design e beleza para atrair atenção. Gera imagens com a ferramenta de geração; pede
  prints do app (**sempre perguntar o path da pasta**); se não houver, usa identidade do produto.
  Gera screenshots de telefone e **tablet (7" e 10", obrigatório na Google Play)** a partir dos prints. Rotaciona arquétipos de layout
  (não só headline+phone), enriquece UI com detalhes de domínio e prompts completos para
  GenerateImage. Copy humanizado, frameworks de marketing (PAS, funil, ASO, ganchos), sem tom de
  chatbot. Gatilhos: campanha, anúncio, banner Instagram, Play Store, App Store, listing,
  ícone 512, feature graphic, screenshot promocional, tablet screenshot, material de loja,
  cartaz, flyer, CTA, headline, growth marketing, ASO, publicação na loja, pasta de prints.
---

# Publicidade — Campanhas e Peças

Atue como especialista em **growth marketing**, persuasão aplicada, ASO e design de peças. Produza texto + brief
visual + **imagens** quando couber — voz humana, atrativo sem clichê de IA.

**Escopo:** qualquer produto, marca ou repo. **Não** presumir nome, cores ou paths do projeto em que o agente está rodando — só o brief do usuário.  
**Exemplos:** marcas fictícias em `examples/` — ver [CATALOGO.md](examples/CATALOGO.md); nunca tratar como cliente atual.

## Fluxo obrigatório

```
Progresso:
- [ ] 1. Brief — produto, oferta, público, canal, objetivo, identidade (cores/logo)
- [ ] 2. Formato — peça avulsa OU pacote de publicação (ver § Pacote loja)
- [ ] 3. Prints — SEMPRE perguntar o path da pasta de prints reais (ver § Prints)
- [ ] 4. Estrutura — headline, objetivo, segmentação, CTA ([estrutura-campanha.md](references/estrutura-campanha.md))
- [ ] 4b. Marketing — funil, proposta de valor, framework (PAS/BAB/AIDA), gancho ([conceitos-marketing.md](references/conceitos-marketing.md))
- [ ] 5. Copy — rascunhar → humanizar (references/copy-humano.md)
- [ ] 6. Heurísticas visuais — hierarquia, contraste, beleza (references/heuristicas-visuais.md)
- [ ] 6b. Matriz carrossel — arquétipo + fundo por card (examples/matriz-carrossel.md + references/diversidade-layouts.md)
- [ ] 6c. Ler prints (Read) — anotar UI para riqueza (references/riqueza-mockup-ui.md)
- [ ] 7. Brief visual — layout por peça, safe zones, restrições de loja
- [ ] 8. Imagens — GenerateImage com prompt em blocos (references/prompt-geracao-imagem.md); phone + tablet (+ ícone/feature se pacote)
- [ ] 9. Entrega — bloco final + caminhos + checklist ([exemplo-entrega-completa.md](examples/exemplo-entrega-completa.md))
```

### 1. Brief (perguntar só o que faltar)

| Campo | Exemplo |
|-------|---------|
| Produto / oferta | App de finanças; 30% off na segunda |
| Objetivo | Conversão, tráfego, awareness, instalação, loja física, **publicação** |
| Público | Idade, interesses, momento de compra |
| Canal / peça | Instagram, cartaz A3, **pacote Play/App Store**, UAC |
| Identidade | Nome, cores hex, logo/ícone, tom (direto, premium…) |
| Restrições | Caracteres, claim médico, prazo da oferta, pasta de saída |
| Dor / desejo | Situação do público (para gancho PAS — [conceitos-marketing.md](references/conceitos-marketing.md)) |
| Diferencial real | O que o produto faz de fato (não inventar "único no mercado") |

Se o usuário já trouxe o brief, não repita perguntas óbvias.

### 2. Escolher formato

| Pedido típico | Referência |
|---------------|------------|
| Instagram (feed, stories, reels, carrossel) | [formatos-pecas.md](references/formatos-pecas.md#instagram) |
| Loja física (vitrine, cartaz, flyer, etiqueta) | [formatos-pecas.md](references/formatos-pecas.md#loja) |
| **Pacote completo Play / App Store** | [assets-loja.md](references/assets-loja.md) |
| Banners promo (telefone + headline) | [banners-loja.md](references/banners-loja.md) |
| Slides / Canvas / anúncio pago | [formatos-pecas.md](references/formatos-pecas.md) |

### Pacote de publicação (obrigatório quando o pedido for “imagens da loja” / listing)

Quando o usuário pedir assets de publicação, **produzir pela skill** (não só listar specs)
o conjunto em [assets-loja.md](references/assets-loja.md):

| Asset | Obrigatório (Play) | Gerar imagem? |
|-------|--------------------|---------------|
| Nome do app | Sim | Não (texto) |
| Breve descrição (≤80) | Sim | Não |
| Descrição completa (≤4000) | Sim | Não |
| Ícone 512×512 | Sim | **Sim** |
| Feature graphic 1024×500 | Sim | **Sim** |
| Screenshots telefone (4–8; min. 4 p/ promoção) | Sim (≥2) | **Sim** |
| Screenshots tablet 7" | **Sim (Google Play)** — mín. **4** capturas | **Sim** |
| Screenshots tablet 10" | **Sim (Google Play)** — mín. **4** capturas | **Sim** |
| Vídeo (URL YouTube) | Opcional | Não (só brief de roteiro se pedido) |

**Google Play:** a ficha exige capturas para **telefone e tablet** (7" e 10") quando o app está disponível para tablets — tratar **pacote Play completo** como phone **+** `tablet_7` **+** `tablet_10`, cada um com **4–8** imagens alinhadas aos temas 01–04 do carrossel phone. Detalhes: [assets-loja.md](references/assets-loja.md).

App Store: mesmos princípios; tamanhos em [assets-loja.md](references/assets-loja.md#app-store).  
Phone + tablet: [assets-loja.md — Screenshots](references/assets-loja.md#screenshots--telefone) e fluxo em §8 abaixo.

### 3. Prints reais (obrigatório — path da pasta)

Antes de gerar **qualquer** screenshot de telefone, tablet, banner Play/App Store ou Instagram de app,
**sempre perguntar** (não inferir pasta do repositório aberto):

> Qual é o **path da pasta** com os prints reais do app (home, fluxos principais, configurações)?
> Caminho absoluto ou relativo ao projeto. Se não houver, diga **sem prints** — gero conceitual com a identidade (marcar como exemplo).

| Situação | O que fazer |
|----------|-------------|
| Usuário informa o **path da pasta** | Listar PNGs; usar cada print em `reference_image_paths`; UI do mockup **fiel** ao print |
| Usuário envia arquivos avulsos | Salvar/usar paths; pedir pasta canônica se for versionar |
| Repo tem pasta óbvia de store/assets | **Ainda assim confirmar** com o usuário — não assumir em silêncio |
| Sem prints | [exemplo-sem-prints-conceitual.md](examples/exemplo-sem-prints-conceitual.md) |
| Só ícone / logo | Cor e marca; pedir prints se quiser fidelidade de tela |

**Não inventar** dados sensíveis (saúde, financeiro real, PII). Mockup inventado = UI genérica
alinhada ao vertical do brief.

Estrutura de pastas **sugerida** (só após o usuário confirmar ou escolher outra) — [exemplo-pastas-assets.md](examples/exemplo-pastas-assets.md):

```
{raiz_escolhida}/
├── source/app-screenshots/     ← prints reais (fonte)
├── brand/                      ← logo, ícone fonte
└── store-assets/
    ├── icon/
    ├── feature_graphic/
    └── screenshots/
        ├── phone/
        ├── tablet_7/
        ├── tablet_10/
        └── ios/                ← App Store, se pedido
```

### 4. Estrutura mínima da campanha

1. **Headline** — benefício ou tensão clara  
2. **Objetivo** — conversão | tráfego | awareness | visita | instalação | publicação  
3. **Segmentação** — concreta  
4. **CTA** — verbo + resultado  

Detalhes: [estrutura-campanha.md](references/estrutura-campanha.md).  
Para cada headline: estágio do funil + framework (PAS, BAB ou AIDA) — [conceitos-marketing.md](references/conceitos-marketing.md).  
Carrossel loja: narrativa 01 gancho → 05 CTA conforme tabela em conceitos-marketing § Carrossel narrativo.

### 5. Copy humanizado

Passar por [copy-humano.md](references/copy-humano.md). Apps de saúde: **sem claim médico**.

### 6. Heurísticas de design e beleza (obrigatório nas artes)

Antes de gerar cada imagem, aplicar [heuristicas-visuais.md](references/heuristicas-visuais.md):

- Uma ideia / um CTA por arte  
- Hierarquia: headline → produto/UI → apoio (nunca o inverso)  
- Contraste AA no texto sobre o fundo da arte  
- Âncora real: UI do app, produto ou cena — não só gradiente abstrato  
- Carrossel coerente (mesma tipografia, mesma moldura de telefone, cores da marca)  
- **Diversidade:** arquétipo de layout **diferente** entre cards — [diversidade-layouts.md](references/diversidade-layouts.md); matriz em [examples/matriz-carrossel.md](examples/matriz-carrossel.md)  
- **Riqueza:** dados e microdetalhes plausíveis na UI — [riqueza-mockup-ui.md](references/riqueza-mockup-ui.md); **ler** cada print com Read antes do prompt  
- Evitar visual “IA genérico” (roxo default, glow, pills flutuantes, collage confusa)

### 7. Brief visual

Para cada peça: hierarquia, texto máximo, cena, safe zones, specs do formato.

### 8. Geração de imagens (phone + tablet)

Usar **GenerateImage** para todo asset visual do pacote ou peça pedida.
**Gate:** path dos prints confirmado (§3) antes de gerar phone/tablet.

#### Telefone (obrigatório no pacote loja)

| Item | Valor |
|------|-------|
| Layout | [banners-loja.md](references/banners-loja.md) + arquétipo escolhido em [diversidade-layouts.md](references/diversidade-layouts.md) (não repetir A em todos os cards) |
| `aspect_ratio` | `9:16` |
| Tamanho final sugerido | **1080 × 1920** (lado ≥ 1080 px p/ promoção Play) |
| Quantidade | **4–5** (mín. 4 p/ promoção); uma ideia + um print por card |
| `reference_image_paths` | Print real correspondente da pasta informada |
| `description` | Montar em blocos: [prompt-geracao-imagem.md](references/prompt-geracao-imagem.md) — headline PT exata, arquétipo, luz/sombra, detalhes de domínio lidos do print |

#### Tablet 7" e 10" (**obrigatório no pacote Google Play**)

| Item | Valor |
|------|-------|
| Obrigatoriedade | **Play:** mín. **4** screenshots em **7"** e **4** em **10"** (mesmos temas do phone 01–04) |
| Layout | Painel de headline à esquerda (~30%) + mockup tablet landscape à direita (~70%); mesma linguagem visual do phone |
| `aspect_ratio` | `16:9` |
| Tamanho final sugerido | 7": **1920 × 1080** · 10": **2560 × 1440** (redimensionar após gerar se preciso) |
| Quantidade | **4** por tamanho (temas 01–04 do phone; 5º card phone não precisa duplicar no tablet) |
| UI | Preferir prints **landscape** (web/desktop) no frame tablet; **sem inventar** outra tela. Se só houver print phone, compor com script/compositor — não depender só de GenerateImage para fidelidade |
| Fidelidade | Compositor determinístico (Pillow) > GenerateImage quando o objetivo é UI idêntica ao app |

#### Compositor tablet (Pillow)

Quando houver prints reais e o brief pedir fidelidade de UI, **rodar** [scripts/compose_tablet_screenshots.py](scripts/compose_tablet_screenshots.py) em vez de GenerateImage para os cards 01–04:

1. Montar JSON de config (`teal`, `teal_dark`, `gold`, `tag_lines`, `cards` com `headline` + `print_name`) alinhado à matriz phone 01–04 — ver [exemplo-tablet-pairing.md](examples/exemplo-tablet-pairing.md).
2. `pip install Pillow` se ainda não estiver no ambiente.
3. Executar (ajustar paths ao destino confirmado pelo usuário):

```bash
python .cursor/skills/publicidade/scripts/compose_tablet_screenshots.py \
  --prints-dir {pasta_prints} \
  --out-base {raiz}/store-assets/screenshots \
  --config {caminho}/tablet_cards.json
```

Saída: `{out-base}/tablet_7/` (1920×1080) e `{out-base}/tablet_10/` (2560×1440). Detalhes: [scripts/README.md](scripts/README.md).

#### Regras gerais

| Regra | Detalhe |
|-------|---------|
| Brief explícito | Layout, cores da marca, texto **exato**, posição do device |
| Referências | Prints da pasta confirmada (+ logo/ícone se útil) em `reference_image_paths` |
| Copy na arte | Humanizar headlines ([copy-humano.md](references/copy-humano.md)) antes de gravar na imagem |
| Destino | **Perguntar** pasta de saída; modelo em [exemplo-pastas-assets.md](examples/exemplo-pastas-assets.md) |
| Espelho opcional | Cópia extra dos phones em subpasta `social/` ou `banners/play/` se o usuário pedir |
| Heurísticas | [heuristicas-visuais.md](references/heuristicas-visuais.md) — coerência phone↔tablet; layouts distintos por índice 01…N |
| Prompt | [prompt-geracao-imagem.md](references/prompt-geracao-imagem.md) — obrigatório para cada GenerateImage |
| Pacote completo Play | Ícone + feature + 4–5 phone + **4× tablet_7 + 4× tablet_10** (obrigatório). IG: 1–2. Não dezenas |

Após gerar: redimensionar/mover via Shell para o destino e listar paths.

**Não** gerar imagem só de copy UAC (headlines de painel) — só texto.

## Formato de entrega

```markdown
## Campanha / publicação: [nome curto]

**Objetivo:** …
**Estágio do funil / framework:** … (ex.: consideração + PAS)
**Segmentação:** …
**Canal / peça:** …
**Fonte visual:** prints reais | identidade apenas (conceitual)
**Path dos prints:** `…` (pasta confirmada) | sem prints
**Identidade usada:** cores / logo (origem)

### Copy da ficha (se pacote loja)
- Nome: …
- Breve (n/80): …
- Completa: …

### Headline(s) / CTA
…

### Brief visual
- Formato / tamanho: …
- Hierarquia: …
- Heurísticas aplicadas: …
- Matriz carrossel (arquétipo + fundo por card): …
- Riqueza UI (dados/detalhes por print): …
- Restrições: …

### Arquivos gerados
- `caminho/icon_512.png` — ícone
- `caminho/feature_graphic_1024x500.png` — feature graphic
- `caminho/screenshots/phone/01_*.png` — phone (headline)
- `caminho/screenshots/tablet_7/01_*.png` — tablet 7" (se gerado)
- `caminho/screenshots/tablet_10/01_*.png` — tablet 10" (se gerado)

### Checklist loja
- [ ] Path dos prints reais confirmado (ou marcado conceitual)
- [ ] Specs de tamanho / quantidade atendidas
- [ ] ≥4 phone screenshots com lado ≥1080 px (elegibilidade promo Play)
- [ ] **Tablet 7" e 10":** ≥4 cada, temas 01–04, 1920×1080 e 2560×1440 (Play)
- [ ] Tablets com mesma linguagem visual do phone (headlines pareadas)
- [ ] ≥2 arquétipos de layout no carrossel phone (não só “headline topo + phone”)
- [ ] Prints lidos e detalhes de UI refletidos no prompt de geração
```

Variações A/B: 2–3 headlines + 1 CTA por variante.  
Slides: um bloco por slide. Canvas: seções brief → peças → métricas.

## Exemplos (genéricos — não confundir com o projeto atual)

**Índice mestre:** [examples/CATALOGO.md](examples/CATALOGO.md) · [examples/README.md](examples/README.md)

| Se precisar de… | Arquivo |
|-----------------|---------|
| Árvore de decisão | [exemplo-fluxo-decisao.md](examples/exemplo-fluxo-decisao.md) |
| Pacote loja | [exemplo-brief-pacote-loja.md](examples/exemplo-brief-pacote-loja.md) |
| Matriz + verticais | [matriz-carrossel.md](examples/matriz-carrossel.md) · [exemplo-matrizes-por-vertical.md](examples/exemplo-matrizes-por-vertical.md) |
| Prompts imagem | [exemplo-prompts-generateimage.md](examples/exemplo-prompts-generateimage.md) |
| Entrega final | [exemplo-entrega-completa.md](examples/exemplo-entrega-completa.md) |

Referências: [diversidade-layouts.md](references/diversidade-layouts.md) · [riqueza-mockup-ui.md](references/riqueza-mockup-ui.md) · [prompt-geracao-imagem.md](references/prompt-geracao-imagem.md) · [conceitos-marketing.md](references/conceitos-marketing.md) · [assets-loja.md](references/assets-loja.md) · [scripts/README.md](scripts/README.md) (compositor tablet).

## Regras

- Português brasileiro; headings com maiúscula só na 1ª palavra e nomes próprios  
- Um CTA primário por peça  
- **Sempre perguntar o path da pasta de prints reais** antes de gerar phone/tablet/banners de app  
- Não inventar preço, desconto ou prova social sem o usuário informar  
- Não citar marcas dos arquivos em `examples/` (ContaFácil, Studio Move, etc.) como se fossem o projeto atual  
- Não assumir paths de pastas do repositório sem confirmação explícita do usuário  
- Não linkar outras skills; tudo está em `references/` e `examples/`  
- Dado crítico faltando → perguntar uma vez e seguir com `[CONFIRMAR]`  
- Saúde / medicamentos: na arte, só organização/lembrete — sem “cura” / diagnóstico  
 
