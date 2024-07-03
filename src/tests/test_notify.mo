import D "mo:base/Debug";
import Types "../origyn_nft_reference/types";

shared (deployer) actor class test_wallet() = this {
  public shared (msg) func notify_sale_nft_origyn(request : Types.SubscriberNotification) : () {
    D.print("was notified!" # debug_show (request));
  };
};
