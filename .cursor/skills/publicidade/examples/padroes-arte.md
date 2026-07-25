# Padrões de arte — catálogo de referência

Complementa PNGs em `examples/` (se existirem). Menu de composição — adaptar marca e prints do **brief do usuário**, não de exemplos fictícios.

Índice: [Arquétipos](#catálogo-por-arquétipo-phone-916) · [Canais](#instagram-vs-loja) · [Brief por peça](#brief-mínimo-por-peça)

## Referências visuais opcionais

| Origem | Arquivo | Layout |
|--------|---------|--------|
| Skill | `banner_play_01_lembrete.png` | A — Play clássico 9:16 |
| Skill | `banner_ig_01_lancamento.png` | IG 1:1 gancho + device |

Não replicar o arquétipo A em todos os cards — [matriz-carrossel.md](matriz-carrossel.md).

## Catálogo por arquétipo (phone 9:16)

Ver também [diversidade-layouts.md](../references/diversidade-layouts.md) (A–H completos).

### A — Play clássico

```
┌──────────────────┐
│ HEADLINE (marca) │
├──────────────────┤
│    [ phone ]     │
└──────────────────┘
```

### D — Lateral com perspectiva

```
┌──────────────────┐
│ HEAD    │ phone  │
│ LINE    │   ╱    │
└──────────────────┘
```

### E — Recorte UI

Headline + zoom em lista/cards com um item em destaque.

### G — Dupla profundidade

Phone frontal + segundo device ao fundo (ex.: tema claro + escuro) usando **dois prints reais** se existirem (`01_home.png` + variante dark).

## Instagram vs loja

| Canal | Prioridade |
|-------|------------|
| Play 9:16 | Thumb legível; A ou C |
| IG 1:1 | Contraste; B ou tipográfica |
| Stories 9:16 | Safe zone 15% topo/base |

## Brief mínimo por peça (copiar e preencher)

```markdown
### Arte 01_gancho
- Arquétipo: D
- Print: `{path_confirmado}/02_core_flow.png`
- Headline: "…"
- Fundo: gradiente {primária} → {neutro}
- Detalhes UI: (após Read do print)
- reference_image_paths: [print, logo opcional]
```

Matriz: [exemplo-matriz-carrossel-preenchida.md](exemplo-matriz-carrossel-preenchida.md).
