use crate::origyn_nft_suite::{ CanisterIds, PrincipalIds };
use crate::origyn_nft_suite::{ init::init, TestEnv };
use origyn_nft_reference::origyn_nft_reference_canister::Account;
use candid::Nat;

#[test]
fn valid_transfer() {
  println!("create init");
  let env = init();
  let TestEnv {
    mut pic,
    canister_ids: CanisterIds { origyn_nft, ogy_ledger, ldg_ledger },
    principal_ids: PrincipalIds { net_principal, controller, originator },
  } = env;

  let standard_nft_return: crate::origyn_nft_suite::nft_utils::BuildStandardNftReturns = crate::origyn_nft_suite::nft_utils::build_standard_nft(
    &mut pic,
    "1".to_string(),
    origyn_nft,
    origyn_nft,
    originator,
    Nat::from(1024 as u32),
    false,
    net_principal
  );
  println!("standard_nft_return: {:?}", standard_nft_return);

  let mint_return = crate::client::origyn_nft_reference::client::mint_nft_origyn(
    &mut pic,
    origyn_nft,
    Some(net_principal),
    ("1".to_string(), Account::Principal_(controller))
  );

  println!("mint_return: {:?}", mint_return);

  //   let user1_principal = random_principal();
  //   let user1 = principal_to_legacy_account_id(user1_principal, None);
  //   let user2_principal = random_principal();
  //   let user2 = principal_to_legacy_account_id(user2_principal, None);

  println!("origyn_nft: {:?}", origyn_nft.to_string());
  println!("ogy_ledger: {:?}", ogy_ledger.to_string());
  println!("ldg_ledger: {:?}", ldg_ledger.to_string());
  println!("net_principal: {:?}", net_principal.to_string());
  println!("controller: {:?}", controller.to_string());
  println!("originator: {:?}", originator.to_string());
}
