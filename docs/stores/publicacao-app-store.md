# Publicação — App Store (Clientta)

Pacote para o App Store Connect.  
**Fonte visual:** mesmos prints em `docs/stores/prints/` e assets em `docs/stores/store-assets/`.  
**Identidade:** verde `#1B6B5C` / `#0F4A3F` (DESIGN.md).

---

## Copy da ficha

Reutilizar a mesma copy da [publicacao-play-store.md](publicacao-play-store.md):

- **Nome:** Clientta
- **Subtítulo (≤30):** Agenda offline de atendimentos
- **Descrição promocional (≤170):** Veja quem vem hoje, organize a agenda e registre cada negociação — tudo no celular, mesmo sem internet.
- **Descrição completa:** ver arquivo Play Store (adaptar se necessário)

### Palavras-chave (≤100, separadas por vírgula)

```
agenda,atendimento,clientes,CRM,offline,corretor,vendedor,seguros,crédito
```

---

## Assets obrigatórios

```
docs/stores/store-assets/
├── icon/icon_1024.png                    # 1024×1024 — App Store Connect
└── screenshots/app_store/
    ├── iphone/iphone_01…05               # 1290×2796 (6.7" iPhone)
    └── ipad/ipad_01…04                   # 2048×2732 (12.9" iPad Pro)
```

| Arquivo | Spec | Uso no Connect |
|---------|------|----------------|
| `icon_1024.png` | **1024×1024** PNG | App Icon |
| `iphone_01…05` | **1290×2796** | Screenshots iPhone 6.7" |
| `ipad_01…04` | **2048×2732** | Screenshots iPad 12.9" |

Regenerar (skill publicidade):

```bash
bash ~/.agents/skills/publicidade/scripts/compose-store-assets.sh . docs/stores/store-manifest.yaml
```

---

## Checklist App Store Connect

### Conta e app
- [ ] Apple Developer Program ativo
- [ ] App criado no App Store Connect com bundle ID do projeto
- [ ] Política de privacidade: `https://sthaynny.github.io/pages-public/clientta/privacidade/`
- [ ] URL de exclusão de conta: `https://sthaynny.github.io/pages-public/clientta/exclusao-de-conta/`

### Ficha da loja (pt-BR)
- [ ] Nome: Clientta
- [ ] Subtítulo (≤30 caracteres)
- [ ] Descrição promocional (≤170)
- [ ] Descrição completa
- [ ] Ícone **1024×1024** (`icon_1024.png`)
- [ ] Screenshots iPhone 6.7" — mínimo 3, usar `iphone_01` a `iphone_05`
- [ ] Screenshots iPad 12.9" — mínimo 3 se suportar iPad (`ipad_01` a `ipad_04`)
- [ ] Categoria primária: Produtividade
- [ ] Classificação etária preenchida

### Técnico
- [ ] IPA / build via Xcode ou CI
- [ ] `GoogleService-Info.plist` / Firebase configurado
- [ ] Assinatura Pro: produto Stripe + restore purchases (se aplicável)

### Assinaturas (se Pro no lançamento)
- [ ] Produto de assinatura no App Store Connect
- [ ] Preço alinhado ao Stripe
- [ ] Política de assinatura: `https://sthaynny.github.io/pages-public/clientta/assinatura/`

---

## Notas

- Ícone Play (512×512) e App Store (1024×1024) são gerados por `resize_store_icons.py` na skill publicidade.
- Screenshots iPhone são upscale dos promocionais phone; para máxima nitidez, capturar no simulador 6.7" e substituir em `prints/`.
- iPad: assets derivados do tablet 10"; preferir capturas reais em iPad se o app for otimizado para telas grandes.
