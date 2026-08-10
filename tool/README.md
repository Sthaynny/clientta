# Tool — regeneração de assets

Os scripts de composição vivem na skill global **publicidade** (`my_utils` / `~/.agents/skills/publicidade/scripts/`).

Este projeto só mantém:

- `regenerate_store_assets.sh` — wrapper que chama a skill
- `docs/stores/store-manifest.yaml` — cores, headlines, prints e paths do Clientta

## Uso

```bash
bash tool/regenerate_store_assets.sh
```

Pré-requisito: `pip install -r ~/.agents/skills/publicidade/scripts/requirements.txt`

## Instalar skill globalmente

```bash
bash /caminho/para/my_utils/.agents/skills/publicidade/scripts/install-global.sh
```
