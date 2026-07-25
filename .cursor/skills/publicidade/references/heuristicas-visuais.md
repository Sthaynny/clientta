# Heurísticas visuais — artes de loja e campanha

Princípios de design e beleza para **chamar atenção** sem parecer stock de IA.
Aplicar em toda imagem gerada pela skill (ícone, feature graphic, screenshots, IG, cartaz).

Índice: [Atenção em 2 s](#atenção-em-2-s) · [Hierarquia](#hierarquia) · [Beleza](#beleza-e-direção-visual) ·
[Diversidade](#diversidade-sem-perder-coerência) · [Carrossel](#consistência-do-carrossel) · [Anti-padrões](#anti-padrões) · [Checklist](#checklist-por-arte)

## Atenção em 2 s

O preview na loja é pequeno. A arte deve responder, nesta ordem:

1. **O que é** (marca ou categoria reconhecível)  
2. **Por que instalar** (benefício em uma frase)  
3. **Como parece** (UI / produto real como âncora)

Se remover o texto e ainda der para adivinhar a categoria do app, a âncora visual está boa.

## Hierarquia

| Nível | Elemento | Regra |
|-------|----------|-------|
| 1 | Headline | Maior contraste; ≤ ~40 caracteres; 1–2 linhas |
| 2 | Mockup / produto | Dominante em área (~60–75% em screenshot 9:16) |
| 3 | Apoio / CTA | Só se couber sem competir com 1 e 2 |

- **Um CTA** (ou nenhum) por arte — nunca botão falso + texto “Baixe já” + seta  
- Máximo **3 tamanhos de texto** na peça  
- Espaço negativo intencional — não preencher “buracos” com ícones decorativos  
- Agrupar por proximidade: headline com sublinha; UI isolada do texto

## Beleza e direção visual

Escolher **uma** direção clara alinhada à marca do brief (não inventar identidade nova):

| Direção | Quando | Evitar |
|---------|--------|--------|
| Calma / confiança | Saúde, finanças, cuidado | Neon, urgency falsa |
| Energia / clareza | Produtividade, fitness | Collage caótica |
| Premium / quieto | Assinatura, B2B | Gradiente roxo genérico |

Regras:

- **Cores da marca** do brief (hex / logo) — não default “IA roxo”  
- Fundo com atmosfera leve (gradiente suave da marca, textura discreta) **só se** a UI continuar legível  
- Tipografia expressiva porém **legível** em miniatura; sem script decorativo em headline de loja  
- Mockup de telefone limpo (moldura fina, sombra suave); UI nítida, sem blur de “lifestyle”  
- Contraste texto/fundo ≥ leitura confortável (equivalente AA no bloco da headline)

## Diversidade sem perder coerência

Mesmice = mesmo enquadramento + mesmo fundo + UI vazia em todos os cards. Corrigir com:

| Manter igual | Variar de propósito |
|--------------|---------------------|
| Tipografia e peso da headline | Arquétipo A–H ([diversidade-layouts.md](diversidade-layouts.md)) |
| Moldura do device (um estilo) | Fundo: sólido / gradiente / split (máx. 2 gradientes iguais no carrossel) |
| Paleta da marca | Escala do phone (hero vs. recorte E) |
| Prints reais quando existem | Camada de riqueza na UI ([riqueza-mockup-ui.md](riqueza-mockup-ui.md)) |

Antes do carrossel: preencher [matriz-carrossel.md](../examples/matriz-carrossel.md).  
Prompt: [prompt-geracao-imagem.md](prompt-geracao-imagem.md).

## Consistência do carrossel

Todos os cards do mesmo listing devem compartilhar:

- Mesma família tipográfica e peso de headline  
- Mesma moldura de device  
- Mesma paleta e margem superior da área de texto  
- Mesmo “nível” de realismo (prints reais **ou** todos conceituais — não misturar sem avisar)

Varia o **conteúdo da UI**, a **headline** e o **arquétipo de layout** — não só o print dentro do mesmo template.

## Anti-padrões

| Evitar | Preferir |
|--------|----------|
| Gradiente abstrato como ideia principal | UI / produto como âncora |
| Pills, badges e stickers flutuando sobre o telefone | Headline em bloco sólido limpo |
| Três adjetivos vazios na arte | Um benefício concreto |
| Prova social inventada (estrelas, “nº 1”) | Nada — ou só se o usuário fornecer |
| Texto ilegível no preview | Fonte grande, pouco copy |
| 8 screenshots com a mesma tela | 4–5 ideias distintas |
| 5 cards com layout idêntico (só troca print) | Rotação de arquétipos ([diversidade-layouts.md](diversidade-layouts.md)) |
| UI com retângulos cinza / sem dados | Horários, valores, status plausíveis ([riqueza-mockup-ui.md](riqueza-mockup-ui.md)) |
| Glow, neon, emoji decorativo | Contraste e hierarquia |
| Claim médico / legal arriscado | Organização, lembrete, produtividade |

## Checklist por arte

Antes de chamar GenerateImage (e após revisar o resultado):

- [ ] Arquétipo deste card ≠ card anterior (ou justificar repetição)?  
- [ ] Uma ideia só?  
- [ ] UI com pelo menos um detalhe de domínio legível?  
- [ ] Headline legível a 2 s no celular?  
- [ ] Âncora = produto/UI (não só fundo)?  
- [ ] Cores da marca do brief?  
- [ ] Contraste do texto OK?  
- [ ] Safe zone / sem crop crítico nas bordas?  
- [ ] Sem clutter (pills, badges, collage)?  
- [ ] Spec de tamanho/proporção correta ([assets-loja.md](assets-loja.md))?  
- [ ] Conceitual marcado se não usou print real?

Incluir na `description` do GenerateImage: ver blocos completos em [prompt-geracao-imagem.md](prompt-geracao-imagem.md) (layout, hierarquia, paleta, texto exato, luz, detalhes UI, “clean store listing style, no floating badges, high contrast headline”).
