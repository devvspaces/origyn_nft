import MigrationTypes "../migrations/types";
import Conversion "mo:candy/conversion";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";

import ICRC3 "mo:icrc3-mo";


module{

  let CandyTypes = MigrationTypes.Current.CandyTypes;
  let Conversions = MigrationTypes.Current.CandyTypes;
  type Account= MigrationTypes.Current.Account;
  type TokenSpec = MigrationTypes.Current.TokenSpec;

  public func supported_blocktypes() : [(Text,Text)] {
    return [
      ("ogy_bid", "https://github.com/origyn-sa/origyn_nft#auction_bid"),
      ("ogy_mint", "https://github.com/origyn-sa/origyn_nft#mint"),
      ("ogy_sale_ended", "https://github.com/origyn-sa/origyn_nft#sale_ended"),
      ("ogy_royalty_paid", "https://github.com/origyn-sa/origyn_nft#royalty_paid"),
      ("ogy_sale_opened", "https://github.com/origyn-sa/origyn_nft#sale_opened"),
      ("ogy_owner_transfer", "https://github.com/origyn-sa/origyn_nft#owner_transfer"),
      ("ogy_escrow_deposit", "https://github.com/origyn-sa/origyn_nft#escrow_deposit"),
      ("ogy_escrow_withdraw", "https://github.com/origyn-sa/origyn_nft#escrow_withdraw"),
      ("ogy_deposit_withdraw", "https://github.com/origyn-sa/origyn_nft#deposit_withdraw"),
      ("ogy_fee_deposit", "https://github.com/origyn-sa/origyn_nft#fee_deposit"),
      ("ogy_fee_deposit_withdraw", "https://github.com/origyn-sa/origyn_nft#fee_deposit_withdraw"),
      ("ogy_sale_withdraw", "https://github.com/origyn-sa/origyn_nft#sale_withdraw"),
      ("ogy_canister_owner_updated", "https://github.com/origyn-sa/origyn_nft#canister_owner_updated"),
      ("ogy_canister_managers_updated", "https://github.com/origyn-sa/origyn_nft#canister_managers_updated"),
      ("ogy_canister_network_updated", "https://github.com/origyn-sa/origyn_nft#canister_network_updated"),
      ("ogy_data", "https://github.com/origyn-sa/origyn_nft#data"),
      ("ogy_burn", "https://github.com/origyn-sa/origyn_nft#burn"),
      ("ogy_extensible", "https://github.com/origyn-sa/origyn_nft#extensible")
    ];
  };

  public func upgrade_block_to_icrc3(block: MigrationTypes.Current.TransactionRecord, former_phash: ?Blob) : (ICRC3.Value, ?ICRC3.Value) {

    let txTop = Buffer.Buffer<(Text, ICRC3.Value)>(3);
    let tx = Buffer.Buffer<(Text, ICRC3.Value)>(8);

    ignore do?{txTop.add(("phash",#Blob((do?{former_phash!})!)))};

    txTop.add(("index", #Nat(block.index)));
    tx.add(("ts", #Nat(Int.abs(block.timestamp))));
    

    switch (block.txn_type) {
      case (#auction_bid(val)){
        txTop.add(("btype",#Text("ogy_bid")));
        tx.add(("op",#Text("ogy_bid")));
        
        if(block.token_id != ""){
          tx.add(("tokenid", #Text(block.token_id)));
        };
        tx.add(("buyer", MigrationTypes.Current.account_to_value(val.buyer)));
        tx.add(("amount", #Nat(val.amount)));
        tx.add(("token", MigrationTypes.Current.tokenspec_to_value(val.token)));
        tx.add(("sale_id", #Text(val.sale_id)));
        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val.extensible)));
      };
      case (#mint(val)) {
         txTop.add(("btype", #Text("ogy_mint")));
         tx.add(("op", #Text("ogy_mint")));
        
        if(block.token_id != ""){
          tx.add(("tokenid", #Text(block.token_id)));
        };

        tx.add(("from", MigrationTypes.Current.account_to_value(val.from)));
        tx.add(("to", MigrationTypes.Current.account_to_value(val.to)));

        switch(val.sale){
          case (null) {};
          case (?sale){
            tx.add(("sale_token", MigrationTypes.Current.tokenspec_to_value(sale.token)));
            tx.add(("sale_amount", #Nat(sale.amount)));
          }
        };
        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val.extensible)));
      };
      case (#sale_ended(val)) {
         txTop.add(("btype",#Text("ogy_sale_ended")));
         tx.add(("op",#Text("ogy_sale_ended")));
        
        if(block.token_id != ""){
          tx.add(("tokenid", #Text(block.token_id)));
        };

        tx.add(("seller", MigrationTypes.Current.account_to_value(val.seller)));
        tx.add(("buyer", MigrationTypes.Current.account_to_value(val.buyer)));
        tx.add(("amount", #Nat(val.amount)));

        switch(val.sale_id){
          case (null) {};
          case (?sale){
            tx.add(("sale_id", #Text(sale)));
            
          }
        };
        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val.extensible)));
      };
      case (#royalty_paid(val)) {
         txTop.add(("btype", #Text("ogy_royalty_paid")));
         tx.add(("op", #Text("ogy_royalty_paid")));
        
        if(block.token_id != ""){
          tx.add(("tokenid", #Text(block.token_id)));
        };

        tx.add(("seller", MigrationTypes.Current.account_to_value(val.seller)));
        tx.add(("buyer", MigrationTypes.Current.account_to_value(val.buyer)));
        tx.add(("amount", #Nat(val.amount)));
        tx.add(("tag", #Text(val.tag)));

        switch(val.sale_id){
          case (null) {};
          case (?sale){
            tx.add(("sale_id", #Text(sale)));
            
          }
        };
        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val.extensible)));
      };
      case (#sale_opened(val)){
         txTop.add(("btype", #Text("ogy_sale_opened")));
         tx.add(("op", #Text("ogy_sale_opened")));
        
        if(block.token_id != ""){
          tx.add(("tokenid", #Text(block.token_id)));
        };

        
        tx.add(("pricing", MigrationTypes.Current.pricing_config_to_value(val.pricing)));

       
        tx.add(("sale_id", #Text(val.sale_id)));
            
        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val.extensible)));
      }; 

      case (#owner_transfer(val)){
        
         txTop.add(("btype", #Text("ogy_owner_transfer")));
         tx.add(("op", #Text("ogy_owner_transfer")));
        
        if(block.token_id != ""){
          tx.add(("tokenid", #Text(block.token_id)));
        };

        tx.add(("from", MigrationTypes.Current.account_to_value(val.from)));
        tx.add(("to", MigrationTypes.Current.account_to_value(val.to)));
        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val.extensible)));

      }; 
      case (#escrow_deposit(val)){
        
         txTop.add(("btype", #Text("ogy_escrow_deposit")));
         tx.add(("op", #Text("ogy_escrow_deposit")));
        
        if(block.token_id != ""){
          tx.add(("tokenid", #Text(block.token_id)));
        };

        tx.add(("seller", MigrationTypes.Current.account_to_value(val.seller)));
        tx.add(("buyer", MigrationTypes.Current.account_to_value(val.buyer)));

        tx.add(("amount", #Nat(val.amount)));
        tx.add(("token", MigrationTypes.Current.tokenspec_to_value(val.token)));
        tx.add(("escrow_token_id", #Text(val.token_id)));
        tx.add(("trx_id",switch(val.trx_id){
          case(#nat(trx_id)) {
            #Nat(trx_id);
          };
          case(#text(trx_id)) {
            #Text(trx_id);
          };
          case(#extensible(val)){
            MigrationTypes.Current.candySharedToValue(val);
          };
        }));

       


        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val.extensible)));

      }; 
      case (#escrow_withdraw(val)) {
        
        txTop.add(("btype", #Text("ogy_escrow_withdraw")));
        tx.add(("op", #Text("ogy_escrow_withdraw")));
        
        if(block.token_id != ""){
          tx.add(("tokenid", #Text(block.token_id)));
        };

        tx.add(("seller", MigrationTypes.Current.account_to_value(val.seller)));
        tx.add(("buyer", MigrationTypes.Current.account_to_value(val.buyer)));

        tx.add(("amount", #Nat(val.amount)));
        tx.add(("token", MigrationTypes.Current.tokenspec_to_value(val.token)));
        tx.add(("trx_id", switch(val.trx_id){
          case(#nat(trx_id)) {
            #Nat(trx_id);
          };
          case(#text(trx_id)) {
            #Text(trx_id);
          };
          case(#extensible(val)){
            MigrationTypes.Current.candySharedToValue(val);
          };
        }));


        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val.extensible)));

      }; 
      case (#deposit_withdraw(val)){
        
        txTop.add(("btype", #Text("ogy_deposit_withdraw")));
        tx.add(("op", #Text("ogy_deposit_withdraw")));
        
        if(block.token_id != ""){
          tx.add(("tokenid", #Text(block.token_id)));
        };
        tx.add(("buyer", MigrationTypes.Current.account_to_value(val.buyer)));

        tx.add(("amount", #Nat(val.amount)));
        tx.add(("fee", #Nat(val.fee)));
        tx.add(("token", MigrationTypes.Current.tokenspec_to_value(val.token)));
        tx.add(("trx_id",switch(val.trx_id){
          case(#nat(trx_id)) {
            #Nat(trx_id);
          };
          case(#text(trx_id)) {
            #Text(trx_id);
          };
          case(#extensible(val)){
            MigrationTypes.Current.candySharedToValue(val);
          };
        }));


        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val.extensible)));

      };
      case (#fee_deposit(val)){
        
        txTop.add(("btype", #Text("ogy_fee_deposit")));
        tx.add(("op", #Text("ogy_fee_deposit")));
        
        if(block.token_id != ""){
          tx.add(("tokenid", #Text(block.token_id)));
        };
        tx.add(("account", MigrationTypes.Current.account_to_value(val.account)));

        tx.add(("amount", #Nat(val.amount)));
        tx.add(("token", MigrationTypes.Current.tokenspec_to_value(val.token)));
        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val.extensible)));

      }; 
      case (#fee_deposit_withdraw(val)){
        
        txTop.add(("btype", #Text("ogy_fee_deposit_withdraw")));
        tx.add(("op", #Text("ogy_fee_deposit_withdraw")));
        
        if(block.token_id != ""){
          tx.add(("tokenid", #Text(block.token_id)));
        };
        tx.add(("account", MigrationTypes.Current.account_to_value(val.account)));

        tx.add(("amount", #Nat(val.amount)));
        tx.add(("trx_id", switch(val.trx_id){
          case(#nat(trx_id)) {
            #Nat(trx_id);
          };
          case(#text(trx_id)) {
            #Text(trx_id);
          };
          case(#extensible(val)){
            MigrationTypes.Current.candySharedToValue(val);
          };
        }));
        tx.add(("fee", #Nat(val.fee)));
        tx.add(("token", MigrationTypes.Current.tokenspec_to_value(val.token)));
        
        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val.extensible)));

      };  
      case (#sale_withdraw(val)){
        
        txTop.add(("btype", #Text("ogy_sale_withdraw")));
        tx.add(("op", #Text("ogy_sale_withdraw")));
        
        if(block.token_id != ""){
          tx.add(("tokenid", #Text(block.token_id)));
        };
        tx.add(("seller", MigrationTypes.Current.account_to_value(val.seller)));
        tx.add(("buyer", MigrationTypes.Current.account_to_value(val.buyer)));

        tx.add(("amount", #Nat(val.amount)));
        tx.add(("trx_id", switch(val.trx_id){
          case(#nat(trx_id)) {
            #Nat(trx_id);
          };
          case(#text(trx_id)) {
            #Text(trx_id);
          };
          case(#extensible(val)){
            MigrationTypes.Current.candySharedToValue(val);
          };
        }));
        tx.add(("fee", #Nat(val.fee)));
        tx.add(("token", MigrationTypes.Current.tokenspec_to_value(val.token)));
        
        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val.extensible)));

      };
 
      case (#canister_owner_updated(val)){
        
        txTop.add(("btype", #Text("ogy_canister_owner_updated")));
        tx.add(("op", #Text("ogy_canister_owner_updated")));
        
        if(block.token_id != ""){
          tx.add(("tokenid", #Text(block.token_id)));
        };
        tx.add(("owner", #Blob(Principal.toBlob(val.owner))));
        
        
        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val.extensible)));

      };
      case (#canister_managers_updated(val)){
        
        txTop.add(("btype", #Text("ogy_canister_managers_updated")));
        tx.add(("op", #Text("ogy_canister_managers_updated")));
        
        if(block.token_id != ""){
          tx.add(("tokenid", #Text(block.token_id)));
        };
        let list = Buffer.Buffer<ICRC3.Value>(val.managers.size());
        for(thisItem in val.managers.vals()){
          list.add(#Blob(Principal.toBlob(thisItem))); 
        };

        tx.add(("managers", #Array(Buffer.toArray(list))));
        
        
        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val.extensible)));

      }; 
      case (#canister_network_updated(val)){
        
        txTop.add(("btype", #Text("ogy_canister_network_updated")));
        tx.add(("op", #Text("ogy_canister_network_updated")));
        
        if(block.token_id != ""){
          tx.add(("tokenid", #Text(block.token_id)));
        };
        tx.add(("network", #Blob(Principal.toBlob(val.network))));
        
        
        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val.extensible)));

      };
      case (#data(val)){
        
        txTop.add(("btype", #Text("ogy_data")));
        tx.add(("op", #Text("ogy_data")));

         if(block.token_id != ""){
          tx.add(("tokenid", #Text(block.token_id)));
        };
        
        switch(val.data_dapp){
          case (null) {};
          case (?data_dapp){
            tx.add(("data_dapp", #Text(data_dapp)));
            
          }
        };

        switch(val.data_dapp){
          case (null) {};
          case (?data_path){
            tx.add(("data_path", #Text(data_path)));
            
          }
        };
        switch(val.hash){
          case (null) {};
          case (?hash){
            tx.add(("hash", #Blob(Blob.fromArray(hash))));
            
          }
        };
        
        
        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val.extensible)));

      }; 
     
      case (#burn(val)){
        
        txTop.add(("btype", #Text("ogy_burn")));
        tx.add(("op", #Text("ogy_burn")));

         

        if(block.token_id != ""){
          tx.add(("tokenid", #Text(block.token_id)));
        };
        
        
        switch(val.from){
          case (null) {};
          case (?from){
            tx.add(("from", MigrationTypes.Current.account_to_value(from)));
            
          }
        };
        
        
        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val.extensible)));

      };
      case (#extensible(val)) {
        tx.add(("extensible", MigrationTypes.Current.candySharedToValue(val)));
      };
    };

    txTop.add(("tx",#Map(Buffer.toArray(tx))));

    return ( #Map(Buffer.toArray(tx)),? #Map(Buffer.toArray(txTop)));
  };




}