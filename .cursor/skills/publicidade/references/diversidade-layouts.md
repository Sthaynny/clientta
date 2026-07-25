# Diversidade de layouts — evitar “sempre a mesma peça”

O carrossel da loja precisa **coerência de marca** (tipografia, paleta, moldura de device), mas **não** o mesmo enquadramento em todos os cards. Variar **arquétipo de layout**, **ângulo do device**, **fundo** e **camada de apoio** — mantendo uma ideia + um CTA por arte.

Índice: [Regra de ouro](#regra-de-ouro) · [Arquétipos phone 9:16](#arquétipos-phone-916) · [Feature graphic](#feature-graphic-1024500) · [Ícone](#ícone-512) · [Instagram](#instagram) · [Rotação obrigatória](#rotação-obrigatória-no-carrossel) · [O que não variar](#o-que-não-variar)

## Regra de ouro

| Coerente em todo o pacote | Diferente a cada card |
|---------------------------|------------------------|
| Família tipográfica e peso da headline | Posição do texto (topo / lateral / faixa) |
| Paleta primária + neutros da marca | Arquétipo de layout (ver tabela) |
| Estilo da moldura do telefone (fina vs. sem moldura) | Escala do mockup (hero grande vs. recorte parcial) |
| Nível de realismo (print real vs. conceitual) | Fundo (sólido / gradiente marca / textura leve / split) |
| Tom de copy humanizado | 1 linha de apoio opcional (só em 1–2 cards) |

**Proibido:** cinco cards idênticos só trocando o print dentro do mesmo retângulo central.

## Arquétipos phone 9:16

Escolher **um arquétipo por screenshot**; não repetir o mesmo em cards consecutivos.

| ID | Nome | Composição | Melhor para |
|----|------|------------|-------------|
| A | **Play clássico** | Headline ~30% topo + phone ~70% base | Gancho, home |
| B | **Split diagonal** | Metade superior headline em bloco marca; phone entra pela diagonal inferior | Energia, produtividade |
| C | **Phone hero** | Device ocupa ~85%; headline em faixa inferior semitransparente | UI densa (agenda, dashboard) |
| D | **Lateral** | Headline alinhada à esquerda ~35% altura; phone à direita, leve perspectiva 8–12° | Fluxo, “faça X em um toque” |
| E | **Recorte UI** | Sem moldura: zoom no canto superior do print (lista/cards) + headline no topo | Detalhe de feature |
| F | **Contexto sutil** | Phone central + ambiente desfocado coerente (mesa, balcão, mão genérica sem rosto) | Lifestyle leve, B2C |
| G | **Dupla profundidade** | Phone principal + segundo device menor ao fundo (opacidade 40%) mostrando outra tela | Modo claro/escuro ou tablet+phone |
| H | **Faixa + selo** | Headline topo + phone centro + **uma** pílula de apoio (ex. “Grátis para começar”) — não badges flutuantes | CTA final do carrossel |

ASCII — rotação sugerida em pacote de 5:

```
01 → A (gancho)     02 → D (fluxo)     03 → E (detalhe)
04 → C ou G (confiança)     05 → H ou B (CTA)
```

## Feature graphic 1024×500

Alternar entre três composições (uma por campanha ou A/B):

| Variante | Elementos |
|----------|-----------|
| **Marca + mockup** | Logo/wordmark à esquerda; phone/tablet parcial à direita; fundo gradiente suave da marca |
| **Tipográfica** | Uma frase grande (≤6 palavras); mockup pequeno ou ícone; muito espaço negativo |
| **UI panorama** | Recorte horizontal de 2–3 telas alinhadas (mesma altura), sem headline longa |

Safe zone: não colocar texto crítico nos 5% das bordas.

## Ícone 512

Variar **silhueta**, não só cor:

- Símbolo único central (alto contraste)
- Monograma da marca em círculo/quadrado arredondado
- Ícone composto (2 formas simples) — evitar detalhe que some em 48 px

Gerar **duas** direções se o usuário pedir escolha; não repetir o mesmo “quadrado com gradiente” de campanha em campanha.

## Instagram

| Formato | Diversificar assim |
|---------|-------------------|
| 1:1 | Alternar A / D / tipográfica pura (sem phone no card 2 do carrossel IG) |
| 9:16 stories | Phone maior, headline mínima; ou fundo foto-textura + sticker de UI |
| Carrossel | Card 1 gancho visual forte; cards 2–3 benefício com layouts B e E; último CTA H |

## Rotação obrigatória no carrossel

Antes de gerar phone 01…N, preencher tabela interna (entregar no brief visual se o usuário quiser):

| # | Print / tema | Arquétipo | Fundo | Detalhe extra na UI (ver [riqueza-mockup-ui.md](riqueza-mockup-ui.md)) |
|---|--------------|-----------|-------|------------------------------------------------------------------------|
| 01 | … | A | gradiente marca | dados realistas no print |
| 02 | … | D | sólido claro | destaque em 1 card da lista |
| … | … | … | … | … |

**Regra:** arquétipos **A** no máximo **2×** por carrossel de 5; **E** ou **G** pelo menos **1×** se houver 4+ cards.

## O que não variar

- Inventar paleta diferente da identidade do brief
- Misturar moldura grossa em um card e sem moldura em outro sem intenção (escolher um estilo de device e manter)
- Colar stickers, estrelas ou “#1” não fornecidos pelo usuário
- Trocar idioma ou tom entre cards do mesmo listing

Ver também: [banners-loja.md — Layouts alternativos](banners-loja.md#layouts-alternativos) · [prompt-geracao-imagem.md](prompt-geracao-imagem.md)
