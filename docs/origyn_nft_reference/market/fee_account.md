# origyn_nft_reference/market/fee_account

## Function `lock_token_fee_balance`
``` motoko no-repl
func lock_token_fee_balance(state : StateAccess, request : { account : Types.Account; token : Types.TokenSpec; token_to_lock : Nat; sale_id : Text }) : Result.Result<Nat, Types.OrigynError>
```

* @param {StateAccess} state - The state access object.
    * @param {Types.FeeDepositRequest} FeeDepositRequest - The request record to be processed.
    * @returns {Nat} - The amount of free tokens available for fees. Returns 0 if the calculated free amount is negative or if no balance is found.

## Function `free_token_fee_balance`
``` motoko no-repl
func free_token_fee_balance(state : StateAccess, request : { account : Types.Account; token : Types.TokenSpec }) : Result.Result<Nat, Types.OrigynError>
```

* @param {StateAccess} state - The state access object.
    * @param {Types.FeeDepositRequest} FeeDepositRequest - The request record to be processed.
    * @returns {Nat} - The amount of free tokens available for fees. Returns 0 if the calculated free amount is negative or if no balance is found.

## Function `unlock_token_fee_balance`
``` motoko no-repl
func unlock_token_fee_balance(state : StateAccess, request : { account : Types.Account; token : Types.TokenSpec; sale_id : Text; update_balance : Bool }) : Result.Result<Nat, Types.OrigynError>
```

* @param {StateAccess} state - The state access object.
    * @param {Types.FeeDepositRequest} FeeDepositRequest - The request record to be processed.
    * @returns {Nat} - The amount of free tokens available for fees. Returns 0 if the calculated free amount is negative or if no balance is found.
