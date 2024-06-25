# origyn_nft_reference/metadata

## Function `build_library`
``` motoko no-repl
func build_library(items : [(Text, [(Text, CandyTypes.AddressedChunkArray)])]) : TrieMap.TrieMap<Text, TrieMap.TrieMap<Text, CandyTypes.Workspace>>
```

* Builds a library from a stable type.
  * @param items - an array of tuples containing the name of the library and an array of tuples of the workspace name and the addressed chunk array.
  * @returns a TrieMap containing the workspace name and the workspace itself.

## Function `library_exists`
``` motoko no-repl
func library_exists(metaData : CandyTypes.CandyShared, library_id : Text) : Bool
```

* Confirms whether a library exists.
  * @param metaData - the metadata for the token.
  * @param library_id - the id of the library.
  * @returns a boolean indicating whether the library exists.

## Function `is_soulbound`
``` motoko no-repl
func is_soulbound(metadata : CandyTypes.CandyShared) : Bool
```

* Confirms whether a token is soulbound.
  * @param metadata - the metadata for the token.
  * @returns a boolean indicating whether the token is soulbound.

## Function `is_physical`
``` motoko no-repl
func is_physical(metadata : CandyTypes.CandyShared) : Bool
```

* Confirms whether a token is a physical item.
  * @param metadata - the metadata for the token.
  * @returns a boolean indicating whether the token is a physical item.

## Function `is_in_physical_escrow`
``` motoko no-repl
func is_in_physical_escrow(metadata : CandyTypes.CandyShared) : Bool
```

* Confirms whether a token is in physical escrow.
  * @param metadata - the metadata for the token.
  * @returns a boolean indicating whether the token is in physical escrow.

## Function `set_system_var`
``` motoko no-repl
func set_system_var(metaData : CandyTypes.CandyShared, name : Text, value : CandyTypes.CandyShared) : CandyTypes.CandyShared
```

* Confirms whether a token is in physical escrow.
  * @param metadata - the metadata for the token.
  * @returns a boolean indicating whether the token is in physical escrow.

## Function `is_owner`
``` motoko no-repl
func is_owner(metaData : CandyTypes.CandyShared, account : Types.Account) : Bool
```

* checks if an account owns an nft
  * @param {CandyTypes.CandyShared} metaData - the metadata of the NFT
  * @param {Types.Account} account - the account to check if they own the NFT
  * @return {Boolean} - true if the account owns the NFT, false otherwise

## Function `get_NFTs_for_user`
``` motoko no-repl
func get_NFTs_for_user(state : Types.State, account : Types.Account) : [Text]
```

* gets all the NFTs for a user
  * @param {Types.State} state - the state of the NFTs
  * @param {Types.Account} account - the account to retrieve the NFTs for
  * @return {Array<Text>} - an array of NFTs owned by the user

## Function `get_system_var`
``` motoko no-repl
func get_system_var(metaData : CandyTypes.CandyShared, name : Text) : CandyTypes.CandyShared
```

* gets a system variable out of the system class
  * @param {CandyTypes.CandyShared} metaData - the metadata to retrieve the system variable from
  * @param {Text} name - the name of the system variable to retrieve
  * @return {CandyTypes.CandyShared} - the value of the requested system variable

## Function `get_library_meta`
``` motoko no-repl
func get_library_meta(metadata : CandyTypes.CandyShared, library_id : Text) : Result.Result<CandyTypes.CandyShared, Types.OrigynError>
```

* gets the metadata for a particular library
  * @param {CandyTypes.CandyShared} metadata - the metadata of the NFT
  * @param {Text} library_id - the id of the library to retrieve the metadata for
  * @return {Result.Result<CandyTypes.CandyShared, Types.OrigynError>} - a result containing the metadata for the library or an error

## Function `get_nft_text_property`
``` motoko no-repl
func get_nft_text_property(metadata : CandyTypes.CandyShared, prop : Text) : Types.OrigynTextResult
```

