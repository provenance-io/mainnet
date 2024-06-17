#!/bin/bash
set -ex

# !!!!!!!!!!!!! Node Sync Processes !!!!!!!!!!!!!!!!!

# if previous step not complete then exit
if [ ! -f "./v1.0.1-done" ]; then exit 0; fi

# if we are already done here then don't run this file again
if [ -f "./v1.3.1-done" ]; then exit 0; fi

# look for the proper software binary, if not found then build it.
if [ ! -f "./software/v1.3.1/provenanced" ]; then

    pushd ./software/source
    git checkout v1.3.1
    make clean build
    mkdir -p ../v1.3.1/
    cp ./build/* ../v1.3.1
    popd

fi;


# 352000       bluetiful        v1.3.1
./software/v1.3.1/provenanced --home="./node" start --halt-height=940450 --log_level=warn
rm -rf ./node/data/wasm/wasm/cache
tar czf ./archive/940450-1.3.1.tar.gz ./node/config/genesis.json ./node/config/*.toml ./node/data

./software/v1.3.1/provenanced --home="./node" start --log_level=warn || true  # run until upgrade halts node, don't exit script on upgrade panic

touch ./v1.3.1-done
