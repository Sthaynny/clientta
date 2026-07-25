# Riqueza visual — mockups e telas nas artes

Objetivo: artes **bonitas e específicas** do produto, não “template de loja” com UI vazia. A riqueza vem de **dados plausíveis**, **profundidade**, **contexto de domínio** e **microdetalhes** — sem poluir a headline.

Índice: [Antes de gerar](#antes-de-gerar-ler-o-print) · [Camadas de detalhe](#camadas-de-detalhe) · [Por domínio](#sugestões-por-domínio-do-app) · [Profundidade e luz](#profundidade-luz-e-material) · [Feature e ícone](#feature-graphic-e-ícone) · [Anti-mesmice](#anti-mesmice)

## Antes de gerar: ler o print

Com path confirmado (SKILL §3):

1. **Listar** PNGs da pasta (`Glob` / `ls`).
2. **Abrir** cada print usado na arte (`Read` em imagem) e anotar:
   - Estrutura (app bar, tabs, cards, lista, calendário)
   - Cores dominantes já presentes na UI
   - O que está vazio ou genérico demais na captura
3. Na `description` do GenerateImage, citar **elementos visíveis** do print (“manter bottom nav com 5 ícones”, “card de receita do dia visível”) + pedido de **refino** abaixo.

**Com print real:** fidelidade primeiro; riqueza = nitidez, sombra do device, alinhamento — não redesenhar a tela.

**Sem print (conceitual):** aplicar todas as camadas deste doc com UI genérica **do vertical** do brief (agenda, finanças, saúde lembrete, etc.).

## Camadas de detalhe

Aplicar **2–4 camadas** por arte (não todas de uma vez):

| Camada | O que adicionar | Limite |
|--------|-----------------|--------|
| **Dados** | Nomes, horários, valores, status (“Confirmado”, “Pago”) coerentes com o produto | Sem PII real; nomes fictícios brasileiros curtos |
| **Estado** | Badge de contagem, barra de progresso parcial, toggle ligado, dia selecionado no calendário | 1 destaque por tela |
| **Densidade** | Listas com 4–6 linhas legíveis; avatares iniciais; ícones de ação consistentes | Não microtexto ilegível no preview |
| **Marca** | Cor primária em FAB, header ou gráfico; logo discreto na app bar se existir no produto | Não competir com headline da arte |
| **Contexto** | Sombra do phone no “chão” da arte; reflexo leve no vidro; grain 2–3% no fundo | Sem foto stock óbvia |

## Sugestões por domínio do app

Adaptar ao brief — exemplos de **conteúdo** na UI (não copy da arte):

| Vertical | Detalhes que vendem sem claim médico |
|----------|--------------------------------------|
| Agenda / serviços | Slots 09:00, 14:30; profissional “Ana”; serviço “Corte”; status cores distintas |
| Financeiro | Entrada/saída do dia; gráfico de barras 7 dias; valor em R$ formatado |
| Gestão / painel | 3 KPIs com números diferentes; seta de tendência; período “Esta semana” |
| Saúde / lembrete | Horários de medicamento; checkboxes; **sem** diagnóstico ou “cura” |
| Vitrine / landing | Foto de capa, CTA “Agendar”, endereço fictício curto |
| Produtividade | Tarefas com prioridade; uma concluída; contador “3 de 5” |

## Profundidade, luz e material

Incluir na `description` quando fizer sentido ao arquétipo ([diversidade-layouts.md](diversidade-layouts.md)):

- **Luz:** soft key light vinda do canto superior esquerdo; sombra do device para baixo-direita, blur suave
- **Moldura:** iPhone/Android fino, cor neutra escura ou prata; tela com cantos arredondados
- **Fundo da arte:** gradiente 2 stops da marca (ex. primário 15% → neutro 0%); ou split 60/40 com cor sólida + off-white
- **Textura:** ruído fotográfico muito leve OU padrão geométrico **uma vez** no pacote (não em todos os cards)

Evitar: bloom neon, glassmorphism pesado, 3D cartoon, mockup flutuando sem sombra.

## Feature graphic e ícone

| Peça | Riqueza sem clutter |
|------|---------------------|
| Feature | 1 mockup + 1 elemento gráfico (linha de agenda, gráfico minimalista) alinhado à grid |
| Ícone | Forma simples + profundidade flat (sombra interna leve) ou duotone marca |

## Anti-mesmice

Checklist antes de cada GenerateImage:

- [ ] Este card usa **arquétipo diferente** do anterior?
- [ ] O fundo **não** é o mesmo gradiente dos outros 4 sem motivo?
- [ ] A UI mostra **conteúdo de domínio**, não placeholders “Lorem” / retângios cinza?
- [ ] Há **um** ponto focal na tela (card destacado, dia selecionado)?
- [ ] `reference_image_paths` inclui print + logo/ícone quando existirem?

Prompt enriquecido: [prompt-geracao-imagem.md](prompt-geracao-imagem.md).
