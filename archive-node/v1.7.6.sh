#!/bin/bash
set -ex

# !!!!!!!!!!!!! Node Sync Processes !!!!!!!!!!!!!!!!!

# if previous step not complete then exit
if [ ! -f "./v1.6.0-done" ]; then exit 0; fi

# if we are already done here then don't run this file again
if [ -f "./v1.7.6-done" ]; then exit 0; fi

# look for the proper software binary, if not found then build it.
if [ ! -f "./software/v1.7.6/provenanced" ]; then

    pushd ./software/source
    git checkout v1.7.6
    make clean build
    mkdir -p ../v1.7.6/
    cp ./build/* ../v1.7.6
    popd

fi;

# 2641250      feldgrau         v1.7.6
./software/v1.7.6/provenanced --home="./node" start --log_level=warn --halt-height=4808390
rm -rf ./node/data/wasm/wasm/cache
tar czf ./archive/4808390-1.7.6.tar.gz ./node/config/genesis.json ./node/config/*.toml ./node/data
./software/v1.7.6/provenanced --home="./node" start --log_level=warn # run until upgrade halts node

touch ./v1.7.6-done
