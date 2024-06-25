# external_canisters/ICRC2

## Type `Account`
``` motoko no-repl
type Account = { owner : Principal; subaccount : ?Subaccount }
```


## Type `Allowance`
``` motoko no-repl
type Allowance = { allowance : Nat; expires_at : ?Timestamp }
```


## Type `AllowanceArgs`
``` motoko no-repl
type AllowanceArgs = { account : Account; spender : Account }
```


## Type `Approve`
``` motoko no-repl
type Approve = { fee : ?Nat; from : Account; memo : ?Blob; created_at_time : ?Timestamp; amount : Nat; expected_allowance : ?Nat; expires_at : ?Timestamp; spender : Account }
```


## Type `ApproveArgs`
``` motoko no-repl
type ApproveArgs = { fee : ?Nat; memo : ?Blob; from_subaccount : ?Blob; created_at_time : ?Timestamp; amount : Nat; expected_allowance : ?Nat; expires_at : ?Timestamp; spender : Account }
```


## Type `ApproveError`
``` motoko no-repl
type ApproveError = {#GenericError : { message : Text; error_code : Nat }; #TemporarilyUnavailable; #Duplicate : { duplicate_of : BlockIndex }; #BadFee : { expected_fee : Nat }; #AllowanceChanged : { current_allowance : Nat }; #CreatedInFuture : { ledger_time : Timestamp }; #TooOld; #Expired : { ledger_time : Timestamp }; #InsufficientFunds : { balance : Nat }}
```


## Type `ApproveResult`
``` motoko no-repl
type ApproveResult = {#Ok : BlockIndex; #Err : ApproveError}
```


## Type `ArchiveInfo`
``` motoko no-repl
type ArchiveInfo = { block_range_end : BlockIndex; canister_id : Principal; block_range_start : BlockIndex }
```


## Type `Block`
``` motoko no-repl
type Block = Value
```


## Type `BlockIndex`
``` motoko no-repl
type BlockIndex = Nat
```


## Type `BlockRange`
``` motoko no-repl
type BlockRange = { blocks : [Block] }
```


## Type `Burn`
``` motoko no-repl
type Burn = { from : Account; memo : ?Blob; created_at_time : ?Timestamp; amount : Nat; spender : ?Account }
```


## Type `ChangeArchiveOptions`
``` motoko no-repl
type ChangeArchiveOptions = { num_blocks_to_archive : ?Nat64; max_transactions_per_response : ?Nat64; trigger_threshold : ?Nat64; more_controller_ids : ?[Principal]; max_message_size_bytes : ?Nat64; cycles_for_archive_creation : ?Nat64; node_max_memory_size_bytes : ?Nat64; controller_id : ?Principal }
```


## Type `ChangeFeeCollector`
``` motoko no-repl
type ChangeFeeCollector = {#SetTo : Account; #Unset}
```


## Type `DataCertificate`
``` motoko no-repl
type DataCertificate = { certificate : ?Blob; hash_tree : Blob }
```


## Type `Duration`
``` motoko no-repl
type Duration = Nat64
```


## Type `FeatureFlags`
``` motoko no-repl
type FeatureFlags = { icrc2 : Bool }
```


## Type `GetArchivesArgs`
``` motoko no-repl
type GetArchivesArgs = { from : ?Principal }
```


## Type `GetArchivesResult`
``` motoko no-repl
type GetArchivesResult = [{ end : Nat; canister_id : Principal; start : Nat }]
```


## Type `GetBlocksArgs`
``` motoko no-repl
type GetBlocksArgs = { start : BlockIndex; length : Nat }
```


## Type `GetBlocksResponse`
``` motoko no-repl
type GetBlocksResponse = { certificate : ?Blob; first_index : BlockIndex; blocks : [Block]; chain_length : Nat64; archived_blocks : [{ callback : QueryBlockArchiveFn; start : BlockIndex; length : Nat }] }
```


