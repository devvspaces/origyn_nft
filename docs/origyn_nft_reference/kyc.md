# origyn_nft_reference/kyc

## Function `pass_kyc_buyer`
``` motoko no-repl
func pass_kyc_buyer(state : StateAccess, escrow : MigrationTypes.Current.EscrowRecord, caller : Principal) : async* Result.Result<MigrationTypes.Current.RunKYCResult, Types.OrigynError>
```

* Perform KYC check for buyer of an escrowed asset.
    * @param {StateAccess} state - The state of the escrow transaction.
    * @param {MigrationTypes.Current.EscrowRecord} escrow - The escrowed asset.
    * @param {Principal} caller - The principal of the caller.
    * @returns {async* Result.Result<MigrationTypes.Current.RunKYCResult, Types.OrigynError>} The KYC result for the buyer.

## Function `pass_kyc_seller`
``` motoko no-repl
func pass_kyc_seller(state : StateAccess, escrow : MigrationTypes.Current.EscrowRecord, caller : Principal) : async* Result.Result<MigrationTypes.Current.RunKYCResult, Types.OrigynError>
```

* Perform KYC check for seller of an escrowed asset.
    * @param {StateAccess} state - The state of the escrow transaction.
    * @param {MigrationTypes.Current.EscrowRecord} escrow - The escrowed asset.
    * @param {Principal} caller - The principal of the caller.
    * @returns {async* Result.Result<MigrationTypes.Current.RunKYCResult, Types.OrigynError>} The KYC result for the seller.

## Function `notify_kyc`
``` motoko no-repl
func notify_kyc(state : StateAccess, escrow : MigrationTypes.Current.EscrowRecord, caller : Principal) : async* ()
```

* Notifies the collection kyc canister buyer and elective kyc canister of a successful KYC check for a given sale.
    * @param {StateAccess} state - the state of the current canister
    * @param {MigrationTypes.Current.EscrowRecord} escrow - the escrow record containing the sale information for the executed transaction
    * @param {Principal} caller - the principal of the caller of the function
    * @returns {Promise<void>}
