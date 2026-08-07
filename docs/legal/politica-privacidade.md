# Política de Privacidade — Clientta

**Última atualização:** 7 de agosto de 2026

Esta Política de Privacidade descreve como o aplicativo **Clientta** (“App”) coleta, usa, armazena e protege dados pessoais, em conformidade com a **Lei Geral de Proteção de Dados (LGPD — Lei nº 13.709/2018)** e demais normas aplicáveis no Brasil.

Ao utilizar o Clientta, você declara ter lido e compreendido esta política. Em caso de dúvidas, entre em contato pelo e-mail indicado na seção [Contato](#contato).

---

## 1. Controlador dos dados

O **controlador** dos dados pessoais tratados por meio do Clientta é:

| Campo | Informação |
|-------|------------|
| **Nome** | Igor Sthaynny |
| **Papel** | Desenvolvedor independente e responsável pelo App |
| **E-mail de contato** | igorsthaynny@gmail.com |

O Clientta é um CRM de agendamentos voltado a consultores e profissionais que atendem clientes no dia a dia. O controlador atua na qualidade de pessoa física, sem vínculo com pessoa jurídica específica para fins desta política.

---

## 2. Dados coletados

O Clientta pode tratar as categorias de dados abaixo, conforme o uso das funcionalidades:

### 2.1 Dados do usuário do App (titular da conta)

- **E-mail** e **senha** (cadastro com e-mail e senha via Firebase Authentication)
- **Identificador único** (`uid`) gerado pelo Firebase Auth
- **Nome e foto de perfil** (quando o login com Google estiver disponível e você optar por utilizá-lo)
- **Status e dados da assinatura Pro** (por exemplo: situação da assinatura, identificadores de cliente e assinatura na Stripe, data de término do período vigente)

### 2.2 Dados de clientes e atendimentos (inseridos por você)

Ao registrar agendamentos no App, você pode incluir informações sobre seus clientes e atendimentos, tais como:

- **Nome do cliente**
- **Telefone do cliente**
- **Tipo de serviço**
- **Data e horários** do atendimento (início e fim)
- **Status** do agendamento (agendado, concluído, cancelado)
- **Notas** e observações sobre o atendimento ou negociação
- **Identificador de série** (para agendamentos recorrentes)

Esses dados são inseridos voluntariamente por você e referem-se a **terceiros** (seus clientes). Ao incluí-los, você declara possuir base legal para fazê-lo e, quando aplicável, deve informar seus clientes sobre o tratamento.

### 2.3 Dados técnicos e de uso

- Informações necessárias ao funcionamento do App (por exemplo, versão do sistema, identificadores de sessão de autenticação)
- Dados de diagnóstico e logs de erro, quando habilitados pelos serviços de infraestrutura (Firebase)

O Clientta **não** coleta intencionalmente dados sensíveis previstos no art. 5º, II, da LGPD (origem racial, convicção religiosa, saúde, biometria etc.), salvo o que você voluntariamente incluir em campos de texto livre (como notas).

---

## 3. Finalidade do tratamento

Os dados são tratados para as finalidades abaixo:

| Finalidade | Dados envolvidos |
|------------|------------------|
| Criar e gerenciar sua conta | E-mail, senha, `uid` |
| Permitir login e manter sessão autenticada | Credenciais e tokens do Firebase Auth |
| Armazenar e exibir seus agendamentos localmente | Dados de clientes e atendimentos |
| Sincronizar agendamentos na nuvem (plano Pro) | Dados de atendimentos e perfil do usuário |
| Processar assinatura Pro e liberar recursos pagos | E-mail, `uid`, dados de assinatura |
| Cumprir obrigações legais e responder a solicitações de titulares | Conforme necessário |
| Melhorar segurança, estabilidade e suporte | Logs técnicos |

---

## 4. Base legal (LGPD)

O tratamento de dados pessoais no Clientta fundamenta-se nas bases legais previstas na LGPD, conforme o contexto:

- **Execução de contrato** (art. 7º, V): prestação do serviço do App, incluindo armazenamento local, autenticação e, no plano Pro, sincronização e cobrança.
- **Consentimento** (art. 7º, I): quando exigido para funcionalidades opcionais ou para dados de terceiros que você insere sobre seus clientes.
- **Legítimo interesse** (art. 7º, IX): segurança da conta, prevenção a fraudes e melhoria técnica do App, respeitados seus direitos.
- **Cumprimento de obrigação legal** (art. 7º, II): quando aplicável a registros fiscais ou respostas a autoridades.

Você pode revogar consentimentos a qualquer momento, quando essa for a base aplicável, sem prejuízo de tratamentos realizados anteriormente com amparo legal.

---

## 5. Armazenamento local

O Clientta adota arquitetura **offline-first**: seus agendamentos ficam disponíveis imediatamente no dispositivo, em arquivo JSON gerenciado pelo componente `DeviceJsonStore`.

| Aspecto | Detalhe |
|---------|---------|
| **Arquivo** | `clientta_data.json` |
| **Local** | Diretório de documentos do aplicativo no seu celular ou tablet |
| **Conteúdo** | Agendamentos e demais dados que você registra no App |
| **Acesso** | Restrito ao App instalado no seu dispositivo |

Os dados locais **não** são automaticamente enviados à nuvem. O envio ocorre apenas se você tiver plano **Pro** ativo e a sincronização estiver habilitada. A exclusão do App ou limpeza dos dados do aplicativo pode remover permanentemente o arquivo local.

---

## 6. Firebase (Authentication)

Para criar conta e acessar recursos que exigem identificação, o Clientta utiliza **Firebase Authentication**, serviço operado pela **Google LLC**, que processa:

- E-mail e senha (cadastro tradicional)
- Identificador único do usuário (`uid`)
- Dados de perfil do provedor social, quando o login com Google estiver disponível

A autenticação é necessária para sincronização na nuvem, gestão de assinatura Pro e associação dos seus dados ao seu perfil. Consulte a [política de privacidade do Firebase](https://firebase.google.com/support/privacy) para informações sobre o tratamento pela Google.

---

## 7. Firestore (sincronização na nuvem — plano Pro)

Usuários com assinatura **Pro** ativa podem sincronizar agendamentos com o **Cloud Firestore**, também operado pela Google LLC. Os dados são organizados assim:

| Caminho | Conteúdo |
|---------|----------|
| `users/{uid}` | Dados do perfil do usuário e status da assinatura (`subscription`) |
| `users/{uid}/appointments/{id}` | Cópia dos agendamentos sincronizados |

**Importante:** o campo `subscription` em `users/{uid}` é atualizado **exclusivamente pelo backend** (Cloud Functions e webhooks da Stripe). O aplicativo pode **ler** essas informações para liberar recursos Pro, mas **não** altera diretamente o status de assinatura.

A sincronização é opcional no sentido de que depende do plano Pro; sem ela, os dados permanecem apenas no dispositivo.

---

## 8. Stripe (assinatura Pro)

O plano **Pro** é cobrado por meio da **Stripe, Inc.**, integrada via **Cloud Functions** do Firebase. O aplicativo Flutter **não** incorpora o SDK da Stripe nem armazena dados completos de cartão de crédito.

Fluxo resumido:

1. Você solicita a assinatura Pro no App.
2. Uma Cloud Function cria a sessão de checkout e retorna uma URL segura.
3. O pagamento é concluído no ambiente da Stripe (navegador ou página hospedada).
4. Webhooks da Stripe atualizam o status da assinatura no Firestore.
5. O App consulta o entitlement para liberar sincronização e demais benefícios Pro.

Dados tratados pela Stripe podem incluir nome, e-mail, informações de pagamento e identificadores de cliente/assinatura. A Stripe atua como **operadora** independente; consulte a [política de privacidade da Stripe](https://stripe.com/br/privacy).

---

## 9. Compartilhamento de dados

O controlador **não vende** dados pessoais. O compartilhamento ocorre apenas nas situações abaixo:

| Destinatário | Motivo |
|--------------|--------|
| **Google (Firebase Auth e Firestore)** | Autenticação, hospedagem e sincronização de dados |
| **Stripe** | Processamento de pagamentos e gestão de assinaturas |
| **Autoridades públicas** | Quando exigido por lei, ordem judicial ou requisição válida |

Prestadores de infraestrutura podem processar dados em servidores fora do Brasil. Nesses casos, o controlador busca garantir níveis adequados de proteção, conforme arts. 33 a 36 da LGPD.

---

## 10. Retenção dos dados

| Tipo de dado | Período |
|--------------|---------|
| **Dados locais** (`clientta_data.json`) | Enquanto o App estiver instalado e os dados não forem apagados por você |
| **Conta e agendamentos no Firestore** | Enquanto a conta existir; após exclusão da conta, dados na nuvem serão removidos em prazo razoável, salvo obrigação legal de retenção |
| **Dados de assinatura (Stripe/Firestore)** | Conforme exigências fiscais e contratuais aplicáveis à cobrança |
| **Logs técnicos** | Pelo tempo necessário à segurança e diagnóstico, geralmente limitado |

Você pode solicitar a exclusão da conta e dos dados associados conforme a seção [Direitos do titular](#11-direitos-do-titular).

---

## 11. Direitos do titular

Nos termos da LGPD, você pode exercer, em relação aos seus dados pessoais:

- **Confirmação** da existência de tratamento
- **Acesso** aos dados
- **Correção** de dados incompletos, inexatos ou desatualizados
- **Anonimização, bloqueio ou eliminação** de dados desnecessários ou tratados em desconformidade
- **Portabilidade**, quando aplicável
- **Eliminação** dos dados tratados com base no consentimento
- **Informação** sobre compartilhamentos
- **Revogação do consentimento**
- **Oposição** a tratamento baseado em legítimo interesse, quando cabível

Para exercer esses direitos, envie solicitação para **igorsthaynny@gmail.com**, informando seu e-mail de cadastro e o pedido desejado. O controlador responderá em prazo razoável, conforme a LGPD.

Se você incluiu dados de **clientes** no App, lembre-se de que esses terceiros também possuem direitos perante você, na qualidade de responsável pelo relacionamento comercial com eles.

Você também pode apresentar reclamação à **Autoridade Nacional de Proteção de Dados (ANPD)**.

---

## 12. Segurança

O controlador adota medidas técnicas e organizacionais para proteger os dados, incluindo:

- Comunicação criptografada (HTTPS/TLS) com serviços na nuvem
- Autenticação obrigatória para acesso a dados sincronizados
- Regras de segurança no Firestore que restringem leitura e escrita por usuário autenticado
- Processamento de pagamentos exclusivamente no ambiente da Stripe, sem armazenamento de dados completos de cartão no App
- Armazenamento local no sandbox do sistema operacional do dispositivo

Nenhum sistema é totalmente imune a riscos. Recomenda-se usar senha forte, manter o sistema operacional atualizado e não compartilhar credenciais de acesso.

---

## 13. Menores de idade

O Clientta é destinado a **profissionais e consultores maiores de 18 anos**. Não coletamos intencionalmente dados de crianças ou adolescentes. Se tomarmos conhecimento de que dados de menor foram fornecidos sem o consentimento adequado do responsável legal, adotaremos medidas para excluí-los.

---

## 14. Alterações desta política

Esta política pode ser atualizada para refletir mudanças no App, na legislação ou em serviços de terceiros. A data da **última atualização** consta no topo do documento. Alterações relevantes poderão ser comunicadas por meio do App ou por e-mail cadastrado, quando apropriado.

O uso continuado do Clientta após a publicação de alterações constitui ciência da versão vigente, salvo quando nova base de consentimento for exigida por lei.

---

## 15. Contato

Para dúvidas, solicitações relacionadas à privacidade ou exercício de direitos previstos na LGPD:

**E-mail:** igorsthaynny@gmail.com  
**Assunto sugerido:** Privacidade — Clientta

Responderemos em prazo compatível com a legislação aplicável.

---

*Documento elaborado para o aplicativo Clientta. Versão em português (Brasil).*
