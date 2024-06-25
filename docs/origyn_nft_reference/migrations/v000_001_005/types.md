# origyn_nft_reference/migrations/v000_001_005/types

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


## Value `Conversions`
``` motoko no-repl
let Conversions
```


## Value `Properties`
``` motoko no-repl
let Properties
```


## Value `JSON`
``` motoko no-repl
let JSON
```


## Value `Workspace`
``` motoko no-repl
let Workspace
```


## Type `CollectionData`
``` motoko no-repl
type CollectionData = { var logo : ?Text; var name : ?Text; var symbol : ?Text; var metadata : ?CandyTypes.CandyShared; var owner : Principal; var managers : [Principal]; var network : ?Principal; var allocated_storage : Nat; var available_space : Nat; var active_bucket : ?Principal; var announce_canister : ?Principal }
```


## Type `AllocationRecord`
``` motoko no-repl
type AllocationRecord = v0_1_4.AllocationRecord
```


## Type `BucketData`
``` motoko no-repl
type BucketData = v0_1_4.BucketData
```


## Type `TransactionRecord`
``` motoko no-repl
type TransactionRecord = { token_id : Text; index : Nat; txn_type : {#auction_bid : { buyer : Account; amount : Nat; token : TokenSpec; sale_id : Text; extensible : CandyTypes.CandyShared }; #mint : { from : Account; to : Account; sale : ?{ token : TokenSpec; amount : Nat }; extensible : CandyTypes.CandyShared }; #sale_ended : { seller : Account; buyer : Account; token : TokenSpec; sale_id : ?Text; amount : Nat; extensible : CandyTypes.CandyShared }; #royalty_paid : { seller : Account; buyer : Account; receiver : Account; tag : Text; token : TokenSpec; sale_id : ?Text; amount : Nat; extensible : CandyTypes.CandyShared }; #sale_opened : { pricing : PricingConfigShared; sale_id : Text; extensible : CandyTypes.CandyShared }; #owner_transfer : { from : Account; to : Account; extensible : CandyTypes.CandyShared }; #escrow_deposit : { seller : Account; buyer : Account; token : TokenSpec; token_id : Text; amount : Nat; trx_id : TransactionID; extensible : CandyTypes.CandyShared }; #escrow_withdraw : { seller : Account; buyer : Account; token : TokenSpec; token_id : Text; amount : Nat; fee : Nat; trx_id : TransactionID; extensible : CandyTypes.CandyShared }; #deposit_withdraw : { buyer : Account; token : TokenSpec; amount : Nat; fee : Nat; trx_id : TransactionID; extensible : CandyTypes.CandyShared }; #sale_withdraw : { seller : Account; buyer : Account; token : TokenSpec; token_id : Text; amount : Nat; fee : Nat; trx_id : TransactionID; extensible : CandyTypes.CandyShared }; #canister_owner_updated : { owner : Principal; extensible : CandyTypes.CandyShared }; #canister_managers_updated : { managers : [Principal]; extensible : CandyTypes.CandyShared }; #canister_network_updated : { network : Principal; extensible : CandyTypes.CandyShared }; #data : { data_dapp : ?Text; data_path : ?Text; hash : ?[Nat8]; extensible : CandyTypes.CandyShared }; #burn : { from : ?Account; extensible : CandyTypes.CandyShared }; #extensible : CandyTypes.CandyShared}; timestamp : Int }
```


## Type `EscrowReceipt`
``` motoko no-repl
type EscrowReceipt = { amount : Nat; seller : Account; buyer : Account; token_id : Text; token : TokenSpec }
```


## Type `SaleStatus`
``` motoko no-repl
type SaleStatus = { sale_id : Text; original_broker_id : ?Principal; broker_id : ?Principal; token_id : Text; sale_type : {#auction : AuctionState} }
```


## Type `HttpAccess`
``` motoko no-repl
type HttpAccess = v0_1_4.HttpAccess
```


## Type `Account`
``` motoko no-repl
type Account = {#principal : Principal; #account : { owner : Principal; sub_account : ?Blob }; #account_id : Text; #extensible : CandyTypes.CandyShared}
```


## Type `TransactionID`
``` motoko no-repl
type TransactionID = {#nat : Nat; #text : Text; #extensible : CandyTypes.CandyShared}
```


