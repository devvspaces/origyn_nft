use crate::{ generate_query_call, generate_update_call };
use origyn_nft_reference::origyn_nft_reference_canister::{
  NftCanisterStageNftOrigynArg,
  OrigynTextResult,
  OrigynBoolResult,
  StageChunkArg,
  StageLibraryResult,
  ManageStorageResult,
  ManageStorageRequest,
  ManageCollectionCommand,
};

generate_update_call!(stage_nft_origyn);
generate_update_call!(stage_library_nft_origyn);
generate_update_call!(manage_storage_nft_origyn);
generate_update_call!(collection_update_nft_origyn);

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

pub mod manage_storage_nft_origyn {
  use super::*;

  pub type Args = ManageStorageRequest;
  pub type Response = ManageStorageResult;
}

pub mod collection_update_nft_origyn {
  use super::*;

  pub type Args = ManageCollectionCommand;
  pub type Response = OrigynBoolResult;
}

pub mod client {
  use super::*;
  use candid::Principal;
  use pocket_ic::PocketIc;
  use types::CanisterId;

  pub fn stage_nft_origyn(
    pic: &mut PocketIc,
    canister_id: CanisterId,
    sender: Option<Principal>,
    args: stage_nft_origyn::Args
  ) -> stage_nft_origyn::Response {
    match sender {
      Some(sender) => {
        crate::client::origyn_nft_reference::stage_nft_origyn(pic, sender, canister_id, &args)
      }
      None => {
        crate::client::origyn_nft_reference::stage_nft_origyn(
          pic,
          Principal::anonymous(),
          canister_id,
          &args
        )
      }
    }
  }

  pub fn stage_library_nft_origyn(
    pic: &mut PocketIc,
    canister_id: CanisterId,
    sender: Option<Principal>,
    args: stage_library_nft_origyn::Args
  ) -> stage_library_nft_origyn::Response {
    match sender {
      Some(sender) => {
        crate::client::origyn_nft_reference::stage_library_nft_origyn(
          pic,
          sender,
          canister_id,
          &args
        )
      }
      None => {
        crate::client::origyn_nft_reference::stage_library_nft_origyn(
          pic,
          Principal::anonymous(),
          canister_id,
          &args
        )
      }
    }
  }

  pub fn manage_storage_nft_origyn(
    pic: &mut PocketIc,
    canister_id: CanisterId,
    sender: Option<Principal>,
    args: manage_storage_nft_origyn::Args
  ) -> manage_storage_nft_origyn::Response {
    match sender {
      Some(sender) => {
        crate::client::origyn_nft_reference::manage_storage_nft_origyn(
          pic,
          sender,
          canister_id,
          &args
        )
      }
      None => {
        crate::client::origyn_nft_reference::manage_storage_nft_origyn(
          pic,
          Principal::anonymous(),
          canister_id,
          &args
        )
      }
    }
  }

  pub fn collection_update_nft_origyn(
    pic: &mut PocketIc,
    canister_id: CanisterId,
    sender: Option<Principal>,
    args: collection_update_nft_origyn::Args
  ) -> collection_update_nft_origyn::Response {
    match sender {
      Some(sender) => {
        crate::client::origyn_nft_reference::collection_update_nft_origyn(
          pic,
          sender,
          canister_id,
          &args
        )
      }
      None => {
        crate::client::origyn_nft_reference::collection_update_nft_origyn(
          pic,
          Principal::anonymous(),
          canister_id,
          &args
        )
      }
    }
  }
}
