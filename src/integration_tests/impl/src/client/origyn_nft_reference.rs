use crate::{ generate_query_call, generate_update_call };
use candid::Nat;
use ic_ledger_types::BlockIndex;
use origyn_nft_reference::origyn_nft_reference_canister::{
  NftCanisterStageNftOrigynArg,
  OrigynTextResult,
  StageChunkArg,
  StageLibraryResult,
};

generate_query_call!(stage_nft_origyn);
generate_query_call!(stage_library_nft_origyn);

pub mod stage_nft_origyn {
  use super::*;

  pub type Args = NftCanisterStageNftOrigynArg;
  pub type Response = OrigynTextResult;
}

pub mod stage_library_nft_origyn {
  use super::*;

  pub type Args = StageChunkArg;
  pub type Response = StageLibraryResult;
}
