# Assets de publicação — Google Play e App Store

Pacote completo que a skill **deve produzir** (texto + imagens) quando o pedido for
publicação / listing / “imagens da loja”. Válido para **qualquer app mobile**.

Índice: [Play — checklist](#google-play--checklist) · [Specs Play](#specs-google-play) ·
[App Store](#app-store) · [Ordem de produção](#ordem-de-produção) · [Destino](#destino-dos-arquivos) ·
[Copy](#copy-da-ficha)

## Google Play — checklist

Produzir e entregar:

| # | Asset | Obrigatório | Tipo |
|---|--------|-------------|------|
| 1 | Nome do app | Sim | Texto |
| 2 | Breve descrição | Sim (≤ 80 caracteres) | Texto |
| 3 | Descrição completa | Sim (≤ 4000 caracteres) | Texto |
| 4 | Ícone do aplicativo | Sim | Imagem **512 × 512** |
| 5 | Recurso gráfico (feature graphic) | Sim | Imagem **1024 × 500** |
| 6 | Capturas de tela do telefone | Sim (2–8; **≥ 4** p/ promoção) | Imagens |
| 7 | Capturas tablet 7" | **Sim** (2–8; **≥ 4** recomendado) | Imagens |
| 8 | Capturas tablet 10" | **Sim** (2–8; **≥ 4** recomendado) | Imagens |
| 9 | Vídeo | Opcional | URL YouTube (+ roteiro se pedido) |

**Por que tablet é obrigatório na Play:** o Console pede assets separados para **telefone**, **tablet 7"** e **tablet 10"** na presença na loja. Publicar só phone deixa a ficha incompleta e prejudica destaque em tablets. O **pacote completo** da skill inclui os três conjuntos com as mesmas headlines (temas 01–04).

Idioma padrão da ficha: o do brief (ex.: pt-BR). Traduções: só se o usuário pedir.

## Specs Google Play

### Ícone

| Item | Valor |
|------|-------|
| Tamanho | **512 × 512 px** |
| Formato | PNG ou JPEG |
| Tamanho arquivo | até 1 MB |
| `aspect_ratio` | `1:1` |
| Conteúdo | Marca reconhecível em miniatura; sem texto longo; sem moldura de status bar |

Heurística: silhueta simples, alto contraste, funciona em fundo claro e escuro da loja.

### Feature graphic (recurso gráfico)

| Item | Valor |
|------|-------|
| Tamanho | **1024 × 500 px** |
| Formato | PNG ou JPEG |
| Tamanho arquivo | até 15 MB |
| `aspect_ratio` | `16:9` (brief: “1024×500 exato, banner horizontal”) |
| Conteúdo | Nome ou benefício curto + visual da marca / mockup leve |

Não colocar informação crítica nas bordas extremas (crop em alguns devices).

### Screenshots — telefone

| Item | Valor |
|------|-------|
| Quantidade | 2–8 (recomendar **4–5**; mínimo **4** para elegibilidade de promoção) |
| Formato | PNG ou JPEG |
| Tamanho arquivo | até 8 MB cada |
| Proporção | **16:9** ou **9:16** |
| Lados | entre 320 px e 3840 px |
| Promoção Play | cada lado ≥ **1080 px** |
| `aspect_ratio` preferido | `9:16` (carrossel vertical moderno) |
| Tamanho sugerido | **1080 × 1920** (ou maior mantendo 9:16) |

Layout recomendado: [banners-loja.md](banners-loja.md) (headline + telefone com UI).

**Uma ideia por screenshot.** Sequência sugerida (adaptar ao produto):

| # | Papel | Conteúdo típico |
|---|--------|-----------------|
| 1 | Gancho | Benefício principal + Home / tela herói |
| 2 | Fluxo core | Ação que o usuário mais faz |
| 3 | Diferencial | O que separa o app (offline, a11y, velocidade…) |
| 4 | Confiança / resultado | Histórico, progresso, privacidade |
| 5 | CTA | “Comece grátis” / próximo passo (opcional) |

### Screenshots — tablet 7" e 10"

Mesmas regras de formato/proporção/tamanho de arquivo que telefone (até 8 por tipo).
**Obrigatório no pacote Google Play:** produzir **ambos** os tamanhos, com **mínimo 4** capturas cada (temas 01–04 alinhados ao carrossel phone).

| Peça | `aspect_ratio` | Tamanho final sugerido | Layout |
|------|----------------|------------------------|--------|
| Tablet 7" | `16:9` | **1920 × 1080** | Headline à esquerda (~30%) + mockup tablet landscape (~70%) |
| Tablet 10" | `16:9` | **2560 × 1440** | Mesma arte em resolução maior (ou gerar e redimensionar) |

Manter a mesma linguagem visual do phone (cores, tipografia, headlines humanizadas).
UI adaptada do **mesmo print** da pasta confirmada — não inventar outra tela.

**Gate obrigatório:** path da pasta de prints reais (ver SKILL §3). Sem path confirmado, não gerar phone/tablet promocionais.

Destino: pasta informada pelo usuário — modelo [../examples/exemplo-pastas-assets.md](../examples/exemplo-pastas-assets.md).

```
store-assets/screenshots/phone/
store-assets/screenshots/tablet_7/
store-assets/screenshots/tablet_10/
```

Prints reais (fonte): pasta confirmada pelo usuário (ex.: `source/app-screenshots/`).

### Vídeo

Campo de URL YouTube no Console. Se pedido: roteiro 15–30 s (gancho 3 s → demo UI → CTA).
Não gerar arquivo de vídeo nesta skill.

## App Store

Mesmos princípios de hierarquia e carrossel. Tamanhos oficiais mudam com o device;
usar o que o usuário indicar no App Store Connect. Defaults práticos se não especificar:

| Peça | Default prático | `aspect_ratio` |
|------|-----------------|----------------|
| iPhone screenshots | 1290 × 2796 (ou 9:16 próximo) | `9:16` |
| iPad | conforme Connect | `4:3` ou brief explícito |
| App icon | 1024 × 1024 | `1:1` |

Não inventar tamanhos “quase”; se o usuário colar specs do Connect, obedecer.

## Ordem de produção

1. **Perguntar o path da pasta de prints reais** (ou “sem prints” → conceitual).  
2. Coletar identidade (nome, cores, logo) se ainda faltar.  
3. Escrever copy da ficha (breve + completa) — [copy-humano.md](copy-humano.md) + benefício/ASO em [conceitos-marketing.md](conceitos-marketing.md).  
4. Definir 4–5 headlines do carrossel (humanizadas, cada uma com gancho/framework) + matriz arquétipo/fundo ([../examples/matriz-carrossel.md](../examples/matriz-carrossel.md)) + 1 linha para feature graphic.  
5. Aplicar [heuristicas-visuais.md](heuristicas-visuais.md) + [diversidade-layouts.md](diversidade-layouts.md) + [riqueza-mockup-ui.md](riqueza-mockup-ui.md).  
6. Gerar **ícone** → **feature graphic** → **phone 01…N** → **tablet_7 01…04** → **tablet_10 01…04** (GenerateImage no phone; tablets com UI fiel: [../scripts/compose_tablet_screenshots.py](../scripts/compose_tablet_screenshots.py) + JSON de cards).  
7. Redimensionar para specs; checklist + listar paths.

## Destino dos arquivos

1. Usar pasta que o usuário indicar.  
2. Se não houver: sugerir estrutura em [../examples/exemplo-pastas-assets.md](../examples/exemplo-pastas-assets.md) e pedir confirmação:

```
{raiz}/
├── source/app-screenshots/   ← prints reais (fonte)
└── store-assets/
    ├── icon/
    │   └── icon_512.png
    ├── feature_graphic/
    │   └── feature_graphic_1024x500.png
    ├── screenshots/
    │   ├── phone/
    │   ├── tablet_7/
    │   ├── tablet_10/
    │   └── ios/
    └── social/
        ├── instagram/
        └── paid/
```

3. Nomes estáveis: `icon_512.png`, `feature_graphic_1024x500.png`, `01_gancho.png`, etc.

## Copy da ficha

| Campo | Limite | Função |
|-------|--------|--------|
| Nome | conforme loja | Reconhecimento da marca |
| Breve descrição | 80 | Hook no resultado da busca — benefício, não jargão |
| Descrição completa | 4000 | O quê / para quem / como / diferenciais / CTA; sem claim ilegal |

Passar breve e completa por [copy-humano.md](copy-humano.md).  
Exemplos prontos: [../examples/CATALOGO.md](../examples/CATALOGO.md).
