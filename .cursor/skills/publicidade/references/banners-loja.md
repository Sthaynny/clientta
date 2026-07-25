# Banners para lojas digitais (Play / App Store) e Instagram de app

Para o **pacote completo** de publicação (ícone, feature, phone, tablet, copy):
[assets-loja.md](assets-loja.md). Heurísticas de beleza: [heuristicas-visuais.md](heuristicas-visuais.md).

Índice: [Quando usar](#quando-usar) · [Prints](#prints) · [Layout Play-style](#layout-play-style) ·
[Layouts alternativos](#layouts-alternativos) · [Specs](#specs) · [Copy na arte](#copy-na-arte) · [Geração](#geração) · [Instagram](#instagram)

## Quando usar

| Canal | Peça | Objetivo |
|-------|------|----------|
| Google Play | Screenshots promocionais (telefone) | Instalação / compreensão em 2 s |
| Google Play | Feature graphic 1024×500 | Banner horizontal da ficha |
| App Store | Screenshots com frame + texto | Idem |
| Instagram | Feed / stories de lançamento | Tráfego para a loja |

Referência de qualidade: fichas grandes — **headline curta no topo + mockup de telefone com a UI**,
uma ideia por card do carrossel.

## Prints

1. **Sempre perguntar o path da pasta** dos prints reais antes de gerar phone/tablet/banners.  
   Texto sugerido: *“Qual é o path da pasta com os prints reais? Se não houver, diga ‘sem prints’.”*  
2. Com path → listar PNGs; cada arte usa o print correspondente em `reference_image_paths` (UI fiel).  
3. Sem prints → [../examples/exemplo-sem-prints-conceitual.md](../examples/exemplo-sem-prints-conceitual.md).  
4. Pasta visível no repo → **confirmar** com o usuário; não assumir em silêncio.

## Layout Play-style

```
┌─────────────────────────┐
│  ÁREA DE HEADLINE       │  ~25–35% superior
│  (fundo sólido marca)   │  1 linha curta OU 2 linhas máx.
│  texto alto contraste   │
├─────────────────────────┤
│                         │
│   [ mockup telefone ]   │  ~65–75% inferior
│   UI do app centralizada│  sem notch cobrindo texto
│                         │
└─────────────────────────┘
```

Regras:

- **Uma ideia por banner**
- Sem trinca forçada de três adjetivos
- Sem prova social inventada
- Sem claim médico (apps de saúde)
- Cores = identidade do **brief** (não inventar paleta de outro produto)

## Layouts alternativos

O Play-style (headline topo + phone) é o arquétipo **A** — usar no máximo **2** cards por carrossel de 5.

Catálogo completo (B split diagonal, C phone hero, D lateral, E recorte UI, F contexto, G dupla profundidade, H faixa+selo): [diversidade-layouts.md](diversidade-layouts.md).

Exemplos e matriz: [../examples/padroes-arte.md](../examples/padroes-arte.md) · [../examples/matriz-carrossel.md](../examples/matriz-carrossel.md).

## Specs

| Peça | Proporção / tamanho | `aspect_ratio` | Texto na arte |
|------|---------------------|----------------|---------------|
| Screenshot promo telefone | 9:16 (ex. 1080×1920) | `9:16` | Headline ≤ ~40 caracteres |
| Feature graphic Play | 1024×500 | `16:9` + brief “1024×500” | Nome + 1 benefício curto |
| Ícone | 512×512 | `1:1` | Sem texto longo |
| App Store phone | 9:16 (ou spec Connect) | `9:16` | Idem Play |
| Instagram feed | 1:1 ou 4:5 | `1:1` / `4:5` | Headline + CTA opcional |
| Instagram stories | 9:16 | `9:16` | Poucas palavras; safe zone |

Carrossel mínimo: **4 a 5** screenshots (Play recomenda ≥4 com lado ≥1080 px para promoção).

| # | Papel | Headline (exemplo genérico) |
|---|--------|----------------------------|
| 1 | Visão geral | O essencial do app em um lugar |
| 2 | Fluxo principal | Faça X sem complicação |
| 3 | Diferencial | O que só este app resolve |
| 4 | Confiança | Seus dados / seu ritmo |
| 5 | CTA | Comece grátis na loja |

Adaptar temas e headlines ao produto do brief.

## Copy na arte

- Legível a 2 segundos no preview da loja  
- Benefício concreto > slogan vazio  
- Passar por [copy-humano.md](copy-humano.md)  
- Legendas opcionais: 1 linha por screenshot para o Console  

## Geração

1. Copy (headline) + brief visual + matriz de arquétipos + checklist de [heuristicas-visuais.md](heuristicas-visuais.md).  
2. **Ler** prints usados; anotar detalhes em [riqueza-mockup-ui.md](riqueza-mockup-ui.md).  
3. **GenerateImage** com [prompt-geracao-imagem.md](prompt-geracao-imagem.md):
   - `description`: layout Play-style, cores do brief, texto exato, posição do telefone, “clean, high contrast, no floating badges”
   - `reference_image_paths`: prints e/ou ícone
   - `aspect_ratio` conforme tabela
   - `filename`: ex. `phone_01_home.png`
4. Mover para a pasta de destino do projeto ([assets-loja.md — Destino](assets-loja.md#destino-dos-arquivos)).  
5. Listar paths na resposta.

## Instagram

- Mesmo mockup + CTA “Baixar grátis” / “Na loja”  
- Stories: menos texto; safe zone superior/inferior  
- Carrossel: card 1 = gancho; meio = benefício; fim = CTA  

Caption: hook + 1–3 frases + CTA — [formatos-pecas.md](formatos-pecas.md#instagram).