* gets a text property out of the metadata of an NFT
  * @param {CandyTypes.CandyShared} metadata - the metadata of the NFT
  * @param {Text} prop - the property to retrieve from the metadata
  * @return {Types.OrigynTextResult} - a result containing the requested text property or an error

## Function `get_nft_principal_property`
``` motoko no-repl
func get_nft_principal_property(metadata : CandyTypes.CandyShared, prop : Text) : Result.Result<Principal, Types.OrigynError>
```

* gets a principal property out of the metadata of an NFT
  * @param {CandyTypes.CandyShared} metadata - the metadata of the NFT
  * @param {Text} prop - the property to retrieve from the metadata
  * @return {Result.Result<Principal, Types.OrigynError>} - a result containing the requested principal property or an error

## Function `get_nft_bool_property`
``` motoko no-repl
func get_nft_bool_property(metadata : CandyTypes.CandyShared, prop : Text) : Types.OrigynBoolResult
```

* Gets a bool property out of the metadata.
  *
  * @param {CandyTypes.CandyShared} metadata - The metadata of the NFT.
  * @param {Text} prop - The name of the property to get.
  * @returns {Types.OrigynBoolResult} A result containing either the bool property or an error.

## Function `get_nft_nat_property`
``` motoko no-repl
func get_nft_nat_property(metadata : CandyTypes.CandyShared, prop : Text) : Result.Result<Nat, Types.OrigynError>
```

* Gets a Nat property out of the metadata.
  *
  * @param {CandyTypes.CandyShared} metadata - The metadata of the NFT.
  * @param {Text} prop - The name of the property to get.
  * @returns {Result.Result<Nat, Types.OrigynError>} A result containing either the Nat property or an error.

## Function `is_minted`
``` motoko no-repl
func is_minted(metaData : CandyTypes.CandyShared) : Bool
```

* Checks if an item is minted.
  *
  * @param {CandyTypes.CandyShared} metaData - The metadata of the NFT.
  * @returns {Bool} True if the NFT is minted, otherwise false.

## Function `get_nft_id`
``` motoko no-repl
func get_nft_id(metadata : CandyTypes.CandyShared) : Types.OrigynTextResult
```

* Gets the id of an NFT.
  *
  * @param {CandyTypes.CandyShared} metadata - The metadata of the NFT.
  * @returns {Types.OrigynTextResult} A result containing either the id or an error.

## Function `get_nft_primary_asset`
``` motoko no-repl
func get_nft_primary_asset(metadata : CandyTypes.CandyShared) : Types.OrigynTextResult
```

* Gets the primary asset for an NFT.
  *
  * @param {CandyTypes.CandyShared} metadata - The metadata of the NFT.
  * @returns {Types.OrigynTextResult} A result containing either the primary asset or an error.

## Function `get_nft_preview_asset`
``` motoko no-repl
func get_nft_preview_asset(metadata : CandyTypes.CandyShared) : Types.OrigynTextResult
```

* Gets the preview asset for an NFT.
  *
  * @param {CandyTypes.CandyShared} metadata - The metadata of the NFT.
  * @returns {Types.OrigynTextResult} A result containing either the preview asset or an error.

## Function `get_nft_experience_asset`
``` motoko no-repl
func get_nft_experience_asset(metadata : CandyTypes.CandyShared) : Types.OrigynTextResult
```

* Gets the experience asset for an NFT.
  *
  * @param {CandyTypes.CandyShared} metadata - The metadata of the NFT.
  * @returns {Types.OrigynTextResult} A result containing either the experience asset or an error.

## Function `get_library_item_from_store`
``` motoko no-repl
func get_library_item_from_store(store : TrieMap.TrieMap<Text, TrieMap.TrieMap<Text, CandyTypes.Workspace>>, token_id : Text, library_id : Text) : Result.Result<CandyTypes.Workspace, Types.OrigynError>
```

* Gets a library item from the store.
  *
  * @param {TrieMap.TrieMap<Text, TrieMap.TrieMap<Text, CandyTypes.Workspace>>} store - The store containing the library items.
  * @param {Text} token_id - The id of the token.
  * @param {Text} library_id - The id of the library.
  * @returns {Result.Result<CandyTypes.Workspace, Types.OrigynError>} A result containing either the library item or an error.

