module {

  //this file contains types needed to provide responses to DIP721 style NFT commands
  public type Subaccount = Blob;
  public type Account = {
    owner : Principal; 
    subaccount : ?Subaccount; 
  };

  public type Value = {
     #Nat : Nat; 
     #Int : Int; 
     #Text : Text; 
     #Blob : Blob;
     #Array : [Value];
     #Map : [(Text, Value)];
  };

  public type TransferArgs = {
    
    from_subaccount : ?Blob;     
    to : Account;
    token_id : Nat;
    memo : ?Blob;
    created_at_time : ?Nat64;
  };

  public type TransferError = {
    #Unauthorized;
    #NonExistingTokenId;
    #TooOld;
    #CreatedInFuture : { ledger_time: Nat64 };
    #Duplicate : { duplicate_of : Nat };
    #GenericError : { error_code : Nat; message : Text };
  };

  public type TransferResultItem = {token_id: Nat; transfer_result: {#Ok: Nat; #Err: TransferError}};
  public type TransferResult = [TransferResultItem];

  public type ApprovalArgs = {
    from_subaccount : ?Blob;
    spender : Account;
    memo : ?Blob;
    expires_at : ?Nat64;
    created_at_time : ?Nat64;
  };

  public type ApprovalError = {
    #Unauthorized;
    #TooOld;
    #NonExistingTokenId;
    #CreatexInFuture : { ledger_time : Nat64};
    #GenericError : { error_code : Nat; message : Text};
  };  

 
  
  public type CollectionMetadata = [(Text, Value)];

  public type SupportedStandard = {name: Text; url: Text};

  public type ApprovalInfo = {
    spender : Account;             // Approval is given to an ICRC Account
    from_subaccount : ?Blob;    // The subaccount the token can be transferred out from with the approval
    expires_at : ?Nat64;
    memo : ?Blob;
    created_at_time : Nat64; 
  };

  public type ApproveTokenArg = {
      token_id : Nat;
      approval_info : ApprovalInfo;
  };

  public type ApproveTokenResult = {
      #Ok : Nat; // Transaction index for successful approval
      #Err : ApproveTokenError;
  };

  public type ApproveTokenError = {
      #InvalidSpender;
      #Unauthorized;
      #NonExistingTokenId;
      #TooOld;
      #CreatedInFuture : { ledger_time: Nat64 };
      #GenericError : { error_code : Nat; message : Text };
      #GenericBatchError : { error_code : Nat; message : Text };
  };

  public type ApproveCollectionArg = {
      approval_info : ApprovalInfo;
  };

  public type ApproveCollectionResult = {
      #Ok : Nat; // Transaction index for successful approval
      #Err : ApproveCollectionError;
  };

  public type ApproveCollectionError = {
      #InvalidSpender;
      #TooOld;
      #CreatedInFuture : { ledger_time: Nat64 };
      #GenericError : { error_code : Nat; message : Text };
      #GenericBatchError : { error_code : Nat; message : Text };
  };

  public type RevokeTokenApprovalArg ={
      spender : ?Account;      // null revokes matching approvals for all spenders
      from_subaccount : ?Blob; // null refers to the default subaccount
      token_id : Nat;
      memo : ?Blob;
      created_at_time : ?Nat64;
  };

  public type RevokeTokenApprovalResponse = {
      #Ok : Nat; // Transaction index for successful approval revocation
      #Err : RevokeTokenApprovalError;
  };

  public type RevokeTokenApprovalError = {
      #ApprovalDoesNotExist;
      #Unauthorized;
      #NonExistingTokenId;
      #TooOld;
      #CreatedInFuture :{ ledger_time: Nat64};
      #GenericError :{ error_code : Nat; message : Text};
      #GenericBatchError :{ error_code : Nat; message : Text};
  };

  public type RevokeCollectionApprovalArg ={
      spender : ?Account;      // null revokes approvals for all spenders that match the remaining parameters
      from_subaccount : ?Blob; // null refers to the default subaccount
      memo : ?Blob;
      created_at_time : ?Nat64;
  };

  public type RevokeCollectionApprovalResult = {
      #Ok : Nat; // Transaction index for successful approval revocation
      #Err : RevokeCollectionApprovalError;
  };

  public type CollectionApproval = ApprovalInfo;

  public type RevokeCollectionApprovalError = {
      #ApprovalDoesNotExist;
      #TooOld;
      #CreatedInFuture :{ ledger_time: Nat64};
      #GenericError :{ error_code : Nat; message : Text};
      #GenericBatchError :{ error_code : Nat; message : Text};
  };

  public type IsApprovedArg ={
      spender : Account;
      from_subaccount : ?Blob;
      token_id : Nat;
  };

  public type TokenApproval ={
      token_id : Nat;
      approval_info : ApprovalInfo;
  };

  public type TransferFromArg = {
      spender_subaccount: ?Blob; // The subaccount of the caller (used to identify the spender)
      from : Account;
      to : Account;
      token_id : Nat;
      memo : ?Blob;
      created_at_time : ?Nat64;
  };

  public type TransferFromResponse =  {
      #Ok : Nat; // Transaction index for successful transfer
      #Err : TransferFromError;
  };

  public type TransferFromError = {
      #InvalidRecipient;
      #Unauthorized;
      #NonExistingTokenId;
      #TooOld;
      #CreatedInFuture :{ ledger_time: Nat64};
      #Duplicate :{ duplicate_of : Nat};
      #GenericError :{ error_code : Nat; message : Text};
      #GenericBatchError :{ error_code : Nat; message : Text};
  };

  public type Service = actor {

    icrc7_name: shared query ()-> async Text;
    icrc7_symbol: shared query ()-> async Text;
    icrc7_description: shared query ()-> async ?Text;
    icrc7_logo: shared query ()-> async ?Text;
    icrc7_total_supply: shared query ()-> async Nat;
    icrc7_supply_cap: shared query ()-> async ?Nat;
    icrc7_max_approvals_per_token_or_collection: shared query ()-> async ?Nat;
    icrc7_max_query_batch_size: shared query ()-> async ?Nat;
    icrc7_max_update_batch_size: shared query ()-> async ?Nat;
    icrc7_default_take_value: shared query ()-> async ?Nat;
    icrc7_max_take_value:  shared query ()-> async ?Nat;
    icrc7_max_revoke_approvals:  shared query ()-> async ?Nat;
    icrc7_max_memo_size:  shared query ()-> async ?Nat;
    icrc7_atomic_batch_transfers:  shared query ()-> async ?Bool;
    icrc7_tx_window:  shared query ()-> async ?Nat;
    icrc7_permitted_drift:  shared query ()-> async ?Nat;

    icrc7_collection_metadata: shared query ()-> async [(Text, Value)];

    icrc7_tokens : shared query (?Nat, ?Nat) -> async [Nat];
    icrc7_token_metadata: shared query ([Nat])-> async [?{ metadata : [(Text,Value)]}];
    icrc7_owner_of: shared query ([Nat])-> async [?Account];
    icrc7_tokens_of: shared query (Account, ?Nat, ?Nat)-> async [Nat];
    icrc7_balance_of: shared query ([Account])-> async [Nat];

    icrc7_transfer: shared ([TransferArgs])-> async [?TransferResult];

    icrc37_collection_metadata: shared query ()-> async [(Text, Value)];
    icrc37_max_approvals_per_token_or_collection:  shared query ()-> async ?Nat;
    icrc37_max_revoke_approvals:  shared query ()-> async ?Nat;
    icrc37_is_approved : shared query ([IsApprovedArg]) -> async ([Bool]);
    icrc37_get_token_approvals : shared query(token_id : Nat, prev : ?TokenApproval, take : ?Nat) -> async ([?TokenApproval]);
    icrc37_get_collection_approvals : shared query (owner : Account, prev : ?CollectionApproval, take : ?Nat) -> async ([ CollectionApproval]) ;
    


    icrc37_approve_tokens: shared ([ApproveTokenArg])-> async [?ApproveTokenResult];
    icrc37_approve_collection: shared ([ApproveCollectionArg])-> async [?ApproveCollectionResult];
    icrc37_revoke_token_approvals: shared ([RevokeTokenApprovalArg]) -> async ([?RevokeTokenApprovalResponse]);
    icrc37_revoke_collection_approvals: shared ([RevokeCollectionApprovalArg]) -> async ([?RevokeCollectionApprovalResult]);
    icrc37_transfer_from : shared ([TransferFromArg]) -> async ([?TransferFromResponse]);

    icrc10_supported_standards: shared query ()-> async [SupportedStandard];
    
  };
}