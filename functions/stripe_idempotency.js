function stripeIdempotencyKey(...segments) {
  return segments
    .map((segment) => String(segment ?? '').trim())
    .filter(Boolean)
    .join('_')
    .replace(/[^a-zA-Z0-9_-]/g, '_')
    .slice(0, 255);
}

function checkoutSessionIdempotencyKey({ userId, plan, previousCheckoutSessionId = null }) {
  const seed = previousCheckoutSessionId
    ? `retry_${previousCheckoutSessionId}`
    : plan;
  return stripeIdempotencyKey('clientta_cs', userId, seed);
}

function stripeCustomerIdempotencyKey(userId) {
  return stripeIdempotencyKey('clientta_cus', userId);
}

function subscriptionCancelAtPeriodEndKey(stripeSubscriptionId) {
  return stripeIdempotencyKey('clientta_cancel_eop', stripeSubscriptionId);
}

module.exports = {
  stripeIdempotencyKey,
  checkoutSessionIdempotencyKey,
  stripeCustomerIdempotencyKey,
  subscriptionCancelAtPeriodEndKey,
};
