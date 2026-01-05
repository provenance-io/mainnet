#!/bin/bash
set -ex

# !!!!!!!!!!!!! Node Sync Processes !!!!!!!!!!!!!!!!!

# if previous step not complete then exit
if [ ! -f "./v1.15.2-done" ]; then exit 0; fi

# if we are already done here then don't run this file again
if [ -f "./v1.16.0-done" ]; then exit 0; fi

# look for the proper software binary, if not found then build it.
if [ ! -f "./software/v1.16.0/provenanced" ]; then

    pushd ./software/source
    git checkout v1.16.0
    make clean build
    mkdir -p ../v1.16.0/
    cp ./build/* ../v1.16.0
    popd

fi;

# 11842000     rust             v1.16.0
./software/v1.16.0/provenanced pre-upgrade --home="./node"
./software/v1.16.0/provenanced --home="./node" start --log_level=warn --halt-height=13735950
rm -rf ./node/data/wasm/wasm/cache
tar czf ./archive/13735950-1.16.0.tar.gz ./node/config/genesis.json ./node/config/*.toml ./node/data
./software/v1.16.0/provenanced --home="./node" start --log_level=warn || true  # run until upgrade halts node, don't exit script on upgrade panic

touch ./v1.16.0-done
