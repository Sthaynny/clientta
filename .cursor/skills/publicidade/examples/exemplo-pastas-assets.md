# Exemplo — pastas e nomenclatura (genérico)

O usuário define onde salvar. Se não disser, **sugerir** uma estrutura e pedir confirmação — **nunca** assumir path do repositório atual.

## Sugestão de árvore (app mobile)

```
{pasta_raiz_escolhida_pelo_usuario}/
├── source/
│   └── app-screenshots/          ← prints reais (fonte; só leitura)
│       ├── 01_home.png
│       ├── 02_core_flow.png
│       ├── 03_feature_detail.png
│       ├── 04_settings_or_trust.png
│       └── 05_landing_or_cta.png
├── brand/
│   ├── logo.png
│   └── app_icon_source.png
└── store-assets/
    ├── icon/
    │   └── icon_512.png
    ├── feature_graphic/
    │   └── feature_graphic_1024x500.png
    ├── screenshots/
    │   ├── phone/
    │   │   ├── 01_gancho.png
    │   │   └── …
    │   ├── tablet_7/
    │   ├── tablet_10/
    │   └── ios/                  ← se App Store
    └── social/
        ├── instagram/
        └── paid/
```

## Nomenclatura estável

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| Ícone Play | `icon_512.png` | — |
| Feature | `feature_graphic_1024x500.png` | — |
| Phone promo | `NN_papel_curto.png` | `01_gancho.png`, `03_diferencial.png` |
| Print fonte | kebab ou `NN_tema` | `02_core_flow.png` |

## Perguntas ao usuário

1. Path da pasta com **prints reais**?  
2. Path da pasta de **saída** dos assets gerados?  
3. Há **logo/ícone** em arquivo? Qual path?
