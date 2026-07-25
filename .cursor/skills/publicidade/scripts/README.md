# Scripts — skill publicidade

## `compose_tablet_screenshots.py`

Compositor determinístico (Pillow) para capturas **tablet 7"** e **10"** da Google Play:
headline ~30% à esquerda + mockup landscape ~70% à direita.

**Quando usar:** pacote loja com prints reais e fidelidade de UI (preferir isto a GenerateImage para tablet).

### Pré-requisito

```bash
pip install Pillow
```

### Uso genérico

```bash
python .cursor/skills/publicidade/scripts/compose_tablet_screenshots.py \
  --prints-dir /caminho/para/prints \
  --out-base /caminho/para/store-assets/screenshots \
  --config /caminho/para/tablet_cards.json
```

O JSON de config define cores (`teal`, `teal_dark`, `gold`), `tag_lines` opcionais e a lista `cards`
(`index`, `slug`, `headline`, `print_name`). Saída: `tablet_7/` (1920×1080) e `tablet_10/` (2560×1440).

### Lúmen (este repositório)

```bash
python docs/store/scripts/compose_tablet_screenshots.py
```

Wrapper com paths e `docs/store/scripts/lumen_tablet_cards.json` (projeto Lúmen).
