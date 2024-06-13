#!/bin/bash
set -ex

# if we are already done here then don't run this file again since it is destructive.
if [ -f "./v1.0.1-done" ]; then exit 0; fi

# look for the proper software binary, if not found then build it.
if [ ! -f "./software/v1.0.1/provenanced" ]; then

    # Setup a source checkout
    mkdir -p ./software/source # just in case
    rm -rf ./software/source # clear out any existing checkout
    git clone git@github.com:provenance-io/provenance.git ./software/source

    pushd ./software/source
    git checkout v1.0.1
    make clean build
    mkdir -p ../v1.0.1/
    cp ./build/* ../v1.0.1
    popd

fi;

# !!!!!!!!!!!!!!! Warning - Bad Times Ahead if you are not careful !!!!!!!!!!!!! 
rm -rf ./node/* ./archive/*

export PIO_P2P_SEEDS=$(curl -s https://raw.githubusercontent.com/cosmos/chain-registry/master/provenance/chain.json | jq -r '[foreach .peers.seeds[] as $item (""; "\($item.id)@\($item.address)")] | join(",")')

# !!!!!!!!!!!!!! Initial Setup and Configuration
mkdir -p ./node ./archive
./software/v1.0.1/provenanced --home="./node" init pio-mainnet-1

sed -i -r 's/pruning = "default"/pruning = "nothing"/' ./node/config/app.toml
sed -i -r 's/minimum-gas-prices=\"0.025nhash\"/minimum-gas-prices=\"1905nhash\"/' ./node/config/app.toml
sed -i -r "s/max_num_inbound_peers = 40/max_num_inbound_peers = 500/" ./node/config/config.toml
sed -i -r "s/seeds = \"\"/seeds = \"$PIO_P2P_SEEDS\"/" ./node/config/config.toml
sed -i -r "s/db_backend = \"goleveldb\"/db_backend = \"cleveldb\"/" ./node/config/config.toml

curl -s "https://raw.githubusercontent.com/provenance-io/mainnet/main/pio-mainnet-1/genesis.json" > ./node/config/genesis.json

./software/v1.0.1/provenanced --home="./node" unsafe-reset-all


# !!!!!!!!!!!!! Node Sync Process !!!!!!!!!!!!!!!!!

# 0            genesis          v1.0.1
./software/v1.0.1/provenanced --home="./node" start --halt-height=351990 --log_level=warn
rm -rf ./node/data/wasm/wasm/cache
tar czf ./archive/351990-1.0.1.tar.gz ./node/config/genesis.json ./node/config/*.toml ./node/data
./software/v1.0.1/provenanced --home="./node" start --log_level=warn # run until upgrade halts node

touch ./v1.0.1-done
