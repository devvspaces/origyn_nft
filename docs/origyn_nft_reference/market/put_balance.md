# origyn_nft_reference/market/put_balance

## Function `put_fee_deposit_balance`
``` motoko no-repl
func put_fee_deposit_balance(state : StateAccess, request : Types.FeeDepositRequest, balance : Nat) : Result.Result<Nat, Types.OrigynError>
```

* Processes a change in fee_deposit balance.
    *
    * @param {StateAccess} state - The state access object.
    * @param {Types.FeeDepositRequest} FeeDepositRequest - The request record to be processed.
    * @returns {Types.EscrowRecord} - The updated escrow record.

## Function `put_escrow_balance`
``` motoko no-repl
func put_escrow_balance(state : StateAccess, escrow : Types.EscrowRecord, append : Bool) : Types.EscrowRecord
```

* Processes a change in escrow balance.
    *
    * @param {StateAccess} state - The state access object.
    * @param {Types.EscrowRecord} escrow - The escrow record to be processed.
    * @param {Bool} append - Determines whether to append the balance to the ledger or not.
    *
    * @returns {Types.EscrowRecord} - The updated escrow record.

## Function `put_sales_balance`
``` motoko no-repl
func put_sales_balance(state : StateAccess, sale_balance : Types.EscrowRecord, append : Bool) : Types.EscrowRecord
```

* Processes a changing sale balance.
    *
    * @param {StateAccess} state - The state access object.
    * @param {Types.EscrowRecord} sale_balance - The sale balance to be processed.
    * @param {Bool} append - Determines whether to append the balance to the ledger or not.
    *
    * @returns {Types.EscrowRecord} - The updated sale balance.
