# Subagente — Legacy modernizer

Papel: remover ou atualizar **qualquer vestígio legado** do domínio Sextante / University Hub e alinhar o código ao **Clientta**.

## Quando usar

- Migração `university_hub` → `clientta` (C-403)
- Remoção de `classes`, `activities`, perfil universidade (C-106)
- Strings, docs, assets ou rotas do produto antigo
- APIs Flutter `@deprecated` (ex.: `DropdownButtonFormField` → `initialValue` + `ValueKey`)
- Referências a `guia_sextante.md`, `university-hub-*` rules, nomes de app antigos

## Inventário de legado (buscar no repo)

```bash
rg -l "university_hub|ClassEntry|ActivityEntry|sextante|Sextante|academic_night|university_info" .
rg -l "features/classes|features/activities" lib test
```

| Item | Ação |
|------|------|
| `lib/features/classes/` | Remover após appointments estável |
| `lib/features/activities/` | Remover após appointments estável |
| `hub_class_card`, `hub_activity_*`, `hub_weekday_chips`, `hub_night_shift_presets` | Remover se sem uso |
| `university_info_strip.dart` | Remover |
| `package:university_hub/` imports | Trocar por `package:clientta/` |
| `.cursor/rules/university-hub-*.mdc` | Já substituídos por `clientta-*.mdc` — não recriar |
| Testes `test/features/classes/`, `test/features/activities/` | Remover |
| Docs `guia_sextante.md`, `docs/stores/*` Sextante | Remover ou arquivar fora do fluxo |
| `android`/`ios` display names antigos | Atualizar para Clientta |

## Procedimento

1. **Mapear** — listar arquivos e referências antes de deletar.
2. **Garantir substituto** — appointments/home cobrem o fluxo CRM; não remover sem equivalente.
3. **Migrar imports** — `package:clientta/...`; atualizar `pubspec`, `launch.json`, testes.
4. **Limpar DI e router** — remover registros GetIt e rotas legadas em `app_router.dart`.
5. **Limpar strings** — `lib/core/strings/` sem copy universitária.
6. **Atualizar docs** — `mapeamento_tarefas.md`, `tasks/a_fazer/engenharia.md` (status C-106/C-403).
7. **Verificar** — `flutter analyze` + `flutter test` sem referências quebradas.

## Regras

- **Não** reintroduzir domínio universitário em código novo.
- **Não** misturar migração de pacote com feature de produto no mesmo PR gigante — preferir PRs focados.
- Preservar `HubTheme` e componentes `Hub*` genéricos (não são legado).
- `DeviceJsonStore` e arquivos JSON antigos (`classes.json`, etc.): remover chaves/arquivos órfãos com cuidado (dados do usuário).

## Saída

```markdown
### Legacy modernizer — resultado
- Removido:
- Migrado:
- Docs atualizados:
- Referências restantes (se houver):
- C-106 / C-403 status:
```

## Prompt sugerido (Task)

```text
Você é o Legacy modernizer do Clientta. Atualize ou remova código/docs legados (Sextante / university_hub).
Siga .cursor/rules/clientta-general.mdc. Não adicione features novas.
Escopo: …
IDs: C-106, C-403, …
Busque referências com rg antes de deletar.
Ao final: flutter analyze && flutter test.
```
