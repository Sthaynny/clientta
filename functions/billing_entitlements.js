const admin = require('firebase-admin');
const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { CALLABLE_OPTIONS } = require('./callable_options');
const {
  PLAN_CATALOG,
  formatBrlMonthly,
  resolvePlanPriceCents,
} = require('./pricing');

const FREE_ACCESS_COLLECTION = 'billing_free_access';
const DISCOUNTS_COLLECTION = 'billing_discounts';
const ENTITLEMENT_SOURCE_FREE_ACCESS = 'free_access';

function getFirestore() {
  return admin.firestore();
}

function normalizeEmail(email) {
  return String(email || '').trim().toLowerCase();
}

function isEntitlementActive(data) {
  if (!data || data.enabled === false) {
    return false;
  }

  const expiresAt = data.expiresAt;
  if (!expiresAt) {
    return true;
  }

  const expiryDate =
    typeof expiresAt.toDate === 'function'
      ? expiresAt.toDate()
      : new Date(expiresAt);
  return expiryDate.getTime() > Date.now();
}

async function lookupFreeAccess(email) {
  const normalized = normalizeEmail(email);
  if (!normalized) {
    return null;
  }

  const snapshot = await getFirestore()
    .collection(FREE_ACCESS_COLLECTION)
    .doc(normalized)
    .get();

  if (!snapshot.exists) {
    return null;
  }

  const data = snapshot.data() || {};
  if (!isEntitlementActive(data)) {
    return null;
  }

  return {
    email: normalized,
    note: data.note || null,
  };
}

async function lookupDiscount(email) {
  const normalized = normalizeEmail(email);
  if (!normalized) {
    return null;
  }

  const snapshot = await getFirestore()
    .collection(DISCOUNTS_COLLECTION)
    .doc(normalized)
    .get();

  if (!snapshot.exists) {
    return null;
  }

  const data = snapshot.data() || {};
  if (!isEntitlementActive(data)) {
    return null;
  }

  const percentOff = Number(data.percentOff);
  if (!Number.isFinite(percentOff) || percentOff <= 0 || percentOff > 100) {
    return null;
  }

  return {
    email: normalized,
    percentOff: Math.round(percentOff),
    note: data.note || null,
  };
}

function applyPercentDiscount(basePriceCents, percentOff) {
  const discounted = Math.round(basePriceCents * (100 - percentOff) / 100);
  return Math.max(discounted, 0);
}

function buildBillingEntitlementCache({ freeAccess, discount, planId = 'pro' }) {
  const basePriceCents = resolvePlanPriceCents(planId);

  if (freeAccess) {
    return {
      type: 'free',
      percentOff: null,
      baseMonthlyPriceCents: basePriceCents,
      effectiveMonthlyPriceCents: 0,
      note: freeAccess.note,
      syncedAt: new Date().toISOString(),
    };
  }

  if (discount) {
    const effectiveMonthlyPriceCents = applyPercentDiscount(
      basePriceCents,
      discount.percentOff,
    );
    return {
      type: 'discount',
      percentOff: discount.percentOff,
      baseMonthlyPriceCents: basePriceCents,
      effectiveMonthlyPriceCents,
      note: discount.note,
      syncedAt: new Date().toISOString(),
    };
  }

  return {
    type: 'none',
    percentOff: null,
    baseMonthlyPriceCents: basePriceCents,
    effectiveMonthlyPriceCents: basePriceCents,
    note: null,
    syncedAt: new Date().toISOString(),
  };
}

function buildFreeAccessSubscriptionPatch(existingSubscription = {}) {
  return {
    plan: 'pro',
    status: 'active',
    entitlementSource: ENTITLEMENT_SOURCE_FREE_ACCESS,
    stripeCustomerId: existingSubscription.stripeCustomerId || null,
    stripeSubscriptionId: null,
    stripeCheckoutSessionId: null,
    accessEndsAt: null,
    updatedAt: new Date().toISOString(),
  };
}

function buildRevokedFreeAccessSubscriptionPatch(existingSubscription = {}) {
  return {
    plan: 'free',
    status: 'inactive',
    entitlementSource: null,
    stripeCustomerId: existingSubscription.stripeCustomerId || null,
    stripeSubscriptionId: null,
    stripeCheckoutSessionId: null,
    accessEndsAt: null,
    updatedAt: new Date().toISOString(),
  };
}

