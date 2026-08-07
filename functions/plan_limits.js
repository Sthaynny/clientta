// Espelha lib/core/plan/plan_access_policy.dart e docs/features/README.md
const FREE_PLAN_LIMITS = {
  maxActiveAppointments: 50,
  maxActiveSeries: 3,
};

function getFreePlanLimitsResponse() {
  return { ...FREE_PLAN_LIMITS };
}

module.exports = {
  FREE_PLAN_LIMITS,
  getFreePlanLimitsResponse,
};
