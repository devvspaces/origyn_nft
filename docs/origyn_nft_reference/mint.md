# origyn_nft_reference/mint

## Function `mint_nft_origyn`
``` motoko no-repl
func mint_nft_origyn(state : Types.State, token_id : Text, new_owner : Types.Account, caller : Principal) : async* Result.Result<Text, Types.OrigynError>
```

* Mint an NFT and update the metadata for relevant library canisters.
    *
    * @param {Types.State} state - The current state of the canister.
    * @param {Text} token_id - The ID of the token to be minted.
    * @param {Types.Account} new_owner - The owner of the newly minted token.
    * @param {Principal} caller - The caller of the function.
    *
    * @returns {Types.OrigynTextResult} - If successful, returns the token ID as a string, otherwise returns an error.
    *
    * @throws {Types.OrigynError} - If the caller is not authorized to mint tokens.

## Function `stage_nft_origyn`
``` motoko no-repl
func stage_nft_origyn(state : Types.State, metadata : CandyTypes.CandyShared, caller : Principal) : Types.OrigynTextResult
```


## Function `stage_library_nft_origyn`
``` motoko no-repl
func stage_library_nft_origyn(state : Types.State, chunk : Types.StageChunkArg, caller : Principal) : Types.LocalStageLibraryResult
```

* Stages a chunk of a library. The chunk size is limited to 2MB.
    * @param {Types.State} state - The state of the canister.
    * @param {Types.StageChunkArg} chunk - The chunk of the library to be staged.
    * @param {Principal} caller - The principal of the caller.
    * @returns {Result.Result<Types.LocalStageLibraryResponse, Types.OrigynError>} - Returns a result indicating success or error.
    * @throws {Types.OrigynError} - Throws an error if there is an unauthorized access, a library is not found, or there is not enough storage.

## Function `stage_library_nft_origyn_remote`
``` motoko no-repl
func stage_library_nft_origyn_remote(state : Types.State, chunk : Types.StageChunkArg, allocation : Types.AllocationRecord, metadata : CandyTypes.CandyShared, caller : Principal) : async* Types.StageLibraryResult
```

* Stage a library remotely for an NFT origyn
    *
    * @param {Types.State} state - The current state
    * @param {Types.StageChunkArg} chunk - The stage chunk argument
    * @param {Types.AllocationRecord} allocation - The allocation record
    * @param {CandyTypes.CandyShared} metadata - The metadata of the candy
    * @param {Principal} caller - The caller principal
    * @returns {async* Result.Result<Types.StageLibraryResponse, Types.OrigynError>} The result of the stage library operation

## Function `execute_mint`
``` motoko no-repl
func execute_mint(state : Types.State, token_id : Text, newOwner : Types.Account, escrow : ?Types.EscrowReceipt, caller : Principal) : Result.Result<(Text, CandyTypes.CandyShared, MigrationTypes.Current.TransactionRecord), Types.OrigynError>
```

* Executes the mint and gives ownership to the specified user
    * @param {Types.State} state - The current state of the system
    * @param {Text} token_id - The ID of the token to be minted
    * @param {Types.Account} newOwner - The account that will own the minted token
    * @param {Types.EscrowReceipt | null} escrow - An optional escrow receipt for the token sale
    * @param {Principal} caller - The principal of the caller
    * @returns {Result.Result<(Text, CandyTypes.CandyShared, MigrationTypes.Current.TransactionRecord), Types.OrigynError>} A result containing the token ID, metadata, and transaction record if successful, or an error if the mint fails
