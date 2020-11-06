#!/bin/bash
set -e

# setup script to stack sats
>/src/stack-sats.sh
echo "#/bin/bash" >> /src/stack-sats.sh
echo "set -e" >> /src/stack-sats.sh
echo "export NODE_OPTIONS=\"--no-deprecation\"" >> /src/stack-sats.sh
echo "export KRAKEN_API_KEY=$KRAKEN_API_KEY" >> /src/stack-sats.sh
echo "export KRAKEN_API_SECRET=$KRAKEN_API_SECRET" >> /src/stack-sats.sh
echo "export KRAKEN_API_FIAT=$KRAKEN_API_FIAT" >> /src/stack-sats.sh
echo "export KRAKEN_BUY_AMOUNT=$KRAKEN_BUY_AMOUNT" >> /src/stack-sats.sh
echo "export TEST=$TEST" >> /src/stack-sats.sh
cat /src/stack-sats-templ.sh >> /src/stack-sats.sh
chmod +x /src/stack-sats.sh

# setup script to withdraw sats
>/src/withdraw-sats.sh
echo "#/bin/bash" >> /src/withdraw-sats.sh
echo "set -e" >> /src/withdraw-sats.sh
echo "export NODE_OPTIONS=\"--no-deprecation\"" >> /src/withdraw-sats.sh
echo "export KRAKEN_API_KEY=$KRAKEN_API_KEY" >> /src/withdraw-sats.sh
echo "export KRAKEN_API_SECRET=$KRAKEN_API_SECRET" >> /src/withdraw-sats.sh
echo "export KRAKEN_API_FIAT=$KRAKEN_API_FIAT" >> /src/withdraw-sats.sh
echo "export KRAKEN_MAX_REL_FEE=$KRAKEN_MAX_REL_FEE" >> /src/withdraw-sats.sh
echo "export KRAKEN_WITHDRAW_KEY=$KRAKEN_WITHDRAW_KEY" >> /src/withdraw-sats.sh
cat /src/withdraw-sats-templ.sh >> /src/withdraw-sats.sh
chmod +x /src/withdraw-sats.sh

>/etc/cron.d/stack-cron
echo "$CRON_STACK root /src/stack-sats.sh 2>&1 | /src/ts.sh >> /var/log/cron.log" >> /etc/cron.d/stack-cron
echo -e "Buying crontab set to run with settings: $CRON_STACK\nBuying BTC for $KRAKEN_API_FIAT $KRAKEN_BUY_AMOUNT"

>/etc/cron.d/withdraw-cron
echo "$CRON_WDR root /src/withdraw-sats.sh 2>&1 | /src/ts.sh >> /var/log/cron.log" >> /etc/cron.d/withdraw-cron
echo -e "Withdrawing crontab set to run with settings: $CRON_WDR\nWithdraw all BTC, only if fee does not exceed $KRAKEN_MAX_REL_FEE%. Withdraw-key: $KRAKEN_WITHDRAW_KEY"

exec "$@"

