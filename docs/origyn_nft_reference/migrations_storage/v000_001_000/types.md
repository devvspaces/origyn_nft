# origyn_nft_reference/migrations_storage/v000_001_000/types

## Value `SB`
``` motoko no-repl
let SB
```


## Value `Map`
``` motoko no-repl
let Map
```


## Value `CandyTypes`
``` motoko no-repl
let CandyTypes
```


## Type `CollectionData`
``` motoko no-repl
type CollectionData = { var owner : Principal; var managers : [Principal]; var network : ?Principal }
```


## Type `CollectionDataForStorage`
``` motoko no-repl
type CollectionDataForStorage = { var owner : Principal; var managers : [Principal]; var network : ?Principal }
```


## Type `AllocationRecord`
``` motoko no-repl
type AllocationRecord = { canister : Principal; allocated_space : Nat; var available_space : Nat; var chunks : SB.StableBuffer<Nat>; token_id : Text; library_id : Text }
```


## Type `LogEntry`
``` motoko no-repl
type LogEntry = { event : Text; timestamp : Int; data : CandyTypes.CandyValue; caller : ?Principal }
```


## Type `State`
``` motoko no-repl
type State = { var nft_metadata : Map.Map<Text, CandyTypes.CandyValue>; var collection_data : CollectionData; var allocations : Map.Map<(Text, Text), AllocationRecord>; var canister_availible_space : Nat; var canister_allocated_storage : Nat; var log : SB.StableBuffer<LogEntry>; var log_history : SB.StableBuffer<[LogEntry]>; var log_harvester : Principal }
```

