# origyn_nft_reference/dfxtypes

## Type `AccountBalanceArgs`
``` motoko no-repl
type AccountBalanceArgs = { account : AccountIdentifier }
```


## Type `AccountBalanceArgsDFX`
``` motoko no-repl
type AccountBalanceArgsDFX = { account : AccountIdentifierDFX }
```


## Type `AccountIdentifier`
``` motoko no-repl
type AccountIdentifier = Blob
```


## Type `AccountIdentifierDFX`
``` motoko no-repl
type AccountIdentifierDFX = Text
```


## Type `Archive`
``` motoko no-repl
type Archive = { canister_id : Principal }
```


## Type `ArchiveOptions`
``` motoko no-repl
type ArchiveOptions = { num_blocks_to_archive : Nat64; trigger_threshold : Nat64; max_message_size_bytes : ?Nat64; cycles_for_archive_creation : ?Nat64; node_max_memory_size_bytes : ?Nat64; controller_id : Principal }
```


## Type `Archives`
``` motoko no-repl
type Archives = { archives : [Archive] }
```


## Type `Block`
``` motoko no-repl
type Block = { transaction : Transaction; timestamp : TimeStamp; parent_hash : ?Blob }
```


## Type `BlockArg`
``` motoko no-repl
type BlockArg = BlockHeight
```


## Type `BlockDFX`
``` motoko no-repl
type BlockDFX = { transaction : TransactionDFX; timestamp : TimeStamp; parent_hash : ?[Nat8] }
```


## Type `BlockHeight`
``` motoko no-repl
type BlockHeight = Nat64
```


## Type `BlockIndex`
``` motoko no-repl
type BlockIndex = Nat64
```


## Type `BlockRange`
``` motoko no-repl
type BlockRange = { blocks : [Block] }
```


## Type `BlockRes`
``` motoko no-repl
type BlockRes = ?{#Ok : ?{#Ok : Block; #Err : CanisterId}; #Err : Text}
```


## Type `CanisterId`
``` motoko no-repl
type CanisterId = Principal
```


## Type `Duration`
``` motoko no-repl
type Duration = { secs : Nat64; nanos : Nat32 }
```


## Type `GetBlocksArgs`
``` motoko no-repl
type GetBlocksArgs = { start : BlockIndex; length : Nat64 }
```


## Type `Hash`
``` motoko no-repl
type Hash = ?{ inner : [Nat8] }
```


## Type `HeaderField`
``` motoko no-repl
type HeaderField = (Text, Text)
```


## Type `HttpRequest`
``` motoko no-repl
type HttpRequest = { url : Text; method : Text; body : [Nat8]; headers : [HeaderField] }
```


## Type `HttpResponse`
``` motoko no-repl
type HttpResponse = { body : [Nat8]; headers : [HeaderField]; status_code : Nat16 }
```


## Type `LedgerCanisterInitPayload`
``` motoko no-repl
type LedgerCanisterInitPayload = { send_whitelist : [Principal]; admin : Principal; token_symbol : ?Text; transfer_fee : ?Tokens; minting_account : AccountIdentifierDFX; transaction_window : ?Duration; max_message_size_bytes : ?Nat64; archive_options : ?ArchiveOptions; standard_whitelist : [Principal]; initial_values : [(AccountIdentifierDFX, Tokens)]; token_name : ?Text }
```


## Type `Memo`
``` motoko no-repl
type Memo = Nat64
```


## Type `NotifyCanisterArgs`
``` motoko no-repl
type NotifyCanisterArgs = { to_subaccount : ?SubAccount; from_subaccount : ?SubAccount; to_canister : Principal; max_fee : Tokens; block_height : BlockHeight }
```


## Type `Operation`
``` motoko no-repl
type Operation = {#Burn : { from : AccountIdentifier; amount : Tokens }; #Mint : { to : AccountIdentifier; amount : Tokens }; #Transfer : { to : AccountIdentifier; fee : Tokens; from : AccountIdentifier; amount : Tokens }}
```


## Type `OperationDFX`
``` motoko no-repl
type OperationDFX = {#Burn : { from : AccountIdentifierDFX; amount : Tokens }; #Mint : { to : AccountIdentifierDFX; amount : Tokens }; #Send : { to : AccountIdentifierDFX; from : AccountIdentifierDFX; amount : Tokens }}
```


## Type `QueryArchiveError`
``` motoko no-repl
type QueryArchiveError = {#BadFirstBlockIndex : { requested_index : BlockIndex; first_valid_index : BlockIndex }; #Other : { error_message : Text; error_code : Nat64 }}
```


## Type `QueryArchiveFn`
``` motoko no-repl
type QueryArchiveFn = shared query GetBlocksArgs -> async QueryArchiveResult
```


## Type `QueryArchiveResult`
``` motoko no-repl
type QueryArchiveResult = {#Ok : BlockRange; #Err : QueryArchiveError}
```


## Type `QueryBlocksResponse`
``` motoko no-repl
type QueryBlocksResponse = { certificate : ?[Nat8]; blocks : [Block]; chain_length : Nat64; first_block_index : BlockIndex; archived_blocks : [{ callback : QueryArchiveFn; start : BlockIndex; length : Nat64 }] }
```


