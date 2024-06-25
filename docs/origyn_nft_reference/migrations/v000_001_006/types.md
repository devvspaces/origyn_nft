# origyn_nft_reference/migrations/v000_001_006/types

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
type CollectionData = v0_1_5.CollectionData
```


## Type `AllocationRecord`
``` motoko no-repl
type AllocationRecord = v0_1_5.AllocationRecord
```


## Type `BucketData`
``` motoko no-repl
type BucketData = v0_1_5.BucketData
```


## Type `TransactionRecord`
``` motoko no-repl
type TransactionRecord = { token_id : Text; index : Nat; txn_type : {#auction_bid : { buyer : Account; amount : Nat; token : TokenSpec; sale_id : Text; extensible : CandyTypes.CandyShared }; #mint : { from : Account; to : Account; sale : ?{ token : TokenSpec; amount : Nat }; extensible : CandyTypes.CandyShared }; #sale_ended : { seller : Account; buyer : Account; token : TokenSpec; sale_id : ?Text; amount : Nat; extensible : CandyTypes.CandyShared }; #royalty_paid : { seller : Account; buyer : Account; receiver : Account; tag : Text; token : TokenSpec; sale_id : ?Text; amount : Nat; extensible : CandyTypes.CandyShared }; #sale_opened : { pricing : PricingConfigShared; sale_id : Text; extensible : CandyTypes.CandyShared }; #owner_transfer : { from : Account; to : Account; extensible : CandyTypes.CandyShared }; #escrow_deposit : { seller : Account; buyer : Account; token : TokenSpec; token_id : Text; amount : Nat; trx_id : TransactionID; extensible : CandyTypes.CandyShared }; #escrow_withdraw : { seller : Account; buyer : Account; token : TokenSpec; token_id : Text; amount : Nat; fee : Nat; trx_id : TransactionID; extensible : CandyTypes.CandyShared }; #deposit_withdraw : { buyer : Account; token : TokenSpec; amount : Nat; fee : Nat; trx_id : TransactionID; extensible : CandyTypes.CandyShared }; #fee_deposit : { amount : Nat; account : Account; extensible : CandyTypes.CandyShared; token : TokenSpec }; #fee_deposit_withdraw : { amount : Nat; account : Account; extensible : CandyTypes.CandyShared; fee : Nat; token : TokenSpec; trx_id : TransactionID }; #sale_withdraw : { seller : Account; buyer : Account; token : TokenSpec; token_id : Text; amount : Nat; fee : Nat; trx_id : TransactionID; extensible : CandyTypes.CandyShared }; #canister_owner_updated : { owner : Principal; extensible : CandyTypes.CandyShared }; #canister_managers_updated : { managers : [Principal]; extensible : CandyTypes.CandyShared }; #canister_network_updated : { network : Principal; extensible : CandyTypes.CandyShared }; #data : { data_dapp : ?Text; data_path : ?Text; hash : ?[Nat8]; extensible : CandyTypes.CandyShared }; #burn : { from : ?Account; extensible : CandyTypes.CandyShared }; #extensible : CandyTypes.CandyShared}; timestamp : Int }
```


## Type `SaleStatus`
``` motoko no-repl
type SaleStatus = { sale_id : Text; original_broker_id : ?Principal; broker_id : ?Principal; token_id : Text; sale_type : {#auction : AuctionState} }
```


## Type `HttpAccess`
``` motoko no-repl
type HttpAccess = v0_1_5.HttpAccess
```


## Type `Account`
``` motoko no-repl
type Account = {#principal : Principal; #account : { owner : Principal; sub_account : ?Blob }; #account_id : Text; #extensible : CandyTypes.CandyShared}
```


## Function `account_to_principal`
``` motoko no-repl
func account_to_principal(account : Account) : Principal
```


## Function `account_to_owner_subaccount`
``` motoko no-repl
func account_to_owner_subaccount(account : Account) : { owner : Principal; sub_account : ?Blob }
```


## Function `compare_account`
``` motoko no-repl
func compare_account(account1 : Account, account2 : Account) : Bool
```


## Type `TransactionID`
``` motoko no-repl
type TransactionID = v0_1_5.TransactionID
```


## Type `AuctionConfig`
``` motoko no-repl
type AuctionConfig = { reserve : ?Nat; token : TokenSpec; buy_now : ?Nat; start_price : Nat; start_date : Int; ending : {#date : Int; #wait_for_quiet : { date : Int; extension : Nat64; fade : Float; max : Nat }}; min_increase : MinIncreaseType; allow_list : ?[Principal] }
```


## Type `AskFeatureKey`
``` motoko no-repl
type AskFeatureKey = {#atomic; #buy_now; #wait_for_quiet; #allow_list; #notify; #reserve; #start_date; #start_price; #min_increase; #ending; #token; #dutch; #kyc; #nifty_settlement; #fee_accounts; #fee_schema}
```


## Type `DutchParams`
``` motoko no-repl
type DutchParams = v0_1_5.DutchParams
```


## Type `FeeAccountsParams`
``` motoko no-repl
type FeeAccountsParams = [FeeName]
```


## Type `BidPaysFeesParams`
``` motoko no-repl
type BidPaysFeesParams = [FeeName]
```


## Type `MinIncreaseType`
``` motoko no-repl
type MinIncreaseType = {#percentage : Float; #amount : Nat}
```


## Type `AskFeature`
``` motoko no-repl
type AskFeature = {#atomic; #buy_now : Nat; #wait_for_quiet : WaitForQuietType; #allow_list : [Principal]; #notify : [Principal]; #reserve : Nat; #start_date : Int; #start_price : Nat; #min_increase : MinIncreaseType; #ending : EndingType; #token : TokenSpec; #dutch : DutchParams; #kyc : Principal; #nifty_settlement : NiftySettlementType; #fee_accounts : FeeAccountsParams; #fee_schema : Text}
```


## Type `AskFeatureMap`
``` motoko no-repl
type AskFeatureMap = Map.Map<AskFeatureKey, AskFeature>
```


## Type `AskFeatureArray`
``` motoko no-repl
type AskFeatureArray = [AskFeature]
```


## Type `AskConfig`
``` motoko no-repl
type AskConfig = ?AskFeatureMap
```


## Type `AskConfigShared`
``` motoko no-repl
type AskConfigShared = ?AskFeatureArray
```


## Type `FeeName`
``` motoko no-repl
type FeeName = Text
```


## Type `BidFeatureKey`
``` motoko no-repl
type BidFeatureKey = {#broker; #fee_schema; #fee_accounts}
```


## Type `BidFeatureMap`
``` motoko no-repl
type BidFeatureMap = Map.Map<BidFeatureKey, BidFeature>
```


## Type `BidConfig`
``` motoko no-repl
type BidConfig = ?BidFeatureMap
```


## Type `BidConfigShared`
``` motoko no-repl
type BidConfigShared = ?[BidFeature]
```


## Type `BidFeature`
``` motoko no-repl
type BidFeature = {#broker : Account; #fee_schema : Text; #fee_accounts : FeeAccountsParams}
```


## Function `bidfeatures_to_map`
``` motoko no-repl
func bidfeatures_to_map(items : [BidFeature]) : BidFeatureMap
```


## Function `bidfeaturesmap_to_bidfeaturearray`
``` motoko no-repl
func bidfeaturesmap_to_bidfeaturearray(items : BidFeatureMap) : [BidFeature]
```


## Type `BidRequest`
``` motoko no-repl
type BidRequest = { escrow_record : EscrowRecord; config : BidConfigShared }
```


## Type `Royalty`
``` motoko no-repl
type Royalty = {#fixed : { tag : Text; fixedXDR : Float; token : ?TokenSpec }; #dynamic : { tag : Text; rate : Float }}
```


## Function `load_broker_bid_feature`
``` motoko no-repl
func load_broker_bid_feature(_config : BidConfig) : ?Account
```


## Function `load_fee_schema_bid_feature`
``` motoko no-repl
func load_fee_schema_bid_feature(_config : BidConfig) : ?Text
```


## Function `load_fee_accounts_bid_feature`
``` motoko no-repl
func load_fee_accounts_bid_feature(_config : BidConfig) : ?FeeAccountsParams
```


## Type `InstantFeatureKey`
``` motoko no-repl
type InstantFeatureKey = {#fee_schema; #fee_accounts}
```


## Type `InstantFeatureMap`
``` motoko no-repl
type InstantFeatureMap = Map.Map<InstantFeatureKey, InstantFeature>
```


## Type `InstantConfig`
``` motoko no-repl
type InstantConfig = ?InstantFeatureMap
```


## Type `InstantConfigShared`
``` motoko no-repl
type InstantConfigShared = ?[InstantFeature]
```


## Type `InstantFeature`
``` motoko no-repl
type InstantFeature = {#fee_schema : Text; #fee_accounts : FeeAccountsParams}
```


## Function `instantfeatures_to_map`
``` motoko no-repl
func instantfeatures_to_map(items : [InstantFeature]) : InstantFeatureMap
```


## Function `instantfeaturesmap_to_instantfeaturearray`
``` motoko no-repl
func instantfeaturesmap_to_instantfeaturearray(items : InstantFeatureMap) : [InstantFeature]
```


## Function `load_fee_schema_instant_feature`
``` motoko no-repl
func load_fee_schema_instant_feature(_config : InstantConfig) : ?Text
```


## Function `load_fee_accounts_instant_feature`
``` motoko no-repl
func load_fee_accounts_instant_feature(_config : InstantConfig) : ?FeeAccountsParams
```


## Function `ask_feature_set_eq`
``` motoko no-repl
func ask_feature_set_eq(a : AskFeatureKey, b : AskFeatureKey) : Bool
```


## Function `load_atomic_ask_feature`
``` motoko no-repl
func load_atomic_ask_feature(_config : AskConfig) : ?()
```


## Function `load_buy_now_ask_feature`
``` motoko no-repl
func load_buy_now_ask_feature(_config : AskConfig) : ?Nat
```


## Function `load_wait_for_quiet_ask_feature`
``` motoko no-repl
func load_wait_for_quiet_ask_feature(_config : AskConfig) : ?WaitForQuietType
```


## Function `load_allow_list_ask_feature`
``` motoko no-repl
func load_allow_list_ask_feature(_config : AskConfig) : ?[Principal]
```


## Function `load_notify_ask_feature`
``` motoko no-repl
func load_notify_ask_feature(_config : AskConfig) : [Principal]
```


## Function `load_reserve_ask_feature`
``` motoko no-repl
func load_reserve_ask_feature(_config : AskConfig) : ?Nat
```


## Function `load_start_date_ask_feature`
``` motoko no-repl
func load_start_date_ask_feature(_config : AskConfig) : ?Int
```


## Function `load_start_price_ask_feature`
``` motoko no-repl
func load_start_price_ask_feature(_config : AskConfig) : ?Nat
```


## Function `load_min_increase_ask_feature`
``` motoko no-repl
func load_min_increase_ask_feature(_config : AskConfig) : ?MinIncreaseType
```


## Function `load_ending_ask_feature`
``` motoko no-repl
func load_ending_ask_feature(_config : AskConfig) : ?EndingType
```


## Function `load_token_ask_feature`
``` motoko no-repl
func load_token_ask_feature(_config : AskConfig) : TokenSpec
```


## Function `load_dutch_ask_feature`
``` motoko no-repl
func load_dutch_ask_feature(_config : AskConfig) : ?DutchParams
```


## Function `load_kyc_ask_feature`
``` motoko no-repl
func load_kyc_ask_feature(_config : AskConfig) : ?Principal
```


## Function `load_nifty_ask_settlement_feature`
``` motoko no-repl
func load_nifty_ask_settlement_feature(_config : AskConfig) : ?NiftySettlementType
```


## Function `load_fee_accounts_ask_feature`
``` motoko no-repl
func load_fee_accounts_ask_feature(_config : AskConfig) : ?FeeAccountsParams
```


## Function `load_fee_schema_ask_feature`
``` motoko no-repl
func load_fee_schema_ask_feature(_config : AskConfig) : ?Text
```


## Function `ask_feature_set_hash`
``` motoko no-repl
func ask_feature_set_hash(a : AskFeatureKey) : Nat
```


## Function `bid_feature_set_hash`
``` motoko no-repl
func bid_feature_set_hash(a : BidFeatureKey) : Nat
```


## Function `bid_feature_set_eq`
``` motoko no-repl
func bid_feature_set_eq(a : BidFeatureKey, b : BidFeatureKey) : Bool
```


## Function `instant_feature_set_hash`
``` motoko no-repl
func instant_feature_set_hash(a : InstantFeatureKey) : Nat
```


## Function `instant_feature_set_eq`
``` motoko no-repl
func instant_feature_set_eq(a : InstantFeatureKey, b : InstantFeatureKey) : Bool
```


## Function `instantfeature_to_key`
``` motoko no-repl
func instantfeature_to_key(request : InstantFeature) : InstantFeatureKey
```


## Function `instant_features_to_value`
``` motoko no-repl
func instant_features_to_value(features : [InstantFeature]) : ICRC3.Value
```


## Function `features_to_map`
``` motoko no-repl
func features_to_map(items : AskFeatureArray) : AskFeatureMap
```


## Function `bidfeature_to_key`
``` motoko no-repl
func bidfeature_to_key(request : BidFeature) : BidFeatureKey
```


## Function `feature_to_key`
``` motoko no-repl
func feature_to_key(request : AskFeature) : AskFeatureKey
```


## Value `ask_feature_set_tool`
``` motoko no-repl
let ask_feature_set_tool : MapUtils.HashUtils<AskFeatureKey>
```


## Value `bid_feature_set_tool`
``` motoko no-repl
let bid_feature_set_tool : MapUtils.HashUtils<BidFeatureKey>
```


## Value `instant_feature_set_tool`
``` motoko no-repl
let instant_feature_set_tool : MapUtils.HashUtils<InstantFeatureKey>
```


## Type `PricingConfig`
``` motoko no-repl
type PricingConfig = {#instant : InstantConfig; #auction : AuctionConfig; #ask : AskConfig; #extensible : CandyTypes.CandyShared}
```


## Type `PricingConfigShared`
``` motoko no-repl
type PricingConfigShared = {#instant : InstantConfigShared; #auction : AuctionConfig; #ask : AskConfigShared; #extensible : CandyTypes.CandyShared}
```


## Type `SalesConfig`
``` motoko no-repl
type SalesConfig = { escrow_receipt : ?EscrowReceipt; broker_id : ?Account; pricing : PricingConfigShared }
```


## Type `MarketTransferRequest`
``` motoko no-repl
type MarketTransferRequest = { token_id : Text; sales_config : SalesConfig }
```


## Function `pricing_shared_to_pricing`
``` motoko no-repl
func pricing_shared_to_pricing(request : PricingConfigShared) : PricingConfig
```


## Type `AuctionState`
``` motoko no-repl
type AuctionState = { config : PricingConfig; var current_bid_amount : Nat; var current_config : BidConfig; var current_escrow : ?EscrowRecord; var end_date : Int; var start_date : Int; token : TokenSpec; var min_next_bid : Nat; var wait_for_quiet_count : ?Nat; allow_list : ?Map.Map<Principal, Bool>; var participants : Map.Map<Principal, Int>; var status : {#open; #closed; #not_started}; var notify_queue : ?Deque.Deque<(Principal, ?SubscriptionID)>; var winner : ?Account }
```


## Type `SubscriptionID`
``` motoko no-repl
type SubscriptionID = Nat
```


## Type `AskSubscriptionInfo`
``` motoko no-repl
type AskSubscriptionInfo = v0_1_5.AskSubscriptionInfo
```


## Type `AskSubscribeRequest`
``` motoko no-repl
type AskSubscribeRequest = v0_1_5.AskSubscribeRequest
```


## Type `TokenSpecFilter`
``` motoko no-repl
type TokenSpecFilter = v0_1_5.TokenSpecFilter
```


## Type `ICTokenSpec`
``` motoko no-repl
type ICTokenSpec = v0_1_5.ICTokenSpec
```


## Type `TokenSpec`
``` motoko no-repl
type TokenSpec = v0_1_5.TokenSpec
```


## Type `SalesSellerTrie`
``` motoko no-repl
type SalesSellerTrie = v0_1_5.SalesSellerTrie
```


## Type `SalesBuyerTrie`
``` motoko no-repl
type SalesBuyerTrie = v0_1_5.SalesBuyerTrie
```


## Type `SalesTokenIDTrie`
``` motoko no-repl
type SalesTokenIDTrie = v0_1_5.SalesTokenIDTrie
```


## Type `SalesLedgerTrie`
``` motoko no-repl
type SalesLedgerTrie = v0_1_5.SalesLedgerTrie
```


## Type `FeeDepositTrie`
``` motoko no-repl
type FeeDepositTrie = Map.Map<Account, Map.Map<TokenSpec, FeeDepositDetail>>
```


## Type `FeeDepositDetail`
``` motoko no-repl
type FeeDepositDetail = { total_balance : Nat; locks : Map.Map<Text, Nat> }
```


## Type `EscrowBuyerTrie`
``` motoko no-repl
type EscrowBuyerTrie = v0_1_5.EscrowBuyerTrie
```


## Type `EscrowSellerTrie`
``` motoko no-repl
type EscrowSellerTrie = v0_1_5.EscrowSellerTrie
```


## Type `EscrowTokenIDTrie`
``` motoko no-repl
type EscrowTokenIDTrie = v0_1_5.EscrowTokenIDTrie
```


## Type `EscrowLedgerTrie`
``` motoko no-repl
type EscrowLedgerTrie = v0_1_5.EscrowLedgerTrie
```


## Type `EscrowRecord`
``` motoko no-repl
type EscrowRecord = v0_1_5.EscrowRecord
```


## Type `EscrowReceipt`
``` motoko no-repl
type EscrowReceipt = { amount : Nat; seller : Account; buyer : Account; token_id : Text; token : TokenSpec }
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


## Value `account_hash_uncompressed`
``` motoko no-repl
let account_hash_uncompressed : (a : Account) -> Nat
```


## Value `token_hash_uncompressed`
``` motoko no-repl
let token_hash_uncompressed : (a : TokenSpec) -> Nat
```


## Function `account_hash`
``` motoko no-repl
func account_hash(a : Account) : Nat
```


## Value `account_eq`
``` motoko no-repl
let account_eq : (a : Account, b : Account) -> Bool
```


## Value `account_handler`
``` motoko no-repl
let account_handler
```


## Value `token_hash`
``` motoko no-repl
let token_hash : (a : TokenSpec) -> Nat
```


## Value `token_eq`
``` motoko no-repl
let token_eq : (a : TokenSpec, b : TokenSpec) -> Bool
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
type VerifiedReciept = v0_1_5.VerifiedReciept
```


## Function `account_to_value`
``` motoko no-repl
func account_to_value(account : Account) : ICRC3.Value
```


## Function `tokenspec_to_value`
``` motoko no-repl
func tokenspec_to_value(token : TokenSpec) : ICRC3.Value
```


## Function `dutchparams_to_value`
``` motoko no-repl
func dutchparams_to_value(value : DutchParams) : ICRC3.Value
```


## Function `ask_features_to_value`
``` motoko no-repl
func ask_features_to_value(features : [AskFeature]) : ICRC3.Value
```


## Function `pricing_config_to_value`
``` motoko no-repl
func pricing_config_to_value(config : PricingConfigShared) : ICRC3.Value
```


## Type `ValueShared`
``` motoko no-repl
type ValueShared = {#Int : Int; #Nat : Nat; #Text : Text; #Blob : Blob; #Array : [ValueShared]; #Map : [(Text, ValueShared)]}
```


## Function `candySharedToValue`
``` motoko no-repl
func candySharedToValue(x : CandyTypes.CandyShared) : ValueShared
```


## Function `defaultICRC3Config`
``` motoko no-repl
func defaultICRC3Config(caller : Principal) : ICRC3.InitArgs
```


## Type `State`
``` motoko no-repl
type State = { var collection_data : CollectionData; var buckets : Map.Map<Principal, BucketData>; var allocations : Map.Map<(Text, Text), AllocationRecord>; var canister_availible_space : Nat; var canister_allocated_storage : Nat; var offers : Map.Map<Account, Map.Map<Account, Int>>; var nft_metadata : Map.Map<Text, CandyTypes.CandyShared>; var escrow_balances : EscrowBuyerTrie; var sales_balances : SalesSellerTrie; var fee_deposit_balances : FeeDepositTrie; var nft_ledgers : Map.Map<Text, SB.StableBuffer<TransactionRecord>>; var master_ledger : SB.StableBuffer<TransactionRecord>; var nft_sales : Map.Map<Text, SaleStatus>; var pending_sale_notifications : Set.Set<Text>; var access_tokens : Map.Map<Text, HttpAccess>; var droute : Droute.Droute; var kyc_cache : Map.Map<KYCTypes.KYCRequest, KYCTypes.KYCResultFuture>; var use_stableBTree : Bool; var icrc3_migration_state : ICRC3.State; var cert_store : CertTree.Store }
```


## Value `OGY_LEDGER_CANISTER_ID`
``` motoko no-repl
let OGY_LEDGER_CANISTER_ID
```


## Function `OGY`
``` motoko no-repl
func OGY() : TokenSpec
```

