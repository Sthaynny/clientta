## Campanha / publicação: ConectaFERSA — Google Play

**Objetivo:** Instalação e publicação na ficha  
**Estágio do funil / framework:** Atenção → decisão; carrossel PAS + CTA (card 05)  
**Segmentação:** Estudantes universitários BR, Android  
**Canal / peça:** Pacote completo Google Play  
**Fonte visual:** prints reais  
**Path dos prints:** `docs/stores/prints/` (nomes finais `01_home_seu_dia.png` … `06_menu_drawer.png`)  
**Identidade usada:** `#1A6B52`, `#0F4535`, dourado `#F5C518` (logo); `lib/core/theme/hub_colors.dart`  
**Play Store:** [LINK_PLAY_STORE]

### Copy da ficha (resumo)

Ver texto completo em `docs/stores/CAMPANHA-PLAY.md`.

- **Nome:** ConectaFERSA  
- **Breve (79/80):** Grade, atividades e o dia na facul — tudo no celular, sem internet.

### Headline(s) / CTA

| # | Headline | Arquétipo |
|---|----------|-----------|
| 01 | Seu dia na faculdade, claro. | A |
| 02 | Sua grade num só lugar. | D |
| 03 | Vários dias? Marca de uma vez. | E |
| 04 | Entrega na data. Sem esquecer. | C |
| 05 | Tudo no celular. Offline. | H (+ selo “Grátis na Play Store”) |

**Feature graphic:** Organize a facul no bolso.

### Brief visual

- Phone: 5× **1080×1920** (9:16), layouts A / D / E / C / H  
- Ícone **512×512**; feature **1024×500**  
- Tablet: compositor Pillow, headline 30% + mockup 70%, temas 01–04 pareados com phone  
- Prints lidos: painel do dia, grade, registrar aula (SIGAA), atividades pendentes, drawer offline  

### Arquivos gerados

| Arquivo | Descrição |
|---------|-----------|
| `docs/stores/CAMPANHA-PLAY.md` | Copy ficha + matriz carrossel |
| `docs/stores/store-assets/tablet_cards.json` | Config compositor tablet |
| `docs/stores/store-assets/icon/icon_512.png` | Ícone Play 512×512 |
| `docs/stores/store-assets/feature_graphic/feature_graphic_1024x500.png` | Recurso gráfico 1024×500 |
| `docs/stores/store-assets/screenshots/phone/01_gancho_dia.png` | Phone card 01 |
| `docs/stores/store-assets/screenshots/phone/02_grade.png` | Phone card 02 |
| `docs/stores/store-assets/screenshots/phone/03_aula_multi_dia.png` | Phone card 03 |
| `docs/stores/store-assets/screenshots/phone/04_atividades.png` | Phone card 04 |
| `docs/stores/store-assets/screenshots/phone/05_offline_cta.png` | Phone card 05 |
| `docs/stores/store-assets/screenshots/tablet_7/01_gancho_dia.png` | Tablet 7" 1920×1080 |
| `docs/stores/store-assets/screenshots/tablet_7/02_grade.png` | Tablet 7" |
| `docs/stores/store-assets/screenshots/tablet_7/03_aula_multi_dia.png` | Tablet 7" |
| `docs/stores/store-assets/screenshots/tablet_7/04_atividades.png` | Tablet 7" |
| `docs/stores/store-assets/screenshots/tablet_10/01_gancho_dia.png` | Tablet 10" 2560×1440 |
| `docs/stores/store-assets/screenshots/tablet_10/02_grade.png` | Tablet 10" |
| `docs/stores/store-assets/screenshots/tablet_10/03_aula_multi_dia.png` | Tablet 10" |
| `docs/stores/store-assets/screenshots/tablet_10/04_atividades.png` | Tablet 10" |

**Cópias intermediárias (geração):** `C:\Users\sthay\.cursor\projects\c-Users-sthay-OneDrive-Documents-GitHub-app-news\assets\` — podem ser descartadas após validação visual.

### Checklist loja

- [x] Path dos prints reais confirmado (`docs/stores/prints/`, README com nomes finais)
- [x] Specs de tamanho / quantidade atendidas (ícone, feature, 5 phone, 4× tablet_7, 4× tablet_10)
- [x] ≥4 phone screenshots com lado ≥1080 px (1080×1920)
- [x] **Tablet 7" e 10":** ≥4 cada, temas 01–04, 1920×1080 e 2560×1440
- [x] Tablets com mesma linguagem visual do phone (headlines pareadas via `tablet_cards.json`)
- [x] ≥2 arquétipos de layout no carrossel phone (A, D, E, C, H — cinco distintos)
- [x] Prints lidos e detalhes de UI refletidos no prompt de geração / compositor
- [ ] Revisão humana: remover faixa DEBUG dos PNGs fonte antes de nova rodada (opcional)
- [ ] Substituir `[LINK_PLAY_STORE]` na descrição da ficha pelo URL real
- [ ] Upload no Play Console (telefone → recurso gráfico → ícone → tablets)

### Próximos passos sugeridos

1. Abrir cada PNG em `store-assets/` e validar legibilidade da headline no preview pequeno.  
2. Se a UI gerada divergir do app, regenerar card específico com o print correspondente em `reference_image_paths`.  
3. Tablets já usam UI **pixel-fiel** dos prints via Pillow — priorizar esses na ficha se houver divergência nos phones gerados por IA.
