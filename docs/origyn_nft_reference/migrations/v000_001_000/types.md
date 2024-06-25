# origyn_nft_reference/migrations/v000_001_000/types

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
type CollectionData = { var logo : ?Text; var name : ?Text; var symbol : ?Text; var metadata : ?CandyTypes.CandyValue; var owner : Principal; var managers : [Principal]; var network : ?Principal; var allocated_storage : Nat; var available_space : Nat; var active_bucket : ?Principal }
```


## Type `BucketData`
``` motoko no-repl
type BucketData = { principal : Principal; var allocated_space : Nat; var available_space : Nat; date_added : Int; b_gateway : Bool; var version : (Nat, Nat, Nat); var allocations : Map.Map<(Text, Text), Int> }
```


## Type `AllocationRecord`
``` motoko no-repl
type AllocationRecord = { canister : Principal; allocated_space : Nat; var available_space : Nat; var chunks : SB.StableBuffer<Nat>; token_id : Text; library_id : Text }
```


## Type `LogEntry`
``` motoko no-repl
type LogEntry = { event : Text; timestamp : Int; data : CandyTypes.CandyValue; caller : ?Principal }
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
type Account = {#principal : Principal; #account : { owner : Principal; sub_account : ?Blob }; #account_id : Text; #extensible : CandyTypes.CandyValue}
```


## Type `EscrowRecord`
``` motoko no-repl
type EscrowRecord = { amount : Nat; buyer : Account; seller : Account; token_id : Text; token : TokenSpec; sale_id : ?Text; lock_to_date : ?Int; account_hash : ?Blob }
```


## Type `TokenSpec`
``` motoko no-repl
type TokenSpec = {#ic : ICTokenSpec; #extensible : CandyTypes.CandyValue}
```


## Type `ICTokenSpec`
``` motoko no-repl
type ICTokenSpec = { canister : Principal; fee : Nat; symbol : Text; decimals : Nat; standard : {#DIP20; #Ledger; #EXTFungible; #ICRC1} }
```


## Type `PricingConfig`
``` motoko no-repl
type PricingConfig = {#instant; #flat : { token : TokenSpec; amount : Nat }; #dutch : { start_price : Nat; decay_per_hour : Float; reserve : ?Nat }; #auction : AuctionConfig; #extensible : {#candyClass}}
```


## Type `AuctionConfig`
``` motoko no-repl
type AuctionConfig = { reserve : ?Nat; token : TokenSpec; buy_now : ?Nat; start_price : Nat; start_date : Int; ending : {#date : Int; #waitForQuiet : { date : Int; extention : Nat64; fade : Float; max : Nat }}; min_increase : {#percentage : Float; #amount : Nat}; allow_list : ?[Principal] }
```


## Type `TransactionRecord`
``` motoko no-repl
type TransactionRecord = { token_id : Text; index : Nat; txn_type : {#auction_bid : { buyer : Account; amount : Nat; token : TokenSpec; sale_id : Text; extensible : CandyTypes.CandyValue }; #mint : { from : Account; to : Account; sale : ?{ token : TokenSpec; amount : Nat }; extensible : CandyTypes.CandyValue }; #sale_ended : { seller : Account; buyer : Account; token : TokenSpec; sale_id : ?Text; amount : Nat; extensible : CandyTypes.CandyValue }; #royalty_paid : { seller : Account; buyer : Account; reciever : Account; tag : Text; token : TokenSpec; sale_id : ?Text; amount : Nat; extensible : CandyTypes.CandyValue }; #sale_opened : { pricing : PricingConfig; sale_id : Text; extensible : CandyTypes.CandyValue }; #owner_transfer : { from : Account; to : Account; extensible : CandyTypes.CandyValue }; #escrow_deposit : { seller : Account; buyer : Account; token : TokenSpec; token_id : Text; amount : Nat; trx_id : TransactionID; extensible : CandyTypes.CandyValue }; #escrow_withdraw : { seller : Account; buyer : Account; token : TokenSpec; token_id : Text; amount : Nat; fee : Nat; trx_id : TransactionID; extensible : CandyTypes.CandyValue }; #deposit_withdraw : { buyer : Account; token : TokenSpec; amount : Nat; fee : Nat; trx_id : TransactionID; extensible : CandyTypes.CandyValue }; #sale_withdraw : { seller : Account; buyer : Account; token : TokenSpec; token_id : Text; amount : Nat; fee : Nat; trx_id : TransactionID; extensible : CandyTypes.CandyValue }; #canister_owner_updated : { owner : Principal; extensible : CandyTypes.CandyValue }; #canister_managers_updated : { managers : [Principal]; extensible : CandyTypes.CandyValue }; #canister_network_updated : { network : Principal; extensible : CandyTypes.CandyValue }; #data; #burn; #extensible : CandyTypes.CandyValue}; timestamp : Int }
```


## Type `TransactionID`
``` motoko no-repl
type TransactionID = {#nat : Nat; #text : Text; #extensible : CandyTypes.CandyValue}
```


## Type `SaleStatus`
``` motoko no-repl
type SaleStatus = { sale_id : Text; original_broker_id : ?Principal; broker_id : ?Principal; token_id : Text; sale_type : {#auction : AuctionState} }
```


## Type `EscrowReceipt`
``` motoko no-repl
type EscrowReceipt = { amount : Nat; seller : Account; buyer : Account; token_id : Text; token : TokenSpec }
```


## Type `AuctionState`
``` motoko no-repl
type AuctionState = { config : PricingConfig; var current_bid_amount : Nat; var current_broker_id : ?Principal; var end_date : Int; var min_next_bid : Nat; var current_escrow : ?EscrowReceipt; var wait_for_quiet_count : ?Nat; var allow_list : ?Map.Map<Principal, Bool>; var participants : Map.Map<Principal, Int>; var status : {#open; #closed; #not_started}; var winner : ?Account }
```


## Type `State`
``` motoko no-repl
type State = { var collection_data : CollectionData; var buckets : Map.Map<Principal, BucketData>; var allocations : Map.Map<(Text, Text), AllocationRecord>; var canister_availible_space : Nat; var canister_allocated_storage : Nat; var log : SB.StableBuffer<LogEntry>; var log_history : SB.StableBuffer<[LogEntry]>; var log_harvester : Principal; var offers : Map.Map<Account, Map.Map<Account, Int>>; var nft_metadata : Map.Map<Text, CandyTypes.CandyValue>; var escrow_balances : EscrowBuyerTrie; var sales_balances : SalesSellerTrie; var nft_ledgers : Map.Map<Text, SB.StableBuffer<TransactionRecord>>; var nft_sales : Map.Map<Text, SaleStatus> }
```

