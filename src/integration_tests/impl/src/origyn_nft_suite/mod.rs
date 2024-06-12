use candid::Principal;
use pocket_ic::PocketIc;
use types::CanisterId;

mod init;
mod tests;
mod nft_utils;

pub struct TestEnv {
  pub pic: PocketIc,
  pub canister_ids: CanisterIds,
  pub controller: Principal,
}

#[derive(Debug)]
pub struct CanisterIds {
  pub origyn_nft: CanisterId,
  pub ogy_ledger: CanisterId,
  pub ldg_ledger: CanisterId,
}
