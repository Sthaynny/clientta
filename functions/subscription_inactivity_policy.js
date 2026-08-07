const INACTIVITY_POLICY_MONTHS = 2;

function addMonths(date, months) {
  const result = new Date(date);
  result.setMonth(result.getMonth() + months);
  return result;
}

function parseTimestamp(value) {
  if (!value) return null;
  if (typeof value.toDate === 'function') {
    return value.toDate();
  }
  if (value instanceof Date) {
    return value;
  }
  const parsed = new Date(value);
  return Number.isNaN(parsed.getTime()) ? null : parsed;
}

function resolveLastActivityAt(userData) {
  const lastActivityAt = parseTimestamp(userData?.lastActivityAt);
  if (lastActivityAt) {
    return lastActivityAt;
  }

  const subscriptionUpdatedAt = parseTimestamp(
    userData?.subscription?.updatedAt,
  );
  if (subscriptionUpdatedAt) {
    return subscriptionUpdatedAt;
  }

  const createdAt = parseTimestamp(userData?.createdAt);
  if (createdAt) {
    return createdAt;
  }

  return null;
}

function isSubscriptionEligibleForInactivityCheck(subscription) {
  const status = subscription?.status;
  return status === 'active' || status === 'trialing';
}

function isInactiveSince(lastActivityAt, referenceDate = new Date()) {
  if (!lastActivityAt) {
    return false;
  }

  const cutoff = addMonths(referenceDate, -INACTIVITY_POLICY_MONTHS);
  return lastActivityAt < cutoff;
}

function shouldCancelForInactivity(userData, referenceDate = new Date()) {
  const subscription = userData?.subscription || {};
  if (!isSubscriptionEligibleForInactivityCheck(subscription)) {
    return false;
  }

  if (subscription.canceledReason === 'inactivity') {
    return false;
  }

  const lastActivityAt = resolveLastActivityAt(userData);
  return isInactiveSince(lastActivityAt, referenceDate);
}

module.exports = {
  INACTIVITY_POLICY_MONTHS,
  addMonths,
  parseTimestamp,
  resolveLastActivityAt,
  isSubscriptionEligibleForInactivityCheck,
  isInactiveSince,
  shouldCancelForInactivity,
};
