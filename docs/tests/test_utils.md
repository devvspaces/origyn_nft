# tests/test_utils

## Function `buildStandardNFT`
``` motoko no-repl
func buildStandardNFT(token_id : Text, canister : Types.Service, app : Principal, file_size : Nat, is_soulbound : Bool, nft_originator : Principal) : async (Result.Result<Text, Types.OrigynError>, Result.Result<Principal, Types.OrigynError>, Result.Result<Principal, Types.OrigynError>, Result.Result<Principal, Types.OrigynError>)
```


## Value `memo_one`
``` motoko no-repl
let memo_one : ?[Nat8]
```


## Function `buildCollection`
``` motoko no-repl
func buildCollection(canister : Types.Service, app : Principal, node : Principal, originator : Principal, file_size : Nat, broker_override : Bool, ledger : MigrationTypes.Current.ICTokenSpec) : async (Result.Result<Text, Types.OrigynError>, Result.Result<Principal, Types.OrigynError>)
```


## Function `standardNFT`
``` motoko no-repl
func standardNFT(token_id : Text, canister : Principal, app : Principal, file_size : Nat, is_soulbound : Bool, originator : Principal) : { metadata : CandyTypes.CandyShared }
```


## Function `standardCollection`
``` motoko no-repl
func standardCollection(canister : Principal, app : Principal, node : Principal, originator : Principal, file_size : Nat, broker_override : Bool, ledgerToken : MigrationTypes.Current.ICTokenSpec) : { metadata : CandyTypes.CandyShared }
```


## Function `standardFileChunk`
``` motoko no-repl
func standardFileChunk(token_id : Text, library_id : Text, text : Text, fileData : CandyTypes.CandyShared) : Types.StageChunkArg
```

