# Clientta 1.4.0 — Notas da versão

**Build:** 12  
**Data:** 15/08/2026  
**Tipo:** Atualização de funcionalidades

---

## Para o Google Play Console (pt-BR)

Copiar o bloco abaixo no campo **O que há de novo**:

```
Novidades do Clientta 1.4.0:

• Meus Clientes — lista unificada com busca por nome ou telefone
• Atendimento — histórico de negociação por cliente, com ligação e WhatsApp
• Lembretes Pro — aviso antes do horário do atendimento (mesmo com o app fechado)
• Backup Pro — exporte e importe seus dados em JSON
• Login com Google e recuperação de senha por e-mail
• Plano Pro — ativação imediata após o checkout e retorno direto ao app
• Interface renovada — carregamento mais fluido, estados vazios e formulários organizados
• Correções de acessibilidade, sincronização de dados do cliente e layout em tablets
```

---

## Resumo por área

### Clientes e atendimento
- Tela **Meus Clientes** com busca e perfil derivado dos agendamentos
- **Atendimento** centralizado por telefone do cliente
- Registro de encontros e timeline de negociação
- Atalhos para ligar e abrir WhatsApp no card do cliente
- Catálogo de tipos de serviço no formulário de agendamento
- Propagação automática de nome e telefone entre registros do mesmo cliente

### Plano Pro e billing
- Ativação Pro imediata após checkout Stripe
- Deep link de retorno ao app na tela de plano
- Atualização do status Pro na Home e Agenda sem recarregar
- Limites do plano gratuito (25 agendamentos ativos) com banner de uso
- Listas de acesso cortesia e desconto via Firestore
- Sincronização de notas de atendimento na nuvem (Pro)

### Lembretes (Pro)
- Notificações locais antes do horário do atendimento
- Configuração de antecedência e deep link ao toque
- Receivers Android para lembretes após reinício do dispositivo

### Backup (Pro)
- Exportação do JSON local para arquivo
- Importação de backup com validação

### Autenticação e conta
- Login com Google (Firebase Auth)
- Fluxo de redefinição de senha
- Link de exclusão de conta no rodapé legal
- E-mail de suporte no menu lateral

### Interface
- Skeletons de carregamento (shimmer) nas telas principais
- Intros e estados vazios em Home, Agenda, Clientes e Atendimento
- Formulário de agendamento com seções agrupadas e barra de salvar fixa
- Filtro por tipo de serviço com chips na agenda
- Tela de plano com hero Pro e grade de benefícios
- Melhor contraste de texto e ajustes de safe area (onboarding, drawer)

### Correções
- Impedir agendamentos duplicados; reconhecer cliente por telefone
- Layout portrait em tablets
- Ordem correta do histórico de atendimento
- Ícones sem bordas brancas em fundos transparentes

---

## Artefato de build

```bash
flutter build appbundle --release
```

Saída: `build/app/outputs/bundle/release/app-release.aab`
