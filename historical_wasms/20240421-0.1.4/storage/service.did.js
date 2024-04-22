export const idlFactory = ({ IDL }) => {
  const CandyShared = IDL.Rec();
  const StorageInitArgs = IDL.Record({
    'network' : IDL.Opt(IDL.Principal),
    'storage_space' : IDL.Opt(IDL.Nat),
    'gateway_canister' : IDL.Principal,
  });
  const canister_id = IDL.Principal;
  const definite_canister_settings = IDL.Record({
    'freezing_threshold' : IDL.Nat,
    'controllers' : IDL.Opt(IDL.Vec(IDL.Principal)),
    'memory_allocation' : IDL.Nat,
    'compute_allocation' : IDL.Nat,
  });
  const canister_status = IDL.Record({
    'status' : IDL.Variant({
      'stopped' : IDL.Null,
      'stopping' : IDL.Null,
      'running' : IDL.Null,
    }),
    'memory_size' : IDL.Nat,
    'cycles' : IDL.Nat,
    'settings' : definite_canister_settings,
    'module_hash' : IDL.Opt(IDL.Vec(IDL.Nat8)),
  });
  const ChunkRequest = IDL.Record({
    'token_id' : IDL.Text,
    'chunk' : IDL.Opt(IDL.Nat),
    'library_id' : IDL.Text,
  });
  const AllocationRecordStable = IDL.Record({
    'allocated_space' : IDL.Nat,
    'token_id' : IDL.Text,
    'available_space' : IDL.Nat,
    'canister' : IDL.Principal,
    'chunks' : IDL.Vec(IDL.Nat),
    'library_id' : IDL.Text,
  });
  const ChunkContent = IDL.Variant({
    'remote' : IDL.Record({
      'args' : ChunkRequest,
      'canister' : IDL.Principal,
    }),
    'chunk' : IDL.Record({
      'total_chunks' : IDL.Nat,
      'content' : IDL.Vec(IDL.Nat8),
      'storage_allocation' : AllocationRecordStable,
      'current_chunk' : IDL.Opt(IDL.Nat),
    }),
  });
  const Errors = IDL.Variant({
    'nyi' : IDL.Null,
    'storage_configuration_error' : IDL.Null,
    'escrow_withdraw_payment_failed' : IDL.Null,
    'token_not_found' : IDL.Null,
    'owner_not_found' : IDL.Null,
    'content_not_found' : IDL.Null,
    'auction_ended' : IDL.Null,
    'out_of_range' : IDL.Null,
    'sale_id_does_not_match' : IDL.Null,
    'sale_not_found' : IDL.Null,
    'kyc_fail' : IDL.Null,
    'item_not_owned' : IDL.Null,
    'property_not_found' : IDL.Null,
    'validate_trx_wrong_host' : IDL.Null,
    'withdraw_too_large' : IDL.Null,
    'content_not_deserializable' : IDL.Null,
    'bid_too_low' : IDL.Null,
    'validate_deposit_wrong_amount' : IDL.Null,
    'existing_sale_found' : IDL.Null,
    'asset_mismatch' : IDL.Null,
    'escrow_cannot_be_removed' : IDL.Null,
    'deposit_burned' : IDL.Null,
    'cannot_restage_minted_token' : IDL.Null,
    'cannot_find_status_in_metadata' : IDL.Null,
    'receipt_data_mismatch' : IDL.Null,
    'validate_deposit_failed' : IDL.Null,
    'unreachable' : IDL.Null,
    'unauthorized_access' : IDL.Null,
    'item_already_minted' : IDL.Null,
    'no_escrow_found' : IDL.Null,
    'escrow_owner_not_the_owner' : IDL.Null,
    'improper_interface' : IDL.Null,
    'app_id_not_found' : IDL.Null,
    'token_non_transferable' : IDL.Null,
    'kyc_error' : IDL.Null,
    'sale_not_over' : IDL.Null,
    'update_class_error' : IDL.Null,
    'malformed_metadata' : IDL.Null,
    'token_id_mismatch' : IDL.Null,
    'id_not_found_in_metadata' : IDL.Null,
    'auction_not_started' : IDL.Null,
    'library_not_found' : IDL.Null,
    'attempt_to_stage_system_data' : IDL.Null,
    'validate_deposit_wrong_buyer' : IDL.Null,
    'not_enough_storage' : IDL.Null,
    'sales_withdraw_payment_failed' : IDL.Null,
  });
  const OrigynError = IDL.Record({
    'text' : IDL.Text,
    'error' : Errors,
    'number' : IDL.Nat32,
    'flag_point' : IDL.Text,
  });
  const ChunkResult = IDL.Variant({ 'ok' : ChunkContent, 'err' : OrigynError });
  const Principal = IDL.Principal;
  const HeaderField = IDL.Tuple(IDL.Text, IDL.Text);
  const HttpRequest = IDL.Record({
    'url' : IDL.Text,
    'method' : IDL.Text,
    'body' : IDL.Vec(IDL.Nat8),
    'headers' : IDL.Vec(HeaderField),
  });
  const StreamingCallbackToken = IDL.Record({
    'key' : IDL.Text,
    'index' : IDL.Nat,
    'content_encoding' : IDL.Text,
  });
  const StreamingStrategy = IDL.Variant({
    'Callback' : IDL.Record({
      'token' : StreamingCallbackToken,
      'callback' : IDL.Func([], [], []),
    }),
  });
  const HTTPResponse = IDL.Record({
    'body' : IDL.Vec(IDL.Nat8),
    'headers' : IDL.Vec(HeaderField),
    'streaming_strategy' : IDL.Opt(StreamingStrategy),
    'status_code' : IDL.Nat16,
  });
  const StreamingCallbackResponse = IDL.Record({
    'token' : IDL.Opt(StreamingCallbackToken),
    'body' : IDL.Vec(IDL.Nat8),
  });
  const PropertyShared = IDL.Record({
    'value' : CandyShared,
    'name' : IDL.Text,
    'immutable' : IDL.Bool,
  });
  CandyShared.fill(
    IDL.Variant({
      'Int' : IDL.Int,
      'Map' : IDL.Vec(IDL.Tuple(CandyShared, CandyShared)),
      'Nat' : IDL.Nat,
      'Set' : IDL.Vec(CandyShared),
      'Nat16' : IDL.Nat16,
      'Nat32' : IDL.Nat32,
      'Nat64' : IDL.Nat64,
      'Blob' : IDL.Vec(IDL.Nat8),
      'Bool' : IDL.Bool,
      'Int8' : IDL.Int8,
      'Ints' : IDL.Vec(IDL.Int),
      'Nat8' : IDL.Nat8,
      'Nats' : IDL.Vec(IDL.Nat),
      'Text' : IDL.Text,
      'Bytes' : IDL.Vec(IDL.Nat8),
      'Int16' : IDL.Int16,
      'Int32' : IDL.Int32,
      'Int64' : IDL.Int64,
      'Option' : IDL.Opt(CandyShared),
      'Floats' : IDL.Vec(IDL.Float64),
      'Float' : IDL.Float64,
      'Principal' : IDL.Principal,
      'Array' : IDL.Vec(CandyShared),
      'Class' : IDL.Vec(PropertyShared),
    })
  );
  const OrigynBoolResult = IDL.Variant({
    'ok' : IDL.Bool,
    'err' : OrigynError,
  });
  const AddressedChunk = IDL.Tuple(IDL.Nat, IDL.Nat, CandyShared);
  const AddressedChunkArray = IDL.Vec(AddressedChunk);
  const StageChunkArg = IDL.Record({
    'content' : IDL.Vec(IDL.Nat8),
    'token_id' : IDL.Text,
    'chunk' : IDL.Nat,
    'filedata' : CandyShared,
    'library_id' : IDL.Text,
  });
  const StageLibraryResponse = IDL.Record({ 'canister' : IDL.Principal });
  const Result = IDL.Variant({
    'ok' : StageLibraryResponse,
    'err' : OrigynError,
  });
  const StorageMetrics = IDL.Record({
    'gateway' : IDL.Principal,
    'available_space' : IDL.Nat,
    'allocations' : IDL.Vec(AllocationRecordStable),
    'allocated_storage' : IDL.Nat,
  });
  const StorageMetricsResult = IDL.Variant({
    'ok' : StorageMetrics,
    'err' : OrigynError,
  });
  const Storage_Canister = IDL.Service({
    '__advance_time' : IDL.Func([IDL.Int], [IDL.Int], []),
    '__set_time_mode' : IDL.Func(
        [IDL.Variant({ 'test' : IDL.Null, 'standard' : IDL.Null })],
        [IDL.Bool],
        [],
      ),
    '__version' : IDL.Func([], [IDL.Text], ['query']),
    'canister_status' : IDL.Func(
        [IDL.Record({ 'canister_id' : canister_id })],
        [canister_status],
        [],
      ),
    'chunk_nft_origyn' : IDL.Func([ChunkRequest], [ChunkResult], ['query']),
    'chunk_secure_nft_origyn' : IDL.Func([ChunkRequest], [ChunkResult], []),
    'cycles' : IDL.Func([], [IDL.Nat], ['query']),
    'get_collection_managers_nft_origyn' : IDL.Func(
        [],
        [IDL.Vec(Principal)],
        ['query'],
      ),
    'get_collection_network_nft_origyn' : IDL.Func(
        [],
        [IDL.Opt(Principal)],
        ['query'],
      ),
    'get_collection_owner_nft_origyn' : IDL.Func([], [Principal], ['query']),
    'http_request' : IDL.Func([HttpRequest], [HTTPResponse], ['query']),
    'http_request_streaming_callback' : IDL.Func(
        [StreamingCallbackToken],
        [StreamingCallbackResponse],
        ['query'],
      ),
    'nftStreamingCallback' : IDL.Func(
        [StreamingCallbackToken],
        [StreamingCallbackResponse],
        ['query'],
      ),
    'refresh_metadata_nft_origyn' : IDL.Func(
        [IDL.Text, CandyShared],
        [OrigynBoolResult],
        [],
      ),
    'show_nft_library_array' : IDL.Func(
        [],
        [
          IDL.Vec(
            IDL.Tuple(
              IDL.Text,
              IDL.Vec(IDL.Tuple(IDL.Text, AddressedChunkArray)),
            )
          ),
        ],
        ['query'],
      ),
    'stage_library_nft_origyn' : IDL.Func(
        [StageChunkArg, AllocationRecordStable, CandyShared],
        [Result],
        [],
      ),
    'storage_info_nft_origyn' : IDL.Func([], [StorageMetricsResult], ['query']),
    'storage_info_secure_nft_origyn' : IDL.Func([], [StorageMetricsResult], []),
    'whoami' : IDL.Func([], [IDL.Principal], ['query']),
  });
  return Storage_Canister;
};
export const init = ({ IDL }) => {
  const StorageInitArgs = IDL.Record({
    'network' : IDL.Opt(IDL.Principal),
    'storage_space' : IDL.Opt(IDL.Nat),
    'gateway_canister' : IDL.Principal,
  });
  return [StorageInitArgs];
};
