# origyn_nft_reference/governance

## Function `governance_nft_origyn`
``` motoko no-repl
func governance_nft_origyn(state : Types.State, request : Types.GovernanceRequest, caller : Principal) : async* Types.GovernanceResult
```

* Executes a governance action for an NFT in the Origyn canister.
  * @param {Types.State} state - The current state of the Origyn canister.
  * @param {Types.GovernanceRequest} request - The governance request object specifying the type of action to execute.
  * @param {Principal} caller - The principal of the caller making the governance request.
  * @returns {Types.GovernanceResult} - Returns a Result object containing either a Types.GovernanceResponse object or a Types.OrigynError object if an error occurs during the governance process.
  * @throws {Types.OrigynError} Throws an OrigynError if an error occurs during the governance process.
