# Exemplo — tablet pareado com phone

**Obrigatório no pacote Google Play:** tablet 7" e 10", mínimo 4 capturas cada.

Quando produzir o pacote Play completo:

## Regras

- Mesmos **temas** dos cards phone 01–04 (papel marketing igual)  
- Layout fixo: headline ~30% esquerda, tablet landscape ~70% direita  
- Fundo: espelhar o card phone correspondente  
- UI: adaptar o **mesmo print** ao landscape — não inventar outra feature  

## Tabela de pareamento

| Phone | Tablet 7" / 10" | Print fonte | Headline (mesma do phone) |
|-------|-----------------|-------------|---------------------------|
| 01 | 01 | `01_home.png` | (igual matriz) |
| 02 | 02 | `02_core_flow.png` | … |
| 03 | 03 | `03_feature_detail.png` | … |
| 04 | 04 | `04_settings_or_trust.png` | … |

## Specs

| Device | Tamanho sugerido | aspect_ratio |
|--------|------------------|--------------|
| 7" | 1920 × 1080 | 16:9 |
| 10" | 2560 × 1440 | 16:9 |

## Prompt (trecho)

```
Tablet landscape mockup right 70%, headline panel left 30%, same headline text as phone card 02,
brand colors consistent with phone series, UI faithful to reference screenshot adapted to wide layout.
```

Destino: subpastas `tablet_7/` e `tablet_10/` sob a pasta de saída confirmada — [exemplo-pastas-assets.md](exemplo-pastas-assets.md).
