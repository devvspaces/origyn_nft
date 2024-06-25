# origyn_nft_reference/ICRC7

## Type `Subaccount`
``` motoko no-repl
type Subaccount = Blob
```


## Type `Account`
``` motoko no-repl
type Account = { owner : Principal; subaccount : ?Subaccount }
```


## Type `Value`
``` motoko no-repl
type Value = {#Nat : Nat; #Int : Int; #Text : Text; #Blob : Blob; #Array : [Value]; #Map : [(Text, Value)]}
```


## Type `TransferArgs`
``` motoko no-repl
type TransferArgs = { from_subaccount : ?Blob; to : Account; token_id : Nat; memo : ?Blob; created_at_time : ?Nat64 }
```


## Type `TransferError`
``` motoko no-repl
type TransferError = {#Unauthorized; #NonExistingTokenId; #TooOld; #CreatedInFuture : { ledger_time : Nat64 }; #Duplicate : { duplicate_of : Nat }; #GenericError : { error_code : Nat; message : Text }}
```


## Type `TransferResultItem`
``` motoko no-repl
type TransferResultItem = { token_id : Nat; transfer_result : {#Ok : Nat; #Err : TransferError} }
```


## Type `TransferResult`
``` motoko no-repl
type TransferResult = [?TransferResultItem]
```


## Type `ApprovalArgs`
``` motoko no-repl
type ApprovalArgs = { from_subaccount : ?Blob; spender : Account; memo : ?Blob; expires_at : ?Nat64; created_at_time : ?Nat64 }
```


## Type `ApprovalError`
``` motoko no-repl
type ApprovalError = {#Unauthorized; #TooOld; #NonExistingTokenId; #CreatexInFuture : { ledger_time : Nat64 }; #GenericError : { error_code : Nat; message : Text }}
```


## Type `CollectionMetadata`
``` motoko no-repl
type CollectionMetadata = [(Text, Value)]
```


## Type `SupportedStandard`
``` motoko no-repl
type SupportedStandard = { name : Text; url : Text }
```


## Type `ApprovalInfo`
``` motoko no-repl
type ApprovalInfo = { spender : Account; from_subaccount : ?Blob; expires_at : ?Nat64; memo : ?Blob; created_at_time : Nat64 }
```


## Type `ApproveTokenArg`
``` motoko no-repl
type ApproveTokenArg = { token_id : Nat; approval_info : ApprovalInfo }
```


## Type `ApproveTokenResult`
``` motoko no-repl
type ApproveTokenResult = {#Ok : Nat; #Err : ApproveTokenError}
```


## Type `ApproveTokenError`
``` motoko no-repl
type ApproveTokenError = {#InvalidSpender; #Unauthorized; #NonExistingTokenId; #TooOld; #CreatedInFuture : { ledger_time : Nat64 }; #GenericError : { error_code : Nat; message : Text }; #GenericBatchError : { error_code : Nat; message : Text }}
```


## Type `ApproveCollectionArg`
``` motoko no-repl
type ApproveCollectionArg = { approval_info : ApprovalInfo }
```


## Type `ApprovalResult`
``` motoko no-repl
type ApprovalResult = [{ token_id : Nat; approval_result : {#Ok : Nat; #Err : ApprovalError} }]
```


## Type `ApproveCollectionResult`
``` motoko no-repl
type ApproveCollectionResult = {#Ok : Nat; #Err : ApproveCollectionError}
```


## Type `ApproveCollectionError`
``` motoko no-repl
type ApproveCollectionError = {#InvalidSpender; #TooOld; #CreatedInFuture : { ledger_time : Nat64 }; #GenericError : { error_code : Nat; message : Text }; #GenericBatchError : { error_code : Nat; message : Text }}
```


## Type `RevokeTokenApprovalArg`
``` motoko no-repl
type RevokeTokenApprovalArg = { spender : ?Account; from_subaccount : ?Blob; token_id : Nat; memo : ?Blob; created_at_time : ?Nat64 }
```


## Type `RevokeTokenApprovalResponse`
``` motoko no-repl
type RevokeTokenApprovalResponse = {#Ok : Nat; #Err : RevokeTokenApprovalError}
```


## Type `RevokeTokenApprovalError`
``` motoko no-repl
type RevokeTokenApprovalError = {#ApprovalDoesNotExist; #Unauthorized; #NonExistingTokenId; #TooOld; #CreatedInFuture : { ledger_time : Nat64 }; #GenericError : { error_code : Nat; message : Text }; #GenericBatchError : { error_code : Nat; message : Text }}
```


## Type `RevokeCollectionApprovalArg`
``` motoko no-repl
type RevokeCollectionApprovalArg = { spender : ?Account; from_subaccount : ?Blob; memo : ?Blob; created_at_time : ?Nat64 }
```


