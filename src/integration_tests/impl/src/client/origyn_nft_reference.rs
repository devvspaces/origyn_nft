use crate::generate_query_call;
use origyn_nft_reference::origyn_nft_reference_canister::{
  NftCanisterStageNftOrigynArg,
  OrigynTextResult,
  StageChunkArg,
  StageLibraryResult,
};
use ic_cdk::api::call::CallResult as OrigynResult;

generate_query_call!(stage_nft_origyn);
generate_query_call!(stage_library_nft_origyn);

pub mod stage_nft_origyn {
  use super::*;

  pub type Args = NftCanisterStageNftOrigynArg;
  pub type Response = OrigynResult<(OrigynTextResult,)>;
}

pub mod stage_library_nft_origyn {
  use super::*;

  pub type Args = StageChunkArg;
  pub type Response = OrigynResult<(StageLibraryResult,)>;
}

pub mod client {
  use super::*;
  use candid::Principal;
  use pocket_ic::PocketIc;
  use types::CanisterId;

  pub fn stage_nft_origyn(
    pic: &mut PocketIc,
    canister_id: CanisterId,
    args: NftCanisterStageNftOrigynArg
  ) -> stage_nft_origyn::Response {
    crate::client::origyn_nft_reference::stage_nft_origyn(
      pic,
      Principal::anonymous(),
      canister_id,
      &args
    )
  }

  pub fn stage_library_nft_origyn(
    pic: &mut PocketIc,
    canister_id: CanisterId,
    args: StageChunkArg
  ) -> stage_library_nft_origyn::Response {
    crate::client::origyn_nft_reference::stage_library_nft_origyn(
      pic,
      Principal::anonymous(),
      canister_id,
      &args
    )
  }
}
