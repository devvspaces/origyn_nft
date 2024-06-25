# origyn_nft_reference/market

## Function `find_escrow_reciept`
``` motoko no-repl
func find_escrow_reciept(state : StateAccess, buyer : Types.Account, seller : Types.Account, token_id : Text) : Result.Result<MigrationTypes.Current.EscrowLedgerTrie, Types.OrigynError>
```

* @param {StateAccess} state - The state access object.
  * @param {Types.Account} buyer - The buyer's account.
  * @param {Types.Account} seller - The seller's account.
  * @param {Text} token_id - The token ID.
  * @returns {Result.Result<MigrationTypes.Current.EscrowLedgerTrie, Types.OrigynError>} - Either the escrow ledger trie or an error.

## Function `is_token_on_sale`
``` motoko no-repl
func is_token_on_sale(state : StateAccess, metadata : CandyTypes.CandyShared, caller : Principal) : Result.Result<Bool, Types.OrigynError>
```

* Checks if a token is currently on sale.
  * @param {StateAccess} state - State access object.
  * @param {CandyTypes.CandyShared} metadata - The metadata for the token.
  * @param {Principal} caller - The caller of the function.
  * @returns {Types.OrigynBoolResult} - A Result type containing either a boolean indicating whether the token is on sale or an error.

## Function `open_sale_nft_origyn`
``` motoko no-repl
func open_sale_nft_origyn(state : StateAccess, token_id : Text, caller : Principal) : Result.Result<Types.ManageSaleResponse, Types.OrigynError>
```

* Opens a sale for an NFT if it is past the date.
  * @param {StateAccess} state - The state of the contract.
  * @param {Text} token_id - The ID of the NFT.
  * @param {Principal} caller - The caller principal.
  * @returns {Result.Result<Types.ManageSaleResponse,Types.OrigynError>} - A `Result` object that either contains a `Types.ManageSaleResponse` object or a `Types.OrigynError` object.

## Function `sale_status_nft_origyn`
``` motoko no-repl
func sale_status_nft_origyn(state : StateAccess, sale_id : Text, caller : Principal) : Result.Result<Types.SaleInfoResponse, Types.OrigynError>
```

* Reports information about a sale.
  * @param {StateAccess} state - The state of the contract.
  * @param {Text} sale_id - The ID of the sale.
  * @param {Principal} caller - The caller principal.
  * @returns {Result.Result<Types.SaleInfoResponse,Types.OrigynError>} - A `Result` object that either contains a `Types.SaleInfoResponse` object or a `Types.OrigynError` object.

## Function `active_sales_nft_origyn`
``` motoko no-repl
func active_sales_nft_origyn(state : StateAccess, pages : ?(Nat, Nat), caller : Principal) : Result.Result<Types.SaleInfoResponse, Types.OrigynError>
```

* Returns active sales on a canister
  *
  * @param {StateAccess} state - The state of the canister
  * @param {Array.<number>} pages - Optional tuple of start page and page size.
  * @param {Principal} caller - The principal of the caller.
  * @returns {Result.Result.<Types.SaleInfoResponse,Types.OrigynError>} - A `Result` object that either contains the sale information as a `Types.SaleInfoResponse` object or an error as a `Types.OrigynError` object.

## Function `history_sales_nft_origyn`
``` motoko no-repl
func history_sales_nft_origyn(state : StateAccess, pages : ?(Nat, Nat), caller : Principal) : Result.Result<Types.SaleInfoResponse, Types.OrigynError>
```

* Returns a history of sales.
    *
    * @param {StateAccess} state - StateAccess object for accessing the canister's state.
    * @param {?(Nat, Nat)} pages - Optional tuple of pagination information in the form (start index, page size).
    * @param {Principal} caller - Principal of the caller making the request.
    * @returns {Result.Result<Types.SaleInfoResponse,Types.OrigynError>} - A result containing a history of sales.

## Function `deposit_info_nft_origyn`
``` motoko no-repl
func deposit_info_nft_origyn(state : StateAccess, request : ?Types.Account, caller : Principal) : Result.Result<Types.SaleInfoResponse, Types.OrigynError>
```

* Returns an invoice or details of where a user can send their deposits on a standard ledger.
    *
    * @param {StateAccess} state - StateAccess object for accessing the canister's state.
    * @param {?Types.Account} request - Optional account information for the request.
    * @param {Principal} caller - Principal of the caller making the request.
    * @returns {Result.Result<Types.SaleInfoResponse,Types.OrigynError>} - A result containing the invoice or deposit information.

## Function `escrow_info_nft_origyn`
``` motoko no-repl
func escrow_info_nft_origyn(state : StateAccess, request : Types.EscrowReceipt, caller : Principal) : Result.Result<Types.SaleInfoResponse, Types.OrigynError>
```