## Type `RevokeCollectionApprovalResult`
``` motoko no-repl
type RevokeCollectionApprovalResult = {#Ok : Nat; #Err : RevokeCollectionApprovalError}
```


## Type `CollectionApproval`
``` motoko no-repl
type CollectionApproval = ApprovalInfo
```


## Type `RevokeCollectionApprovalError`
``` motoko no-repl
type RevokeCollectionApprovalError = {#ApprovalDoesNotExist; #TooOld; #CreatedInFuture : { ledger_time : Nat64 }; #GenericError : { error_code : Nat; message : Text }; #GenericBatchError : { error_code : Nat; message : Text }}
```


## Type `IsApprovedArg`
``` motoko no-repl
type IsApprovedArg = { spender : Account; from_subaccount : ?Blob; token_id : Nat }
```


## Type `TokenApproval`
``` motoko no-repl
type TokenApproval = { token_id : Nat; approval_info : ApprovalInfo }
```


## Type `TransferFromArg`
``` motoko no-repl
type TransferFromArg = { spender_subaccount : ?Blob; from : Account; to : Account; token_id : Nat; memo : ?Blob; created_at_time : ?Nat64 }
```


## Type `TransferFromResponse`
``` motoko no-repl
type TransferFromResponse = {#Ok : Nat; #Err : TransferFromError}
```


## Type `TransferFromError`
``` motoko no-repl
type TransferFromError = {#InvalidRecipient; #Unauthorized; #NonExistingTokenId; #TooOld; #CreatedInFuture : { ledger_time : Nat64 }; #Duplicate : { duplicate_of : Nat }; #GenericError : { error_code : Nat; message : Text }; #GenericBatchError : { error_code : Nat; message : Text }}
```


## Type `Service`
``` motoko no-repl
type Service = actor { icrc7_name : shared query () -> async Text; icrc7_symbol : shared query () -> async Text; icrc7_description : shared query () -> async ?Text; icrc7_logo : shared query () -> async ?Text; icrc7_total_supply : shared query () -> async Nat; icrc7_supply_cap : shared query () -> async ?Nat; icrc7_max_approvals_per_token_or_collection : shared query () -> async ?Nat; icrc7_max_query_batch_size : shared query () -> async ?Nat; icrc7_max_update_batch_size : shared query () -> async ?Nat; icrc7_default_take_value : shared query () -> async ?Nat; icrc7_max_take_value : shared query () -> async ?Nat; icrc7_max_revoke_approvals : shared query () -> async ?Nat; icrc7_max_memo_size : shared query () -> async ?Nat; icrc7_atomic_batch_transfers : shared query () -> async ?Bool; icrc7_tx_window : shared query () -> async ?Nat; icrc7_permitted_drift : shared query () -> async ?Nat; icrc7_collection_metadata : shared query () -> async [(Text, Value)]; icrc7_tokens : shared query (?Nat, ?Nat) -> async [Nat]; icrc7_token_metadata : shared query ([Nat]) -> async [?{ metadata : [(Text, Value)] }]; icrc7_owner_of : shared query ([Nat]) -> async [?Account]; icrc7_tokens_of : shared query (Account, ?Nat, ?Nat) -> async [Nat]; icrc7_balance_of : shared query ([Account]) -> async [Nat]; icrc7_transfer : shared ([TransferArgs]) -> async TransferResult; icrc7_transfer_fee : shared (Nat) -> async ?Nat; icrc37_collection_metadata : shared query () -> async [(Text, Value)]; icrc37_max_approvals_per_token_or_collection : shared query () -> async ?Nat; icrc37_max_revoke_approvals : shared query () -> async ?Nat; icrc37_is_approved : shared query ([IsApprovedArg]) -> async ([Bool]); icrc37_get_token_approvals : shared query (token_id : Nat, prev : ?TokenApproval, take : ?Nat) -> async ([?TokenApproval]); icrc37_get_collection_approvals : shared query (owner : Account, prev : ?CollectionApproval, take : ?Nat) -> async ([CollectionApproval]); icrc37_approve_tokens : shared ([ApproveTokenArg]) -> async [?ApproveTokenResult]; icrc37_approve_collection : shared ([ApproveCollectionArg]) -> async [?ApproveCollectionResult]; icrc37_revoke_token_approvals : shared ([RevokeTokenApprovalArg]) -> async ([?RevokeTokenApprovalResponse]); icrc37_revoke_collection_approvals : shared ([RevokeCollectionApprovalArg]) -> async ([?RevokeCollectionApprovalResult]); icrc37_transfer_from : shared ([TransferFromArg]) -> async ([?TransferFromResponse]); icrc10_supported_standards : shared query () -> async [SupportedStandard] }
```

