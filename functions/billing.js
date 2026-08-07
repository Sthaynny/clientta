const admin = require('firebase-admin');
const { onCall, onRequest, HttpsError } = require('firebase-functions/v2/https');
const { CALLABLE_OPTIONS, callableWithSecrets } = require('./callable_options');
const {
  stripeSecretKey,
  stripeWebhookSecret,
  getStripe,
  isStripeTestMode,
  getStripeProPriceId,
} = require('./stripe_client');
const {
  checkoutSessionIdempotencyKey,
  stripeCustomerIdempotencyKey,
  subscriptionCancelAtPeriodEndKey,
} = require('./stripe_idempotency');
const {
  getPlanPricingResponse,
  resolvePlanPriceCents,
  PLAN_CATALOG,
} = require('./pricing');
const { getFreePlanLimitsResponse } = require('./plan_limits');
const {
  resolveEntitlementsForEmail,
  buildPersonalizedPlanPricing,
  buildFreeAccessSubscriptionPatch,
  hasActiveStripeSubscription,
  isFreeAccessSubscription,
  applyPercentDiscount,
} = require('./billing_entitlements');

const BILLING_SECRETS = [stripeSecretKey, stripeWebhookSecret];

function getFirestore() {
  return admin.firestore();
}

function assertAuthenticated(request) {
  if (!request.auth?.uid) {
    throw new HttpsError('unauthenticated', 'Faça login para continuar.');
  }
  return request.auth.uid;
}

function mapStripeStatusToBilling(stripeStatus) {
  switch (stripeStatus) {
    case 'active':
      return 'active';
    case 'trialing':
      return 'trialing';
    case 'past_due':
    case 'unpaid':
    case 'paused':
      return 'pastDue';
    case 'canceled':
      return 'canceled';
    case 'incomplete':
    case 'incomplete_expired':
    default:
      return 'inactive';
  }
}

function unixSecondsToDate(value) {
  const seconds = Number(value);
  if (!Number.isFinite(seconds) || seconds <= 0) return null;
  return new Date(seconds * 1000);
}

function toFirestoreTimestamp(date) {
  if (!date) return null;
  return admin.firestore.Timestamp.fromDate(date);
}

function appendBillingResult(returnUrl, result) {
  const url = new URL(returnUrl);
  url.searchParams.set('billing', result);
  return url.toString();
}

function isSimulatedStripeResourceId(resourceId) {
  return String(resourceId || '').startsWith('sandbox_');
}

async function getUserDoc(uid) {
  const doc = await getFirestore().collection('users').doc(uid).get();
  return doc.exists ? doc.data() || {} : {};
}

async function resolveUserIdFromStripeSubscription(stripeSubscription) {
  const metadataUserId = stripeSubscription.metadata?.userId;
  if (metadataUserId) {
    return metadataUserId;
  }

  const customerId =
    typeof stripeSubscription.customer === 'string'
      ? stripeSubscription.customer
      : stripeSubscription.customer?.id;
  if (!customerId) {
    return null;
  }

  const snapshot = await getFirestore()
    .collection('users')
    .where('subscription.stripeCustomerId', '==', customerId)
    .limit(1)
    .get();

  if (snapshot.empty) {
    return null;
  }

  return snapshot.docs[0].id;
}

