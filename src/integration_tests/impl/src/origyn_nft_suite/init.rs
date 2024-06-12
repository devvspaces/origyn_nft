use std::{ env, path::Path };
use candid::{ Nat, Principal };
use ic_ledger_types::Tokens;
use ledger_utils::principal_to_legacy_account_id;
use pocket_ic::PocketIc;
use utils::consts::E8S_FEE_OGY;
use icrc_ledger_types::{ icrc1::{ account::Account, transfer::NumTokens } };
use crate::origyn_nft_suite::nft_utils;
use origyn_nft_reference::origyn_nft_reference_canister::{ Service };

use crate::{
  client::pocket::{ create_canister, install_canister },
  utils::random_principal,
  wasms,
};

use super::{ CanisterIds, TestEnv };

pub static POCKET_IC_BIN: &str = "/usr/local/bin/pocket-ic";

pub async fn init() -> TestEnv {
  validate_pocketic_installation();
  println!("install validate");

  let mut pic: PocketIc = PocketIc::new();
  println!("pic set");

  let controller = random_principal();
  let originator = random_principal();
  println!("controller: {:?}", controller);
  println!("originator: {:?}", originator);
  let canister_ids: CanisterIds = install_canisters(&mut pic, controller);
  println!("canister_ids: {:?}", canister_ids);

  init_origyn_nft(Service(canister_ids.origyn_nft), originator).await;
  TestEnv {
    pic,
    canister_ids,
    controller,
  }
}

async fn init_origyn_nft(canister: Service, originator: Principal) {
  let standardStage = nft_utils::build_standard_nft(
    "1".to_string(),
    canister.clone(),
    canister.0.clone(),
    originator,
    Nat::from(1024 as u32),
    false
  ).await;
}

fn install_canisters(pic: &mut PocketIc, controller: Principal) -> CanisterIds {
  let origyn_nft_canister_id = create_canister(pic, controller);
  let ogy_ledger_canister_id = create_canister(pic, controller);
  let ldg_ledger_canister_id = create_canister(pic, controller);

  let origyn_nft_canister_wasm = wasms::ORIGYN_NFT.clone();
  let ogy_ledger_canister_wasm = wasms::OGY_LEDGER.clone();
  let ldg_ledger_canister_wasm = wasms::LDG_LEDGER.clone();

  let ogy_legacy_minting_account_principal = controller;

  install_canister(pic, controller, origyn_nft_canister_id, origyn_nft_canister_wasm, {});

  let ogy_ledger_init_args = icrc_ledger_canister::init::InitArgs {
    minting_account: Account {
      owner: ogy_legacy_minting_account_principal,
      subaccount: None,
    },
    initial_balances: vec![],
    archive_options: icrc_ledger_canister::init::ArchiveOptions {
      trigger_threshold: 2000,
      num_blocks_to_archive: 1000,
      controller_id: Principal::anonymous(),
    },
    metadata: vec![],
    transfer_fee: Nat::from(E8S_FEE_OGY),
    token_symbol: "OGY".to_string(),
    token_name: "Origyn".to_string(),
  };
  install_canister(
    pic,
    controller,
    ogy_ledger_canister_id,
    ogy_ledger_canister_wasm,
    ogy_ledger_init_args
  );

  let ldg_ledger_init_args = icrc_ledger_canister::init::InitArgs {
    minting_account: Account {
      owner: ogy_legacy_minting_account_principal,
      subaccount: None,
    },
    initial_balances: vec![],
    archive_options: icrc_ledger_canister::init::ArchiveOptions {
      trigger_threshold: 2000,
      num_blocks_to_archive: 1000,
      controller_id: Principal::anonymous(),
    },
    metadata: vec![],
    transfer_fee: Nat::from(E8S_FEE_OGY),
    token_symbol: "LDG".to_string(),
    token_name: "LedGer".to_string(),
  };

  install_canister(
    pic,
    controller,
    ldg_ledger_canister_id,
    ldg_ledger_canister_wasm,
    ldg_ledger_init_args
  );

  CanisterIds {
    origyn_nft: origyn_nft_canister_id,
    ogy_ledger: ogy_ledger_canister_id,
    ldg_ledger: ldg_ledger_canister_id,
  }
}

pub fn validate_pocketic_installation() {
  let path = POCKET_IC_BIN;

  if !Path::new(&path).exists() {
    println!(
      "
        Could not find the PocketIC binary to run canister integration tests.

        I looked for it at {:?}. You can specify another path with the environment variable POCKET_IC_BIN (note that I run from {:?}).
        ",
      &path,
      &env
        ::current_dir()
        .map(|x| x.display().to_string())
        .unwrap_or_else(|_| "an unknown directory".to_string())
    );
  }
}
