# origyn_nft_reference/storage_store

## Function `stage_library_nft_origyn`
``` motoko no-repl
func stage_library_nft_origyn(state : Types.StorageState, chunk : Types.StageChunkArg, source_allocation : Types.AllocationRecordStable, metadata : CandyTypes.CandyShared, caller : Principal) : async* Result.Result<Types.StageLibraryResponse, Types.OrigynError>
```

* Stores a chunk of NFT data in the storage.
  * @param {Types.StorageState} state - The current state of the storage.
  * @param {Types.StageChunkArg} chunk - The chunk of data to be stored.
  * @param {Types.AllocationRecordStable} source_allocation - The record of the source allocation.
  * @param {CandyTypes.CandyShared} metadata - The metadata for the chunk.
  * @param {Principal} caller - The principal that triggered the function.
  * @returns {Result.Result<Types.StageLibraryResponse, Types.OrigynError>} The result of the operation.
