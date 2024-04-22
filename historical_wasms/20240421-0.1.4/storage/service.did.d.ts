import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export type AddressedChunk = [bigint, bigint, CandyShared];
export type AddressedChunkArray = Array<AddressedChunk>;
export interface AllocationRecordStable {
  'allocated_space' : bigint,
  'token_id' : string,
  'available_space' : bigint,
  'canister' : Principal,
  'chunks' : Array<bigint>,
  'library_id' : string,
}
export type CandyShared = { 'Int' : bigint } |
  { 'Map' : Array<[CandyShared, CandyShared]> } |
  { 'Nat' : bigint } |
  { 'Set' : Array<CandyShared> } |
  { 'Nat16' : number } |
  { 'Nat32' : number } |
  { 'Nat64' : bigint } |
  { 'Blob' : Uint8Array | number[] } |
  { 'Bool' : boolean } |
  { 'Int8' : number } |
  { 'Ints' : Array<bigint> } |
  { 'Nat8' : number } |
  { 'Nats' : Array<bigint> } |
  { 'Text' : string } |
  { 'Bytes' : Uint8Array | number[] } |
  { 'Int16' : number } |
  { 'Int32' : number } |
  { 'Int64' : bigint } |
  { 'Option' : [] | [CandyShared] } |
  { 'Floats' : Array<number> } |
  { 'Float' : number } |
  { 'Principal' : Principal } |
  { 'Array' : Array<CandyShared> } |
  { 'Class' : Array<PropertyShared> };
export type ChunkContent = {
    'remote' : { 'args' : ChunkRequest, 'canister' : Principal }
  } |
  {
    'chunk' : {
      'total_chunks' : bigint,
      'content' : Uint8Array | number[],
      'storage_allocation' : AllocationRecordStable,
      'current_chunk' : [] | [bigint],
    }
  };
export interface ChunkRequest {
  'token_id' : string,
  'chunk' : [] | [bigint],
  'library_id' : string,
}
export type ChunkResult = { 'ok' : ChunkContent } |
  { 'err' : OrigynError };
export type Errors = { 'nyi' : null } |
  { 'storage_configuration_error' : null } |
  { 'escrow_withdraw_payment_failed' : null } |
  { 'token_not_found' : null } |
  { 'owner_not_found' : null } |
  { 'content_not_found' : null } |
  { 'auction_ended' : null } |
  { 'out_of_range' : null } |
  { 'sale_id_does_not_match' : null } |
  { 'sale_not_found' : null } |
  { 'kyc_fail' : null } |
  { 'item_not_owned' : null } |
  { 'property_not_found' : null } |
  { 'validate_trx_wrong_host' : null } |
  { 'withdraw_too_large' : null } |
  { 'content_not_deserializable' : null } |
  { 'bid_too_low' : null } |
  { 'validate_deposit_wrong_amount' : null } |
  { 'existing_sale_found' : null } |
  { 'asset_mismatch' : null } |
  { 'escrow_cannot_be_removed' : null } |
  { 'deposit_burned' : null } |
  { 'cannot_restage_minted_token' : null } |
  { 'cannot_find_status_in_metadata' : null } |
  { 'receipt_data_mismatch' : null } |
  { 'validate_deposit_failed' : null } |
  { 'unreachable' : null } |
  { 'unauthorized_access' : null } |
  { 'item_already_minted' : null } |
  { 'no_escrow_found' : null } |
  { 'escrow_owner_not_the_owner' : null } |
  { 'improper_interface' : null } |
  { 'app_id_not_found' : null } |
  { 'token_non_transferable' : null } |
  { 'kyc_error' : null } |
  { 'sale_not_over' : null } |
  { 'update_class_error' : null } |
  { 'malformed_metadata' : null } |
  { 'token_id_mismatch' : null } |
  { 'id_not_found_in_metadata' : null } |
  { 'auction_not_started' : null } |
  { 'library_not_found' : null } |
  { 'attempt_to_stage_system_data' : null } |
  { 'validate_deposit_wrong_buyer' : null } |
  { 'not_enough_storage' : null } |
  { 'sales_withdraw_payment_failed' : null };
