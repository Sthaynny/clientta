# Changelog

Mudanças notáveis do Clientta. O `versionCode` da Play é o número após `+` em
`pubspec.yaml` (ex.: `1.4.0+12` é versionName `1.4.0`, versionCode `12`).
Texto para a loja: [docs/stores/](docs/stores/README.md).

## Convenção

- Toda mudança em `lib/` ou `functions/*.js` entra em **Não lançado** no mesmo PR
  (o harness falha se faltar).
- Uma linha por funcionalidade, em português, pelo que o usuário percebe.
- Seções: **Adicionado**, **Alterado**, **Corrigido**, **Interno**.
- Ao publicar, renomear **Não lançado** para `versionName+versionCode` e abrir um novo
  **Não lançado** vazio.
- Validar antes do PR: `bash scripts/harness.sh full` (ver [AGENTS.md](AGENTS.md)).

## Não lançado

- Nada ainda.

## 1.4.0+12 (agosto/2026)

Texto completo da loja em [docs/stores/notas-versao-1.4.0.md](docs/stores/notas-versao-1.4.0.md).

**Adicionado**
- Meus Clientes: lista unificada com busca por nome ou telefone.
- Atendimento: histórico de negociação por cliente, com atalhos para ligar e abrir WhatsApp.
- Lembretes Pro: aviso antes do horário do atendimento, mesmo com o app fechado, inclusive após reiniciar o aparelho.
- Backup Pro: exportar e importar os dados em JSON.
- Login com Google e redefinição de senha por e-mail.
- Plano Pro ativado na hora após o checkout, com retorno direto ao app.
- Link de exclusão de conta no rodapé legal e e-mail de suporte no menu lateral.

**Alterado**
- Interface renovada: carregamento com skeletons, estados vazios, formulários agrupados em seções e barra de salvar fixa.
- Tela de plano com hero Pro e grade de benefícios; filtro por tipo de serviço em chips na agenda.
- Limite do plano gratuito reduzido para 25 agendamentos ativos, com banner de uso.

**Corrigido**
- Nome e telefone do cliente propagados entre todos os registros dele.
- Contraste de textos cinza, safe area do onboarding e do menu, layout em tablets.
