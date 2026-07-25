# Prompt de geração — usar todos os recursos

Checklist para **GenerateImage** (e revisão pós-geração). Objetivo: máxima atratividade com **controle** — layout variado, UI rica, fidelidade aos prints.

## Pipeline

```
1. Path prints confirmado
2. Ler prints (Read) + logo/ícone se houver
3. Escolher arquétipo (diversidade-layouts.md) — tabela do carrossel
4. Montar description em blocos (abaixo)
5. reference_image_paths: [print principal, logo opcional, 2º print só em G]
6. aspect_ratio + filename
7. Pós: redimensionar para spec (Shell) → mover destino
```

## Estrutura da `description` (inglês técnico + texto PT exato)

O modelo entende bem instruções em inglês para composição; **headline na arte** em português **literal** entre aspas.

### Bloco 1 — Tipo e spec

```
Professional app store promotional graphic, [aspect_ratio], [exact pixels if needed].
Clean commercial quality, not stock photo collage.
```

### Bloco 2 — Layout (arquétipo)

Copiar estrutura do arquétipo escolhido em [diversidade-layouts.md](diversidade-layouts.md). Exemplo A:

```
Layout: top 30% solid brand color block with headline; bottom 70% centered smartphone mockup, slight perspective 5 degrees.
```

### Bloco 3 — Copy na arte (exato)

Headline já validada com [conceitos-marketing.md](conceitos-marketing.md) (gancho + benefício) e [copy-humano.md](copy-humano.md).

```
Headline text exactly: "Agenda e caixa. Sem planilha."
Typography: bold sans-serif, high contrast white on brand teal, max 2 lines.
```

### Bloco 4 — UI / print

**Com referência:**

```
Phone screen must match the reference screenshot faithfully: same navigation, cards, and colors.
Enhance: crisp pixels, realistic status bar, subtle screen glare.
Domain details: [list from riqueza-mockup-ui.md after reading print].
Do not invent new screens or fake medical claims.
```

**Conceitual:**

```
Invent plausible [vertical] app UI: [specific list items, KPIs, times].
Material-style or iOS-clean UI matching brand colors [#hex primary, #hex accent].
No gray placeholder rectangles; show readable Brazilian Portuguese micro-labels.
```

### Bloco 5 — Beleza e luz

```
Soft studio lighting from top-left, gentle device shadow on background.
Background: [solid / 2-stop gradient / split] using brand palette.
No floating badges, no star ratings, no purple AI gradient, no emoji decorations.
```

### Bloco 6 — Restrições loja

```
Google Play style screenshot, safe margins, no cropped text at edges.
Single primary message, no watermark.
```

## `reference_image_paths`

| Arte | Paths típicos |
|------|----------------|
| Phone 01 | `print_home.png` |
| Phone 02 | `print_flow.png` |
| Feature | `print_hero.png` + `icon_512.png` |
| Ícone | `logo.svg/png` ou brief de forma |

Ordem: print principal primeiro; logo segundo se couber no limite da ferramenta.

## Tabela rápida aspect_ratio

| Peça | aspect_ratio |
|------|----------------|
| Phone screenshot promo | `9:16` |
| Feature graphic | `16:9` (brief 1024×500) |
| Ícone Play | `1:1` |
| IG feed | `1:1` ou `4:5` |
| Tablet | `16:9` |

## Pós-geração

- Redimensionar para 1080×1920, 1024×500, 512×512 conforme [assets-loja.md](assets-loja.md)
- Se UI borrada: regenerar com “sharp UI pixels, no blur on screen content”
- Se layout repetido: trocar arquétipo antes de regenerar

## Recursos do agente (usar de propósito)

| Recurso | Uso |
|---------|-----|
| **Read** em prints | Extrair detalhes para bloco 4 |
| **GenerateImage** | Toda peça visual do pacote |
| **Shell** | Redimensionar/mover para pasta de saída confirmada |
| **Brief / guia de marca** | Cores, tom, proibições (ex.: saúde) fornecidos pelo usuário |
| **heuristicas-visuais.md** | Contraste, anti-padrões |
| **copy-humano.md** | Headline antes de bloco 3 |

Não entregar só texto quando o pedido incluir imagens — gerar, salvar paths, checklist.

Exemplos de prompt preenchidos: [../examples/exemplo-prompts-generateimage.md](../examples/exemplo-prompts-generateimage.md).
