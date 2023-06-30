# pio-mainnet-1

<!--
There are external scripts that depend on the files in here; moving or deleting
them would break those scripts, and we don't want to do that.

The files in this directory and the gentx directory should never be changed.
This README.md file is an exception.

The files in `config` subdirectories should not be moved or deleted either.
New version subdirectories can be added to the `config` dir though.
-->

The first public mainnet using the 0.40 SDK base Provenance Blockchain is focused on streamlining the process for building the public network configuration.

- **Genesis Version** - 1.0.1
- **Genesis Finalized** - 19-04-2021 16:00:00Z
- **Network Start** - 20-04-2021 16:20:00Z
- **Explorer** - [explorer.provenance.io](https://explorer.provenance.io)
- **Seed Nodes** - `4bd2fb0ae5a123f1db325960836004f980ee09b4@seed-0.provenance.io:26656,048b991204d7aac7209229cbe457f622eed96e5d@seed-1.provenance.io:26656`
- **Upgrades** - [https://explorer.provenance.io/network/upgrades](https://explorer.provenance.io/network/upgrades)

This directory contains files and info related to the `pio-mainnet-1` blockchain.

Usage notes:

- If you download a `packed-conf.json' file, you should NOT download the `.toml` config files, and vice versa.
- When downloading a `config.toml` (or `packed-conf.json`) file, you should change the `moniker` value to your own.
- In the `client.toml` (or `packed-conf.json`), you should use your own node's url for the `node` value. If you don't yet have your own node, you can use `https://rpc.provenance.io:443`.

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

