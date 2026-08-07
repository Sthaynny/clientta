# Política de Assinatura — Clientta Pro

**Última atualização:** 7 de agosto de 2026

Esta política descreve as regras da assinatura **Clientta Pro**, incluindo cobrança, cancelamento voluntário e **cancelamento automático por inatividade**.

Ao assinar o plano Pro, você concorda com os termos abaixo, além da [Política de Privacidade](politica-privacidade.md).

---

## 1. Plano Pro

| Item | Detalhe |
|------|---------|
| **Modelo** | Assinatura mensal recorrente |
| **Cobrança** | Processada pela Stripe |
| **Benefícios** | Sincronização na nuvem, agenda ilimitada e recursos Pro documentados em [features/README.md](../features/README.md) |
| **Gestão** | Tela **Plano e assinatura** (`/configuracoes/plano`) no app |

---

## 2. O que conta como uso (atividade)

Para fins desta política, considera-se **atividade** qualquer uma das ações abaixo, com conta autenticada:

- Criar, editar ou excluir atendimentos na agenda
- Sincronizar dados com o Firestore (plano Pro)
- Qualquer escrita em `users/{uid}/appointments` na nuvem

O app e o backend registram a data da última atividade no campo `lastActivityAt` do documento `users/{uid}`.

---

## 3. Cancelamento automático por inatividade

### Regra

Assinaturas **Pro ativas** ou em **período de teste (`trialing`)** sem atividade por **2 (dois) meses consecutivos** são **canceladas automaticamente**.

### Como funciona

1. O sistema verifica diariamente (job agendado às 06:00 UTC / 03:00 horário de Brasília) todas as contas com assinatura elegível.
2. Se `lastActivityAt` for anterior a 2 meses, a assinatura é marcada para cancelamento na Stripe (`cancel_at_period_end: true`).
3. Você **mantém o acesso Pro até o fim do período já pago**; após essa data, a conta volta ao plano gratuito.
4. O motivo do cancelamento fica registrado em `subscription.canceledReason = "inactivity"`.

### Referência de data

| Prioridade | Campo usado |
|------------|-------------|
| 1 | `lastActivityAt` |
| 2 | `subscription.updatedAt` (ex.: data de ativação) |
| 3 | `createdAt` da conta |

Na ativação de uma nova assinatura Pro, `lastActivityAt` é atualizado automaticamente — você tem 2 meses completos a partir da ativação, mesmo sem uso imediato.

### O que **não** cancela por inatividade

- Contas no plano **gratuito**
- Assinaturas já **canceladas** ou **inativas**
- Assinaturas com atividade nos últimos 2 meses

---

## 4. Cancelamento voluntário

Você pode cancelar a qualquer momento em **Plano e assinatura** → **Cancelar assinatura**.

- O cancelamento voluntário também usa `cancel_at_period_end` — acesso Pro até o fim do período pago.
- Não há reembolso proporcional automático; dúvidas sobre cobrança: contato com suporte.

---

## 5. Pagamento em atraso

Falhas de pagamento (`past_due`) seguem o fluxo da Stripe (tentativas de cobrança, eventual suspensão). Isso é independente da política de inatividade.

---

## 6. Como evitar o cancelamento automático

Use o app pelo menos uma vez a cada 2 meses: registre ou edite um atendimento, ou sincronize a agenda (com Pro ativo e conexão disponível).

---

## 7. Alterações desta política

Esta política pode ser atualizada. A data no topo indica a versão vigente. Alterações relevantes podem ser comunicadas pelo app ou por e-mail cadastrado.

---

## 8. Contato

**E-mail:** igorsthaynny@gmail.com  
**Assunto sugerido:** Assinatura — Clientta

---

*Documento em português (Brasil). Complementa [assinatura_stripe.md](../features/assinatura_stripe.md) e [billing/readme.md](../billing/readme.md).*