export interface HTTPResponse {
  'body' : Uint8Array | number[],
  'headers' : Array<HeaderField>,
  'streaming_strategy' : [] | [StreamingStrategy],
  'status_code' : number,
}
export type HeaderField = [string, string];
export interface HttpRequest {
  'url' : string,
  'method' : string,
  'body' : Uint8Array | number[],
  'headers' : Array<HeaderField>,
}
export type OrigynBoolResult = { 'ok' : boolean } |
  { 'err' : OrigynError };
export interface OrigynError {
  'text' : string,
  'error' : Errors,
  'number' : number,
  'flag_point' : string,
}
export type Principal = Principal;
export interface PropertyShared {
  'value' : CandyShared,
  'name' : string,
  'immutable' : boolean,
}
export type Result = { 'ok' : StageLibraryResponse } |
  { 'err' : OrigynError };
export interface StageChunkArg {
  'content' : Uint8Array | number[],
  'token_id' : string,
  'chunk' : bigint,
  'filedata' : CandyShared,
  'library_id' : string,
}
export interface StageLibraryResponse { 'canister' : Principal }
export interface StorageInitArgs {
  'network' : [] | [Principal],
  'storage_space' : [] | [bigint],
  'gateway_canister' : Principal,
}
export interface StorageMetrics {
  'gateway' : Principal,
  'available_space' : bigint,
  'allocations' : Array<AllocationRecordStable>,
  'allocated_storage' : bigint,
}
export type StorageMetricsResult = { 'ok' : StorageMetrics } |
  { 'err' : OrigynError };
export interface Storage_Canister {
  '__advance_time' : ActorMethod<[bigint], bigint>,
  '__set_time_mode' : ActorMethod<
    [{ 'test' : null } | { 'standard' : null }],
    boolean
  >,
  '__version' : ActorMethod<[], string>,
  'canister_status' : ActorMethod<
    [{ 'canister_id' : canister_id }],
    canister_status
  >,
  'chunk_nft_origyn' : ActorMethod<[ChunkRequest], ChunkResult>,
  'chunk_secure_nft_origyn' : ActorMethod<[ChunkRequest], ChunkResult>,
  'cycles' : ActorMethod<[], bigint>,
  'get_collection_managers_nft_origyn' : ActorMethod<[], Array<Principal>>,
  'get_collection_network_nft_origyn' : ActorMethod<[], [] | [Principal]>,
  'get_collection_owner_nft_origyn' : ActorMethod<[], Principal>,
  'http_request' : ActorMethod<[HttpRequest], HTTPResponse>,
  'http_request_streaming_callback' : ActorMethod<
    [StreamingCallbackToken],
    StreamingCallbackResponse
  >,
  'nftStreamingCallback' : ActorMethod<
    [StreamingCallbackToken],
    StreamingCallbackResponse
  >,
  'refresh_metadata_nft_origyn' : ActorMethod<
    [string, CandyShared],
    OrigynBoolResult
  >,
  'show_nft_library_array' : ActorMethod<
    [],
    Array<[string, Array<[string, AddressedChunkArray]>]>
  >,
  'stage_library_nft_origyn' : ActorMethod<
    [StageChunkArg, AllocationRecordStable, CandyShared],
    Result
  >,
  'storage_info_nft_origyn' : ActorMethod<[], StorageMetricsResult>,
  'storage_info_secure_nft_origyn' : ActorMethod<[], StorageMetricsResult>,
  'whoami' : ActorMethod<[], Principal>,
}
export interface StreamingCallbackResponse {
  'token' : [] | [StreamingCallbackToken],
  'body' : Uint8Array | number[],
}
export interface StreamingCallbackToken {
  'key' : string,
  'index' : bigint,
  'content_encoding' : string,
}
export type StreamingStrategy = {
    'Callback' : {
      'token' : StreamingCallbackToken,
      'callback' : [Principal, string],
    }
  };
export type canister_id = Principal;
export interface canister_status {
  'status' : { 'stopped' : null } |
    { 'stopping' : null } |
    { 'running' : null },
  'memory_size' : bigint,
  'cycles' : bigint,
  'settings' : definite_canister_settings,
  'module_hash' : [] | [Uint8Array | number[]],
}
export interface definite_canister_settings {
  'freezing_threshold' : bigint,
  'controllers' : [] | [Array<Principal>],
  'memory_allocation' : bigint,
  'compute_allocation' : bigint,
}
export interface _SERVICE extends Storage_Canister {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
