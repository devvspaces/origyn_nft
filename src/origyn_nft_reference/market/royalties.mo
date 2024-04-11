import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import D "mo:base/Debug";
import Deque "mo:base/Deque";
import Error "mo:base/Error";
import Float "mo:base/Float";
import Hash "mo:base/Hash";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Timer "mo:base/Timer";

import AccountIdentifier "mo:principalmo/AccountIdentifier";

import Map "mo:map/Map";
import Set "mo:map/Set";
import MapUtil "mo:map/utils";

import Star "mo:star/star";
import SHA256 "mo:crypto/SHA/SHA256";
import Parser "mo:parser-combinators/Parser";

import PutBalance "./put_balance";
import Ledger_Interface "../ledger_interface";
import Metadata "../metadata";
import MigrationTypes "../migrations/types";
import Migrations "../migrations/types";
import NFTUtils "../utils";
import Types "../types";
import FeeAccount "./fee_account";
import Verify "./verify_reciept";

module {
  let debug_channel = {
    royalties = false;
  };

  type StateAccess = Types.State;

  let CandyTypes = MigrationTypes.Current.CandyTypes;
  let Conversions = MigrationTypes.Current.Conversions;
  let Properties = MigrationTypes.Current.Properties;

  type ProcessRoyaltiesRequest = {
    var remaining : Nat;
    total : Nat;
    fee : Nat;
    account_hash : ?Blob;
    royalty : [CandyTypes.CandyShared];
    escrow : Types.EscrowReceipt;
    broker_id : ?Principal;
    original_broker_id : ?Principal;
    sale_id : ?Text;
    metadata : CandyTypes.CandyShared;
    token_id : ?Text;
    token : Types.TokenSpec;
    fee_accounts : ?MigrationTypes.Current.FeeAccountsParams;
    fee_schema : Text;
  };

  let account_handler = MigrationTypes.Current.account_handler;
  let token_handler = MigrationTypes.Current.token_handler;

  public let royalties_names : [Text] = [
    "com.origyn.royalty.broker",
    "com.origyn.royalty.node",
    "com.origyn.royalty.originator",
    "com.origyn.royalty.custom",
    "com.origyn.royalty.network",
  ];

  private func dev_fund() : { owner : Principal; sub_account : ?Blob } {
    {
      owner = Principal.fromText("a3lu7-uiaaa-aaaaj-aadnq-cai");
      sub_account = ?Blob.fromArray([90, 139, 65, 137, 126, 28, 225, 88, 245, 212, 115, 206, 119, 123, 54, 216, 86, 30, 91, 21, 25, 35, 79, 182, 234, 229, 219, 103, 248, 132, 25, 79]);
    };
  };

  /**
    * Calculates the network royalty account for a given principal.
    *
    * @param {Principal} principal - The principal for which to calculate the network royalty account.
    *
    * @returns {Array<Nat8>} An array of 8-bit natural numbers representing the calculated network royalty account.
    */
  public func get_network_royalty_account(principal : Principal, ledger_token_id : ?Nat) : [Nat8] {
    let h = SHA256.New();
    h.write(Conversions.candySharedToBytes(#Text("com.origyn.network_royalty")));
    h.write(Conversions.candySharedToBytes(#Text("canister-id")));
    h.write(Conversions.candySharedToBytes(#Text(Principal.toText(principal))));
    switch (ledger_token_id) {
      case (?val) {
        h.write(Conversions.candySharedToBytes(#Text("token-id")));
        h.write(Conversions.candySharedToBytes(#Nat(val)));
      };
      case (null) {};
    };
    h.sum([]);
  };

  public func _load_royalty(fee_schema : Text, royalty : CandyTypes.CandyShared) : Result.Result<MigrationTypes.Current.Royalty, Types.OrigynError> {
    debug if (debug_channel.royalties) D.print("_load_royalty" # debug_show (royalty));

    let ?properties : ?CandyTypes.PropertyShared = Properties.getClassPropertyShared(royalty, "tag") else return #err(Types.errors(null, #malformed_metadata, "_load_royalty - missing tag in royalty  ", null));
    let #Text(tag) = properties.value else return #err(Types.errors(null, #malformed_metadata, "_load_royalty - missing tag in royalty  ", null));

    if (fee_schema == Types.metadata.__system_fixed_royalty) {
      let ?properties_2 : ?CandyTypes.PropertyShared = Properties.getClassPropertyShared(royalty, "fixedXDR") else return #err(Types.errors(null, #malformed_metadata, "_load_royalty - missing fixedXDR in fixed royalty  ", null));
      let #Float(fixedXDR) = properties_2.value else return #err(Types.errors(null, #malformed_metadata, "_load_royalty - missing fixedXDR in fixed royalty  ", null));

      let tokenCanister : ?Principal = switch (Properties.getClassPropertyShared(royalty, "tokenCanister")) {
        case (null) { null };
        case (?val) {
          switch (val.value) {
            case (#Principal(val)) { ?val };
            case (_) null;
          };
        };
      };

      let tokenSymbol : ?Text = switch (Properties.getClassPropertyShared(royalty, "tokenSymbol")) {
        case (null) { null };
        case (?val) {
          switch (val.value) {
            case (#Text(val)) { ?val };
            case (_) null;
          };
        };
      };

      let tokenDecimals : ?Nat = switch (Properties.getClassPropertyShared(royalty, "tokenDecimals")) {
        case (null) { null };
        case (?val) {
          switch (val.value) {
            case (#Nat(val)) { ?val };
            case (_) null;
          };
        };
      };

      let tokenFee : ?Nat = switch (Properties.getClassPropertyShared(royalty, "tokenFee")) {
        case (null) { null };
        case (?val) {
          switch (val.value) {
            case (#Nat(val)) { ?val };
            case (_) null;
          };
        };
      };

      let token : ?Types.TokenSpec = if (tokenCanister != null and tokenSymbol != null and tokenDecimals != null and tokenFee != null) {
        switch (tokenCanister) {
          case (?canisterId) {
            ? #ic({
              canister = canisterId;
              decimals = Option.get<Nat>(tokenDecimals, 0);
              fee = tokenFee;
              id = null;
              standard = #Ledger;
              symbol = Option.get<Text>(tokenSymbol, "");
            });
          };
          case (null) { null };
        };
      } else {
        null;
      };

      return #ok(#fixed({ tag = tag; fixedXDR = fixedXDR; token = token }));
    } else {
      let ?properties_2 : ?CandyTypes.PropertyShared = Properties.getClassPropertyShared(royalty, "rate") else return #err(Types.errors(null, #malformed_metadata, "_load_royalty - missing rate in dynamic royalty  ", null));
      let #Float(rate) = properties_2.value else return #err(Types.errors(null, #malformed_metadata, "_load_royalty - missing rate in dynamic royalty  ", null));

      return #ok(#dynamic({ tag = tag; rate = rate }));
    };
  };

  //handles royalty distribution
  public func _process_royalties(
    state : StateAccess,
    request : ProcessRoyaltiesRequest,
    caller : Principal,
  ) : Result.Result<(Nat, [(Types.EscrowRecord, Bool)]), Types.OrigynError> {
    debug if (debug_channel.royalties) D.print("in process royalty" # debug_show (request));

    let results = Buffer.Buffer<(Types.EscrowRecord, Bool)>(1);

    label royaltyLoop for (this_item in request.royalty.vals()) {
      let the_array = switch (this_item) {
        case (#Class(the_array)) the_array;
        case (_) { continue royaltyLoop };
      };

      debug if (debug_channel.royalties) D.print("getting items from class " # debug_show (this_item));

      let loaded_royalty = switch (_load_royalty(request.fee_schema, this_item)) {
        case (#ok(val)) { val };
        case (#err(err)) {
          return #err(Types.errors(?state.canistergeekLogger, #malformed_metadata, "_process_royalties - error _load_royalty ", ?caller));
        };
      };

      let tag = switch (loaded_royalty) {
        case (#fixed(val)) { val.tag };
        case (#dynamic(val)) { val.tag };
      };

      let total_royalty = switch (loaded_royalty) {
        case (#fixed(val)) {
          Int.abs(Float.toInt(Float.ceil(val.fixedXDR)));
        };
        case (#dynamic(val)) {
          (request.total * Int.abs(Float.toInt(val.rate * 1_000_000))) / 1_000_000;
        };
      };

      debug if (debug_channel.royalties) D.print("total_royalty =  " # debug_show (total_royalty));

      let principal : [{ owner : Principal; sub_account : ?Blob }] = switch (Properties.getClassPropertyShared(this_item, "account")) {
        case (null) {
          let #ic(tokenSpec) = request.token else {
            debug if (debug_channel.royalties) D.print("not an IC token spec so continuing " # debug_show (request.token));
            continue royaltyLoop;
          }; //we only support ic token specs for royalties

          let _association_table : [(Text, f : (state : StateAccess, request : ProcessRoyaltiesRequest, tokenSpec : Types.ICTokenSpec) -> [{ owner : Principal; sub_account : ?Blob }])] = [
            (Types.metadata.royalty_network, _build_network_account),
            (Types.metadata.royalty_node, _build_royalties_node_account),
            (Types.metadata.royalty_originator, _build_royalties_originator_account),
            (Types.metadata.royalty_broker, _build_royalties_broker_account),
          ];

          let _current_royalty = Array.find<(Text, f : (state : StateAccess, request : ProcessRoyaltiesRequest, tokenSpec : Types.ICTokenSpec) -> [{ owner : Principal; sub_account : ?Blob }])>(_association_table, func x = tag == x.0);
          switch (_current_royalty) {
            case (?val) { val.1 (state, request, tokenSpec) };
            case (null) { [dev_fund()] }; //dev fund
          };

        };
        case (?val) {
          switch (val.value) {
            case (#Principal(val)) [{
              owner = val;
              sub_account = null;
            }];
            case (_) [dev_fund()]; //dev fund
          };
        };
      };

      // Check if fee_accounts is set for this royalty
      let fee_accounts : MigrationTypes.Current.FeeAccountsParams = Option.get(request.fee_accounts, []);

      debug if (debug_channel.royalties) D.print("fee_accounts =  " # debug_show (fee_accounts));
      switch (Array.find<(Text, MigrationTypes.Current.Account)>(fee_accounts, func(val) { return val.0 == tag })) {
        case (?val) {
          switch (val.1) {
            case (#account(fee_accounts_set)) {
              for (this_principal in principal.vals()) {
                let this_royalty = (total_royalty / principal.size());
                debug if (debug_channel.royalties) D.print("this_royalty =  " # debug_show (this_royalty));

                if (this_royalty > request.fee) {
                  let send_account : {
                    owner : Principal;
                    sub_account : ?Blob;
                  } = if (Principal.fromText("yfhhd-7eebr-axyvl-35zkt-z6mp7-hnz7a-xuiux-wo5jf-rslf7-65cqd-cae") == this_principal.owner) {
                    {
                      owner = Principal.fromText("a3lu7-uiaaa-aaaaj-aadnq-cai");
                      sub_account = ?Blob.fromArray([90, 139, 65, 137, 126, 28, 225, 88, 245, 212, 115, 206, 119, 123, 54, 216, 86, 30, 91, 21, 25, 35, 79, 182, 234, 229, 219, 103, 248, 132, 25, 79]);
                    };
                  } else {
                    this_principal;
                  };

                  var _escrow : Types.EscrowReceipt = {
                    request.escrow with
                    buyer = #account(fee_accounts_set);
                    seller = #account(send_account);
                    amount = this_royalty;
                    token_id = Option.get(request.token_id, "");
                    token = switch (loaded_royalty) {
                      case (#fixed(val)) {
                        switch (val.token) {
                          case (?_token) {
                            _token;
                          };
                          case (_) {
                            request.escrow.token;
                          };
                        };
                      };
                      case (#dynamic(_)) {
                        request.escrow.token;
                      };
                    };
                  };

                  let basic_info = {
                    amount = _escrow.amount;
                    buyer = _escrow.buyer;
                    seller = _escrow.seller;
                    token = _escrow.token;
                    token_id = _escrow.token_id;
                  };

                  let fees_account_info : Types.SubAccountInfo = NFTUtils.get_fee_deposit_account_info(basic_info.buyer, state.canister());

                  let id = Metadata.add_transaction_record(
                    state,
                    {
                      token_id = request.escrow.token_id;
                      index = 0;
                      txn_type = #royalty_paid {
                        _escrow with
                        tag = tag;
                        receiver = #account({
                          owner = send_account.owner;
                          sub_account = send_account.sub_account;
                        });
                        sale_id = request.sale_id;
                        extensible = switch (request.token_id) {
                          case (null) #Option(null) : CandyTypes.CandyShared;
                          case (?token_id) #Text(token_id) : CandyTypes.CandyShared;
                        };
                      };
                      timestamp = state.get_time();
                    },
                    caller,
                  );

                  debug if (debug_channel.royalties) D.print("added trx" # debug_show (id));

                  let newReciept = {
                    _escrow with
                    seller = #account({
                      owner = send_account.owner;
                      sub_account = switch (send_account.sub_account) {
                        case (null) null;
                        case (?val) ?val;
                      };
                    });

                    sale_id = request.sale_id;
                    lock_to_date = null;
                    account_hash = ?fees_account_info.account.sub_account;
                  };

                  results.add((newReciept, true));
                } else {
                  //can't pay out if less than fee
                };
              };
            };
            case (_) {}; // TODO CHECK WITH AUSTIN
          };
        };
        case (null) {
          debug if (debug_channel.royalties) D.print("test royalty" # debug_show ((total_royalty, principal)));
          for (this_principal in principal.vals()) {
            let this_royalty = (total_royalty / principal.size());

            if (this_royalty > request.fee) {
              request.remaining -= this_royalty;
              //royaltyList.add(#principal(principal), this_royalty);

              let send_account : {
                owner : Principal;
                sub_account : ?Blob;
              } = if (Principal.fromText("yfhhd-7eebr-axyvl-35zkt-z6mp7-hnz7a-xuiux-wo5jf-rslf7-65cqd-cae") == this_principal.owner) {
                {
                  owner = Principal.fromText("a3lu7-uiaaa-aaaaj-aadnq-cai");
                  sub_account = ?Blob.fromArray([90, 139, 65, 137, 126, 28, 225, 88, 245, 212, 115, 206, 119, 123, 54, 216, 86, 30, 91, 21, 25, 35, 79, 182, 234, 229, 219, 103, 248, 132, 25, 79]);
                };
              } else {
                this_principal;
              };

              let id = Metadata.add_transaction_record(
                state,
                {
                  token_id = request.escrow.token_id;
                  index = 0;
                  txn_type = #royalty_paid {
                    request.escrow with
                    amount = this_royalty;
                    tag = tag;
                    receiver = #account({
                      owner = send_account.owner;
                      sub_account = switch (send_account.sub_account) {
                        case (null) null;
                        case (?val) ?val;
                      };
                    });
                    sale_id = request.sale_id;
                    extensible = switch (request.token_id) {
                      case (null) #Option(null) : CandyTypes.CandyShared;
                      case (?token_id) #Text(token_id) : CandyTypes.CandyShared;
                    };
                  };
                  timestamp = state.get_time();
                },
                caller,
              );

              debug if (debug_channel.royalties) D.print("added trx" # debug_show (id));

              let newReciept = {
                request.escrow with
                amount = this_royalty;
                seller = #account({
                  owner = send_account.owner;
                  sub_account = switch (send_account.sub_account) {
                    case (null) null;
                    case (?val) ?val;
                  };
                });
                sale_id = request.sale_id;
                lock_to_date = null;
                account_hash = request.account_hash;
              };

              //note, if a sale ledger already exists this will add the value, but we need to keep the original amount so we don't double request the same amount.
              let new_sale_balance = PutBalance.put_sales_balance(state, newReciept, true);

              results.add((newReciept, false));
              debug if (debug_channel.royalties) D.print("new_sale_balance" # debug_show (newReciept));
            } else {
              //can't pay out if less than fee
            };
          };
        };
      };
    };

    return #ok(request.remaining, Buffer.toArray(results));
  };

  private func _build_network_account(state : StateAccess, request : ProcessRoyaltiesRequest, tokenSpec : Types.ICTokenSpec) : [{
    owner : Principal;
    sub_account : ?Blob;
  }] {
    debug if (debug_channel.royalties) D.print("found the network" # debug_show (get_network_royalty_account(tokenSpec.canister, tokenSpec.id)));
    switch (state.state.collection_data.network) {
      case (null) [dev_fund()]; //dev fund
      case (?val) [{
        owner = val;
        sub_account = ?Blob.fromArray(get_network_royalty_account(tokenSpec.canister, tokenSpec.id));
      }];
    };
  };

  private func _build_royalties_node_account(state : StateAccess, request : ProcessRoyaltiesRequest, tokenSpec : Types.ICTokenSpec) : [{
    owner : Principal;
    sub_account : ?Blob;
  }] {
    let val = Metadata.get_system_var(request.metadata, Types.metadata.__system_node);

    switch (val) {
      case (#Option(null)) [dev_fund()]; //dev fund
      case (#Principal(val)) [{
        owner = val;
        sub_account = null;
      }];
      case (_) [dev_fund()];
    };
  };

  private func _build_royalties_originator_account(state : StateAccess, request : ProcessRoyaltiesRequest, tokenSpec : Types.ICTokenSpec) : [{
    owner : Principal;
    sub_account : ?Blob;
  }] {
    let val = Metadata.get_system_var(request.metadata, Types.metadata.__system_originator);

    switch (val) {
      case (#Option(null)) [dev_fund()]; //dev fund
      case (#Principal(val)) [{
        owner = val;
        sub_account = null;
      }];
      case (_) [dev_fund()];
    };
  };

  private func _build_royalties_broker_account(state : StateAccess, request : ProcessRoyaltiesRequest, tokenSpec : Types.ICTokenSpec) : [{
    owner : Principal;
    sub_account : ?Blob;
  }] {
    switch (request.broker_id, request.original_broker_id) {
      case (null, null) {
        let ?collection = Map.get(state.state.nft_metadata, Map.thash, "") else {
          state.canistergeekLogger.logMessage("_build_royalties_broker_account cannot find collection metatdata. this should not happene" # debug_show (request.token_id), #Bool(false), null);
          D.trap("_build_royalties_broker_account cannot find collection metatdata. this should not happen");
        };

        let override = switch (Metadata.get_nft_bool_property(collection, Types.metadata.broker_royalty_dev_fund_override)) {
          case (#ok(val)) val;
          case (_) {
            state.canistergeekLogger.logMessage("_build_royalties_broker_account overriding error candy type" # debug_show (collection) # debug_show (request.token_id), #Bool(false), null);
            false;
          };
        };

        if (override) {
          state.canistergeekLogger.logMessage("_build_royalties_broker_account overriding " # debug_show (request.token_id), #Bool(override), null);
          return [];
        };

        state.canistergeekLogger.logMessage("_build_royalties_broker_account override result using dev fund" # debug_show (request.token_id), #Bool(override), null);

        [dev_fund()];
      }; //dev fund
      case (?val, null) [{
        owner = val;
        sub_account = null;
      }];
      case (null, ?val2) [{
        owner = val2;
        sub_account = null;
      }];
      case (?val, ?val2) {
        if (val == val2)[{
          owner = val;
          sub_account = null;
        }] else [{ owner = val; sub_account = null }, { owner = val2; sub_account = null }];
      };
    };

  };
};