## Type `AuctionConfig`
``` motoko no-repl
type AuctionConfig = { reserve : ?Nat; token : TokenSpec; buy_now : ?Nat; start_price : Nat; start_date : Int; ending : {#date : Int; #wait_for_quiet : { date : Int; extension : Nat64; fade : Float; max : Nat }}; min_increase : {#percentage : Float; #amount : Nat}; allow_list : ?[Principal] }
```


## Type `AskFeatureKey`
``` motoko no-repl
type AskFeatureKey = {#atomic; #buy_now; #wait_for_quiet; #allow_list; #notify; #reserve; #start_date; #start_price; #min_increase; #ending; #token; #dutch; #kyc; #nifty_settlement}
```


## Type `DutchParams`
``` motoko no-repl
type DutchParams = { time_unit : {#hour : Nat; #minute : Nat; #day : Nat}; decay_type : {#flat : Nat; #percent : Float} }
```


## Type `AskFeature`
``` motoko no-repl
type AskFeature = {#atomic; #buy_now : Nat; #wait_for_quiet : { extension : Nat64; fade : Float; max : Nat }; #allow_list : [Principal]; #notify : [Principal]; #reserve : Nat; #start_date : Int; #start_price : Nat; #min_increase : {#percentage : Float; #amount : Nat}; #ending : {#date : Int; #timeout : Nat}; #token : TokenSpec; #dutch : DutchParams; #kyc : Principal; #nifty_settlement : { duration : ?Int; expiration : ?Int; fixed : Bool; lenderOffer : Bool; interestRatePerSecond : Float }}
```


## Type `AskFeatureMap`
``` motoko no-repl
type AskFeatureMap = Map.Map<AskFeatureKey, AskFeature>
```


## Type `AskConfig`
``` motoko no-repl
type AskConfig = ?AskFeatureMap
```


## Type `AskConfigShared`
``` motoko no-repl
type AskConfigShared = ?[AskFeature]
```


## Function `ask_feature_set_eq`
``` motoko no-repl
func ask_feature_set_eq(a : AskFeatureKey, b : AskFeatureKey) : Bool
```


## Function `ask_feature_set_hash`
``` motoko no-repl
func ask_feature_set_hash(a : AskFeatureKey) : Nat
```


## Function `features_to_map`
``` motoko no-repl
func features_to_map(items : [AskFeature]) : Map.Map<AskFeatureKey, AskFeature>
```


## Function `feature_to_key`
``` motoko no-repl
func feature_to_key(request : AskFeature) : AskFeatureKey
```


## Value `ask_feature_set_tool`
``` motoko no-repl
let ask_feature_set_tool : MapUtils.HashUtils<AskFeatureKey>
```


## Type `PricingConfig`
``` motoko no-repl
type PricingConfig = {#instant; #auction : AuctionConfig; #ask : AskConfig; #extensible : CandyTypes.CandyShared}
```


## Type `PricingConfigShared`
``` motoko no-repl
type PricingConfigShared = {#instant; #auction : AuctionConfig; #ask : AskConfigShared; #extensible : CandyTypes.CandyShared}
```


## Function `pricing_shared_to_pricing`
``` motoko no-repl
func pricing_shared_to_pricing(request : PricingConfigShared) : PricingConfig
```


## Type `AuctionState`
``` motoko no-repl
type AuctionState = { config : PricingConfig; var current_bid_amount : Nat; var current_broker_id : ?Principal; var end_date : Int; var start_date : Int; token : TokenSpec; var min_next_bid : Nat; var current_escrow : ?EscrowReceipt; var wait_for_quiet_count : ?Nat; allow_list : ?Map.Map<Principal, Bool>; var participants : Map.Map<Principal, Int>; var status : {#open; #closed; #not_started}; var notify_queue : ?Deque.Deque<(Principal, ?SubscriptionID)>; var winner : ?Account }
```


## Type `SubscriptionID`
``` motoko no-repl
type SubscriptionID = Nat
```


## Type `AskSubscriptionInfo`
``` motoko no-repl
type AskSubscriptionInfo = { filter : ?{ token_ids : ?[TokenIDFilter]; tokens : ?[TokenSpecFilter] }; stake : (Principal, Nat, ?Nat) }
```


