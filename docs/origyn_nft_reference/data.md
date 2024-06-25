# origyn_nft_reference/data

## Function `update_app_nft_origyn`
``` motoko no-repl
func update_app_nft_origyn(request : Types.NFTUpdateRequest, state : Types.State, caller : Principal) : Types.UpdateAppResponse
```

*  Updates an NFT's metadata with information about the app it belongs to.
  *  @param {Types.NFTUpdateRequest} request - The update request object containing the token ID and app ID to be updated.
  *  @param {Types.State} state - The current state of the Origyn canister.
  *  @param {Principal} caller - The principal of the caller making the update request.
  *  @returns {Types.NFTUpdateResult} - Returns a Result object containing either a Types.NFTUpdateResponse object or a Types.OrigynError object if an error occurs during the update process.
  *  @throws {Types.OrigynError} Throws an OrigynError if an error occurs during the update process.