* Returns an invoice or details of where a user can send their escrow on a standard ledger.
    *
    * @param {StateAccess} state - StateAccess object for accessing the canister's state.
    * @param {Types.EscrowRecord} request - Escrow Info to use to derive the account.
    * @param {Principal} caller - Principal of the caller making the request.
    * @returns {Result.Result<Types.SaleInfoResponse,Types.OrigynError>} - A result containing the invoice or deposit information.

## Function `fee_deposit_info_nft_origyn`
``` motoko no-repl
func fee_deposit_info_nft_origyn(state : StateAccess, request : ?Types.Account, caller : Principal) : Result.Result<Types.SaleInfoResponse, Types.OrigynError>
```

* returns an account that a seller can deposit tokens into for fees
    *
    * @param {StateAccess} state - StateAccess object for accessing the canister's state.
    * @param {Types.Account} request - Account Info to use to derive the account.
    * @param {Principal} caller - Principal of the caller making the request.
    * @returns {Result.Result<Types.FeeDepositInfoResponse,Types.OrigynError>} - A result containing the deposit information.

## Function `end_sale_nft_origyn`
``` motoko no-repl
func end_sale_nft_origyn(state : StateAccess, token_id : Text, caller : Principal) : async* Star.Star<Types.ManageSaleResponse, Types.OrigynError>
```

* ends a sale if it is past the date or a buy it now has occured
  *
  * @param {StateAccess} state - StateAccess object for accessing the canister's state.
  * @param {Text} token_id - Text object containing the token ID for the sale.
  * @param {Principal} caller - Principal object containing the caller of the function.
  * @returns {Star.Star<Types.ManageSaleResponse, Types.OrigynError>} - Star.Star object containing the result of the function.

## Function `distribute_sale`
``` motoko no-repl
func distribute_sale(state : StateAccess, request : Types.DistributeSaleRequest, caller : Principal) : async* Star.Star<Types.ManageSaleResponse, Types.OrigynError>
```

* Distributes a sale to the appropriate buyers by adding withdrawal requests to a buffer.
    *
    * @param {StateAccess} state - The state access object.
    * @param {Types.DistributeSaleRequest} request - The request containing the seller information.
    * @param {Principal} caller - The caller principal.
    *
    * @returns {async* Types.ManageSaleResult} - The result of the sale distribution.

## Function `market_transfer_nft_origyn_async`
``` motoko no-repl
func market_transfer_nft_origyn_async(state : StateAccess, request : Types.MarketTransferRequest, caller : Principal, canister_call : Bool) : async* Result.Result<Types.MarketTransferRequestReponse, Types.OrigynError>
```

* Handles async market transfer operations like instant where interaction with other canisters is required
    * @param {StateAccess} state - StateAccess instance representing the state of the canister
    * @param {Types.MarketTransferRequest} request - MarketTransferRequest object containing the details of the transfer
    * @param {Principal} caller - Principal object representing the caller
    * @param {Bool} canister_call - Bool object representing whether the transfer is being done in a canister call
    *
    * @returns {Result.Result<Types.MarketTransferRequestReponse, Types.OrigynError>} Result object representing the result of the transfer operation

## Function `market_transfer_nft_origyn`
``` motoko no-repl
func market_transfer_nft_origyn(state : StateAccess, request : Types.MarketTransferRequest, caller : Principal) : async* Result.Result<Types.MarketTransferRequestReponse, Types.OrigynError>
```

* Processes royalties for a given escrow transaction and updates state accordingly.
    * @param {StateAccess} state - StateAccess object for accessing the canister's state.
    * @param {Types.MarketTransferRequest} request - An object containing the necessary information for royalty processing.
    * @param {Principal} caller - Principal object containing the caller of the function.
    *
    * @returns {Result.Result<Types.MarketTransferRequestReponse, Types.OrigynError>} Result object representing the result of the transfer operation

## Function `handle_notify`
``` motoko no-repl
func handle_notify(state : StateAccess) : async ()
```

* handle_notify
  * @param {StateAccess} state - StateAccess object for accessing the canister's state.
  * @returns {async *}

## Function `calc_dutch_price`
``` motoko no-repl
func calc_dutch_price(state : StateAccess, auction : Types.AuctionState, metadata : CandyTypes.CandyShared) : Types.AuctionState
```

* calc_dutch_price
  * @param {StateAccess} state - StateAccess object for accessing the canister's state.
  * @param {Types.AuctionState} auction - AuctionState object containing the auction details.
  * @param {CandyTypes.CandyShared} metadata - CandyShared object containing the metadata for the sale.
  * @returns {Types.AuctionState} - AuctionState object containing the updated auction details.

