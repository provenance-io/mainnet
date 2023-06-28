# pio-mainnet-1

<!--
There are external scripts that depend on the files in here; moving them
would break those scripts, and we don't want to do that.

The files in this directory and the gentx directory should never be changed.
This README.md file is an exception.
The files in `config` subdirectories should not be moved or renamed either.
New version subdirectories can be added to the `config` dir though.
-->

This directory contains files and info related to the `pio-mainnet-1` blockchain.

When downloading a `config.toml` file, you should change the `moniker` value.

If you download a `packed-conf.json' file, you should NOT download the `.toml` config files, and vice versa.

## Contents

Most of the files directly in this directory pertain to genesis.
Config files for more recent versions can be found in the `config` directory.

- README.md - This file.
- extra-args.txt - Extra agruments that one might want to include with `provenanced start`.
- genesis-version.txt - The version of `provenanced` used at genesis.
- gentx - A directory containing the `Tx`s involved with genesis.
- genesis.json - The genesis file.
- config.toml - A basic `config.toml` file from genesis.
- node-config.toml - A `config.toml` used for a node at genesis.
- node-app.toml - An `app.toml` config file used for a node at genesis.
- config - A directory containing recommended config files at versions other than genesis.

