use std::{ env, path::Path };
use candid::{ Nat, Principal };
use ic_ledger_types::Tokens;
use ledger_utils::principal_to_legacy_account_id;
use pocket_ic::PocketIc;
use utils::consts::E8S_FEE_OGY;
use icrc_ledger_types::{ icrc1::{ account::Account, transfer::NumTokens } };
use crate::origyn_nft_suite::nft_utils;
use origyn_nft_reference::origyn_nft_reference_canister::{
  CandyShared,
  ManageStorageRequestConfigureStorage,
};
use types::CanisterId;

use crate::{
  client::pocket::{ create_canister, install_canister },
  utils::random_principal,
  wasms,
};

use super::{ CanisterIds, TestEnv };

pub static POCKET_IC_BIN: &str = "/usr/local/bin/pocket-ic";

pub fn init() -> TestEnv {
  validate_pocketic_installation();
  println!("install validate");

  let mut pic: PocketIc = PocketIc::new();
  println!("pic set");

  // let mut pic: PocketIc = PocketIc::new();
  // println!("pic set");

  let controller: Principal = random_principal();
  let originator: Principal = random_principal();
  let net_principal: Principal = random_principal();
  let canister_ids: CanisterIds = install_canisters(&mut pic, controller);
  println!("origyn_nft: {:?}", canister_ids.origyn_nft.to_string());
  println!("ogy_ledger: {:?}", canister_ids.ogy_ledger.to_string());
  println!("ldg_ledger: {:?}", canister_ids.ldg_ledger.to_string());

  init_origyn_nft(&mut pic, canister_ids.origyn_nft, originator, controller, net_principal);
  TestEnv {
    pic,
    canister_ids,
    controller,
  }
}

fn init_origyn_nft(
  pic: &mut PocketIc,
  canister: CanisterId,
  originator: Principal,
  controller: Principal,
  net_principal: Principal
) {
  let manage_storage_return: origyn_nft_reference::origyn_nft_reference_canister::ManageStorageResult = crate::client::origyn_nft_reference::client::manage_storage_nft_origyn(
    pic,
    canister,
    Some(controller),
    crate::client::origyn_nft_reference::manage_storage_nft_origyn::Args::ConfigureStorage(
      ManageStorageRequestConfigureStorage::Heap(Some(Nat::from(500000000 as u32)))
    )
  );

  println!("manage_storage_return: {:?}", manage_storage_return);

  let collection_update_return: origyn_nft_reference::origyn_nft_reference_canister::OrigynBoolResult = crate::client::origyn_nft_reference::client::collection_update_nft_origyn(
    pic,
    canister,
    Some(controller),
    crate::client::origyn_nft_reference::collection_update_nft_origyn::Args::UpdateOwner(
      net_principal
    )
  );

  println!("collection_update_return: {:?}", collection_update_return);

  let standardStage = nft_utils::build_standard_nft(
    pic,
    "1".to_string(),
    canister,
    canister,
    originator,
    Nat::from(1024 as u32),
    false,
    controller,
    net_principal
  );
}

fn install_canisters(pic: &mut PocketIc, controller: Principal) -> CanisterIds {
  let origyn_nft_canister_id: Principal = create_canister(pic, controller);
  let ogy_ledger_canister_id: Principal = create_canister(pic, controller);
  let ldg_ledger_canister_id: Principal = create_canister(pic, controller);

  let origyn_nft_canister_wasm: Vec<u8> = wasms::ORIGYN_NFT.clone();
  let ogy_ledger_canister_wasm: Vec<u8> = wasms::OGY_LEDGER.clone();
  let ldg_ledger_canister_wasm: Vec<u8> = wasms::LDG_LEDGER.clone();

  let ogy_legacy_minting_account_principal: Principal = controller;

  install_canister(pic, controller, origyn_nft_canister_id, origyn_nft_canister_wasm, {});

  let ogy_ledger_init_args: icrc_ledger_canister::init::LedgerArgument = icrc_ledger_canister::init::LedgerArgument::Init(
    icrc_ledger_canister::init::InitArgs {
      minting_account: Account::from(ogy_legacy_minting_account_principal),
      initial_balances: vec![(
        Account {
          owner: Principal::from_text("bw4dl-smaaa-aaaaa-qaacq-cai").unwrap(),
          subaccount: None,
        },
        Nat::from(18_446_744_073_709_551_615 as u64),
      )],
      archive_options: icrc_ledger_canister::init::ArchiveOptions {
        trigger_threshold: 2000,
        num_blocks_to_archive: 1000,
        controller_id: controller,
      },
      metadata: vec![],
      transfer_fee: Nat::from(0u64),
      token_symbol: "OGY".into(),
      token_name: "Origyn".into(),
    }
  );

  install_canister(
    pic,
    controller,
    ogy_ledger_canister_id,
    ogy_ledger_canister_wasm,
    ogy_ledger_init_args
  );

  let ldg_ledger_init_args: icrc_ledger_canister::init::LedgerArgument = icrc_ledger_canister::init::LedgerArgument::Init(
    icrc_ledger_canister::init::InitArgs {
      minting_account: Account {
        owner: ogy_legacy_minting_account_principal,
        subaccount: None,
      },
      initial_balances: vec![],
      archive_options: icrc_ledger_canister::init::ArchiveOptions {
        trigger_threshold: 2000,
        num_blocks_to_archive: 1000,
        controller_id: controller,
      },
      metadata: vec![],
      transfer_fee: Nat::from(E8S_FEE_OGY),
      token_symbol: "LDG".to_string(),
      token_name: "LedGer".to_string(),
    }
  );

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
