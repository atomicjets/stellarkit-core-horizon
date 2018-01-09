#!/bin/bash

set -e

export STELLAR_HOME="/opt/stellar"

export HORIZ_ENV="$STELLAR_HOME/horizon.env"
if [ $TESTNET -gt 0 ]
then
  export HORIZ_ENV="$STELLAR_HOME/horizon-testnet.env"
fi

function main() {
  echo ""
  echo "Starting Horizon"
  echo ""

  build-config /configs/horizon.env > $STELLAR_HOME/horizon.env
  build-config /configs/horizon-testnet.env > $STELLAR_HOME/horizon-testnet.env

  build-config /configs/.pgpass > /root/.pgpass
  chmod 600 /root/.pgpass

  init_horizon

  /launch
}

function init_horizon() {
  if [ -f $STELLAR_HOME/.horizon-initialized ]
  then
    echo "horizon: already initialized"
    return 0
  fi

  source $HORIZ_ENV
  horizon db init

  touch $STELLAR_HOME/.horizon-initialized
}

main