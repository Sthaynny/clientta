const admin = require('firebase-admin');
const { onSchedule } = require('firebase-functions/v2/scheduler');
const { onDocumentWritten } = require('firebase-functions/v2/firestore');
const { CALLABLE_OPTIONS } = require('./callable_options');
const {
  stripeSecretKey,
  getStripe,
  isStripeTestMode,
} = require('./stripe_client');
const { subscriptionCancelAtPeriodEndKey } = require('./stripe_idempotency');
const {
  shouldCancelForInactivity,
  INACTIVITY_POLICY_MONTHS,
} = require('./subscription_inactivity_policy');

const BILLING_SECRETS = [stripeSecretKey];

function getFirestore() {
  return admin.firestore();
}

function isSimulatedStripeResourceId(resourceId) {
  return String(resourceId || '').startsWith('sandbox_');
}

async function cancelSubscriptionForInactivity(uid, userData) {
  const subscription = userData.subscription || {};
  const stripeSubscriptionId = subscription.stripeSubscriptionId;

  if (!stripeSubscriptionId) {
    return { canceled: false, reason: 'missing_subscription_id' };
  }

  if (isSimulatedStripeResourceId(stripeSubscriptionId)) {
    await getFirestore()
      .collection('users')
      .doc(uid)
      .set(
        {
          subscription: {
            ...subscription,
            status: 'canceled',
            canceledReason: 'inactivity',
            canceledAt: new Date().toISOString(),
            updatedAt: new Date().toISOString(),
          },
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        { merge: true },
      );
    return { canceled: true, mode: 'sandbox' };
  }

  const stripe = getStripe();
  const updated = await stripe.subscriptions.update(
    stripeSubscriptionId,
    { cancel_at_period_end: true },
    {
      idempotencyKey: subscriptionCancelAtPeriodEndKey(stripeSubscriptionId),
    },
  );

  await getFirestore()
    .collection('users')
    .doc(uid)
    .set(
      {
        subscription: {
          ...subscription,
          status: updated.status === 'canceled' ? 'canceled' : 'active',
          canceledReason: 'inactivity',
          canceledAt: new Date().toISOString(),
          cancelAtPeriodEnd: true,
          accessEndsAt: updated.current_period_end
            ? new Date(updated.current_period_end * 1000).toISOString()
            : subscription.accessEndsAt || null,
          updatedAt: new Date().toISOString(),
        },
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

  return { canceled: true, mode: 'stripe' };
}

async function processInactiveSubscriptions() {
  const snapshot = await getFirestore().collection('users').get();
  const results = {
    scanned: snapshot.size,
    canceled: 0,
    skipped: 0,
    errors: 0,
  };

  for (const doc of snapshot.docs) {
    const userData = doc.data() || {};
    if (!shouldCancelForInactivity(userData)) {
      results.skipped += 1;
      continue;
    }

    try {
      const outcome = await cancelSubscriptionForInactivity(doc.id, userData);
      if (outcome.canceled) {
        results.canceled += 1;
        console.info('Canceled inactive subscription', {
          uid: doc.id,
          mode: outcome.mode,
        });
      } else {
        results.skipped += 1;
      }
    } catch (error) {
      results.errors += 1;
      console.error('Failed to cancel inactive subscription', {
        uid: doc.id,
        error,
      });
    }
  }

  return results;
}

const cancelInactiveSubscriptions = onSchedule(
  {
    ...CALLABLE_OPTIONS,
    schedule: '0 6 * * *',
    timeZone: 'America/Sao_Paulo',
    secrets: BILLING_SECRETS,
  },
  async () => {
    const results = await processInactiveSubscriptions();
    console.info('Inactive subscription sweep finished', {
      ...results,
      inactivityMonths: INACTIVITY_POLICY_MONTHS,
      stripeTestMode: isStripeTestMode(),
    });
  },
);

const trackUserActivityOnAppointmentWrite = onDocumentWritten(
  {
    document: 'users/{userId}/appointments/{appointmentId}',
    region: CALLABLE_OPTIONS.region,
  },
  async (event) => {
    if (!event.data?.after?.exists) {
      return;
    }

    const userId = event.params.userId;
    await getFirestore().collection('users').doc(userId).set(
      {
        lastActivityAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true },
    );
  },
);

module.exports = {
  cancelInactiveSubscriptions,
  trackUserActivityOnAppointmentWrite,
  processInactiveSubscriptions,
  cancelSubscriptionForInactivity,
};
