use ic_ledger_types::Tokens;
use ledger_utils::principal_to_legacy_account_id;
use utils::consts::{ E8S_FEE_OGY, E8S_PER_OGY };

use crate::origyn_nft_suite::{ init::init, TestEnv };
use crate::utils::random_principal;

#[test]
fn valid_transfer() {
  println!("create init");
  let env = init();
  let TestEnv { mut pic, canister_ids, controller } = env;

  let nft_canister_id = canister_ids.origyn_nft;

  //   let user1_principal = random_principal();
  //   let user1 = principal_to_legacy_account_id(user1_principal, None);
  //   let user2_principal = random_principal();
  //   let user2 = principal_to_legacy_account_id(user2_principal, None);

  println!("nft_canister_id: {:?}", nft_canister_id);
  println!("canister_ids: {:?}", canister_ids);
  println!("controller: {:?}", controller);
}
