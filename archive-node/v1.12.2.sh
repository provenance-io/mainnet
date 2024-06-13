#!/bin/bash
set -ex

# !!!!!!!!!!!!! Node Sync Processes !!!!!!!!!!!!!!!!!

# if previous step not complete then exit
if [ ! -f "./v1.11.1-done" ]; then exit 0; fi

# if we are already done here then don't run this file again
if [ -f "./v1.12.2-done" ]; then exit 0; fi

# look for the proper software binary, if not found then build it.
if [ ! -f "./software/v1.12.2/provenanced" ]; then

    pushd ./software/source
    git checkout v1.12.2
    make clean build
    mkdir -p ../v1.12.2/
    cp ./build/* ../v1.12.2
    popd

fi;

# 7334444      neoncarrot       v1.12.2
./software/v1.12.2/provenanced --home="./node" start --log_level=warn --halt-height=8485505
rm -rf ./data/wasm/wasm/cache
tar czf ./archive/8485505-1.12.2.tar.gz ./node/config/genesis.json ./node/config/*.toml ./node/data
./software/v1.12.2/provenanced --home="./node" start --log_level=warn # run until upgrade halts node

touch ./v1.12.2-done
