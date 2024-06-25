# origyn_nft_reference/owner

## Function `share_wallet_nft_origyn`
``` motoko no-repl
func share_wallet_nft_origyn(state : StateAccess, request : Types.ShareWalletRequest, caller : Principal) : Result.Result<Types.OwnerTransferResponse, Types.OrigynError>
```

* Share ownership of an NFT token within the same principal or account ID.
    * This should only be used by the owner to transfer between wallets they own.
    * To protect this, any assets in the canister associated with the account/principal should be moved along with the token.
    *
    * @param {StateAccess} state - the state of the canister
    * @param {Types.ShareWalletRequest} request - the request object containing the token ID, the current owner's account, and the new owner's account
    * @param {Principal} caller - the principal of the caller
    *
    * @returns {Types.OwnerUpdateResult} the transaction record and a list of assets associated with the token

## Function `transferDip721`
``` motoko no-repl
func transferDip721(state : StateAccess, from : Principal, to : Principal, tokenAsNat : Nat, caller : Principal) : async* DIP721.DIP721NatResult
```

* Transfer a DIP721 token from one principal to another by finding the appropriate escrow record and using it for the transfer.
    * If the escrow does not exist, the function fails.
    *
    * @param {StateAccess} state - StateAccess to the canister's state
    * @param {Principal} from - The principal that currently owns the token
    * @param {Principal} to - The principal that will own the token after the transfer
    * @param {Nat} tokenAsNat - The token ID encoded as a Nat value
    * @param {Principal} caller - The principal that called the function
    *
    * @returns {DIP721.Result} - A DIP721 result object indicating the success or failure of the transfer operation.

## Function `_prepare_transferICRC7`
``` motoko no-repl
func _prepare_transferICRC7(state : StateAccess, from : ICRC7.Account, to : ICRC7.Account, tokenAsNat : Nat, caller : Principal) : async* ICRC7.TransferResultItem
```

* Prepare ransfer a ICRC7 token from one account to another by finding the appropriate escrow record and using it for the transfer.
    * If the escrow does not exist, the function fails.
    *
    * @param {StateAccess} state - StateAccess to the canister's state
    * @param {Account} from - The account that currently owns the token
    * @param {Account} to - The account that will own the token after the transfer
    * @param {Nat} tokenAsNat - The token ID encoded as a Nat value
    * @param {Principal} caller - The principal that called the function
    *
    * @returns {ICRC7.TransferResult} - A ICRC7 result object indicating the success or failure of the transfer operation.

## Function `transferICRC7`
``` motoko no-repl
func transferICRC7(state : StateAccess, from : ICRC7.Account, to : ICRC7.Account, tokenAsNat : Nat, caller : Principal) : async* ICRC7.TransferResultItem
```

* Transfer a ICRC7 token from one account to another by finding the appropriate escrow record and using it for the transfer.
    * If the escrow does not exist, the function fails.
    *
    * @param {StateAccess} state - StateAccess to the canister's state
    * @param {Account} from - The account that currently owns the token
    * @param {Account} to - The account that will own the token after the transfer
    * @param {Nat} tokenAsNat - The token ID encoded as a Nat value
    * @param {Principal} caller - The principal that called the function
    *
    * @returns {ICRC7.TransferResult} - A ICRC7 result object indicating the success or failure of the transfer operation.

## Function `transferExt`
``` motoko no-repl
func transferExt(state : StateAccess, request : EXT.TransferRequest, caller : Principal) : async* EXT.TransferResponse
```

* Transfer an EXT token from one principal to another by finding the appropriate escrow record and using it for the transfer.
    * If the escrow does not exist, the function fails.
    *
    * @param {StateAccess} state - StateAccess to the canister's state
    * @param {EXT.TransferRequest} request - The transfer request object, which includes information about the token and the principals involved in the transfer
    * @param {Principal} caller - The principal that called the function
    *
    * @returns {EXT.TransferResponse} - A transfer response object indicating the success or failure of the transfer operation.

## Function `getNFTForTokenIdentifier`
``` motoko no-repl
func getNFTForTokenIdentifier(state : StateAccess, token : EXT.TokenIdentifier) : Result.Result<Text, Types.OrigynError>
```

* Gets the NFT with the specified token identifier.
    *
    * @param {StateAccess} state - The state accessor.
    * @param {EXT.TokenIdentifier} token - The token identifier to search for.
    *
    * @returns {Result.Result<Text,Types.OrigynError>} Returns a result indicating success or failure with the data or an error message.

## Function `bearerEXT`
``` motoko no-repl
func bearerEXT(state : StateAccess, tokenIdentifier : EXT.TokenIdentifier, caller : Principal) : Types.EXTBearerResult
```

* Gets the account identifier of the bearer of the NFT with the specified token identifier.
    *
    * @param {StateAccess} state - The state accessor.
    * @param {EXT.TokenIdentifier} tokenIdentifier - The token identifier for which to get the account identifier of the bearer.
    * @param {Principal} caller - The caller principal.
    *
    * @returns {Types.EXTBearerResult} Returns a result indicating success or failure with the data or an error message.
