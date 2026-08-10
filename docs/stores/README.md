# Clientta — assets de loja e publicação

Materiais para Google Play, LinkedIn e Instagram.

## Estrutura

```
docs/stores/
├── prints/                    # Screenshots brutos do app (UI real)
├── store-assets/
│   ├── icon/
│   │   ├── icon_512.png       # Google Play (512×512)
│   │   └── icon_1024.png      # App Store (1024×1024)
│   ├── feature_graphic/feature_graphic_1024x500.png
│   ├── screenshots/
│   │   ├── phone/             # Promocionais 1080×1920
│   │   ├── tablet_7/          # 1920×1080 landscape
│   │   ├── tablet_10/         # 2560×1440 landscape
│   │   └── app_store/         # iPhone + iPad (App Store Connect)
│   └── banners/instagram/
├── store-manifest.yaml        # Config para skill publicidade (headlines, cores, prints)
├── publicacao-play-store.md
├── publicacao-app-store.md    # Copy + checklist App Store Connect
├── publicacao-linkedin.md
└── publicacao-instagram.md
```

## Regenerar artes

Configuração do projeto: `docs/stores/store-manifest.yaml`  
Scripts: skill global **publicidade** (`my_utils` → `~/.agents/skills/publicidade/scripts/`).

```bash
bash tool/regenerate_store_assets.sh
```

Instalar skill (uma vez): `bash my_utils/.agents/skills/publicidade/scripts/install-global.sh`

## Guias

| Documento | Uso |
|-----------|-----|
| [publicacao-play-store.md](publicacao-play-store.md) | Ficha completa da Play Store |
| [publicacao-app-store.md](publicacao-app-store.md) | Ficha completa da App Store |
| [publicacao-linkedin.md](publicacao-linkedin.md) | Post de portfólio / aprendizado |
| [publicacao-instagram.md](publicacao-instagram.md) | Carrossel para perfil pessoal |