## Type `AskSubscribeRequest`
``` motoko no-repl
type AskSubscribeRequest = {#subscribe : AskSubscriptionInfo; #unsubscribe : (Principal, Nat)}
```


## Type `TokenIDFilter`
``` motoko no-repl
type TokenIDFilter = { token_id : Text; tokens : [{ min_amount : ?Nat; max_amount : ?Nat; token : TokenSpec }]; filter_type : {#allow; #block} }
```


## Type `TokenSpecFilter`
``` motoko no-repl
type TokenSpecFilter = { token : TokenSpec; filter_type : {#allow; #block} }
```


## Type `ICTokenSpec`
``` motoko no-repl
type ICTokenSpec = v0_1_4.ICTokenSpec
```


## Type `TokenSpec`
``` motoko no-repl
type TokenSpec = v0_1_4.TokenSpec
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


## Type `EscrowRecord`
``` motoko no-repl
type EscrowRecord = { amount : Nat; buyer : Account; seller : Account; token_id : Text; token : TokenSpec; sale_id : ?Text; lock_to_date : ?Int; account_hash : ?Blob }
```


## Value `compare_library`
``` motoko no-repl
let compare_library
```


## Value `library_equal`
``` motoko no-repl
let library_equal : ((Text, Text), (Text, Text)) -> Bool
```


## Value `library_hash`
``` motoko no-repl
let library_hash : ((Text, Text)) -> Nat
```


## Function `account_hash_uncompressed`
``` motoko no-repl
func account_hash_uncompressed(a : Account) : Nat
```


## Function `token_hash_uncompressed`
``` motoko no-repl
func token_hash_uncompressed(a : TokenSpec) : Nat
```


## Function `account_hash`
``` motoko no-repl
func account_hash(a : Account) : Nat
```


## Function `account_eq`
``` motoko no-repl
func account_eq(a : Account, b : Account) : Bool
```


## Value `account_handler`
``` motoko no-repl
let account_handler
```


## Function `token_hash`
``` motoko no-repl
func token_hash(a : TokenSpec) : Nat
```


## Function `token_eq`
``` motoko no-repl
func token_eq(a : TokenSpec, b : TokenSpec) : Bool
```


## Value `token_handler`
``` motoko no-repl
let token_handler
```


## Type `KYCRequest`
``` motoko no-repl
type KYCRequest = KYCTypes.KYCRequest
```


## Type `KYCResult`
``` motoko no-repl
type KYCResult = KYCTypes.KYCResult
```


## Type `RunKYCResult`
``` motoko no-repl
type RunKYCResult = KYCTypes.RunKYCResult
```


## Type `KYCTokenSpec`
``` motoko no-repl
type KYCTokenSpec = KYCTypes.TokenSpec
```


## Type `KYCCacheMap`
``` motoko no-repl
type KYCCacheMap = KYCTypes.CacheMap
```


## Value `KYC`
``` motoko no-repl
let KYC
```


## Type `VerifiedReciept`
``` motoko no-repl
type VerifiedReciept = { found_asset : { token_spec : TokenSpec; escrow : EscrowRecord }; found_asset_list : EscrowLedgerTrie }
```


## Type `State`
``` motoko no-repl
type State = { var collection_data : CollectionData; var buckets : Map.Map<Principal, BucketData>; var allocations : Map.Map<(Text, Text), AllocationRecord>; var canister_availible_space : Nat; var canister_allocated_storage : Nat; var offers : Map.Map<Account, Map.Map<Account, Int>>; var nft_metadata : Map.Map<Text, CandyTypes.CandyShared>; var escrow_balances : EscrowBuyerTrie; var sales_balances : SalesSellerTrie; var nft_ledgers : Map.Map<Text, SB.StableBuffer<TransactionRecord>>; var master_ledger : SB.StableBuffer<TransactionRecord>; var nft_sales : Map.Map<Text, SaleStatus>; var pending_sale_notifications : Set.Set<Text>; var access_tokens : Map.Map<Text, HttpAccess>; var droute : Droute.Droute; var kyc_cache : Map.Map<KYCTypes.KYCRequest, KYCTypes.KYCResultFuture>; var use_stableBTree : Bool }
```