## Type `GetBlocksResult`
``` motoko no-repl
type GetBlocksResult = { log_length : Nat; blocks : [{ id : Nat; block : ICRC3Value }]; archived_blocks : [{ args : [GetBlocksArgs]; callback : shared query [GetBlocksArgs] -> async GetBlocksResult }] }
```


## Type `GetTransactionsRequest`
``` motoko no-repl
type GetTransactionsRequest = { start : TxIndex; length : Nat }
```


## Type `GetTransactionsResponse`
``` motoko no-repl
type GetTransactionsResponse = { first_index : TxIndex; log_length : Nat; transactions : [Transaction]; archived_transactions : [{ callback : QueryArchiveFn; start : TxIndex; length : Nat }] }
```


## Type `HttpRequest`
``` motoko no-repl
type HttpRequest = { url : Text; method : Text; body : Blob; headers : [(Text, Text)] }
```


## Type `HttpResponse`
``` motoko no-repl
type HttpResponse = { body : Blob; headers : [(Text, Text)]; status_code : Nat16 }
```


## Type `ICRC3DataCertificate`
``` motoko no-repl
type ICRC3DataCertificate = { certificate : Blob; hash_tree : Blob }
```


## Type `ICRC3Value`
``` motoko no-repl
type ICRC3Value = {#Int : Int; #Map : [(Text, ICRC3Value)]; #Nat : Nat; #Blob : Blob; #Text : Text; #Array : [ICRC3Value]}
```


## Type `InitArgs`
``` motoko no-repl
type InitArgs = { decimals : ?Nat8; token_symbol : Text; transfer_fee : Nat; metadata : [(Text, MetadataValue)]; minting_account : Account; initial_balances : [(Account, Nat)]; maximum_number_of_accounts : ?Nat64; accounts_overflow_trim_quantity : ?Nat64; fee_collector_account : ?Account; archive_options : { num_blocks_to_archive : Nat64; max_transactions_per_response : ?Nat64; trigger_threshold : Nat64; more_controller_ids : ?[Principal]; max_message_size_bytes : ?Nat64; cycles_for_archive_creation : ?Nat64; node_max_memory_size_bytes : ?Nat64; controller_id : Principal }; max_memo_length : ?Nat16; token_name : Text; feature_flags : ?FeatureFlags }
```


## Type `LedgerArg`
``` motoko no-repl
type LedgerArg = {#Upgrade : ?UpgradeArgs; #Init : InitArgs}
```


## Type `Map`
``` motoko no-repl
type Map = [(Text, Value)]
```


## Type `MetadataValue`
``` motoko no-repl
type MetadataValue = {#Int : Int; #Nat : Nat; #Blob : Blob; #Text : Text}
```


## Type `Mint`
``` motoko no-repl
type Mint = { to : Account; memo : ?Blob; created_at_time : ?Timestamp; amount : Nat }
```


## Type `QueryArchiveFn`
``` motoko no-repl
type QueryArchiveFn = shared query GetTransactionsRequest -> async TransactionRange
```


## Type `QueryBlockArchiveFn`
``` motoko no-repl
type QueryBlockArchiveFn = shared query GetBlocksArgs -> async BlockRange
```


## Type `StandardRecord`
``` motoko no-repl
type StandardRecord = { url : Text; name : Text }
```


## Type `Subaccount`
``` motoko no-repl
type Subaccount = Blob
```


## Type `Timestamp`
``` motoko no-repl
type Timestamp = Nat64
```


## Type `Tokens`
``` motoko no-repl
type Tokens = Nat
```


## Type `Transaction`
``` motoko no-repl
type Transaction = { burn : ?Burn; kind : Text; mint : ?Mint; approve : ?Approve; timestamp : Timestamp; transfer : ?Transfer }
```


## Type `TransactionRange`
``` motoko no-repl
type TransactionRange = { transactions : [Transaction] }
```


## Type `Transfer`
``` motoko no-repl
type Transfer = { to : Account; fee : ?Nat; from : Account; memo : ?Blob; created_at_time : ?Timestamp; amount : Nat; spender : ?Account }
```


