# Exclusão de conta — Clientta

**Última atualização:** 10 de agosto de 2026

**App:** Clientta  
**Desenvolvedor:** Igor Sthaynny  
**Contato:** igorsthaynny@gmail.com

Esta página descreve como solicitar a **exclusão da sua conta** e dos **dados pessoais associados** ao aplicativo Clientta, em conformidade com a LGPD e os requisitos do Google Play.

**URL pública:** https://sthaynny.github.io/pages-public/clientta/exclusao-de-conta/

---

## Como solicitar exclusão

1. Envie um e-mail para **igorsthaynny@gmail.com** com o assunto **"Exclusão de conta — Clientta"**.
2. Informe o **e-mail usado no cadastro** do app (e-mail/senha ou login com Google).
3. Aguarde a confirmação em até **15 dias úteis**.

## Antes de excluir

- **Assinatura Pro:** cancele em **Plano e assinatura** no app ou solicite cancelamento no mesmo e-mail.
- **Backup (Pro):** exporte JSON pela tela de plano, se quiser guardar cópia.

## O que será excluído

- Conta de autenticação (Firebase Auth)
- Perfil em `users/{uid}` no Firestore
- Agendamentos em `users/{uid}/appointments`
- Notas em `users/{uid}/encounterNotes`
- Status de assinatura Pro no Firestore
- Vínculo com cliente Stripe (assinatura cancelada se ativa)

## O que pode ser mantido

| Tipo | Motivo | Prazo indicativo |
|------|--------|------------------|
| Registros de cobrança (Stripe) | Obrigações fiscais/contábeis | Até 5 anos |
| Logs técnicos (Firebase) | Segurança e diagnóstico | Prazo limitado |
| Backup exportado por você | Sob seu controle | Enquanto mantiver a cópia |

## Dados no celular

A exclusão da conta na nuvem **não apaga** automaticamente `clientta_data.json` no aparelho. Para remover:

- **Android:** Configurações → Apps → Clientta → Limpar dados, ou desinstalar.
- **iOS:** desinstalar o app.

## Exclusão parcial sem apagar a conta

O Clientta **não oferece** exclusão seletiva na nuvem sem excluir a conta. Você pode apagar agendamentos e notas individualmente no app.

---

*Complementa [politica-privacidade.md](politica-privacidade.md).*