## Function `account_to_candy`
``` motoko no-repl
func account_to_candy(val : Types.Account) : CandyTypes.CandyShared
```

* Converts an account value to a CandyShared.
  * @param {Types.Account} val - The account value to convert.
  * @returns {CandyTypes.CandyShared} The converted CandyShared.

## Function `token_spec_to_candy`
``` motoko no-repl
func token_spec_to_candy(val : Types.TokenSpec) : CandyTypes.CandyShared
```

* Converts a token specification to a CandyShared.
  * @param {Types.TokenSpec} val - The token specification to convert.
  * @returns {CandyTypes.CandyShared} The converted CandyShared.

## Function `pricing_to_candy`
``` motoko no-repl
func pricing_to_candy(val : MigrationTypes.Current.PricingConfig) : CandyTypes.CandyShared
```

* Converts a pricing configuration to a CandyShared.
  * @param {Types.PricingConfig} val - The pricing configuration to convert.
  * @returns {CandyTypes.CandyShared} The converted CandyShared.

## Function `pricing_shared_to_candy`
``` motoko no-repl
func pricing_shared_to_candy(val : MigrationTypes.Current.PricingConfigShared) : CandyTypes.CandyShared
```

* Converts a pricing configuration sared to a CandyShared.
  * @param {Types.PricingConfigShared} val - The pricing configuration to convert.
  * @returns {CandyTypes.CandyShared} The converted CandyShared.

## Function `auction_config_to_candy`
``` motoko no-repl
func auction_config_to_candy(val : Types.AuctionConfig) : CandyTypes.CandyShared
```

* Converts an auction configuration to a CandyShared.
  * @param {Types.AuctionConfig} val - The auction configuration to convert.
  * @returns {CandyTypes.CandyShared} The converted CandyShared.

## Function `ask_config_to_candy`
``` motoko no-repl
func ask_config_to_candy(val : MigrationTypes.Current.AskConfig) : CandyTypes.CandyShared
```

* Converts an ask configuration to a CandyShared.
  * @param {Types.AskConfig} val - The ask configuration to convert.
  * @returns {CandyTypes.CandyShared} The converted CandyShared.

## Function `ask_config_shared_to_candy`
``` motoko no-repl
func ask_config_shared_to_candy(val : MigrationTypes.Current.AskConfigShared) : CandyTypes.CandyShared
```

* Converts an ask configuration to a CandyShared.
  * @param {Types.AskConfigShared} val - The ask configuration to convert.
  * @returns {CandyTypes.CandyShared} The converted CandyShared.

## Function `candy_to_account`
``` motoko no-repl
func candy_to_account(val : CandyTypes.CandyShared) : Types.BearerResult
```

* Converts a CandyShared to an account value.
  * @param {CandyTypes.CandyShared} val - The CandyShared to convert.
  * @returns {Types.BearerResult} The converted account value.

## Function `get_nft_owner`
``` motoko no-repl
func get_nft_owner(metadata : CandyTypes.CandyShared) : Types.BearerResult
```

* Gets the owner of an NFT in the owner field.
  * @param {CandyTypes.CandyShared} metadata - The metadata of the NFT.
  * @returns {Types.BearerResult} The owner of the NFT.

## Function `get_nft_owner_by_id`
``` motoko no-repl
func get_nft_owner_by_id(state : Types.State, token_id : Text) : Types.BearerResult
```

* Gets the owner of an NFT in the owner field.
  * @param {Text} token_id - The id of the NFT.
  * @returns {Types.BearerResult} The owner of the NFT.

## Function `set_nft_owner`
``` motoko no-repl
func set_nft_owner(state : Types.State, token_id : Text, new_owner : Types.Account, caller : Principal) : Result.Result<CandyTypes.CandyShared, Types.OrigynError>
```

* Sets the owner of an NFT.
  * @param {Types.State} state - The state of the contract.
  * @param {Text} token_id - The ID of the token to update.
  * @param {Types.Account} new_owner - The new owner of the token.
  * @param {Principal} caller - The principal of the caller.
  * @returns {Result.Result<CandyTypes.CandyShared, Types.OrigynError>} The updated metadata of the NFT.