## Type `TransferArg`
``` motoko no-repl
type TransferArg = { to : Account; fee : ?Tokens; memo : ?Blob; from_subaccount : ?Subaccount; created_at_time : ?Timestamp; amount : Tokens }
```


## Type `TransferError`
``` motoko no-repl
type TransferError = {#GenericError : { message : Text; error_code : Nat }; #TemporarilyUnavailable; #BadBurn : { min_burn_amount : Tokens }; #Duplicate : { duplicate_of : BlockIndex }; #BadFee : { expected_fee : Tokens }; #CreatedInFuture : { ledger_time : Timestamp }; #TooOld; #InsufficientFunds : { balance : Tokens }}
```


## Type `TransferFromArgs`
``` motoko no-repl
type TransferFromArgs = { to : Account; fee : ?Tokens; spender_subaccount : ?Subaccount; from : Account; memo : ?Blob; created_at_time : ?Timestamp; amount : Tokens }
```


## Type `TransferFromError`
``` motoko no-repl
type TransferFromError = {#GenericError : { message : Text; error_code : Nat }; #TemporarilyUnavailable; #InsufficientAllowance : { allowance : Tokens }; #BadBurn : { min_burn_amount : Tokens }; #Duplicate : { duplicate_of : BlockIndex }; #BadFee : { expected_fee : Tokens }; #CreatedInFuture : { ledger_time : Timestamp }; #TooOld; #InsufficientFunds : { balance : Tokens }}
```


## Type `TransferFromResult`
``` motoko no-repl
type TransferFromResult = {#Ok : BlockIndex; #Err : TransferFromError}
```


## Type `TransferResult`
``` motoko no-repl
type TransferResult = {#Ok : BlockIndex; #Err : TransferError}
```


## Type `TxIndex`
``` motoko no-repl
type TxIndex = Nat
```


## Type `UpgradeArgs`
``` motoko no-repl
type UpgradeArgs = { change_archive_options : ?ChangeArchiveOptions; token_symbol : ?Text; transfer_fee : ?Nat; metadata : ?[(Text, MetadataValue)]; maximum_number_of_accounts : ?Nat64; accounts_overflow_trim_quantity : ?Nat64; change_fee_collector : ?ChangeFeeCollector; max_memo_length : ?Nat16; token_name : ?Text; feature_flags : ?FeatureFlags }
```


## Type `Value`
``` motoko no-repl
type Value = {#Int : Int; #Map : Map; #Nat : Nat; #Nat64 : Nat64; #Blob : Blob; #Text : Text; #Array : [Value]}
```


## Type `Self`
``` motoko no-repl
type Self = actor { archives : shared query () -> async [ArchiveInfo]; get_blocks : shared query GetBlocksArgs -> async GetBlocksResponse; get_data_certificate : shared query () -> async DataCertificate; get_transactions : shared query GetTransactionsRequest -> async GetTransactionsResponse; icrc1_balance_of : shared query Account -> async Tokens; icrc1_decimals : shared query () -> async Nat8; icrc1_fee : shared query () -> async Tokens; icrc1_metadata : shared query () -> async [(Text, MetadataValue)]; icrc1_minting_account : shared query () -> async ?Account; icrc1_name : shared query () -> async Text; icrc1_supported_standards : shared query () -> async [StandardRecord]; icrc1_symbol : shared query () -> async Text; icrc1_total_supply : shared query () -> async Tokens; icrc1_transfer : shared TransferArg -> async TransferResult; icrc2_allowance : shared query AllowanceArgs -> async Allowance; icrc2_approve : shared ApproveArgs -> async ApproveResult; icrc2_transfer_from : shared TransferFromArgs -> async TransferFromResult; icrc3_get_archives : shared query GetArchivesArgs -> async GetArchivesResult; icrc3_get_blocks : shared query [GetBlocksArgs] -> async GetBlocksResult; icrc3_get_tip_certificate : shared query () -> async ?ICRC3DataCertificate; icrc3_supported_block_types : shared query () -> async [{ url : Text; block_type : Text }] }
```

