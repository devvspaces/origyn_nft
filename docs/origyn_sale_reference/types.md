# origyn_sale_reference/types

## Type `OrigynError`
``` motoko no-repl
type OrigynError = { number : Nat32; text : Text; error : Errors; flag_point : Text }
```


## Type `InitArgs`
``` motoko no-repl
type InitArgs = { owner : Principal; allocation_expiration : Int; nft_gateway : ?Principal; sale_open_date : ?Int; registration_date : ?Int; end_date : ?Int; required_lock_date : ?Int }
```


## Type `ManageCommand`
``` motoko no-repl
type ManageCommand = {#UpdateOwner : Principal; #UpdateAllocationExpiration : Int; #UpdateNFTGateway : ?Principal; #UpdateSaleOpenDate : ?Int; #UpdateRegistrationDate : ?Int; #UpdateEndDate : ?Int; #UpdateLockDate : ?Int}
```


## Type `NFTInventoryItem`
``` motoko no-repl
type NFTInventoryItem = { canister : Principal; token_id : Text; var available : Bool; var sale_block : ?Nat; var allocation : ?Principal; var reservations : Map.Map<Text, Int> }
```


## Type `NFTInventoryItemDetail`
``` motoko no-repl
type NFTInventoryItemDetail = { canister : Principal; token_id : Text; available : Bool; sale_block : ?Nat; allocation : ?Principal; reservations : [(Text, Int)] }
```


## Function `stabalize_xfer_NFTInventoryItem`
``` motoko no-repl
func stabalize_xfer_NFTInventoryItem(item : (Text, NFTInventoryItem)) : NFTInventoryItemDetail
```


## Type `NFTInventoryItemRequest`
``` motoko no-repl
type NFTInventoryItemRequest = { canister : Principal; token_id : Text }
```


## Type `NFTInventory`
``` motoko no-repl
type NFTInventory = Map.Map<Text, NFTInventoryItem>
```


## Type `GetInventoryItemResponse`
``` motoko no-repl
type GetInventoryItemResponse = NFTInventoryItem
```


## Type `GetInventoryResponse`
``` motoko no-repl
type GetInventoryResponse = { total_size : Nat; items : [NFTInventoryItemDetail]; start : Nat }
```


## Type `Allocation`
``` motoko no-repl
type Allocation = { principal : Principal; var token : ?TokenSpec; var nfts : [Text]; var expiration : Int }
```


## Type `Allocations`
``` motoko no-repl
type Allocations = Map.Map<Principal, Allocation>
```


## Type `Purchases`
``` motoko no-repl
type Purchases = Map.Map<Principal, Map.Map<Text, NFTTypes.Current.TransactionRecord>>
```


## Type `Groups`
``` motoko no-repl
type Groups = Map.Map<Text, Group>
```


## Type `Group`
``` motoko no-repl
type Group = { namespace : Text; var members : Map.Map<Principal, Int>; var redemptions : Map.Map<Principal, Nat>; var pricing : Pricing; var allowed_amount : ?AllowedAmount; var additive : Bool; var tier : Nat }
```


## Type `GroupStable`
``` motoko no-repl
type GroupStable = { namespace : Text; members : [(Principal, Int)]; redemptions : [(Principal, Nat)]; pricing : Pricing; allowed_amount : ?AllowedAmount; additive : Bool; tier : Nat }
```


## Function `group_stabalize`
``` motoko no-repl
func group_stabalize(item : Group) : GroupStable
```


## Type `AddGroupRequest`
``` motoko no-repl
type AddGroupRequest = { key : Text; item : {#add : { namespace : Text; members : [Principal]; pricing : ?Pricing; allowed_amount : ?AllowedAmount; tier : Nat; additive : Bool }} }
```


## Type `GetGroupResponse`
``` motoko no-repl
type GetGroupResponse = [{ namespace : Text; pricing : ?Pricing; allowed_amount : ?AllowedAmount }]
```


## Type `GetEscrowResponse`
``` motoko no-repl
type GetEscrowResponse = { receipt : NFTTypes.Current.EscrowReceipt; balance : Nat; transaction : NFTTypes.Current.TransactionRecord }
```


