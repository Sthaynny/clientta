# Formatos de peças

Índice: [Instagram](#instagram) · [Loja](#loja) · [Slides](#slides) · [Canvas](#canvas) ·
[Anúncio app](#anuncio-app) · [Play / App Store](#play--app-store)

- Pacote completo de publicação: [assets-loja.md](assets-loja.md)  
- Banners promo (telefone + headline): [banners-loja.md](banners-loja.md)  
- Heurísticas de beleza: [heuristicas-visuais.md](heuristicas-visuais.md)  
- Diversidade de layout: [diversidade-layouts.md](diversidade-layouts.md)  
- Marketing (funil, ganchos, ASO): [conceitos-marketing.md](conceitos-marketing.md)

## Instagram

| Formato | Proporção / tamanho | Texto na arte | Notas |
|--------|---------------------|---------------|-------|
| Feed quadrado | 1:1 (1080×1080) | Headline curta + CTA | Primeira linha conta no preview |
| Feed vertical | 4:5 (1080×1350) | Idem | Preferir no mobile |
| Stories / Reels cover | 9:16 (1080×1920) | Poucas palavras; safe zone | Evitar UI sob username/CTA nativo |
| Carrossel | 1:1 ou 4:5 por card | 1 ideia por card; CTA no último | Card 1 = gancho; fim = CTA |
| Reels (caption) | — | Hook na 1ª linha; CTA no fim | Caption ≠ texto da arte |

**Hierarquia:** headline → sub (opcional) → CTA.  
**Caption:** 1 hook + 1–3 frases + CTA + hashtags só se a marca usar (máx. ~5).

## Loja

| Peça | Uso | Texto |
|------|-----|-------|
| Cartaz A3 / A2 | Vitrine, parede | Headline grande; oferta; validade; CTA |
| Flyer A5 / A6 | Distribuição | Frente: oferta; verso: detalhes |
| Faixa / banner | Vitrine longa | Uma linha + preço; legível a 3–5 m |
| Etiqueta de preço | Produto | Preço antigo riscado + novo |
| Totem / display | Corredor | Benefício + seta/CTA |

**Regras:** contraste alto; um preço protagonista; letras miúdas só no rodapé.

## Slides

| Slide | Conteúdo |
|-------|----------|
| 1 — Capa | Nome da campanha + período |
| 2 — Objetivo e KPIs | Um objetivo + 2–3 métricas |
| 3 — Público | Segmentação em bullets curtos |
| 4–N — Peças | Headline + CTA + canal |
| Penúltimo — Calendário | Datas |
| Último — Próximos passos | Donos e prazos |

Por slide: 1 título + no máximo 2 frases ou 4 bullets.

## Canvas

1. Seções: Brief · Peças · Copy · Calendário · Métricas  
2. Layout rico (tabelas, cards de peça) em vez de markdown longo no chat  
3. Seguir skill de canvas do ambiente se `.canvas.tsx` for solicitado  
4. Cada card = headline + CTA + formato + status  

## Anuncio app

Paid social / UAC / Meta / Google:

| Elemento | Limite prático |
|----------|----------------|
| Headline primária | ~25–40 caracteres |
| Texto primário | 1–2 frases; benefício + prova leve (só se real) |
| CTA do botão | Opções nativas da plataforma |
| Criativo | Demo do app ou oferta — evitar stock genérico |

Entregar: 3 headlines + 2 textos + 1 CTA + brief do criativo.  
Arte estática → [banners-loja.md](banners-loja.md) + GenerateImage.

## Play / App Store

Quando o pedido for **publicação / listing / assets da loja**, produzir o pacote inteiro
em [assets-loja.md](assets-loja.md) — não só screenshots.

| Peça | Spec | Entrega |
|------|------|---------|
| Ícone | 512×512 (Play) | GenerateImage `1:1` |
| Feature graphic | 1024×500 | GenerateImage + brief exato |
| Screenshot promo | 9:16, headline + mockup | 4–5 artes; [banners-loja.md](banners-loja.md) |
| Tablet 7" + 10" | 1920×1080 e 2560×1440, ≥4 cada | **Obrigatório Play** — [exemplo-tablet-pairing.md](../examples/exemplo-tablet-pairing.md) |
| Nome / breve / completa | limites da loja | Texto humanizado |

**Sempre** perguntar por prints antes de gerar; sem prints → [../examples/exemplo-sem-prints-conceitual.md](../examples/exemplo-sem-prints-conceitual.md).  
Índice de exemplos: [../examples/CATALOGO.md](../examples/CATALOGO.md).
