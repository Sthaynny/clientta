const test = require('node:test');
const assert = require('node:assert/strict');
const {
  normalizeEmail,
  applyPercentDiscount,
  buildBillingEntitlementCache,
  buildFreeAccessSubscriptionPatch,
  isFreeAccessSubscription,
} = require('../billing_entitlements');
const { resolvePlanPriceCents } = require('../pricing');

test('normalizeEmail lowercases and trims', () => {
  assert.equal(normalizeEmail('  User@Example.COM '), 'user@example.com');
});

test('applyPercentDiscount calculates rounded price', () => {
  assert.equal(applyPercentDiscount(2990, 50), 1495);
  assert.equal(applyPercentDiscount(2990, 100), 0);
});

test('buildBillingEntitlementCache returns free access pricing', () => {
  const cache = buildBillingEntitlementCache({
    freeAccess: { email: 'user@example.com', note: 'Beta' },
    discount: null,
  });

  assert.equal(cache.type, 'free');
  assert.equal(cache.effectiveMonthlyPriceCents, 0);
  assert.equal(cache.note, 'Beta');
});

test('buildBillingEntitlementCache returns discount pricing', () => {
  const cache = buildBillingEntitlementCache({
    freeAccess: null,
    discount: { email: 'user@example.com', percentOff: 25, note: null },
  });

  assert.equal(cache.type, 'discount');
  assert.equal(cache.percentOff, 25);
  assert.equal(
    cache.effectiveMonthlyPriceCents,
    applyPercentDiscount(resolvePlanPriceCents('pro'), 25),
  );
});

test('buildFreeAccessSubscriptionPatch marks complimentary access', () => {
  const patch = buildFreeAccessSubscriptionPatch();

  assert.equal(patch.plan, 'pro');
  assert.equal(patch.status, 'active');
  assert.equal(patch.entitlementSource, 'free_access');
  assert.equal(patch.stripeSubscriptionId, null);
});

test('isFreeAccessSubscription detects complimentary subscriptions', () => {
  assert.equal(
    isFreeAccessSubscription({ entitlementSource: 'free_access' }),
    true,
  );
  assert.equal(
    isFreeAccessSubscription({ entitlementSource: 'stripe' }),
    false,
  );
});
