# Design brief — Aula em vários dias da semana

**Status:** production-ready para implementação (`/impeccable craft` ou equivalente).  
**Escopo:** formulário de aula (criar/editar), persistência e listagem em Minha grade; home “Aulas de hoje” inalterada em comportamento (filtro por `weekday`).

---

## 1. Feature summary

Estudantes cadastram a mesma disciplina (nome, sala, horários) em **vários dias** num único fluxo, em vez de repetir o formulário. Dados continuam **offline**, **uma linha JSON por dia** para o filtro da home, ligadas por `seriesId` opcional. Registros antigos (sem `seriesId`) seguem editáveis como hoje.

**Sucesso:** criar “Cálculo — Seg/Qua/Sex, 08:00–10:00, sala X” em uma ida ao formulário; editar a série num lugar; a grade mostra a série de forma legível sem triplicar ruído visual.

---

## 2. Primary user action

**Selecionar os dias da semana e salvar** com disciplina e horário já preenchidos — sem reabrir o formulário por dia.

---

## 3. Design direction

| Aspecto | Decisão |
|--------|---------|
| Color strategy | **Restrained** (DESIGN.md): chips selecionados com fundo `surface`, borda/foco `seed`; horário em bloco `schedule` só na listagem. |
| Scene | Corredor entre aulas, celular numa mão — chips grandes o suficiente para toque (≥48dp hit), rótulos curtos. |
| Anchors | Google Calendar “event repeat” (chips de dias), Notion database multi-select, grade horária de faculdade em papel (mesma matéria, colunas de dias). |

**Controles:** `HubTextFormField`, `HubPrimaryButton`, `InputDecoration` do `HubTheme` no bloco de chips; **não** `DSTextFormField`. Espaçamento `DSSpacing.md` entre seções.

---

## 4. Scope

| | |
|--|--|
| Fidelity | Production-ready (comportamento e copy finais). |
| Breadth | Fluxo criar + editar (série e legado) + listagem Minha grade. |
| Interactivity | Chips toggle, modo de horário, save com diff; sem animações de lista. |
| Fora | Conflito de horários, sync, importação, notificações. |

---

## 5. Data model (implementação)

```text
ClassEntry:
  id, weekday (1–7), subject, startTime, endTime, room?, notes?
  seriesId?  // null = legado ou aula de um único dia sem série
```

| Regra | Detalhe |
|-------|---------|
| Série | Mesmo `seriesId` (UUID) em N linhas; `subject`, `room`, `notes` **iguais** em todas as linhas da série (fonte única no form). |
| Legado | `seriesId == null`; uma linha; UX atual preservada. |
| Home | `todayClasses = where(c.weekday == DateTime.now().weekday)` — sem mudança de contrato. |
| Repositório | Novos métodos sugeridos: `getBySeriesId`, `saveSeries` (upsert/delete em lote) ou orquestração no ViewModel com `save`/`delete` existentes. |

**Ao salvar série:** gerar `seriesId` novo no create; no edit, reutilizar o da série carregada.

---

## 6. Layout — formulário

Ordem vertical (`ListView`, padding `DSSpacing.md`):

1. **Disciplina** (obrigatório) — igual hoje.  
2. **Dias da semana** — seção com rótulo + chips em **wrap** (2 linhas típicas: Seg–Sex, depois Sáb/Dom).  
3. **Horário** — ver §7.  
4. **Sala**, **Observações** — iguais hoje.  
5. **Salvar** — `HubPrimaryButton`.

**App bar:** `addClassString` / `editClassString` (série usa os mesmos títulos; subtítulo opcional só se implementação quiser `editClassSeriesHint` — ver strings).

**Hierarquia:** disciplina e dias acima da dobra; horário em seguida; sala/notas secundários.

---

## 7. Horário — compartilhado vs por dia

**Padrão (recomendado):** toggle ou `HubSwitchFormField` — **“Mesmo horário em todos os dias”** = ligado.

| Modo | UI |
|------|-----|
| Mesmo horário | Uma linha Início \| Fim (como hoje); aplica a todos os dias selecionados. |
| Por dia | Lista compacta: para cada **dia selecionado**, linha com rótulo curto (`weekdayShortLabels`) + Início \| Fim. Dias desmarcados não aparecem na lista. |

**Ao alternar modo:** ligar “mesmo horário” copia o par início/fim do primeiro dia visível (ou do último editado) para todos os selecionados. Desligar mantém valores atuais por dia.

**Validação:** início/fim não vazios; opcional futuro: fim > início (fora do escopo se não existir hoje).

---

## 8. Chip UI — dias da semana

