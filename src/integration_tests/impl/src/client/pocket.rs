use std::time::Duration;

use candid::{ CandidType, Principal };
use pocket_ic::{ PocketIc, UserError, WasmResult };
use serde::de::DeserializeOwned;
use types::CanisterId;

use crate::utils::T;

const INIT_CYCLES_BALANCE: u128 = 1_000 * T;

pub fn create_canister(pic: &mut PocketIc, controller: Principal) -> CanisterId {
    let canister_id = pic.create_canister_with_settings(Some(controller), None);
    pic.add_cycles(canister_id, INIT_CYCLES_BALANCE);
    pic.advance_time(Duration::from_secs(1));
    canister_id
}

pub fn create_canister_with_id(
    pic: &mut PocketIc,
    controller: Principal,
    canister_id: &str
) -> CanisterId {
    let canister_id = canister_id.try_into().expect("Invalid canister ID");
    pic.create_canister_with_id(Some(controller), None, canister_id).expect(
        "Create canister with ID failed"
    );
    pic.add_cycles(canister_id, INIT_CYCLES_BALANCE);
    pic.advance_time(Duration::from_secs(1));
    canister_id
}

pub fn start_canister(pic: &mut PocketIc, sender: Principal, canister_id: CanisterId) {
    pic.start_canister(canister_id, Some(sender)).unwrap();
}

pub fn stop_canister(pic: &mut PocketIc, sender: Principal, canister_id: CanisterId) {
    pic.stop_canister(canister_id, Some(sender)).unwrap();
}

pub fn install_canister<P: CandidType>(
    pic: &mut PocketIc,
    sender: Principal,
    canister_id: CanisterId,
    wasm: Vec<u8>,
    payload: P
) {
    pic.install_canister(canister_id, wasm, candid::encode_one(&payload).unwrap(), Some(sender));
    pic.advance_time(Duration::from_secs(1));
}

pub fn execute_query<P: CandidType, R: CandidType + DeserializeOwned>(
    pic: &PocketIc,
    sender: Principal,
    canister_id: CanisterId,
    method_name: &str,
    payload: &P
) -> R {
    pic.advance_time(Duration::from_secs(1));
    unwrap_response(
        pic.query_call(canister_id, sender, method_name, candid::encode_one(payload).unwrap())
    )
}

pub fn execute_update<P: CandidType, R: CandidType + DeserializeOwned>(
    pic: &mut PocketIc,
    sender: Principal,
    canister_id: CanisterId,
    method_name: &str,
    payload: &P
) -> R {
    pic.advance_time(Duration::from_secs(1));
    unwrap_response(
        pic.update_call(canister_id, sender, method_name, candid::encode_one(payload).unwrap())
    )
}

pub fn execute_update_no_response<P: CandidType>(
    pic: &mut PocketIc,
    sender: Principal,
    canister_id: CanisterId,
    method_name: &str,
    payload: &P
) {
    pic.advance_time(Duration::from_secs(1));
    pic.update_call(
        canister_id,
        sender,
        method_name,
        candid::encode_one(payload).unwrap()
    ).unwrap();
}

fn unwrap_response<R: CandidType + DeserializeOwned>(response: Result<WasmResult, UserError>) -> R {
    match response.unwrap() {
        WasmResult::Reply(bytes) => candid::decode_one(&bytes).unwrap(),
        WasmResult::Reject(error) => panic!("FATAL ERROR: {error}"),
    }
}