async function updateUserSubscription(uid, patch) {
  const ref = getFirestore().collection('users').doc(uid);
  const payload = {
    subscription: patch,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  if (patch.status === 'active' || patch.status === 'trialing') {
    payload.lastActivityAt = admin.firestore.FieldValue.serverTimestamp();
  }

  await ref.set(payload, { merge: true });
}

async function ensureStripeCustomer(stripe, uid, email) {
  const userData = await getUserDoc(uid);
  const existingCustomerId = userData.subscription?.stripeCustomerId;
  if (existingCustomerId && !isSimulatedStripeResourceId(existingCustomerId)) {
    return existingCustomerId;
  }

  const customer = await stripe.customers.create(
    {
      email: email || undefined,
      metadata: { userId: uid },
    },
    { idempotencyKey: stripeCustomerIdempotencyKey(uid) },
  );

  await updateUserSubscription(uid, {
    ...(userData.subscription || {}),
    stripeCustomerId: customer.id,
  });

  return customer.id;
}

function buildSubscriptionPatch({
  plan,
  status,
  stripeCustomerId,
  stripeSubscriptionId,
  stripeCheckoutSessionId,
  stripePriceId,
  currentPeriodEnd,
  cancelAtPeriodEnd,
  entitlementSource,
}) {
  return {
    plan: plan || 'pro',
    status: status || 'inactive',
    stripeCustomerId: stripeCustomerId || null,
    stripeSubscriptionId: stripeSubscriptionId || null,
    stripeCheckoutSessionId: stripeCheckoutSessionId || null,
    stripePriceId: stripePriceId || null,
    accessEndsAt: currentPeriodEnd
      ? currentPeriodEnd.toISOString()
      : null,
    cancelAtPeriodEnd: Boolean(cancelAtPeriodEnd),
    entitlementSource: entitlementSource || null,
    updatedAt: new Date().toISOString(),
  };
}

function resolveStripePriceIdFromSubscription(stripeSubscription) {
  const firstItem = stripeSubscription.items?.data?.[0];
  if (!firstItem?.price) return null;
  return typeof firstItem.price === 'string'
    ? firstItem.price
    : firstItem.price.id;
}

function buildCheckoutLineItem({
  monthlyPriceCents,
  stripePriceId,
  planMeta,
}) {
  if (stripePriceId) {
    return {
      price: stripePriceId,
      quantity: 1,
    };
  }

  return {
    price_data: {
      currency: 'brl',
      unit_amount: monthlyPriceCents,
      recurring: { interval: 'month' },
      product_data: { name: planMeta.name },
    },
    quantity: 1,
  };
}

async function applyStripeSubscriptionToUser(uid, stripeSubscription, plan = 'pro') {
  const userData = await getUserDoc(uid);
  const currentSubscription = userData.subscription || {};

  if (
    isFreeAccessSubscription(currentSubscription) &&
    !hasActiveStripeSubscription(currentSubscription, isSimulatedStripeResourceId)
  ) {
    return;
  }

  const status = mapStripeStatusToBilling(stripeSubscription.status);
  const currentPeriodEnd = unixSecondsToDate(
    stripeSubscription.current_period_end,
  );

  await updateUserSubscription(
    uid,
    buildSubscriptionPatch({
      plan,
      status,
      stripeCustomerId:
        typeof stripeSubscription.customer === 'string'
          ? stripeSubscription.customer
          : stripeSubscription.customer?.id,
      stripeSubscriptionId: stripeSubscription.id,
      stripePriceId: resolveStripePriceIdFromSubscription(stripeSubscription),
      currentPeriodEnd,
      cancelAtPeriodEnd: stripeSubscription.cancel_at_period_end,
      entitlementSource: 'stripe',
    }),
  );
}

const getPlanPricing = onCall(CALLABLE_OPTIONS, async (request) => {
  const stripePriceId = getStripeProPriceId();
  const email = String(request.auth?.token?.email || '').trim().toLowerCase();
  if (!email) {
    return getPlanPricingResponse(stripePriceId);
  }

  const { billingEntitlement } = await resolveEntitlementsForEmail(email);
  const pro = buildPersonalizedPlanPricing('pro', billingEntitlement);
  if (stripePriceId) {
    pro.stripePriceId = stripePriceId;
  }

  return {
    pro,
    billingEntitlement,
    freeLimits: getFreePlanLimitsResponse(),
  };
});

const createSubscription = onCall(
  callableWithSecrets(BILLING_SECRETS),
  async (request) => {
    const uid = assertAuthenticated(request);
    const plan = String(request.data?.plan || 'pro');
    const returnUrl = String(request.data?.returnUrl || '').trim();
    if (!returnUrl) {
      throw new HttpsError('invalid-argument', 'returnUrl é obrigatório.');
    }

    resolvePlanPriceCents(plan);

    const userData = await getUserDoc(uid);
    const currentSubscription = userData.subscription || {};
    const email = String(request.auth.token.email || '').trim().toLowerCase();
    const { freeAccess, discount } = await resolveEntitlementsForEmail(email, plan);

    if (freeAccess) {
      const patch = buildFreeAccessSubscriptionPatch(currentSubscription);
      await updateUserSubscription(uid, patch);
      return {
        checkoutUrl: '',
        isSandboxCheckout: false,
        isFreeAccess: true,
        plan,
      };
    }

    if (isStripeTestMode()) {
      const sandboxSessionId = `sandbox_cs_${uid}_${Date.now()}`;
      await updateUserSubscription(uid, {
        ...buildSubscriptionPatch({
          plan,
          status: 'inactive',
          stripeCustomerId: currentSubscription.stripeCustomerId || `sandbox_cus_${uid}`,
          stripeCheckoutSessionId: sandboxSessionId,
        }),
      });

      return {
        checkoutUrl: '',
        isSandboxCheckout: true,
        plan,
      };
    }

    const stripe = getStripe();
    const customerId = await ensureStripeCustomer(stripe, uid, email);
    const configuredPriceId = getStripeProPriceId();
    const baseMonthlyPriceCents = resolvePlanPriceCents(plan);
    const monthlyPriceCents = discount
      ? applyPercentDiscount(baseMonthlyPriceCents, discount.percentOff)
      : baseMonthlyPriceCents;
    const planMeta = PLAN_CATALOG[plan];
    const useCatalogPrice = configuredPriceId && monthlyPriceCents === baseMonthlyPriceCents;

    const session = await stripe.checkout.sessions.create(
      {
        mode: 'subscription',
        customer: customerId,
        client_reference_id: uid,
        metadata: { userId: uid, plan },
        line_items: [
          buildCheckoutLineItem({
            monthlyPriceCents,
            stripePriceId: useCatalogPrice ? configuredPriceId : '',
            planMeta,
          }),
        ],
        subscription_data: {
          metadata: { userId: uid, plan },
        },
        success_url: appendBillingResult(returnUrl, 'success'),
        cancel_url: appendBillingResult(returnUrl, 'cancel'),
      },
      {
        idempotencyKey: checkoutSessionIdempotencyKey({
          userId: uid,
          plan,
          previousCheckoutSessionId: currentSubscription.stripeCheckoutSessionId,
        }),
      },
    );

    await updateUserSubscription(uid, {
      ...buildSubscriptionPatch({
        plan,
        status: 'inactive',
        stripeCustomerId: customerId,
        stripeCheckoutSessionId: session.id,
        stripePriceId: useCatalogPrice ? configuredPriceId : null,
      }),
    });

    return {
      checkoutUrl: session.url,
      isSandboxCheckout: false,
      plan,
    };
  },
);

const syncSubscriptionStatus = onCall(
  callableWithSecrets(BILLING_SECRETS),
  async (request) => {
    const uid = assertAuthenticated(request);
    const userData = await getUserDoc(uid);
    const subscription = userData.subscription || {};
    const stripeSubscriptionId = subscription.stripeSubscriptionId;

    if (!stripeSubscriptionId) {
      if (isFreeAccessSubscription(subscription)) {
        return { subscription: subscription };
      }
      return { subscription: subscription };
    }

    if (isSimulatedStripeResourceId(stripeSubscriptionId)) {
      return { subscription: subscription };
    }

    const stripe = getStripe();
    const stripeSubscription = await stripe.subscriptions.retrieve(
      stripeSubscriptionId,
    );
    await applyStripeSubscriptionToUser(
      uid,
      stripeSubscription,
      subscription.plan || 'pro',
    );

    const updated = await getUserDoc(uid);
    return { subscription: updated.subscription || {} };
  },
);

const completeSandboxSubscription = onCall(
  callableWithSecrets(BILLING_SECRETS),
  async (request) => {
    const uid = assertAuthenticated(request);
    if (!isStripeTestMode()) {
      throw new HttpsError(
        'failed-precondition',
        'Sandbox disponível apenas com chave de teste.',
      );
    }

    const now = new Date();
    const accessEndsAt = new Date(now);
    accessEndsAt.setMonth(accessEndsAt.getMonth() + 1);

    const patch = buildSubscriptionPatch({
      plan: 'pro',
      status: 'active',
      stripeCustomerId: `sandbox_cus_${uid}`,
      stripeSubscriptionId: `sandbox_sub_${uid}_${Date.now()}`,
      currentPeriodEnd: accessEndsAt,
    });

    await updateUserSubscription(uid, patch);
    return { subscription: patch };
  },
);

const cancelSubscription = onCall(
  callableWithSecrets(BILLING_SECRETS),
  async (request) => {
    const uid = assertAuthenticated(request);
    const userData = await getUserDoc(uid);
    const subscription = userData.subscription || {};
    const stripeSubscriptionId = subscription.stripeSubscriptionId;

    if (isFreeAccessSubscription(subscription)) {
      throw new HttpsError(
        'failed-precondition',
        'Acesso cortesia não pode ser cancelado pelo app.',
      );
    }

    if (!stripeSubscriptionId) {
      throw new HttpsError('failed-precondition', 'Nenhuma assinatura ativa.');
    }

    if (isSimulatedStripeResourceId(stripeSubscriptionId)) {
      const patch = buildSubscriptionPatch({
        plan: subscription.plan || 'pro',
        status: 'canceled',
        stripeCustomerId: subscription.stripeCustomerId,
        stripeSubscriptionId,
      });
      await updateUserSubscription(uid, patch);
      return { subscription: patch, canceledAtPeriodEnd: true };
    }

    const stripe = getStripe();
    const updated = await stripe.subscriptions.update(
      stripeSubscriptionId,
      { cancel_at_period_end: true },
      {
        idempotencyKey: subscriptionCancelAtPeriodEndKey(stripeSubscriptionId),
      },
    );

    await applyStripeSubscriptionToUser(
      uid,
      updated,
      subscription.plan || 'pro',
    );

    const refreshed = await getUserDoc(uid);
    return {
      subscription: refreshed.subscription || {},
      canceledAtPeriodEnd: true,
    };
  },
);

const stripeBillingWebhook = onRequest(
  {
    region: 'southamerica-east1',
    secrets: BILLING_SECRETS,
  },
  async (req, res) => {
    if (req.method !== 'POST') {
      res.status(405).send('Method Not Allowed');
      return;
    }

    const stripe = getStripe();
    const signature = req.headers['stripe-signature'];
    let event;

    try {
      event = stripe.webhooks.constructEvent(
        req.rawBody,
        signature,
        stripeWebhookSecret.value(),
      );
    } catch (error) {
      console.error('Webhook signature error', error);
      res.status(400).send(`Webhook Error: ${error.message}`);
      return;
    }

    const eventRef = getFirestore().collection('billing_events').doc(event.id);
    const existing = await eventRef.get();
    if (existing.exists) {
      res.json({ received: true, duplicate: true });
      return;
    }

    try {
      switch (event.type) {
        case 'checkout.session.completed': {
          const session = event.data.object;
          const uid = session.client_reference_id || session.metadata?.userId;
          if (!uid) break;

          if (session.subscription) {
            const stripeSubscription = await stripe.subscriptions.retrieve(
              session.subscription,
            );
            await applyStripeSubscriptionToUser(
              uid,
              stripeSubscription,
              session.metadata?.plan || 'pro',
            );
          }
          break;
        }
        case 'customer.subscription.created':
        case 'customer.subscription.updated':
        case 'customer.subscription.deleted': {
          const stripeSubscription = event.data.object;
          const uid = await resolveUserIdFromStripeSubscription(
            stripeSubscription,
          );
          if (!uid) break;
          await applyStripeSubscriptionToUser(
            uid,
            stripeSubscription,
            stripeSubscription.metadata?.plan || 'pro',
          );
          break;
        }
        case 'invoice.paid': {
          const invoice = event.data.object;
          if (!invoice.subscription) break;
          const stripeSubscription = await stripe.subscriptions.retrieve(
            invoice.subscription,
          );
          const uid = await resolveUserIdFromStripeSubscription(
            stripeSubscription,
          );
          if (!uid) break;
          await applyStripeSubscriptionToUser(
            uid,
            stripeSubscription,
            stripeSubscription.metadata?.plan || 'pro',
          );
          break;
        }
        case 'invoice.payment_failed': {
          const invoice = event.data.object;
          if (!invoice.subscription) break;
          const stripeSubscription = await stripe.subscriptions.retrieve(
            invoice.subscription,
          );
          const uid = await resolveUserIdFromStripeSubscription(
            stripeSubscription,
          );
          if (!uid) break;
          await updateUserSubscription(uid, {
            plan: stripeSubscription.metadata?.plan || 'pro',
            status: 'pastDue',
            stripeCustomerId:
              typeof stripeSubscription.customer === 'string'
                ? stripeSubscription.customer
                : stripeSubscription.customer?.id,
            stripeSubscriptionId: stripeSubscription.id,
          });
          break;
        }
        default:
          break;
      }

      await eventRef.set({
        type: event.type,
        processedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      res.json({ received: true });
    } catch (error) {
      console.error('Webhook processing error', error);
      res.status(500).send('Webhook handler failed');
    }
  },
);

module.exports = {
  getPlanPricing,
  createSubscription,
  syncSubscriptionStatus,
  completeSandboxSubscription,
  cancelSubscription,
  stripeBillingWebhook,
  getUserDoc,
  updateUserSubscription,
  isSimulatedStripeResourceId,
};