## Type `Pricing`
``` motoko no-repl
type Pricing = [{#cost_per : { amount : Nat; token : TokenSpec }; #free}]
```


## Type `State`
``` motoko no-repl
type State = { var owner : Principal; var manager : ?Principal; var nft_inventory : NFTInventory; var nft_group : Groups; var nft_group_size : Nat; var nft_reservation : Reservations; var nft_reservation_size : Nat; var user_allocations : Allocations; var user_registrations : Registrations; var user_purchases : Purchases; var allocation_expiration : Int; var nft_gateway : ?Principal; var sale_open_date : ?Int; var registration_date : ?Int; var end_date : ?Int; var required_lock_date : ?Int; var allocation_queue : Deque.Deque<(Principal, Int)> }
```


## Type `SaleMetrics`
``` motoko no-repl
type SaleMetrics = { owner : Principal; allocation_expiration : Int; nft_gateway : ?Principal; sale_open_date : ?Int; registration_date : ?Int; end_date : ?Int }
```


## Type `AllowedAmount`
``` motoko no-repl
type AllowedAmount = Nat
```


## Type `ManageNFTRequest`
``` motoko no-repl
type ManageNFTRequest = {#add : NFTInventoryItemRequest; #remove : Text}
```


## Type `ManageNFTItemResponse`
``` motoko no-repl
type ManageNFTItemResponse = {#add : Text; #remove : Text; #err : (Text, OrigynError)}
```


## Type `ManageNFTResponse`
``` motoko no-repl
type ManageNFTResponse = { total_size : Nat; items : [ManageNFTItemResponse] }
```


## Type `ManageGroupRequest`
``` motoko no-repl
type ManageGroupRequest = [{#update : { namespace : Text; members : ?[Principal]; pricing : ?Pricing; allowed_amount : ?AllowedAmount; tier : Nat; additive : Bool }; #remove : { namespace : Text }; #addMembers : { namespace : Text; members : [Principal] }; #removeMembers : { namespace : Text; members : [Principal] }}]
```


## Type `ManageGroupResult`
``` motoko no-repl
type ManageGroupResult = {#update : Result.Result<GroupStable, OrigynError>; #remove : Result.Result<Text, OrigynError>; #addMembers : Result.Result<(Nat, Nat), OrigynError>; #removeMembers : Result.Result<(Nat, Nat), OrigynError>; #err : OrigynError}
```


## Type `ManageGroupResponse`
``` motoko no-repl
type ManageGroupResponse = [ManageGroupResult]
```


## Type `Reservations`
``` motoko no-repl
type Reservations = Map.Map<Text, Reservation>
```


## Type `Reservation`
``` motoko no-repl
type Reservation = { namespace : Text; reservation_type : ReservationType; exclusive : Bool; nfts : [Text] }
```


## Type `ReservationType`
``` motoko no-repl
type ReservationType = {#Groups : [Text]; #Principal : Principal}
```


## Type `ManageReservationRequest`
``` motoko no-repl
type ManageReservationRequest = {#add : { namespace : Text; reservation_type : {#Groups : [Text]; #Principal : Principal}; exclusive : Bool; nfts : [Text] }; #remove : { namespace : Text }; #addNFTs : { namespace : Text; nfts : [Text] }; #removeNFTs : { namespace : Text; nfts : [Text] }; #update_type : { namespace : Text; reservation_type : {#Groups : [Text]; #Principal : Principal} }}
```


## Type `ManageReservationItemResponse`
``` motoko no-repl
type ManageReservationItemResponse = {#add : Text; #remove : Text; #addNFTs : Nat; #removeNFTs : Nat; #update_type : Text; #err : (Text, OrigynError)}
```


## Type `ManageReservationResponse`
``` motoko no-repl
type ManageReservationResponse = { total_size : Nat; items : [ManageReservationItemResponse] }
```


## Type `AllocationRequest`
``` motoko no-repl
type AllocationRequest = { principal : Principal; number_to_allocate : Nat; token : ?TokenSpec }
```


