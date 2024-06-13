#!/bin/bash
set -ex

# !!!!!!!!!!!!! Node Sync Processes !!!!!!!!!!!!!!!!!

# if previous step not complete then exit
if [ ! -f "./v1.8.2-done" ]; then exit 0; fi

# if we are already done here then don't run this file again
if [ -f "./v1.10.0-done" ]; then exit 0; fi

# look for the proper software binary, if not found then build it.
if [ ! -f "./software/v1.10.0/provenanced" ]; then

    pushd ./software/source
    git checkout v1.10.0
    make clean build
    mkdir -p ../v1.10.0/
    cp ./build/* ../v1.10.0
    popd

fi;

# 5689885      lava             v1.10.0
./software/v1.10.0/provenanced --home="./node" start --log_level=warn --halt-height=6512525
rm -rf ./node/data/wasm/wasm/cache
tar czf ./archive/6512525-1.10.0.tar.gz ./node/config/genesis.json ./node/config/*.toml ./node/data
./software/v1.10.0/provenanced --home="./node" start --log_level=warn # run until upgrade halts node

touch ./v1.10.0-done
