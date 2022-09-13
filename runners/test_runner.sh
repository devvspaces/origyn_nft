set -ex

dfx identity new test_nft_ref || true
dfx identity use test_nft_ref

ADMIN_PRINCIPAL=$(dfx identity get-principal)
ADMIN_ACCOUNTID=$(dfx ledger account-id)

echo $ADMIN_PRINCIPAL
echo $ADMIN_ACCOUNTID

dfx canister create test_runner
dfx canister create test_runner_nft
dfx canister create test_runner_nft_2
dfx canister create test_runner_instant_transfer
dfx canister create test_runner_data
dfx canister create test_runner_utils
dfx canister create test_runner_collection
dfx canister create test_runner_storage
dfx canister create test_runner_sale
dfx canister create dfxledger
dfx canister create dfxledger2
dfx canister create test_canister_factory
dfx canister create test_storage_factory

DFX_LEDGER_CANISTER_ID=$(dfx canister id dfxledger)
DFX_LEDGER_ACCOUNT_ID=$(python3 principal_to_accountid.py $DFX_LEDGER_CANISTER_ID)

DFX_LEDGER_CANISTER2_ID=$(dfx canister id dfxledger2)
DFX_LEDGER_ACCOUNT2_ID=$(python3 principal_to_accountid.py $DFX_LEDGER_CANISTER2_ID)

TEST_RUNNER_CANISTER_ID=$(dfx canister id test_runner)
TEST_RUNNER_ACCOUNT_ID=$(python3 principal_to_accountid.py $TEST_RUNNER_CANISTER_ID)

TEST_RUNNER_NFT_CANISTER_ID=$(dfx canister id test_runner_nft)
TEST_RUNNER_NFT_ACCOUNT_ID=$(python3 principal_to_accountid.py $TEST_RUNNER_NFT_CANISTER_ID)

TEST_RUNNER_NFT_CANISTER_2_ID=$(dfx canister id test_runner_nft_2)
TEST_RUNNER_NFT_ACCOUNT_2_ID=$(python3 principal_to_accountid.py $TEST_RUNNER_NFT_CANISTER_2_ID)

TEST_RUNNER_STORAGE_CANISTER_ID=$(dfx canister id test_runner_storage)
TEST_RUNNER_STORAGE_ACCOUNT_ID=$(python3 principal_to_accountid.py $TEST_RUNNER_STORAGE_CANISTER_ID)

TEST_RUNNER_INSTANT_CANISTER_ID=$(dfx canister id test_runner_instant_transfer)
TEST_RUNNER_INSTANT_ACCOUNT_ID=$(python3 principal_to_accountid.py $TEST_RUNNER_NFT_CANISTER_2_ID)

TEST_RUNNER_DATA_CANISTER_ID=$(dfx canister id test_runner_data)
TEST_RUNNER_DATA_ACCOUNT_ID=$(python3 principal_to_accountid.py $TEST_RUNNER_INSTANT_CANISTER_ID)

TEST_RUNNER_UTILS_CANISTER_ID=$(dfx canister id test_runner_utils)
TEST_RUNNER_UTILS_ACCOUNT_ID=$(python3 principal_to_accountid.py $TEST_RUNNER_UTILS_CANISTER_ID)

TEST_RUNNER_SALE_CANISTER_ID=$(dfx canister id test_runner_utils)
TEST_RUNNER_SALE_ACCOUNT_ID=$(python3 principal_to_accountid.py $TEST_RUNNER_SALE_CANISTER_ID)


TEST_RUNNER_COLLECTION_CANISTER_ID=$(dfx canister id test_runner_collection)
TEST_RUNNER_COLLECTION_ACCOUNT_ID=$(python3 principal_to_accountid.py $TEST_RUNNER_COLLECTION_CANISTER_ID)

TEST_CANISTER_FACTORY_ID=$(dfx canister id test_canister_factory)
TEST_STORAGE_FACTORY_ID=$(dfx canister id test_storage_factory)

dfx build test_runner_collection
dfx build test_runner
dfx build test_runner_nft
dfx build test_runner_nft_2
dfx build test_runner_instant_transfer
dfx build test_runner_data
dfx build test_runner_utils
dfx build test_runner_storage
dfx build test_runner_sale
dfx build test_canister_factory
dfx build test_storage_factory
dfx build dfxledger
dfx build dfxledger2

gzip ./.dfx/local/canisters/test_runner_collection/test_runner_collection.wasm -f
gzip ./.dfx/local/canisters/test_runner/test_runner.wasm -f
gzip ./.dfx/local/canisters/test_runner_nft/test_runner_nft.wasm -f
gzip ./.dfx/local/canisters/test_runner_nft_2/test_runner_nft_2.wasm -f
gzip ./.dfx/local/canisters/test_runner_instant_transfer/test_runner_instant_transfer.wasm -f
gzip ./.dfx/local/canisters/test_runner_data/test_runner_data.wasm -f
gzip ./.dfx/local/canisters/test_runner_utils/test_runner_utils.wasm -f
gzip ./.dfx/local/canisters/test_runner_storage/test_runner_storage.wasm -f
gzip ./.dfx/local/canisters/test_canister_factory/test_canister_factory.wasm -f
gzip ./.dfx/local/canisters/test_storage_factory/test_storage_factory.wasm -f
gzip ./.dfx/local/canisters/test_runner_sale/test_runner_sale.wasm -f


dfx canister install test_canister_factory --mode=reinstall --wasm ./.dfx/local/canisters/test_canister_factory/test_canister_factory.wasm.gz

dfx canister install test_storage_factory --mode=reinstall  --wasm ./.dfx/local/canisters/test_storage_factory/test_storage_factory.wasm.gz


