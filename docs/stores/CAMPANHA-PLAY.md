# Campanha / publicação: Hub Universitário — Google Play

**Objetivo:** Instalação e publicação na ficha Play  
**Estágio do funil / framework:** Atenção → consideração → decisão; carrossel com PAS no card 03 e CTA no 05  
**Segmentação:** Estudantes universitários no Brasil (18–28), Android, rotina de aulas e entregas  
**Canal / peça:** Pacote completo Google Play  
**Fonte visual:** prints reais  
**Path dos prints:** `docs/stores/prints/`  
**Identidade usada:** verde Hub `#1A6B52` / `#0F4535`, dourado/amarelo no logo Hub Universitário (`lib/core/theme/hub_colors.dart`)  
**Play Store:** [LINK_PLAY_STORE]

---

## Copy da ficha

- **Nome:** Hub Universitário
- **Breve (79/80):** Grade, atividades e o dia na facul — tudo no celular, sem internet.
- **Descrição completa:**

Organizar a faculdade não precisa virar planilha nem grupo de WhatsApp perdido.

O **Hub Universitário** é um organizador pessoal para quem estuda na universidade: você monta a **grade de aulas**, registra **entregas e provas** e abre o **painel do dia** para ver o que importa agora — aula da manhã, trabalho da semana, sala e horário.

**Para quem é:** estudantes que querem clareza na rotina, sem depender de sinal o tempo todo.

**O que você faz no app:**
- Cadastrar aulas com dias da semana, horário, sala e observações (incluindo referência de turno sistema acadêmico).
- Ver a grade em lista clara, com horários e edição rápida.
- Registrar atividades por tipo (entrega, prova, trabalho) e marcar como feito.
- Consultar **Seu dia na faculdade**: resumo de aulas e atividades de hoje, com atalhos para registrar.

**Diferencial:** funciona **offline** — seus dados ficam no aparelho. Sem login obrigatório para começar.

**Privacidade:** organização local no dispositivo; você controla o que cadastra.

**Comece agora:** instale grátis, monte sua grade e marque a próxima entrega em menos de um minuto.

[LINK_PLAY_STORE]

---

## Matriz carrossel (phone)

| # | Papel | Marketing | Framework | Print fonte | Arquétipo | Fundo | Headline (arte) | Foco riqueza UI |
|---|--------|-----------|-----------|-------------|-----------|-------|-----------------|-----------------|
| 01 | Gancho | Atenção | Contraste dor/planilha | `01_home_seu_dia.png` | A Play clássico | Gradiente `#1A6B52` → `#0F4535` | Seu dia na faculdade, claro. | Card verde “Sábado, 25 de julho”, badges “1 aula hoje” / “1 atividade hoje”, atalhos Registrar aula/atividade |
| 02 | Interesse | BAB | Resultado visível | `05_minha_grade.png` | D Lateral | Neutro claro `#F4F6F8` | Sua grade num só lugar. | Cards “mobile” Ter–Qui e “Teste” Sáb LTI 1, blocos 08:00–10:00 azuis, FAB Registrar aula |
| 03 | Desejo | PAS | Solução na UI | `03_registrar_aula.png` | E Recorte UI | Split verde / branco | Vários dias? Marca de uma vez. | Chips Seg–Dom com Sáb selecionado, horários 08:00–10:00, turno sistema acadêmico, botão Salvar |
| 04 | Confiança | Razão | Controle de prazos | `02_atividades_pendente.png` | C Phone hero | Verde escuro suave | Entrega na data. Sem esquecer. | Tag “Entrega”, “Estudar prova de G”, data 25/07/2026, FAB Registrar atividade |
| 05 | Ação | Decisão | CTA | `06_menu_drawer.png` | H Faixa + selo | Gradiente invertido | Tudo no celular. Offline. | Drawer: logo amarelo, “Grade, atividades e rotina — offline”; selo apoio “Grátis na Play Store” |

**Feature graphic (tipográfica + mockup):** headline “Organize a facul no bolso.” + phone parcial com painel do dia.

**Tablet 01–04:** mesmas headlines e prints `01_home_seu_dia.png`, `05_minha_grade.png`, `03_registrar_aula.png`, `02_atividades_pendente.png` — compositor Pillow.

---

## Headline(s) / CTA

| # | Headline | CTA na arte |
|---|----------|-------------|
| 01 | Seu dia na faculdade, claro. | — |
| 02 | Sua grade num só lugar. | — |
| 03 | Vários dias? Marca de uma vez. | — |
| 04 | Entrega na data. Sem esquecer. | — |
| 05 | Tudo no celular. Offline. | Faixa: Grátis na Play Store |

---

## Brief visual

- **Phone:** 5× 9:16 (alvo 1080×1920 pós-redimensionar), arquétipos A, D, E, C, H  
- **Ícone:** 512×512, tocha/logo estilo Hub Universitário, verde + amarelo, sem texto longo  
- **Feature:** 1024×500, marca + benefício curto  
- **Heurísticas:** hierarquia headline → UI; sem badges flutuantes; contraste AA no texto  
- **Riqueza UI:** datas PT-BR, sistema acadêmico, salas LTI, tipos Entrega/Trabalho  
- **Restrições:** sem claim médico; sem prova social inventada; remover faixa DEBUG nas artes promocionais (UI de referência pode manter — ideal regenerar sem DEBUG em produção final)

---

## Arquivos gerados

Ver `docs/stores/ENTREGA-PLAY.md` (checklist e paths finais).