| Spec | Valor |
|------|--------|
| Labels | `weekdayShortLabels`: Seg, Ter, Qua, Qui, Sex, Sáb, Dom |
| Estado off | Borda `border`, texto `inkMuted`, fundo `canvas` ou `surface` |
| Estado on | Borda `seed` 1.5px, texto `ink`, fundo `surface`; opcional leve tint `seed` ~8% |
| Interação | Tap alterna seleção; mínimo **1 dia** selecionado (não permitir desmarcar o último) |
| A11y | `Semantics` com nome completo (`weekdayLabels[i]`) + “selecionado” |

Substitui o `DropdownButtonFormField` de dia único no fluxo principal; legado em edição de linha sem série pode mostrar **um chip selecionado** (mesmo componente, comportamento equivalente ao dropdown).

---

## 9. UX flows

### 9.1 Criar (nova série)

1. FAB → formulário vazio.  
2. Disciplina + **≥1 chip** + horário (modo padrão compartilhado) + sala/notas.  
3. Salvar → N entradas, mesmo `seriesId`, ids únicos por linha.  
4. Snack de sucesso opcional; `context.back(true)` como hoje.

**Default chips:** dia da semana atual pré-selecionado (paridade com `weekday = DateTime.now().weekday`).

### 9.2 Editar série

**Entrada:** usuário toca editar num card agrupado **ou** editar numa linha que tem `seriesId` (qualquer membro da série).

1. Carregar **todos** os `ClassEntry` com esse `seriesId`.  
2. Hidratar: chips = união dos `weekday`; subject/room/notes do primeiro (devem ser iguais); horários = compartilhado se todos iguais, senão modo “por dia” ligado com mapa por weekday.  
3. Salvar → **diff** (§10).  
4. Voltar e recarregar lista.

### 9.3 Editar legado (`seriesId == null`)

1. Um chip selecionado (dia atual da linha).  
2. Usuário pode **adicionar dias** antes de salvar → passa a série: atribuir **novo** `seriesId`, linha original atualizada + linhas novas para dias adicionados.  
3. Usuário pode **trocar** o único dia → update da mesma linha (ainda sem `seriesId`).  
4. Se após salvar restar **apenas um dia** com `seriesId` atribuído no meio de uma edição de série → ver edge case §11.

### 9.4 Excluir

| Contexto | Ação |
|----------|------|
| Card de série (listagem) | **Excluir** remove **toda a série** (confirmar com diálogo). |
| Edição / futuro menu | Opcional fase 2: “Remover só este dia” na série — se implementado na v1, atualizar diff ao salvar em vez de delete em massa no card. |

**v1 recomendada:** delete no card da série = apaga todas as linhas com o `seriesId`. Card legado = delete uma linha (hoje).

---

## 10. Save diff (editar série)

Estado desejado após salvar: conjunto de linhas = dias selecionados, campos alinhados ao form.

| Operação | Condição |
|----------|----------|
| **Delete** | `weekday` existia na série e foi desmarcado no chip. |
| **Update** | `weekday` ainda selecionado; id preservado; atualizar subject, room, notes, start, end. |
| **Create** | `weekday` novo na seleção; novo `id`; mesmo `seriesId`. |

Transação lógica: ler lista completa → aplicar deletes → upserts → `writeRoot` uma vez (evitar estado parcial).

**Campos compartilhados:** sempre replicar subject/room/notes idênticos em todas as linhas da série após save.

---

## 11. Listagem — agrupamento (Minha grade)

**Objetivo:** uma matéria repetida não ocupa N cards idênticos.

| Tipo de item | Render |
|--------------|--------|
| Legado / dia único sem série | `HubClassCard` atual: um `weekdayLabel` longo. |
| Série (`seriesId` != null, ≥2 linhas) | **Um card** por série: disciplina, sala, bloco de horário (ver abaixo), meta **“Seg · Qua · Sex”** (`weekdayShortLabels` ordenados por weekday). |
| Série com 1 linha só | Tratar como card simples (um dia); opcional limpar `seriesId` no save para normalizar. |

**Horário no card agrupado:**

- Todos os membros com mesmo start/end → um `_TimeBlock` como hoje.  
- Horários diferentes → meta `schedule`: **“Horários variam”** + no detalhe do card ou subtítulo listar `Seg 08:00–10:00; Qua 14:00–16:00` (caption `inkMuted`, máx. 2 linhas com ellipsis).

**Ordenação:** manter sort por weekday + startTime no repositório; na UI, **agrupar** linhas consecutivas com mesmo `seriesId` em um item de lista (ViewModel expõe `ScheduleListItem` sealed: `single(ClassEntry)` | `series(seriesId, entries)`).