function hasActiveStripeSubscription(subscription = {}, isSimulatedStripeResourceId) {
  const stripeSubscriptionId = subscription.stripeSubscriptionId;
  if (!stripeSubscriptionId) {
    return false;
  }
  return !isSimulatedStripeResourceId(stripeSubscriptionId);
}

function isFreeAccessSubscription(subscription = {}) {
  return subscription.entitlementSource === ENTITLEMENT_SOURCE_FREE_ACCESS;
}

async function resolveEntitlementsForEmail(email, planId = 'pro') {
  const [freeAccess, discount] = await Promise.all([
    lookupFreeAccess(email),
    lookupDiscount(email),
  ]);

  const billingEntitlement = buildBillingEntitlementCache({
    freeAccess,
    discount,
    planId,
  });

  return {
    freeAccess,
    discount,
    billingEntitlement,
  };
}

function buildPersonalizedPlanPricing(planId, billingEntitlement) {
  const plan = PLAN_CATALOG[planId];
  if (!plan) {
    throw new Error(`plan_disabled:${planId}`);
  }

  const effectiveMonthlyPriceCents =
    billingEntitlement?.effectiveMonthlyPriceCents ?? plan.monthlyPriceCents;
  const percentOff = billingEntitlement?.percentOff ?? null;

  return {
    id: plan.id,
    name: plan.name,
    price: formatBrlMonthly(effectiveMonthlyPriceCents),
    monthlyPriceCents: effectiveMonthlyPriceCents,
    baseMonthlyPriceCents: plan.monthlyPriceCents,
    percentOff,
    enabled: plan.enabled,
    hasFreeAccess: billingEntitlement?.type === 'free',
    hasDiscount: billingEntitlement?.type === 'discount',
  };
}

async function syncUserEntitlements({
  uid,
  email,
  getUserDoc,
  updateUserSubscription,
  isSimulatedStripeResourceId,
}) {
  const normalized = normalizeEmail(email);
  if (!normalized) {
    throw new HttpsError('failed-precondition', 'E-mail do usuário indisponível.');
  }

  const { freeAccess, discount, billingEntitlement } =
    await resolveEntitlementsForEmail(normalized);

  const userRef = getFirestore().collection('users').doc(uid);
  await userRef.set(
    {
      billingEntitlement,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    { merge: true },
  );

  const userData = await getUserDoc(uid);
  const subscription = userData.subscription || {};

  if (hasActiveStripeSubscription(subscription, isSimulatedStripeResourceId)) {
    return {
      subscription,
      billingEntitlement,
      appliedFreeAccess: false,
    };
  }

  if (freeAccess) {
    const patch = buildFreeAccessSubscriptionPatch(subscription);
    await updateUserSubscription(uid, patch);
    return {
      subscription: patch,
      billingEntitlement,
      appliedFreeAccess: true,
    };
  }

  if (isFreeAccessSubscription(subscription)) {
    const patch = buildRevokedFreeAccessSubscriptionPatch(subscription);
    await updateUserSubscription(uid, patch);
    return {
      subscription: patch,
      billingEntitlement,
      appliedFreeAccess: false,
      revokedFreeAccess: true,
    };
  }

  return {
    subscription,
    billingEntitlement,
    appliedFreeAccess: false,
  };
}

const syncEntitlements = onCall(CALLABLE_OPTIONS, async (request) => {
  if (!request.auth?.uid) {
    throw new HttpsError('unauthenticated', 'Faça login para continuar.');
  }

  const billing = require('./billing');
  const result = await syncUserEntitlements({
    uid: request.auth.uid,
    email: request.auth.token.email,
    getUserDoc: billing.getUserDoc,
    updateUserSubscription: billing.updateUserSubscription,
    isSimulatedStripeResourceId: billing.isSimulatedStripeResourceId,
  });

  return result;
});

module.exports = {
  FREE_ACCESS_COLLECTION,
  DISCOUNTS_COLLECTION,
  ENTITLEMENT_SOURCE_FREE_ACCESS,
  normalizeEmail,
  lookupFreeAccess,
  lookupDiscount,
  applyPercentDiscount,
  buildBillingEntitlementCache,
  buildFreeAccessSubscriptionPatch,
  buildRevokedFreeAccessSubscriptionPatch,
  hasActiveStripeSubscription,
  isFreeAccessSubscription,
  resolveEntitlementsForEmail,
  buildPersonalizedPlanPricing,
  syncUserEntitlements,
  syncEntitlements,
};