## Type `SendArgs`
``` motoko no-repl
type SendArgs = { to : AccountIdentifierDFX; fee : Tokens; memo : Memo; from_subaccount : ?SubAccount; created_at_time : ?TimeStamp; amount : Tokens }
```


## Type `SubAccount`
``` motoko no-repl
type SubAccount = [Nat8]
```


## Type `TimeStamp`
``` motoko no-repl
type TimeStamp = { timestamp_nanos : Nat64 }
```


## Type `TipOfChainRes`
``` motoko no-repl
type TipOfChainRes = { certification : ?[Nat8]; tip_index : BlockHeight }
```


## Type `Tokens`
``` motoko no-repl
type Tokens = { e8s : Nat64 }
```


## Type `Transaction`
``` motoko no-repl
type Transaction = { memo : Memo; operation : ?Operation; created_at_time : TimeStamp }
```


## Type `TransactionDFX`
``` motoko no-repl
type TransactionDFX = { memo : Memo; operation : ?OperationDFX; created_at_time : TimeStamp }
```


## Type `TransferArgs`
``` motoko no-repl
type TransferArgs = { to : AccountIdentifier; fee : Tokens; memo : Memo; from_subaccount : ?SubAccount; created_at_time : ?TimeStamp; amount : Tokens }
```


## Type `TransferError`
``` motoko no-repl
type TransferError = {#TxTooOld : { allowed_window_nanos : Nat64 }; #BadFee : { expected_fee : Tokens }; #TxDuplicate : { duplicate_of : BlockIndex }; #TxCreatedInFuture; #InsufficientFunds : { balance : Tokens }}
```


## Type `TransferFee`
``` motoko no-repl
type TransferFee = { transfer_fee : Tokens }
```


## Type `TransferFeeArg`
``` motoko no-repl
type TransferFeeArg = {  }
```


## Type `TransferResult`
``` motoko no-repl
type TransferResult = {#Ok : BlockIndex; #Err : TransferError}
```


## Type `TransferStandardArgs`
``` motoko no-repl
type TransferStandardArgs = { to : AccountIdentifier; fee : Tokens; memo : Memo; from_subaccount : ?SubAccount; from_principal : Principal; created_at_time : ?TimeStamp; amount : Tokens }
```


## Type `Subaccount`
``` motoko no-repl
type Subaccount = [Nat8]
```


## Type `Account`
``` motoko no-repl
type Account = { owner : Principal; subaccount : ?Subaccount }
```


## Type `ICRC1TransferArgs`
``` motoko no-repl
type ICRC1TransferArgs = { from_subaccount : ?Subaccount; to : Account; amount : Nat; fee : ?Nat; memo : ?[Nat8]; created_at_time : ?Nat64 }
```


## Type `ICRC1TransferError`
``` motoko no-repl
type ICRC1TransferError = {#GenericError : { message : Text; error_code : Nat }; #TemporarilyUnavailable; #BadBurn : { min_burn_amount : Nat }; #Duplicate : { duplicate_of : Nat }; #BadFee : { expected_fee : Nat }; #CreatedInFuture : { ledger_time : Nat64 }; #TooOld; #InsufficientFunds : { balance : Nat }}
```


## Type `ICRC1TransferResult`
``` motoko no-repl
type ICRC1TransferResult = {#Ok : Nat; #Err : ICRC1TransferError}
```


## Type `Service`
``` motoko no-repl
type Service = actor { account_balance : shared query AccountBalanceArgs -> async Tokens; account_balance_dfx : shared query AccountBalanceArgsDFX -> async Tokens; archives : shared query () -> async Archives; block_dfx : shared query BlockArg -> async BlockRes; decimals : shared query () -> async { decimals : Nat32 }; get_admin : shared query {  } -> async Principal; get_minting_account_id_dfx : shared query {  } -> async ?AccountIdentifier; get_nodes : shared query () -> async [CanisterId]; get_send_whitelist_dfx : shared query {  } -> async [Principal]; http_request : shared query HttpRequest -> async HttpResponse; name : shared query () -> async { name : Text }; notify_dfx : shared NotifyCanisterArgs -> async (); query_blocks : shared query GetBlocksArgs -> async QueryBlocksResponse; send_dfx : shared SendArgs -> async BlockHeight; set_admin : shared Principal -> async (); set_minting_account_id_dfx : shared AccountIdentifier -> async (); set_send_whitelist_dfx : shared [Principal] -> async (); set_standard_whitelist_dfx : shared [Principal] -> async (); symbol : shared query () -> async { symbol : Text }; tip_of_chain_dfx : shared query {  } -> async TipOfChainRes; total_supply_dfx : shared query {  } -> async Tokens; icrc1_balance_of : shared query (Account) -> async (Nat); icrc1_transfer : shared (ICRC1TransferArgs) -> async (ICRC1TransferResult); transfer_fee : shared query TransferFeeArg -> async TransferFee; transfer_standard_stdldg : shared TransferStandardArgs -> async TransferResult }
```


## Type `GetBlocksError`
``` motoko no-repl
type GetBlocksError = {#BadFirstBlockIndex : { requested_index : BlockIndex; first_valid_index : BlockIndex }; #Other : { error_code : Nat64; error_message : Text }}
```


## Type `ArchiveService`
``` motoko no-repl
type ArchiveService = actor { get_blocks : shared query (GetBlocksArgs) -> async (GetBlocksResult) }
```

