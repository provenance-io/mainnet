#!/bin/bash
set -ex

# !!!!!!!!!!!!! Node Sync Processes !!!!!!!!!!!!!!!!!

# if previous step not complete then exit
if [ ! -f "./v1.10.0-done" ]; then exit 0; fi

# if we are already done here then don't run this file again
if [ -f "./v1.11.1-done" ]; then exit 0; fi

# look for the proper software binary, if not found then build it.
if [ ! -f "./software/v1.11.1/provenanced" ]; then

    pushd ./software/source
    git checkout v1.11.1
    make clean build
    mkdir -p ../v1.11.1/
    cp ./build/* ../v1.11.1
    popd

fi;

# 6512577      mango            v1.11.1
./software/v1.11.1/provenanced --home="./node" start --log_level=warn --halt-height=7334400
rm -rf ./data/wasm/wasm/cache
tar czf ./archive/7334400-1.11.1.tar.gz ./node/config/genesis.json ./node/config/*.toml ./node/data
./software/v1.11.1/provenanced --home="./node" start --log_level=warn # run until upgrade halts node

touch ./v1.11.1-done
