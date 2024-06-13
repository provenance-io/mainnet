#!/bin/bash
set -ex

# !!!!!!!!!!!!! Node Sync Processes !!!!!!!!!!!!!!!!!

# if previous step not complete then exit
if [ ! -f "./v1.16.0-done" ]; then exit 0; fi

# if we are already done here then don't run this file again
if [ -f "./v1.17.1-done" ]; then exit 0; fi

# look for the proper software binary, if not found then build it.
if [ ! -f "./software/v1.17.1/provenanced" ]; then

    pushd ./software/source
    git checkout v1.17.1
    make clean build
    mkdir -p ../v1.17.1/
    cp ./build/* ../v1.17.1
    popd

fi;

# 13736000     saffron          v1.17.1
./software/v1.17.1/provenanced pre-upgrade --home="./node"
./software/v1.17.1/provenanced --home="./node" start --log_level=warn --halt-height=15727300
rm -rf ./node/data/wasm/wasm/cache
tar czf ./archive/15727300-1.17.1.tar.gz ./node/config/genesis.json ./node/config/*.toml ./node/data
./software/v1.17.1/provenanced --home="./node" start --log_level=warn # run until upgrade halts node

touch ./v1.17.1-done
