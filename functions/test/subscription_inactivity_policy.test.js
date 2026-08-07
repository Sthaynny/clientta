const test = require('node:test');
const assert = require('node:assert/strict');
const {
  INACTIVITY_POLICY_MONTHS,
  resolveLastActivityAt,
  shouldCancelForInactivity,
  isInactiveSince,
} = require('../subscription_inactivity_policy');

test('resolveLastActivityAt prefers lastActivityAt over subscription.updatedAt', () => {
  const lastActivityAt = new Date('2026-01-10T12:00:00.000Z');
  const resolved = resolveLastActivityAt({
    lastActivityAt,
    subscription: { updatedAt: '2026-02-01T12:00:00.000Z' },
    createdAt: new Date('2025-12-01T12:00:00.000Z'),
  });

  assert.equal(resolved.toISOString(), lastActivityAt.toISOString());
});

test('resolveLastActivityAt falls back to subscription.updatedAt', () => {
  const updatedAt = '2026-02-01T12:00:00.000Z';
  const resolved = resolveLastActivityAt({
    subscription: { updatedAt },
    createdAt: new Date('2025-12-01T12:00:00.000Z'),
  });

  assert.equal(resolved.toISOString(), new Date(updatedAt).toISOString());
});

test('isInactiveSince returns true after inactivity window', () => {
  const referenceDate = new Date('2026-08-07T12:00:00.000Z');
  const lastActivityAt = new Date('2026-03-01T12:00:00.000Z');

  assert.equal(isInactiveSince(lastActivityAt, referenceDate), true);
});

test('isInactiveSince returns false inside inactivity window', () => {
  const referenceDate = new Date('2026-08-07T12:00:00.000Z');
  const lastActivityAt = new Date('2026-07-01T12:00:00.000Z');

  assert.equal(isInactiveSince(lastActivityAt, referenceDate), false);
});

test('shouldCancelForInactivity ignores non-active subscriptions', () => {
  const referenceDate = new Date('2026-08-07T12:00:00.000Z');
  const shouldCancel = shouldCancelForInactivity(
    {
      subscription: { status: 'canceled' },
      lastActivityAt: new Date('2026-01-01T12:00:00.000Z'),
    },
    referenceDate,
  );

  assert.equal(shouldCancel, false);
});

test('shouldCancelForInactivity cancels active subscriptions after window', () => {
  const referenceDate = new Date('2026-08-07T12:00:00.000Z');
  const shouldCancel = shouldCancelForInactivity(
    {
      subscription: { status: 'active' },
      lastActivityAt: new Date('2026-01-01T12:00:00.000Z'),
    },
    referenceDate,
  );

  assert.equal(shouldCancel, true);
});

test('policy window is configured for two months', () => {
  assert.equal(INACTIVITY_POLICY_MONTHS, 2);
});