## Function `is_nft_owner`
``` motoko no-repl
func is_nft_owner(metadata : CandyTypes.CandyShared, anAccount : Types.Account) : Types.OrigynBoolResult
```

* Checks if the provided account is the owner of the specified NFT.
  *
  * @param {CandyTypes.CandyShared} metadata - Metadata of the NFT
  * @param {Types.Account} anAccount - The account to check if it's the owner
  * @returns {Types.OrigynBoolResult} - Result object containing a boolean indicating whether or not the provided account is the owner of the NFT

## Function `get_current_sale_id`
``` motoko no-repl
func get_current_sale_id(metaData : CandyTypes.CandyShared) : CandyTypes.CandyShared
```

* Gets the current sale (or last finished sale) for the specified NFT.
  *
  * @param {CandyTypes.CandyShared} metaData - Metadata of the NFT
  * @returns {CandyTypes.CandyShared} - The current sale ID (or empty if no sale exists)

## Function `get_primary_host`
``` motoko no-repl
func get_primary_host(state : Types.State, token_id : Text, caller : Principal) : Types.OrigynTextResult
```

* Gets the primary host of the specified NFT. Used for testing redirects locally.
  *
  * @param {Types.State} state - The current state of the system
  * @param {Text} token_id - The ID of the NFT
  * @param {Principal} caller - The caller's principal ID
  * @returns {Types.OrigynTextResult} - Result object containing a string of the primary host of the NFT, or an error if it couldn't be found

## Function `get_primary_port`
``` motoko no-repl
func get_primary_port(state : Types.State, token_id : Text, caller : Principal) : Types.OrigynTextResult
```

* Gets the primary port of the specified NFT. Used for testing redirects locally.
  *
  * @param {Types.State} state - The current state of the system
  * @param {Text} token_id - The ID of the NFT
  * @param {Principal} caller - The caller's principal ID
  * @returns {Types.OrigynTextResult} - Result object containing a string of the primary port of the NFT, or an error if it couldn't be found

## Function `get_primary_protocol`
``` motoko no-repl
func get_primary_protocol(state : Types.State, token_id : Text, caller : Principal) : Types.OrigynTextResult
```

* Gets the primary protocol of the specified NFT. Used for testing redirects locally.
  *
  * @param {Types.State} state - The current state of the system
  * @param {Text} token_id - The ID of the NFT
  * @param {Principal} caller - The caller's principal ID
  * @returns {Types.OrigynTextResult} - Result object containing a string of the primary protocol of the NFT, or an error if it couldn't be found

## Function `get_clean_metadata`
``` motoko no-repl
func get_clean_metadata(metadata : CandyTypes.CandyShared, caller : Principal) : CandyTypes.CandyShared
```

* Cleans metadata according to permissions.
  *
  * @param {CandyTypes.CandyShared} metadata - The metadata to clean
  * @param {Principal} caller - The caller's principal ID
  * @returns {CandyTypes.CandyShared} - The cleaned metadata

## Function `clean_node`
``` motoko no-repl
func clean_node(root_class : CandyTypes.CandyShared, a_class : CandyTypes.CandyShared, owner : ?Types.Account, caller : Principal) : CandyTypes.CandyShared
```

* Cleans a node in metadata based on permissions
  * @param {CandyTypes.CandyShared} a_class - the node to clean
  * @param {?Types.Account} owner - the account that owns the node, if any
  * @param {Principal} caller - the principal making the request
  * @returns {CandyTypes.CandyShared} the cleaned node

## Function `get_metadata_for_token`
``` motoko no-repl
func get_metadata_for_token(state : Types.State, token_id : Text, caller : Principal, canister : ?Principal, canister_owner : Principal) : Result.Result<CandyTypes.CandyShared, Types.OrigynError>
```