**Editar:** `onEdit` do card agrupado passa **qualquer** `ClassEntry` da série (ViewModel resolve `seriesId`).

---

## 12. Key states

| Estado | Comportamento |
|--------|----------------|
| Loading / erro | Igual listas atuais (`AppLoadingWidget`, `BodyErrorDefaultWidget`). |
| Nenhum dia selecionado | Bloqueado por UX (sempre ≥1 chip); se validação falhar, erro inline ou snack: `selectAtLeastOneWeekdayString`. |
| Disciplina vazia | Manter mensagem atual (`Informe a disciplina.` → mover para strings se ainda hardcoded). |
| Save erro | `errorSaveString`. |
| Série órfã | Não deve ocorrer se diff for atômico; se falhar no meio, retry load. |

---

## 13. Content requirements (`daily_strings.dart`)

| Chave sugerida | Copy (pt-BR) |
|----------------|--------------|
| `weekdaysString` | Dias da semana |
| `weekdayShortLabels` | const: Seg, Ter, Qua, Qui, Sex, Sáb, Dom |
| `sameTimeAllDaysString` | Mesmo horário em todos os dias |
| `perDayTimeString` | Horário por dia |
| `scheduleVariesString` | Horários variam |
| `selectAtLeastOneWeekdayString` | Selecione pelo menos um dia. |
| `deleteClassSeriesTitleString` | Excluir aula em todos os dias? |
| `deleteClassSeriesMessageString` | Isso remove esta disciplina de todos os dias da série. Não dá para desfazer. |
| `confirmString` / `cancelString` | Se ainda não existirem em `strings.dart` |

**Reuso:** `subjectString`, `roomString`, `startTimeString`, `endTimeString`, `notesOptionalString`, `addClassString`, `editClassString`, `weekdayLabels` (a11y / tooltips).

**Atualizar copy vazio (opcional):** `emptyScheduleMessage` mencionar “um ou mais dias”.

---

## 14. Edge cases

| Caso | Decisão |
|------|---------|
| Legado misturado na mesma disciplina manual | Sem deduplicação automática; usuário edita e unifica em série se quiser. |
| Expandir legado para vários dias | Novo `seriesId` + novas linhas; id original mantido no dia original. |
| Reduzir série a 1 dia | Manter `seriesId` (implementação simples) **ou** remover `seriesId` ao salvar — **recomendado:** remover `seriesId` quando restar 1 dia. |
| Horários diferentes na mesma série | Suportado no form “por dia”; listagem mostra “Horários variam”. |
| Notas/sala diferentes entre linhas antigas (dados sujos) | Na hidratação de série, usar primeiro membro ordenado por weekday; save sobrescreve todos. |
| Dois `seriesId` iguais por corrupção | Agrupar por `seriesId`; ids de linha ainda únicos. |
| Delete série vs home | Home só mostra o dia corrente; delete série remove todas as ocorrências futuras na grade. |
| Sobreposição de horários no mesmo dia | Não bloquear na v1 (comportamento atual). |

---

## 15. Interaction model

- Chips: toggle imediato; se “por dia”, lista de horários adiciona/remove linha ao marcar/desmarcar dia.  
- Save: loading em `HubPrimaryButton`; sem segundo tap.  
- Voltar da grade após save: `load.execute()` como hoje.  
- Diálogo de exclusão de série: `AlertDialog` padrão Material, ações destrutiva `error` / cancelar neutro.

---

## 16. Recommended references (impeccable)

- `interaction-design.md` — formulário, chips, confirmação destrutiva.  
- `layout.md` — wrap de chips, lista por dia no modo horário variável.  
- `normalize.md` — consistência de bordas/foco com `HubTheme`.

---

## 17. Open questions (defaults assumidos)

| Pergunta | Default no brief |
|----------|------------------|
| Excluir um dia da série sem apagar os outros? | v1: só via editar (desmarcar chip + save); delete no card = série inteira. |
| Chips Sáb/Dom visíveis? | Sim, todos os 7 (graduação pode ter sábado). |
| Normalizar série de 1 dia? | Remover `seriesId` ao salvar se só 1 chip. |

---

**Handoff:** implementar modelo + repositório em lote, `ClassFormViewModel` com estado `Set<int> weekdays` e diff, `ClassesViewModel` com agrupamento, widget `HubWeekdayChips` (ou local ao form se ainda não reutilizado).

**Produto:** cadastro e grade documentados em [features/disciplinas.md](features/disciplinas.md) e [features/grade_horaria.md](features/grade_horaria.md) (plano Free/Pro).