dfx canister install test_runner_collection --mode=reinstall --wasm ./.dfx/local/canisters/test_runner_collection/test_runner_collection.wasm.gz  --argument "(principal  \"$DFX_LEDGER_CANISTER_ID\", principal  \"$DFX_LEDGER_CANISTER2_ID\")"

dfx canister install test_runner --mode=reinstall --wasm ./.dfx/local/canisters/test_runner/test_runner.wasm.gz --argument "(record{ canister_factory = principal \"$TEST_CANISTER_FACTORY_ID\"; storage_factory = principal \"$TEST_STORAGE_FACTORY_ID\"; dfx_ledger = opt (principal  \"$DFX_LEDGER_CANISTER_ID\"); dfx_ledger2 = opt (principal  \"$DFX_LEDGER_CANISTER2_ID\"); test_runner_nft = opt principal \"$TEST_RUNNER_NFT_CANISTER_ID\"; test_runner_nft_2 = opt principal \"$TEST_RUNNER_NFT_CANISTER_2_ID\"; test_runner_instant = opt(principal \"$TEST_RUNNER_INSTANT_CANISTER_ID\"); test_runner_data = opt(principal \"$TEST_RUNNER_DATA_CANISTER_ID\"); test_runner_utils = opt(principal \"$TEST_RUNNER_UTILS_CANISTER_ID\"); test_runner_collection = opt (principal \"$TEST_RUNNER_COLLECTION_CANISTER_ID\"); test_runner_storage= opt principal \"$TEST_RUNNER_STORAGE_CANISTER_ID\"; test_runner_sale = opt principal \"$TEST_RUNNER_SALE_CANISTER_ID\";})"

dfx canister install test_runner_nft --wasm ./.dfx/local/canisters/test_runner_nft/test_runner_nft.wasm.gz --mode=reinstall --argument "(principal  \"$DFX_LEDGER_CANISTER_ID\", principal  \"$DFX_LEDGER_CANISTER2_ID\")"

dfx canister install test_runner_nft_2 --mode=reinstall --wasm ./.dfx/local/canisters/test_runner_nft_2/test_runner_nft_2.wasm.gz --argument "(principal  \"$DFX_LEDGER_CANISTER_ID\", principal  \"$DFX_LEDGER_CANISTER2_ID\")"

dfx canister install test_runner_storage --mode=reinstall --wasm ./.dfx/local/canisters/test_runner_storage/test_runner_storage.wasm.gz --argument "(principal  \"$DFX_LEDGER_CANISTER_ID\", principal  \"$DFX_LEDGER_CANISTER2_ID\")"

dfx canister install test_runner_sale --mode=reinstall --wasm ./.dfx/local/canisters/test_runner_sale/test_runner_sale.wasm.gz --argument "(principal  \"$DFX_LEDGER_CANISTER_ID\", principal  \"$DFX_LEDGER_CANISTER2_ID\")"

dfx canister install test_runner_utils --mode=reinstall --wasm ./.dfx/local/canisters/test_runner_utils/test_runner_utils.wasm.gz --argument "(principal  \"$DFX_LEDGER_CANISTER_ID\", principal  \"$DFX_LEDGER_CANISTER2_ID\")"

dfx canister install test_runner_data --mode=reinstall --wasm ./.dfx/local/canisters/test_runner_data/test_runner_data.wasm.gz --argument "(principal  \"$DFX_LEDGER_CANISTER_ID\", principal  \"$DFX_LEDGER_CANISTER2_ID\")"

dfx canister install test_runner_instant_transfer --mode=reinstall --wasm ./.dfx/local/canisters/test_runner_instant_transfer/test_runner_instant_transfer.wasm.gz --argument "(principal  \"$DFX_LEDGER_CANISTER_ID\", principal  \"$DFX_LEDGER_CANISTER2_ID\")"

dfx canister install dfxledger --mode=reinstall --argument "(record { minting_account = \"$ADMIN_ACCOUNTID\"; initial_values = vec { record { \"$TEST_RUNNER_ACCOUNT_ID\"; record { e8s = 18446744073709551615: nat64 } } }; max_message_size_bytes = null; transaction_window = null; archive_options = opt record { trigger_threshold = 2000: nat64; num_blocks_to_archive = 1000: nat64; node_max_memory_size_bytes = null; max_message_size_bytes = null; controller_id = principal \"$TEST_RUNNER_CANISTER_ID\"  }; send_whitelist = vec {};standard_whitelist = vec {};transfer_fee = null; token_symbol = null; token_name = null;admin = principal \"$TEST_RUNNER_CANISTER_ID\"})"

dfx canister install dfxledger2 --mode=reinstall --argument "(record { minting_account = \"$ADMIN_ACCOUNTID\"; initial_values = vec { record { \"$TEST_RUNNER_ACCOUNT_ID\"; record { e8s = 18446744073709551615: nat64 } } }; max_message_size_bytes = null; transaction_window = null; archive_options = opt record { trigger_threshold = 2000: nat64; num_blocks_to_archive = 1000: nat64; node_max_memory_size_bytes = null; max_message_size_bytes = null; controller_id = principal \"$TEST_RUNNER_CANISTER_ID\"  }; send_whitelist = vec {};standard_whitelist = vec {};transfer_fee = null; token_symbol = null; token_name = null;admin = principal \"$TEST_RUNNER_CANISTER_ID\"})"


TEST_RUNNER_ID=$(dfx canister id test_runner)

echo $TEST_RUNNER_ID

dfx canister call test_runner test
#dfx canister call test_runner_nft test
#dfx canister call test_runner_data_nft test
#dfx canister call test_runner_utils_nft test

