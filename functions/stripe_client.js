const Stripe = require('stripe');
const { defineSecret, defineString } = require('firebase-functions/params');

const stripeSecretKey = defineSecret('STRIPE_SECRET_KEY');
const stripeWebhookSecret = defineSecret('STRIPE_WEBHOOK_SECRET');
const stripeProPriceId = defineString('STRIPE_PRO_PRICE_ID', { default: '' });

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

function getStripeProPriceId() {
  return String(stripeProPriceId.value() || '').trim();
}

module.exports = {
  stripeSecretKey,
  stripeWebhookSecret,
  stripeProPriceId,
  getStripe,
  isStripeTestMode,
  getStripeProPriceId,
};