## Function `refresh_offers_nft_origyn`
``` motoko no-repl
func refresh_offers_nft_origyn(state : StateAccess, request : ?Types.Account, caller : Principal) : Types.ManageSaleResult
```

* refresh_offers_nft_origyn
  * @param {StateAccess} state - StateAccess object for accessing the canister's state.
  * @param {?Types.Account} request - Optional account information for the request.
  * @param {Principal} caller - Principal object representing the caller.
  * @returns {Types.ManageSaleResult} - A result indicating whether the offers were refreshed.

## Function `escrow_nft_origyn`
``` motoko no-repl
func escrow_nft_origyn(state : StateAccess, request : Types.EscrowRequest, caller : Principal) : async* Star.Star<Types.ManageSaleResponse, Types.OrigynError>
```

* escrow_nft_origyn
  * @param {StateAccess} state - StateAccess object for accessing the canister's state.
  * @param {Types.EscrowRequest} request - EscrowRequest object containing the details of the deposit and escrow.
  * @param {Principal} caller - Principal object representing the caller.
  * @returns {Star.Star<Types.ManageSaleResponse, Types.OrigynError>} - A result indicating whether the escrow was created.

## Function `deposit_fee_nft_origyn`
``` motoko no-repl
func deposit_fee_nft_origyn(state : StateAccess, request : Types.FeeDepositRequest, caller : Principal) : async* Star.Star<Types.ManageSaleResponse, Types.OrigynError>
```

* deposit_fee_nft_origyn
  * @param {StateAccess} state - StateAccess object for accessing the canister's state.
  * @param {Types.FeeDepositRequest} request - FeeDepositRequest object containing the details of the fee deposit.
  * @param {Principal} caller - Principal object representing the caller.
  * @returns {Star.Star<Types.ManageSaleResponse, Types.OrigynError>} - A result indicating whether the fee deposit was created.

## Function `ask_subscribe_nft_origyn`
``` motoko no-repl
func ask_subscribe_nft_origyn(state : StateAccess, request : Types.AskSubscribeRequest, caller : Principal) : async* Star.Star<Types.ManageSaleResponse, Types.OrigynError>
```

* ask_subscribe_nft_origyn
  * @param {StateAccess} state - StateAccess object for accessing the canister's state.
  * @param {Types.AskSubscribeRequest} request - AskSubscribeRequest object containing the details of the ask subscribe.
  * @param {Principal} caller - Principal object representing the caller.
  * @returns {Star.Star<Types.ManageSaleResponse, Types.OrigynError>} - A result indicating whether the ask subscribe was created.

## Function `recognize_escrow_nft_origyn`
``` motoko no-repl
func recognize_escrow_nft_origyn(state : StateAccess, request : Types.EscrowRequest, caller : Principal) : async* Star.Star<Types.ManageSaleResponse, Types.OrigynError>
```

* recognize_escrow_nft_origyn
  * @param {StateAccess} state - StateAccess object for accessing the canister's state.
  * @param {Types.EscrowRequest} request - EscrowRequest object containing the details of the escrow.
  * @param {Principal} caller - Principal object representing the caller.
  * @returns {Star.Star<Types.ManageSaleResponse, Types.OrigynError>} - A result indicating whether the escrow was recognized.

## Function `withdraw_nft_origyn`
``` motoko no-repl
func withdraw_nft_origyn(state : StateAccess, withdraw : Types.WithdrawRequest, caller : Principal) : async* Star.Star<Types.ManageSaleResponse, Types.OrigynError>
```

* Allows the user to withdraw tokens from an NFT canister.
    * @param {StateAccess} state - The StateAccess instance of the NFT canister.
    * @param {Types.WithdrawRequest} withdraw - The withdraw request details containing token information.
    * @param {Principal} caller - The Principal of the caller.
    * @returns {async* Types.ManageSaleResult} - A Result object containing either a ManageSaleResponse or an OrigynError.

## Function `bid_nft_origyn`
``` motoko no-repl
func bid_nft_origyn(state : StateAccess, request : Types.BidRequest, caller : Principal, canister_call : Bool) : async* Star.Star<Types.ManageSaleResponse, Types.OrigynError>
```

* Allows bids on auctions. Verifies auction status, seller, buyer, token ownership, and bid amount before allowing a bid.
    * If the bid is too low, it will refund the escrow. If the auction is already closed, it will attempt to refund the bid.
    * If the escrow cannot be verified, it will try to claim it first.
    *
    * @param {StateAccess} state - The state of the canister.
    * @param {Types.BidRequest} request - The bid request containing the token id and escrow receipt.
    * @param {Principal} caller - The principal of the caller.
    * @param {Bool} canister_call - Determines if the function is being called from another function within the canister.
    * @returns {Types.ManageSaleResult} A result indicating either a successful bid or an error message.