## Type `AllocationResponse`
``` motoko no-repl
type AllocationResponse = { allocation_size : Nat; token : ?TokenSpec; principal : Principal; expiration : Int }
```


## Type `RedeemAllocationRequest`
``` motoko no-repl
type RedeemAllocationRequest = { escrow_receipt : NFTTypes.Current.EscrowReceipt }
```


## Type `RedeemAllocationResponse`
``` motoko no-repl
type RedeemAllocationResponse = { nfts : [{ token_id : Text; transaction : Result.Result<NFTTypes.Current.TransactionRecord, OrigynError> }] }
```


## Type `Registration`
``` motoko no-repl
type Registration = { principal : Principal; var max_desired : Nat; var escrow_receipt : ?NFTTypes.Current.EscrowReceipt; var allocation_size : Nat; var allocation : Map.Map<Text, RegistrationClaim> }
```


## Type `RegistrationClaim`
``` motoko no-repl
type RegistrationClaim = { var claimed : Bool; var trx : ?NFTTypes.Current.TransactionRecord }
```


## Type `Registrations`
``` motoko no-repl
type Registrations = Map.Map<Principal, Registration>
```


## Type `RegisterEscrowRequest`
``` motoko no-repl
type RegisterEscrowRequest = { principal : Principal; max_desired : Nat; escrow_receipt : ?NFTTypes.Current.EscrowReceipt }
```


## Type `RegisterEscrowAllocationDetail`
``` motoko no-repl
type RegisterEscrowAllocationDetail = { token_id : Text; claimed : Bool; trx : ?NFTTypes.Current.TransactionRecord }
```


## Function `stabalize_xfer_RegisterAllocation`
``` motoko no-repl
func stabalize_xfer_RegisterAllocation(item : (Text, RegistrationClaim)) : RegisterEscrowAllocationDetail
```


## Type `RegisterEscrowResponse`
``` motoko no-repl
type RegisterEscrowResponse = { max_desired : Nat; principal : Principal; escrow_receipt : ?NFTTypes.Current.EscrowReceipt; allocation : [RegisterEscrowAllocationDetail]; allocation_size : Nat }
```


## Type `TestRequest`
``` motoko no-repl
type TestRequest = { account_id : NFTTypes.Current.Account; standard : {#DIP20; #Ledger; #EXTFungible} }
```


## Type `Errors`
``` motoko no-repl
type Errors = {#bad_date; #bad_canister_trx; #reservation_item_exists; #reservation_item_does_not_exists; #group_item_exists; #group_item_does_not_exists; #inventory_item_exists; #inventory_item_does_not_exists; #improper_allocation; #improper_escrow; #improper_lock; #inventory_empty; #registartion_not_open; #allocation_does_not_exist; #bad_config; #nyi; #ijn; #nti; #unauthorized_access}
```


## Function `errors`
``` motoko no-repl
func errors(the_error : Errors, flag_point : Text, caller : ?Principal) : OrigynError
```


## Type `OrigynBoolResult`
``` motoko no-repl
type OrigynBoolResult = Result.Result<Bool, OrigynError>
```


## Type `OrigynTextResult`
``` motoko no-repl
type OrigynTextResult = Result.Result<Text, OrigynError>
```


## Type `Service`
``` motoko no-repl
type Service = actor { manage_nfts_sale_nft_origyn : shared ([ManageNFTRequest]) -> async Result.Result<ManageNFTResponse, OrigynError>; allocate_sale_nft_origyn : shared (AllocationRequest) -> async Result.Result<AllocationResponse, OrigynError>; redeem_allocation_sale_nft_origyn : shared (RedeemAllocationRequest) -> async Result.Result<RedeemAllocationResponse, OrigynError>; register_escrow_sale_nft_origyn : shared (RegisterEscrowRequest) -> async Result.Result<RegisterEscrowResponse, OrigynError>; execute_claim_sale_nft_origyn : shared (Text) -> async Result.Result<NFTTypes.Current.TransactionRecord, OrigynError>; manage_reservation_sale_nft_origyn : shared ([ManageReservationRequest]) -> async Result.Result<ManageReservationResponse, OrigynError> }
```

