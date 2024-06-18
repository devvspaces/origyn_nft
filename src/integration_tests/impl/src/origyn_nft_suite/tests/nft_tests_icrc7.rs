use crate::client::icrc1_icrc2_token;
use crate::client::origyn_nft_reference::icrc7_owner_of;
use crate::origyn_nft_suite::{ CanisterIds, PrincipalIds };
use crate::origyn_nft_suite::{ init::init, TestEnv };
use ic_cdk::print;
use icrc_ledger_types::icrc2;
use origyn_nft_reference::origyn_nft_reference_canister::{ Account, Account3 };
use candid::{ Nat, Principal };
use pocket_ic::PocketIc;
use utils::consts::E8S_FEE_OGY;

fn init_nft_with_premint_nft(
  pic: &mut PocketIc,
  origyn_nft: Principal,
  originator: Principal,
  net_principal: Principal,
  nft_owner: Principal
) -> bool {
  let standard_nft_return: crate::origyn_nft_suite::nft_utils::BuildStandardNftReturns = crate::origyn_nft_suite::nft_utils::build_standard_nft(
    pic,
    "1".to_string(),
    origyn_nft.clone(),
    origyn_nft.clone(),
    originator.clone(),
    Nat::from(1024 as u32),
    false,
    net_principal.clone()
  );

  let mint_return: origyn_nft_reference::origyn_nft_reference_canister::OrigynTextResult = crate::client::origyn_nft_reference::client::mint_nft_origyn(
    pic,
    origyn_nft.clone(),
    Some(net_principal.clone()),
    ("1".to_string(), Account::Principal_(nft_owner.clone()))
  );

  println!("mint_return: {:?}", mint_return);

  match mint_return {
    origyn_nft_reference::origyn_nft_reference_canister::OrigynTextResult::Ok(_) => true,
    _ => false,
  }
}

