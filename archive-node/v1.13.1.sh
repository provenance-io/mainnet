#!/bin/bash
set -ex

# !!!!!!!!!!!!! Node Sync Processes !!!!!!!!!!!!!!!!!

# if previous step not complete then exit
if [ !  -f "./v1.12.2-done" ]; then exit 0; fi

# if we are already done here then don't run this file again
if [ -f "./v1.13.1-done" ]; then exit 0; fi

# look for the proper software binary, if not found then build it.
if [ ! -f "./software/v1.13.1/provenanced" ]; then

    pushd ./software/source
    git checkout v1.13.1
    make clean build
    mkdir -p ../v1.13.1/
    cp ./build/* ../v1.13.1
    popd

fi;

# Transistion away from cleveldb with this upgrade, ensure that the IAVL fast-sync is enabled
./software/v1.13.1/provenanced --home="./node" config set db_backend goleveldb
./software/v1.13.1/provenanced --home="./node" config set iavl-disable-fastnode false


# 8485555      ochre            v1.13.1
./software/v1.13.1/provenanced --home="./node" start --log_level=warn --halt-height=8485556 # restart now to deal with iavl upgrade
./software/v1.13.1/provenanced --home="./node" start --log_level=warn --halt-height=9828880 # run through 1.13.x blocks
rm -rf ./node/data/wasm/wasm/cache
tar czf ./archive/9828880-1.13.1.tar.gz ./node/config/genesis.json ./node/config/*.toml ./node/data
./software/v1.13.1/provenanced --home="./node" start --log_level=warn || true  # run until upgrade halts node, don't exit script on upgrade panic

touch ./v1.13.1-done
