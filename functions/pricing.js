const PRO_MONTHLY_PRICE_CENTS = 2990;

const PLAN_CATALOG = {
  pro: {
    id: 'pro',
    name: 'Clientta Pro',
    monthlyPriceCents: PRO_MONTHLY_PRICE_CENTS,
    enabled: true,
  },
};

function formatBrlMonthly(cents) {
  const value = (cents / 100).toFixed(2).replace('.', ',');
  return `R$ ${value}/mês`;
}

function getPlanPricingResponse() {
  const pro = PLAN_CATALOG.pro;
  return {
    pro: {
      id: pro.id,
      name: pro.name,
      price: formatBrlMonthly(pro.monthlyPriceCents),
      monthlyPriceCents: pro.monthlyPriceCents,
      enabled: pro.enabled,
    },
  };
}

function resolvePlanPriceCents(planId) {
  const plan = PLAN_CATALOG[planId];
  if (!plan || !plan.enabled) {
    throw new Error(`plan_disabled:${planId}`);
  }
  return plan.monthlyPriceCents;
}

module.exports = {
  PLAN_CATALOG,
  getPlanPricingResponse,
  resolvePlanPriceCents,
};
