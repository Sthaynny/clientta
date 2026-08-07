const test = require('node:test');
const assert = require('node:assert/strict');
const {
  getPlanPricingResponse,
  resolvePlanPriceCents,
} = require('../pricing');

test('getPlanPricingResponse returns pro plan metadata', () => {
  const pricing = getPlanPricingResponse();

  assert.equal(pricing.pro.id, 'pro');
  assert.equal(pricing.pro.enabled, true);
  assert.match(pricing.pro.price, /^R\$ /);
  assert.equal(pricing.freeLimits.maxActiveAppointments, 50);
  assert.equal(pricing.freeLimits.maxActiveSeries, 3);
});

test('resolvePlanPriceCents returns configured monthly price', () => {
  assert.equal(resolvePlanPriceCents('pro'), 2990);
});

test('resolvePlanPriceCents rejects disabled plans', () => {
  assert.throws(() => resolvePlanPriceCents('unknown'), /plan_disabled/);
});
