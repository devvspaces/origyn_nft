set -ex

dfx identity new test_nft_ref || true
dfx identity use test_nft_ref

ADMIN_PRINCIPAL=$(dfx identity get-principal)
ADMIN_ACCOUNTID=$(dfx ledger account-id)

echo $ADMIN_PRINCIPAL
echo $ADMIN_ACCOUNTID

#dfx canister create test_runner
dfx canister create test_runner_sale
#dfx canister create test_canister_factory
#dfx canister create test_storage_factory
#dfx canister create dfxledger


DFX_LEDGER_CANISTER_ID=$(dfx canister id dfxledger)
DFX_LEDGER_ACCOUNT_ID=$(python3 principal_to_accountid.py $DFX_LEDGER_CANISTER_ID)

DFX_LEDGER_CANISTER2_ID=$(dfx canister id dfxledger2)
DFX_LEDGER_ACCOUNT2_ID=$(python3 principal_to_accountid.py $DFX_LEDGER_CANISTER2_ID)

TEST_RUNNER_CANISTER_ID=$(dfx canister id test_runner)
TEST_RUNNER_ACCOUNT_ID=$(python3 principal_to_accountid.py $TEST_RUNNER_CANISTER_ID)

TEST_RUNNER_SALE_CANISTER_ID=$(dfx canister id test_runner_sale)
TEST_RUNNER_SALE_ACCOUNT_ID=$(python3 principal_to_accountid.py $TEST_RUNNER_SALE_CANISTER_ID)


TEST_CANISTER_FACTORY_ID=$(dfx canister id test_canister_factory)
TEST_STORAGE_FACTORY_ID=$(dfx canister id test_storage_factory)


dfx build test_runner
dfx build test_runner_sale
#dfx build test_canister_factory
#dfx build test_storage_factory
gzip ./.dfx/local/canisters/test_runner_sale/test_runner_sale.wasm -f

#dfx canister install test_canister_factory --mode=reinstall 

#dfx canister install test_storage_factory --mode=reinstall 

dfx canister install test_runner --mode=reinstall --argument "(record { canister_factory = principal \"$TEST_CANISTER_FACTORY_ID\"; storage_factory = principal \"$TEST_STORAGE_FACTORY_ID\";dfx_ledger = opt principal \"$DFX_LEDGER_CANISTER_ID\"; dfx_ledger2 = opt principal \"$DFX_LEDGER_CANISTER2_ID\";test_runner_nft = null; test_runner_nft_2 = null; test_runner_instant = null; test_runner_data = null; test_runner_utils = null; test_runner_collection = null;test_runner_storage = null; test_runner_sale = opt principal \"$TEST_RUNNER_SALE_CANISTER_ID\";})"

dfx canister install test_runner_sale --wasm ./.dfx/local/canisters/test_runner_sale/test_runner_sale.wasm.gz --mode=reinstall --argument "(principal  \"$DFX_LEDGER_CANISTER_ID\", principal  \"$DFX_LEDGER_CANISTER2_ID\")"

#dfx canister  install dfxledger --mode=reinstall --argument "(record { minting_account = \"$ADMIN_ACCOUNTID\"; initial_values = vec { record { \"$TEST_RUNNER_ACCOUNT_ID\"; record { e8s = 18446744073709551615: nat64 } } }; max_message_size_bytes = null; transaction_window = null; archive_options = opt record { trigger_threshold = 2000: nat64; num_blocks_to_archive = 1000: nat64; node_max_memory_size_bytes = null; max_message_size_bytes = null; controller_id = principal \"$TEST_RUNNER_CANISTER_ID\"  }; send_whitelist = vec {};standard_whitelist = vec {};transfer_fee = opt (record {e8s = 200_000}); token_symbol = null; token_name = null;admin = principal \"$TEST_RUNNER_CANISTER_ID\"})"


dfx canister call test_runner test

