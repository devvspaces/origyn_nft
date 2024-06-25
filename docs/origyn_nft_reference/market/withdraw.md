# origyn_nft_reference/market/withdraw

## Function `_withdraw_deposit`
``` motoko no-repl
func _withdraw_deposit(state : StateAccess, withdraw : Types.WithdrawRequest, details : Types.DepositWithdrawDescription, caller : Principal) : async* Star.Star<Types.ManageSaleResponse, Types.OrigynError>
```

* Withdraw or deposit funds to a specified account using the specified details.
    * @param {StateAccess} state - The state of the canister.
    * @param {Types.DepositWithdrawDescription} details - The details of the withdrawal or deposit.
    * @param {Principal} caller - The caller of the function.
    * @returns {async* Result.Result<Types.ManageSaleResponse,Types.OrigynError>} - The result of the operation which may contain an error.

## Function `_withdraw_fee_deposit`
``` motoko no-repl
func _withdraw_fee_deposit(state : StateAccess, withdraw : Types.WithdrawRequest, details : Types.FeeDepositWithdrawDescription, caller : Principal) : async* Star.Star<Types.ManageSaleResponse, Types.OrigynError>
```

* Withdraw fee deposit funds to a specified account using the specified details.
    * @param {StateAccess} state - The state of the canister.
    * @param {Types.DepositWithdrawDescription} details - The details of the withdrawal or deposit.
    * @param {Principal} caller - The caller of the function.
    * @returns {async* Result.Result<Types.ManageSaleResponse,Types.OrigynError>} - The result of the operation which may contain an error.

## Function `_withdraw_escrow`
``` motoko no-repl
func _withdraw_escrow(state : StateAccess, withdraw : Types.WithdrawRequest, details : Types.WithdrawDescription, caller : Principal) : async* Star.Star<Types.ManageSaleResponse, Types.OrigynError>
```

* Withdraws an asset from an escrow account and sends payment to the designated recipient.
    * @param {StateAccess} state - the state access object
    * @param {Types.WithdrawRequest} withdraw - the withdraw request object containing information about the asset being withdrawn
    * @param {Types.WithdrawDescription} details - the description of the withdrawal
    * @param {Principal} caller - the caller of the function
    * @returns {async* Result.Result<Types.ManageSaleResponse,Types.OrigynError>} - the result of the function execution

## Function `_withdraw_sale`
``` motoko no-repl
func _withdraw_sale(state : StateAccess, withdraw : Types.WithdrawRequest, details : Types.WithdrawDescription, caller : Principal) : async* Star.Star<Types.ManageSaleResponse, Types.OrigynError>
```

* Withdraws a sale for a given token from the escrow and sends payment to the specified recipient.
    *
    * @param {StateAccess} state - The state access object.
    * @param {Types.WithdrawRequest} withdraw - The withdrawal request object.
    * @param {Types.WithdrawDescription} details - The withdrawal details object.
    * @param {Principal} caller - The caller of the function.
    * @returns {Types.ManageSaleResult} - A Result object that either contains a ManageSaleResponse or an OrigynError if the withdrawal failed.

## Function `_reject_offer`
``` motoko no-repl
func _reject_offer(state : StateAccess, withdraw : Types.WithdrawRequest, details : Types.RejectDescription, caller : Principal) : async* Star.Star<Types.ManageSaleResponse, Types.OrigynError>
```

* Rejects an offer and sends the tokens back to the source.
    * @param {StateAccess} state - The state access object.
    * @param {Types.WithdrawRequest} withdraw - The withdraw request object.
    * @param {Types.RejectDescription} details - The reject description object.
    * @param {Principal} caller - The caller principal.
    * @returns {async* Result.Result<Types.ManageSaleResponse,Types.OrigynError>} A Result type containing either a Types.ManageSaleResponse object or a Types.OrigynError object.
