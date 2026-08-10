# Clientta — assets de loja e publicação

Materiais para Google Play, LinkedIn e Instagram.

## Estrutura

```
docs/stores/
├── prints/                    # Screenshots brutos do app (UI real)
├── store-assets/
│   ├── icon/icon_512.png
│   ├── feature_graphic/feature_graphic_1024x500.png
│   ├── screenshots/phone/     # Artes promocionais 1080×1920
│   └── banners/instagram/     # Peças para perfil pessoal
├── publicacao-play-store.md   # Copy + checklist Play Console
├── publicacao-linkedin.md     # Estrutura post de aprendizado
└── publicacao-instagram.md    # Carrossel + caption pessoal
```

## Regenerar artes

```bash
cd tool
python compose_feature_graphic.py
python compose_store_screenshots.py
python compose_instagram_capa.py
python compose_instagram_cta.py
```

Módulo compartilhado: `tool/store_compose_common.py` (recorte da status bar, moldura com notch, máscara arredondada e sombra).

## Guias

| Documento | Uso |
|-----------|-----|
| [publicacao-play-store.md](publicacao-play-store.md) | Ficha completa da Play Store |
| [publicacao-linkedin.md](publicacao-linkedin.md) | Post de portfólio / aprendizado |
| [publicacao-instagram.md](publicacao-instagram.md) | Carrossel para perfil pessoal |
