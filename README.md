# Origyn Nft Reference - v0.1.6

### Purpose

This repo contains the reference implementation of the ORIGYN NFT in motoko, and the storage canister implementation that allows unlimited storage for NFT canisters.

## Getting up and running
### Requirements
- dfx install (see version requeried in dfx.json)


### Build
```bash
npm run build
```

build will create a wasm tar in `./src/declarations/origyn_nft_reference/origyn_nft_reference.wasm.gz`

### Deploy

No init args are required to deploy the canister, but you will have to call a few methods to configure the canister.

First, you will need to create a canister id for the canister you want to configure. You can do this by running the following command:

```bash
dfx canister create origyn_nft_reference
```

Then, you will need to configure the canister. You can do this by running the following command:

```bash
  dfx canister call origyn_nft_reference manage_storage_nft_origyn '(variant {configure_storage = variant {heap = opt 500000000}})'
  dfx canister call origyn_nft_reference collection_update_nft_origyn "(variant {UpdateOwner = principal \"$ADMIN_PRINCIPAL\"})"
```

Replace `$ADMIN_PRINCIPAL` with the principal of the canister you want to configure.

Now, you have an empty canister with the origyn_nft_reference canister installed and configured.
You can now start configuring the collection using stage_nft_origyn.
you have example done for integration testing in [nft_utils.rs](./src/integration_tests/impl/src/origyn_nft_suite/nft_utils.rs#L262)
As origyn nft can have a lot of different configurations, you can check the [documentation](./docs/nft-collection-configuration.md) for more information.

Now your collection is configured, you can start minting NFTs.
First we define the metadata of the NFT, then we mint it.
Again, you have example done for integration testing in [nft_utils.rs](./src/integration_tests/impl/src/origyn_nft_suite/tests/nft_tests_icrc7.rs#L13)

and then the minting :
```bash
dfx canister call origyn_nft_reference mint_nft_origyn "(\"$NFT_ID\", record {owner = principal \"$NFT_OWNER_PRINCIPAL\"})"
```

And that's it, you have created your first custom collection, and created + minted your first NFT.

### Testing - new way
#### Install poketic
Check this link : https://internetcomputer.org/docs/current/developer-docs/smart-contracts/test/pocket-ic for more information

Export the path of the bin folder of your poketic installation
```bash
export POCKET_IC_BIN=/path/to/poketic/bin
```

#### build canisters
```bash
npm run build
```
-> This step will build the canisters and copy the wasm files in the correct folders

#### Run the tests
```bash
npm run integration_test
```
-> This step will compile integration tests done in rust, and run them using poketic.



### Testing - old way

You will need the proper version of yes for your OS. (npm install -g yes)

yes yes | ./runners/test_runner.sh


### Logs & Metrics

[Logs and metrics documentation](./docs/logs_and_metrics.md)

### Audit
[Audit document - Trail Of Bits](./docs/audit.md)


### Motoko base

It is important to note that every now and then there are new items in the motoko base library. One example of this is Timer. If you are using an older vesion of the motoko base library in vessel you will have an error complaining about a non existent Timer. In this repo we try to keep libs up-to-date, however, just be aware that from time to time you might need to change the upstream varible in the package-set.dhall to reflect the lastest motoko library.
