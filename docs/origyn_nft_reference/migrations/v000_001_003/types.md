# origyn_nft_reference/migrations/v000_001_003/types

## Value `SB`
``` motoko no-repl
let SB
```


## Value `Map`
``` motoko no-repl
let Map
```


## Value `Conversions`
``` motoko no-repl
let Conversions
```


## Value `Properties`
``` motoko no-repl
let Properties
```


## Value `CandyTypes`
``` motoko no-repl
let CandyTypes
```


## Type `CollectionData`
``` motoko no-repl
type CollectionData = v0_1_0.CollectionData
```


## Type `BucketData`
``` motoko no-repl
type BucketData = { principal : Principal; var allocated_space : Nat; var available_space : Nat; date_added : Int; b_gateway : Bool; var version : (Nat, Nat, Nat); var allocations : Map.Map<(Text, Text), Int> }
```


## Type `AllocationRecord`
``` motoko no-repl
type AllocationRecord = v0_1_0.AllocationRecord
```


## Type `LogEntry`
``` motoko no-repl
type LogEntry = v0_1_0.LogEntry
```


## Type `SalesSellerTrie`
``` motoko no-repl
type SalesSellerTrie = Map.Map<Account, Map.Map<Account, Map.Map<Text, Map.Map<TokenSpec, EscrowRecord>>>>
```


## Type `SalesBuyerTrie`
``` motoko no-repl
type SalesBuyerTrie = Map.Map<Account, Map.Map<Text, Map.Map<TokenSpec, EscrowRecord>>>
```


## Type `SalesTokenIDTrie`
``` motoko no-repl
type SalesTokenIDTrie = Map.Map<Text, Map.Map<TokenSpec, EscrowRecord>>
```


## Type `SalesLedgerTrie`
``` motoko no-repl
type SalesLedgerTrie = Map.Map<TokenSpec, EscrowRecord>
```


## Type `EscrowBuyerTrie`
``` motoko no-repl
type EscrowBuyerTrie = Map.Map<Account, Map.Map<Account, Map.Map<Text, Map.Map<TokenSpec, EscrowRecord>>>>
```


## Type `EscrowSellerTrie`
``` motoko no-repl
type EscrowSellerTrie = Map.Map<Account, Map.Map<Text, Map.Map<TokenSpec, EscrowRecord>>>
```


## Type `EscrowTokenIDTrie`
``` motoko no-repl
type EscrowTokenIDTrie = Map.Map<Text, Map.Map<TokenSpec, EscrowRecord>>
```


## Type `EscrowLedgerTrie`
``` motoko no-repl
type EscrowLedgerTrie = Map.Map<TokenSpec, EscrowRecord>
```


## Type `Account`
``` motoko no-repl
type Account = v0_1_0.Account
```


## Type `EscrowRecord`
``` motoko no-repl
type EscrowRecord = v0_1_0.EscrowRecord
```


## Type `TokenSpec`
``` motoko no-repl
type TokenSpec = v0_1_0.TokenSpec
```


## Type `ICTokenSpec`
``` motoko no-repl
type ICTokenSpec = v0_1_0.ICTokenSpec
```


## Type `PricingConfig`
``` motoko no-repl
type PricingConfig = v0_1_0.PricingConfig
```


## Type `AuctionConfig`
``` motoko no-repl
type AuctionConfig = v0_1_0.AuctionConfig
```


## Type `TransactionRecord`
``` motoko no-repl
type TransactionRecord = v0_1_0.TransactionRecord
```


## Type `TransactionID`
``` motoko no-repl
type TransactionID = v0_1_0.TransactionID
```


## Type `SaleStatus`
``` motoko no-repl
type SaleStatus = v0_1_0.SaleStatus
```


## Type `EscrowReceipt`
``` motoko no-repl
type EscrowReceipt = v0_1_0.EscrowReceipt
```


## Type `AuctionState`
``` motoko no-repl
type AuctionState = v0_1_0.AuctionState
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


## Function `account_eq`
``` motoko no-repl
func account_eq(a : Account, b : Account) : Bool
```


## Function `token_compare`
``` motoko no-repl
func token_compare(a : TokenSpec, b : TokenSpec) : Order.Order
```


## Function `token_eq`
``` motoko no-repl
func token_eq(a : TokenSpec, b : TokenSpec) : Bool
```


## Function `account_hash`
``` motoko no-repl
func account_hash(a : Account) : Nat
```


## Function `account_hash_uncompressed`
``` motoko no-repl
func account_hash_uncompressed(a : Account) : Nat
```


## Function `token_hash`
``` motoko no-repl
func token_hash(a : TokenSpec) : Nat
```


## Function `token_hash_uncompressed`
``` motoko no-repl
func token_hash_uncompressed(a : TokenSpec) : Nat
```


## Value `account_handler`
``` motoko no-repl
let account_handler
```


## Type `HttpAccess`
``` motoko no-repl
type HttpAccess = { identity : Principal; expires : Int }
```


## Value `token_handler`
``` motoko no-repl
let token_handler
```


## Type `State`
``` motoko no-repl
type State = { var collection_data : CollectionData; var buckets : Map.Map<Principal, BucketData>; var allocations : Map.Map<(Text, Text), AllocationRecord>; var canister_availible_space : Nat; var canister_allocated_storage : Nat; var offers : Map.Map<Account, Map.Map<Account, Int>>; var nft_metadata : Map.Map<Text, CandyTypes.CandyValue>; var escrow_balances : EscrowBuyerTrie; var sales_balances : SalesSellerTrie; var nft_ledgers : Map.Map<Text, SB.StableBuffer<TransactionRecord>>; var nft_sales : Map.Map<Text, SaleStatus>; var access_tokens : Map_lib.Map<Text, HttpAccess> }
```

