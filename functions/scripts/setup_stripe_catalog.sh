#!/usr/bin/env bash
# Provisiona produto e preço Clientta Pro no Stripe (test ou live).
# Requer: stripe CLI autenticado (`stripe login`).
#
# Uso:
#   ./scripts/setup_stripe_catalog.sh test
#   ./scripts/setup_stripe_catalog.sh live

set -euo pipefail

MODE="${1:-test}"
LOOKUP_KEY="clientta_pro_monthly"
PRODUCT_NAME="Clientta Pro"
PRICE_CENTS=2990
CURRENCY="brl"

if [[ "$MODE" == "live" ]]; then
  STRIPE_FLAG="--live"
else
  STRIPE_FLAG=""
fi

echo "==> Stripe mode: $MODE"

existing_price="$(stripe prices list $STRIPE_FLAG --lookup-keys "$LOOKUP_KEY" --limit 1 --format json | node -e "const d=JSON.parse(require('fs').readFileSync(0,'utf8')); console.log(d.data?.[0]?.id||'')")"

if [[ -n "$existing_price" ]]; then
  echo "Price já existe: $existing_price (lookup_key=$LOOKUP_KEY)"
  PRICE_ID="$existing_price"
else
  echo "==> Criando produto..."
  product_id="$(stripe products create $STRIPE_FLAG \
    --name "$PRODUCT_NAME" \
    --description "Assinatura Pro — sync na nuvem e limites elevados." \
    --metadata app=clientta,plan=pro \
    --format json | node -e "const d=JSON.parse(require('fs').readFileSync(0,'utf8')); console.log(d.id)")"

  echo "==> Criando preço mensal R$ 29,90..."
  PRICE_ID="$(stripe prices create $STRIPE_FLAG \
    --product "$product_id" \
    --currency "$CURRENCY" \
    --unit-amount "$PRICE_CENTS" \
    --recurring interval=month \
    --lookup-key "$LOOKUP_KEY" \
    --format json | node -e "const d=JSON.parse(require('fs').readFileSync(0,'utf8')); console.log(d.id)")"
fi

echo ""
echo "STRIPE_PRO_PRICE_ID=$PRICE_ID"
echo ""
echo "Próximos passos:"
echo "  firebase functions:secrets:set STRIPE_SECRET_KEY"
echo "  firebase functions:secrets:set STRIPE_WEBHOOK_SECRET"
echo "  firebase functions:config:set stripe.pro_price_id=$PRICE_ID"
echo "  # ou export STRIPE_PRO_PRICE_ID no deploy / .env"
