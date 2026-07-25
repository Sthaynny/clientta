# Exemplo — fluxo de decisão (qual caminho seguir)

```
Pedido do usuário
        │
        ├─ "listing" / "Play" / "App Store" / "screenshots da loja"
        │       → Pacote [assets-loja.md](../references/assets-loja.md)
        │       → Brief [exemplo-brief-pacote-loja.md](exemplo-brief-pacote-loja.md)
        │       → Perguntar path dos prints (nunca assumir pasta do repo)
        │
        ├─ "Instagram" / "stories" / "carrossel" / "post"
        │       → [formatos-pecas.md](../references/formatos-pecas.md#instagram)
        │       → [exemplo-brief-instagram.md](exemplo-brief-instagram.md)
        │
        ├─ "cartaz" / "flyer" / "vitrine" / "loja física"
        │       → [exemplo-brief-varejo-fisico.md](exemplo-brief-varejo-fisico.md)
        │
        ├─ "UAC" / "Meta Ads" / "Google Ads" / "anúncio pago"
        │       → Texto: [exemplo-brief-anuncio-pago.md](exemplo-brief-anuncio-pago.md)
        │       → Arte estática: GenerateImage + [exemplo-prompts-generateimage.md](exemplo-prompts-generateimage.md)
        │
        ├─ "slides" / "apresentação" / "kickoff"
        │       → [exemplo-slides-campanha.md](exemplo-slides-campanha.md)
        │
        └─ Só copy / só headline
                → [estrutura-campanha.md](../references/estrutura-campanha.md) + [copy-humano.md](../references/copy-humano.md)
                → Sem GenerateImage (salvo se pedir arte)
```

## Checklist mínimo antes de gerar imagem

1. Objetivo primário definido?  
2. Path da pasta de prints **confirmado** ou marcado `sem prints`?  
3. Matriz carrossel preenchida (se ≥2 screenshots)?  
4. Headlines humanizadas + framework anotado?  
5. Destino de saída perguntado ao usuário?
