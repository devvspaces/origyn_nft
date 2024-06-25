# origyn_nft_reference/market/royalties

## Value `royalties_names`
``` motoko no-repl
let royalties_names : [MigrationTypes.Current.FeeName]
```


## Function `get_total_amount_fixed_royalties`
``` motoko no-repl
func get_total_amount_fixed_royalties(fee_accounts : [MigrationTypes.Current.FeeName], metadata : CandyTypes.CandyShared) : Nat
```


## Function `royalty_to_array`
``` motoko no-repl
func royalty_to_array(properties : CandyTypes.CandyShared, collection : Text) : [CandyTypes.CandyShared]
```

* Converts the properties and collection of a Candy NFT to an array.
    *
    * @param {CandyTypes.CandyShared} properties - The properties of the Candy NFT.
    * @param {Text} collection - The collection of the Candy NFT.
    *
    * @returns {Array} - An array of Candy NFT properties.

## Function `get_network_royalty_account`
``` motoko no-repl
func get_network_royalty_account(principal : Principal, ledger_token_id : ?Nat) : [Nat8]
```

* Calculates the network royalty account for a given principal.
    *
    * @param {Principal} principal - The principal for which to calculate the network royalty account.
    *
    * @returns {Array<Nat8>} An array of 8-bit natural numbers representing the calculated network royalty account.

## Function `_load_royalty`
``` motoko no-repl
func _load_royalty(fee_schema : Text, royalty : CandyTypes.CandyShared) : Result.Result<MigrationTypes.Current.Royalty, Types.OrigynError>
```


## Function `_process_royalties`
``` motoko no-repl
func _process_royalties(state : StateAccess, request : ProcessRoyaltiesRequest, caller : Principal) : (Nat, [(Types.EscrowRecord, Bool)])
```

