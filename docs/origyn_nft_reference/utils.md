# origyn_nft_reference/utils

## Value `NANOS`
``` motoko no-repl
let NANOS
```


## Value `MINUTE_LENGTH`
``` motoko no-repl
let MINUTE_LENGTH
```


## Value `HOUR_LENGTH`
``` motoko no-repl
let HOUR_LENGTH
```


## Value `DAY_LENGTH`
``` motoko no-repl
let DAY_LENGTH
```


## Value `YEAR_LENGTH`
``` motoko no-repl
let YEAR_LENGTH
```


## Function `get_nat_as_token_id`
``` motoko no-repl
func get_nat_as_token_id(tokenNat : Nat) : Text
```

* Converts a Nat value to a token ID Text value.
    * @param {Nat} tokenNat - The Nat value to convert.
    * @returns {Text} The resulting token ID Text value.

## Function `get_token_id_as_nat`
``` motoko no-repl
func get_token_id_as_nat(token_id : Text) : Nat
```

* Converts a token ID Text value to a Nat value.
    * @param {Text} token_id - The token ID Text value to convert.
    * @returns {Nat} The resulting Nat value.

## Function `is_owner_manager_network`
``` motoko no-repl
func is_owner_manager_network(state : Types.State, caller : Principal) : Bool
```

* Determines whether a given Principal is the owner, a manager, or part of the network associated with a given state.
    * @param {Types.State} state - The state to check.
    * @param {Principal} caller - The Principal to check.
    * @returns {Bool} A boolean value indicating whether the Principal is the owner, a manager, or part of the network associated with the given state.

## Function `is_owner_network`
``` motoko no-repl
func is_owner_network(state : Types.State, caller : Principal) : Bool
```

* Determines whether a given Principal is the owner or part of the network associated with a given state.
    * @param {Types.State} state - The state to check.
    * @param {Principal} caller - The Principal to check.
    * @returns {Bool} A boolean value indicating whether the Principal is the owner or part of the network associated with the given state.

## Function `is_network`
``` motoko no-repl
func is_network(state : Types.State, caller : Principal) : Bool
```

* Determines whether a given Principal is part of the network associated with a given state.
    * @param {Types.State} state - The state to check.
    * @param {Principal} caller - The Principal to check.
    * @returns {Bool} A boolean value indicating whether the Principal is part of the network associated with the given state.

## Function `get_auction_state_from_status`
``` motoko no-repl
func get_auction_state_from_status(current_sale : Types.SaleStatus) : Result.Result<Types.AuctionState, Types.OrigynError>
```

* Returns the auction state from the provided sale status.
    * @param {Types.SaleStatus} current_sale - The sale status to use.
    * @returns {Result.Result<Types.AuctionState, Types.OrigynError>} The resulting auction state.

## Function `get_auction_state_from_statusStable`
``` motoko no-repl
func get_auction_state_from_statusStable(current_sale : Types.SaleStatusShared) : Result.Result<Types.AuctionStateShared, Types.OrigynError>
```

* Returns the auction state from the provided stable sale status.
    * @param {Types.SaleStatusShared} current_sale - The stable sale status to use.
    * @returns {Result.Result<Types.AuctionStateShared, Types.OrigynError>} The resulting auction state.

## Function `build_library`
``` motoko no-repl
func build_library(items : [(Text, [(Text, CandyTypesOld.AddressedChunkArray)])]) : TrieMap.TrieMap<Text, TrieMap.TrieMap<Text, CandyTypes.Workspace>>
```

* Builds a TrieMap object from an array of item tuples containing a Text key and an array of addressed chunk data.
    * @param {[(Text,[(Text,CandyTypes.AddressedChunkArray)])]} items - The items to use in building the TrieMap object.
    * @returns {TrieMap.TrieMap<Text, TrieMap.TrieMap<Text, CandyTypes.Workspace>>} The resulting TrieMap object.

## Function `build_library_new`
``` motoko no-repl
func build_library_new(items : [(Text, [(Text, CandyTypes.AddressedChunkArray)])]) : TrieMap.TrieMap<Text, TrieMap.TrieMap<Text, CandyTypes.Workspace>>
```


## Value `compare_library`
``` motoko no-repl
let compare_library
```


## Value `library_equal`
``` motoko no-repl
let library_equal
```


## Value `library_hash`
``` motoko no-repl
let library_hash
```


## Function `get_deposit_info`
``` motoko no-repl
func get_deposit_info(depositor_account : Types.Account, host : Principal) : Types.SubAccountInfo
```

* Retrieves information about a depositor account for the Origyn NFT deposit contract.
    * @param {Types.Account} depositor_account - The account of the depositor.
    * @param {Principal} host - The host of the sub-account.
    * @returns {Types.SubAccountInfo} An object containing information about the depositor sub-account.

## Function `get_escrow_account_info`
``` motoko no-repl
func get_escrow_account_info(request : MigrationTypes.Current.EscrowReceipt, host : Principal) : Types.SubAccountInfo
```

* Retrieves information about an escrow account for an Origyn NFT transaction.
    * @param {Types.EscrowReceipt} request - The request object containing transaction details.
    * @param {Principal} host - The host of the sub-account.
    * @returns {Types.SubAccountInfo} An object containing information about the escrow sub-account.

## Function `get_icrc7_royalty_account`
``` motoko no-repl
func get_icrc7_royalty_account(host : Principal) : Types.SubAccountInfo
```

* Retrieves information about a phantom account to return for icrc7 royalties.
    * @returns {Types.SubAccountInfo} An object containing information about the sub-account.

## Function `hash_blob`
``` motoko no-repl
func hash_blob(item : Blob) : Nat
```

* Hashes a blob using SHA256 and returns the result as a Nat.
    * @param {Blob} item - The blob to be hashed.
    * @returns {Nat} The resulting hash value.

## Function `get_sale_account_info`
``` motoko no-repl
func get_sale_account_info(request : Types.EscrowReceipt, host : Principal) : Types.SubAccountInfo
```

* Retrieves information about a sale account for an Origyn NFT transaction.
    * @param {Types.EscrowReceipt} request - The request object containing transaction details.
    * @param {Principal} host - The host of the sub-account.
    * @returns {Types.SubAccountInfo} An object containing information about the sale sub-account.

## Function `get_fee_deposit_account_info`
``` motoko no-repl
func get_fee_deposit_account_info(request : Types.Account, host : Principal) : Types.SubAccountInfo
```

* Retrieves information about a fee deposit account for an Origyn NFT transaction.
    * @param {Types.Account} request - The request object containing transaction details.
    * @param {Principal} host - The host of the sub-account.
    * @returns {Types.SubAccountInfo} An object containing information about the fee deposit sub-account.

## Function `find_escrow_asset_map`
``` motoko no-repl
func find_escrow_asset_map(state : StateAccess, escrow : Types.EscrowReceipt) : { to_list : ?MigrationTypes.Current.EscrowSellerTrie; token_list : ?MigrationTypes.Current.EscrowTokenIDTrie; asset_list : ?MigrationTypes.Current.EscrowLedgerTrie; balance : ?MigrationTypes.Current.EscrowRecord }
```


## Function `create_principal_with_no_subaccount`
``` motoko no-repl
func create_principal_with_no_subaccount(principal : Principal) : { owner : Principal; sub_account : ?Blob }
```

