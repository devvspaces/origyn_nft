# origyn_nft_reference/migrations_storage/v000_001_003/types

## Value `SB`
``` motoko no-repl
let SB
```


## Value `Map`
``` motoko no-repl
let Map
```


## Type `CollectionData`
``` motoko no-repl
type CollectionData = v0_1_0.CollectionData
```


## Type `CollectionDataForStorage`
``` motoko no-repl
type CollectionDataForStorage = v0_1_0.CollectionDataForStorage
```


## Type `AllocationRecord`
``` motoko no-repl
type AllocationRecord = v0_1_0.AllocationRecord
```


## Type `HttpAccess`
``` motoko no-repl
type HttpAccess = { identity : Principal; expires : Int }
```


## Function `compare_library`
``` motoko no-repl
func compare_library(x : (Text, Text), y : (Text, Text)) : Order.Order
```


## Function `library_equal`
``` motoko no-repl
func library_equal(x : (Text, Text), y : (Text, Text)) : Bool
```


## Function `library_hash`
``` motoko no-repl
func library_hash(x : (Text, Text)) : Nat
```


## Type `State`
``` motoko no-repl
type State = { var nft_metadata : Map_lib.Map<Text, CandyTypes_lib.CandyValue>; var collection_data : CollectionData; var allocations : Map_lib.Map<(Text, Text), AllocationRecord>; var canister_availible_space : Nat; var canister_allocated_storage : Nat; var access_tokens : Map_lib.Map<Text, HttpAccess> }
```

