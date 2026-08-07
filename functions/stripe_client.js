const Stripe = require('stripe');
const { defineSecret } = require('firebase-functions/params');

const stripeSecretKey = defineSecret('STRIPE_SECRET_KEY');
const stripeWebhookSecret = defineSecret('STRIPE_WEBHOOK_SECRET');

function getStripe() {
  return new Stripe(stripeSecretKey.value(), {
    apiVersion: '2026-05-27.dahlia',
  });
}

function isStripeTestMode() {
  const secretKey = String(stripeSecretKey.value() || '');
  return (
    secretKey.startsWith('sk_test_') || secretKey.startsWith('rk_test_')
  );
}

module.exports = {
  stripeSecretKey,
  stripeWebhookSecret,
  getStripe,
  isStripeTestMode,
};
