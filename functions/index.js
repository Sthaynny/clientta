const admin = require('firebase-admin');
const billing = require('./billing');

if (!admin.apps.length) {
  admin.initializeApp();
}

exports.getPlanPricing = billing.getPlanPricing;
exports.createSubscription = billing.createSubscription;
exports.syncSubscriptionStatus = billing.syncSubscriptionStatus;
exports.completeSandboxSubscription = billing.completeSandboxSubscription;
exports.cancelSubscription = billing.cancelSubscription;
exports.stripeBillingWebhook = billing.stripeBillingWebhook;
