# origyn_nft_reference/market/verify_reciept

## Function `verify_escrow_record`
``` motoko no-repl
func verify_escrow_record(state : StateAccess, escrow : Types.EscrowRecord, owner : ?Types.Account) : Result.Result<MigrationTypes.Current.VerifiedReciept, Types.OrigynError>
```


## Function `verify_escrow_receipt`
``` motoko no-repl
func verify_escrow_receipt(state : StateAccess, escrow : Types.EscrowReceipt, owner : ?Types.Account, sale_id : ?Text) : Result.Result<MigrationTypes.Current.VerifiedReciept, Types.OrigynError>
```

* Verifies an escrow receipt to determine whether a buyer/seller/token_id tuple has a balance on file.
  * @param {StateAccess} state - The state access object.
  * @param {Types.EscrowReceipt} escrow - The escrow receipt to verify.
  * @param {?Types.Account} owner - The owner of the asset.
  * @param {?Text} sale_id - The sale id.
  * @returns {Result.Result<MigrationTypes.Current.VerifiedReciept, Types.OrigynError>} Returns a Result object that contains a MigrationTypes.Current.VerifiedReciept object if successful, otherwise it contains a Types.OrigynError object.

## Function `verify_sales_reciept`
``` motoko no-repl
func verify_sales_reciept(state : StateAccess, escrow : Types.EscrowReceipt) : Result.Result<MigrationTypes.Current.VerifiedReciept, Types.OrigynError>
```

* Verifies that a revenue receipt is in the NFT Canister.
  * @param {StateAccess} state - State access object.
  * @param {Types.EscrowReceipt} escrow - The revenue receipt to verify.
  * @returns {Result.Result<MigrationTypes.Current.VerifiedReceipt, Types.OrigynError>} - A Result type containing either a verified receipt or an error.

## Function `handle_escrow_update_error`
``` motoko no-repl
func handle_escrow_update_error(state : StateAccess, escrow : Types.EscrowReceipt, owner : ?Types.Account, found_asset : { token_spec : Types.TokenSpec; escrow : Types.EscrowRecord }, found_asset_list : MigrationTypes.Current.EscrowLedgerTrie) : ()
```

* Handles an error encountered while updating an escrow balance.
    *
    * @param {StateAccess} state - The current state of the canister.
    * @param {Types.EscrowReceipt} escrow - The receipt of the escrow transaction.
    * @param {Types.Account} owner - The account owner.
    * @param {Object} found_asset - An object containing the found asset and its token specifications.
    * @param {MigrationTypes.Current.EscrowLedgerTrie} found_asset_list - The list of found assets.
    *
    * @returns {void}

## Function `handle_sale_update_error`
``` motoko no-repl
func handle_sale_update_error(state : StateAccess, escrow : Types.EscrowReceipt, owner : ?Types.Account, found_asset : { token_spec : Types.TokenSpec; escrow : Types.EscrowRecord }, found_asset_list : MigrationTypes.Current.EscrowLedgerTrie) : ()
```

* Handles an error encountered while updating a sale balance.
    *
    * @param {StateAccess} state - The current state of the canister.
    * @param {Types.EscrowReceipt} escrow - The receipt of the escrow transaction.
    * @param {Types.Account} owner - The account owner.
    * @param {Object} found_asset - An object containing the found asset and its token specifications.
    * @param {MigrationTypes.Current.EscrowLedgerTrie} found_asset_list - The list of found assets.
    *
    * @returns {void}