/*

    pub fn icrc7_approve(
      pic: &mut PocketIc,
      canister_id: CanisterId,
      sender: Principal,
      args: icrc7_approve::Args
    ) -> icrc7_approve::Response {
      crate::client::origyn_nft_reference::icrc7_approve(pic, sender, canister_id, &args)
    }

    pub fn icrc7_atomic_batch_transfers(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_atomic_batch_transfers::Response {
      crate::client::origyn_nft_reference::icrc7_atomic_batch_transfers(pic, sender, canister_id, &())
    }

    pub fn icrc7_balance_of(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal,
      args: icrc7_balance_of::Args
    ) -> icrc7_balance_of::Response {
      crate::client::origyn_nft_reference::icrc7_balance_of(pic, sender, canister_id, &args)
    }

    pub fn icrc7_collection_metadata(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_collection_metadata::Response {
      crate::client::origyn_nft_reference::icrc7_collection_metadata(pic, sender, canister_id, &())
    }

    pub fn icrc7_default_take_value(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_default_take_value::Response {
      crate::client::origyn_nft_reference::icrc7_default_take_value(pic, sender, canister_id, &())
    }

    pub fn icrc7_description(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_description::Response {
      crate::client::origyn_nft_reference::icrc7_description(pic, sender, canister_id, &())
    }

    pub fn icrc7_logo(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_logo::Response {
      crate::client::origyn_nft_reference::icrc7_logo(pic, sender, canister_id, &())
    }

    pub fn icrc7_max_approvals_per_token_or_collection(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_max_approvals_per_token_or_collection::Response {
      crate::client::origyn_nft_reference::icrc7_max_approvals_per_token_or_collection(
        pic,
        sender,
        canister_id,
        &()
      )
    }

    pub fn icrc7_max_memo_size(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_max_memo_size::Response {
      crate::client::origyn_nft_reference::icrc7_max_memo_size(pic, sender, canister_id, &())
    }

    pub fn icrc7_max_query_batch_size(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_max_query_batch_size::Response {
      crate::client::origyn_nft_reference::icrc7_max_query_batch_size(pic, sender, canister_id, &())
    }

    pub fn icrc7_max_revoke_approvals(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_max_revoke_approvals::Response {
      crate::client::origyn_nft_reference::icrc7_max_revoke_approvals(pic, sender, canister_id, &())
    }

    pub fn icrc7_max_take_value(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_max_take_value::Response {
      crate::client::origyn_nft_reference::icrc7_max_take_value(pic, sender, canister_id, &())
    }

    pub fn icrc7_max_update_batch_size(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_max_update_batch_size::Response {
      crate::client::origyn_nft_reference::icrc7_max_update_batch_size(pic, sender, canister_id, &())
    }

    pub fn icrc7_name(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_name::Response {
      crate::client::origyn_nft_reference::icrc7_name(pic, sender, canister_id, &())
    }

    pub fn icrc7_owner_of(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_owner_of::Response {
      crate::client::origyn_nft_reference::icrc7_owner_of(pic, sender, canister_id, &())
    }

    pub fn icrc7_permitted_drift(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_permitted_drift::Response {
      crate::client::origyn_nft_reference::icrc7_permitted_drift(pic, sender, canister_id, &())
    }

    pub fn icrc7_supply_cap(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_supply_cap::Response {
      crate::client::origyn_nft_reference::icrc7_supply_cap(pic, sender, canister_id, &())
    }

    pub fn icrc7_supported_standards(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_supported_standards::Response {
      crate::client::origyn_nft_reference::icrc7_supported_standards(pic, sender, canister_id, &())
    }

    pub fn icrc7_symbol(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_symbol::Response {
      crate::client::origyn_nft_reference::icrc7_symbol(pic, sender, canister_id, &())
    }

    pub fn icrc7_token_metadata(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal,
      args: icrc7_token_metadata::Args
    ) -> icrc7_token_metadata::Response {
      crate::client::origyn_nft_reference::icrc7_token_metadata(pic, sender, canister_id, &args)
    }

    pub fn icrc7_tokens(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal,
      args: icrc7_tokens::Args
    ) -> icrc7_tokens::Response {
      crate::client::origyn_nft_reference::icrc7_tokens(pic, sender, canister_id, &args)
    }

    pub fn icrc7_tokens_of(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal,
      args: icrc7_tokens_of::Args
    ) -> icrc7_tokens_of::Response {
      crate::client::origyn_nft_reference::icrc7_tokens_of(pic, sender, canister_id, &args)
    }

    pub fn icrc7_total_supply(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_total_supply::Response {
      crate::client::origyn_nft_reference::icrc7_total_supply(pic, sender, canister_id, &())
    }

    pub fn icrc7_transfer(
      pic: &mut PocketIc,
      canister_id: CanisterId,
      sender: Principal,
      args: icrc7_transfer::Args
    ) -> icrc7_transfer::Response {
      crate::client::origyn_nft_reference::icrc7_transfer(pic, sender, canister_id, &args)
    }

    pub fn icrc7_transfer_fee(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal,
      args: icrc7_transfer_fee::Args
    ) -> icrc7_transfer_fee::Response {
      crate::client::origyn_nft_reference::icrc7_transfer_fee(pic, sender, canister_id, &args)
    }

    pub fn icrc7_tx_window(
      pic: &PocketIc,
      canister_id: CanisterId,
      sender: Principal
    ) -> icrc7_tx_window::Response {
      crate::client::origyn_nft_reference::icrc7_tx_window(pic, sender, canister_id, &())
    }
    */

// #[test]
// fn test_icrc7_approve() {
//   let mut env = init();
//   let TestEnv {
//     ref mut pic,
//     canister_ids: CanisterIds { origyn_nft, ogy_ledger, ldg_ledger },
//     principal_ids: PrincipalIds { net_principal, controller, originator, nft_owner },
//   } = env;

//   init_nft_with_premint_nft(
//     pic,
//     origyn_nft.clone(),
//     originator.clone(),
//     net_principal.clone(),
//     nft_owner.clone()
//   );

//   let args: origyn_nft_reference::origyn_nft_reference_canister::ApprovalArgs = crate::client::origyn_nft_reference::icrc7_approve::Args {
//     memo: None,
//     from_subaccount: None,
//     created_at_time: None,
//     expires_at: None,
//     spender: Account3 { owner: controller, subaccount: None },
//   };