* Retrieves the metadata for a token
  * @param {Types.State} state - the current state of the canister
  * @param {Text} token_id - the ID of the token to retrieve metadata for
  * @param {Principal} caller - the caller of the function
  * @param {Principal|null} canister - the ID of the canister to retrieve metadata for
  * @param {Principal} canister_owner - the owner of the canister
  * @returns {Result.Result<CandyTypes.CandyShared, Types.OrigynError>} - the result of the metadata retrieval attempt

## Function `add_transaction_record`
``` motoko no-repl
func add_transaction_record(state : Types.State, rec : MigrationTypes.Current.TransactionRecord, caller : Principal) : Result.Result<MigrationTypes.Current.TransactionRecord, Types.OrigynError>
```

* Adds a transaction record to the ledger
  * @param {Types.State} state - the current state of the canister
  * @param {MigrationTypes.Current.TransactionRecord} rec - the transaction record to add
  * @param {Principal} caller - the caller of the function
  * @returns {Result.Result<MigrationTypes.Current.TransactionRecord, Types.OrigynError>} - the result of the transaction record addition attempt

## Function `announceTransaction`
``` motoko no-repl
func announceTransaction(state : Types.State, rec : MigrationTypes.Current.TransactionRecord) : ()
```

* Announces a transaction
  * @param {Types.State} state - the current state of the canister
  * @param {MigrationTypes.Current.TransactionRecord} rec - the transaction record being announced
  * @returns {void}

## Function `get_nft_library`
``` motoko no-repl
func get_nft_library(metadata : CandyTypes.CandyShared, caller : ?Principal) : Result.Result<CandyTypes.CandyShared, Types.OrigynError>
```

* Retrieves the library metadata for an NFT
  * @param {CandyTypes.CandyShared} metadata - the metadata for the NFT
  * @param {Principal} [caller=null] - the caller of the function
  * @returns {Result.Result<CandyTypes.CandyShared, Types.OrigynError>} - the result of the metadata retrieval attempt

## Function `get_nft_library_array`
``` motoko no-repl
func get_nft_library_array(metadata : CandyTypes.CandyShared, caller : ?Principal) : Result.Result<[CandyTypes.CandyShared], Types.OrigynError>
```

* Retrieves an array of the library metadata for an NFT
  * @param {CandyTypes.CandyShared} metadata - the metadata for the NFT
  * @param {Principal} [caller=null] - the caller of the function
  * @returns {Result.Result<[CandyTypes.CandyShared], Types.OrigynError>} - the result of the metadata retrieval attempt

## Function `chunk_nft_origyn`
``` motoko no-repl
func chunk_nft_origyn(state : Types.State, request : Types.ChunkRequest, caller : ?Principal) : Types.ChunkResult
```

* Gets a specific chunk out of the library storage
  *
  * @param {Types.State} state - the current state of the canister
  * @param {Types.ChunkRequest} request - the request for the chunk content
  * @param {?Principal} caller - the principal making the request
  * @returns {Types.ChunkResult} - a Result type containing either the chunk content or an error message

## Function `collection_update_nft_origyn`
``` motoko no-repl
func collection_update_nft_origyn(state : Types.State, request : Types.ManageCollectionCommand, caller : Principal) : Types.OrigynBoolResult
```

* Updates collection data
  * @param {Types.State} state - The state of the collection
  * @param {Types.ManageCollectionCommand} request - The collection data to be updated
  * @param {Principal} caller - The principal of the caller
  * @returns {Types.OrigynBoolResult} - A Result object containing a boolean indicating the success or failure of the update and an OrigynError in case of failure

## Function `ledger_to_candy`
``` motoko no-repl
func ledger_to_candy(ledger : SB.StableBuffer<MigrationTypes.Current.TransactionRecord>, page : Nat, size : Nat) : [CandyTypes.CandyShared]
```

* Converts a ledger of transaction records to an array of CandyShareds
  * @param {SB.StableBuffer<MigrationTypes.Current.TransactionRecord>} ledger - The ledger to convert
  * @param {Nat} page - The page number of results to return
  * @param {Nat} size - The number of results to return per page
  * @returns {[CandyTypes.CandyShared]} - An array of CandyShareds
