#!/usr/bin/env bash

# No config dir yet, create it.
if [ ! -d "${PIO_HOME}/config" ]; then
  mkdir -p "${PIO_HOME}/config"
fi

# No data dir yet, create it.
if [ ! -d "${PIO_HOME}/data" ]; then
    mkdir "${PIO_HOME}/data"
fi

# No cosmovisor dir yet, create it.
if [ ! -d "${DAEMON_HOME}/cosmovisor" ]; then
  mkdir -p "${DAEMON_HOME}/cosmovisor/genesis/bin"
  cp /usr/bin/provenanced /usr/lib/libwasmvm.so "${DAEMON_HOME}/cosmovisor/genesis/bin/"
  ln -s "${DAEMON_HOME}/cosmovisor/genesis" "${DAEMON_HOME}/cosmovisor/current"
fi

# If custom genesis.json is not provided, use the default.
if [ ! -f "${PIO_HOME}/config/genesis.json" ]; then
  cp "/${CHAIN_ID}/genesis.json" "${PIO_HOME}/config/genesis.json"
fi

# If custom config.toml is not provided, use the default.
if [ ! -f "${PIO_HOME}/config/config.toml" ]; then
  cp "/${CHAIN_ID}/node-config.toml" "${PIO_HOME}/config/config.toml"
fi

# If custom app.toml is not provided, use the default.
if [ ! -f "${PIO_HOME}/config/app.toml" ]; then
  cp "/${CHAIN_ID}/node-app.toml" "${PIO_HOME}/config/app.toml"
fi

exec "$@"