//   let response: origyn_nft_reference::origyn_nft_reference_canister::ApprovalResult = crate::client::origyn_nft_reference::client::icrc7_approve(
//     pic,
//     origyn_nft.clone(),
//     net_principal.clone(),
//     args
//   );

//   for item in response {
//     match item.approval_result {
//       origyn_nft_reference::origyn_nft_reference_canister::ApprovalResultItemApprovalResult::Err(
//         _,
//       ) => (),
//       _ => panic!("should return error for now, not yet compatible"),
//     }
//   }
// }

#[test]
fn icrc7_transfer() {
  let mut env = init();
  let TestEnv {
    ref mut pic,
    canister_ids: CanisterIds { origyn_nft, ogy_ledger, ldg_ledger },
    principal_ids: PrincipalIds { net_principal, controller, originator, nft_owner },
  } = env;

  init_nft_with_premint_nft(
    pic,
    origyn_nft.clone(),
    originator.clone(),
    net_principal.clone(),
    nft_owner.clone()
  );

  let token_id_as_nat = crate::client::origyn_nft_reference::client::get_token_id_as_nat(
    pic,
    origyn_nft.clone(),
    net_principal.clone(),
    "1".to_string()
  );

  let transfer_fee: Option<Nat> = crate::client::origyn_nft_reference::client::icrc7_transfer_fee(
    pic,
    origyn_nft.clone(),
    net_principal.clone(),
    token_id_as_nat.clone()
  );

  match transfer_fee {
    Some(fee) => {
      let balance = icrc1_icrc2_token::client::balance_of(
        pic,
        ogy_ledger.clone(),
        nft_owner.clone()
      );

      let approve_res: icrc1_icrc2_token::icrc2_approve::Response = icrc1_icrc2_token::client::approve(
        pic,
        nft_owner.clone(),
        ogy_ledger.clone(),
        origyn_nft.clone(),
        None,
        fee.clone() + Nat::from(E8S_FEE_OGY)
      );

      match approve_res {
        icrc1_icrc2_token::icrc2_approve::Response::Ok(_) => (),
        icrc1_icrc2_token::icrc2_approve::Response::Err(err) => panic!("approve failed: {:?}", err),
      }

      let owner_of = crate::client::origyn_nft_reference::client::icrc7_owner_of(
        pic,
        origyn_nft.clone(),
        net_principal.clone(),
        vec![token_id_as_nat.clone()]
      );

      println!("owner_of: {:?}", owner_of);
      for item in owner_of {
        match item {
          Some(val) => {
            println!("val: {:?}", val.owner.to_string());
            // should match nft_owner
            assert!(val.owner.to_string() == nft_owner.to_string());
          }
          None => (),
        }
      }

      let args: origyn_nft_reference::origyn_nft_reference_canister::TransferArgs = origyn_nft_reference::origyn_nft_reference_canister::TransferArgs {
        memo: None,
        from_subaccount: None,
        created_at_time: None,
        to: Account3 { owner: controller, subaccount: None },
        token_id: token_id_as_nat.clone(),
      };

      let response: origyn_nft_reference::origyn_nft_reference_canister::TransferResult = crate::client::origyn_nft_reference::client::icrc7_transfer(
        pic,
        origyn_nft.clone(),
        nft_owner.clone(),
        vec![args]
      );

      for item in response {
        println!("item: {:?}", item);
      }

      let owner_of = crate::client::origyn_nft_reference::client::icrc7_owner_of(
        pic,
        origyn_nft.clone(),
        net_principal.clone(),
        vec![token_id_as_nat.clone()]
      );

      println!("owner_of: {:?}", owner_of);
      for item in owner_of {
        match item {
          Some(val) => {
            println!("val: {:?}", val.owner.to_string());
            // should match controller
            assert!(val.owner.to_string() == controller.to_string());
          }
          None => (),
        }
      }
    }
    None => panic!("transfer fee not found"),
  }
}
