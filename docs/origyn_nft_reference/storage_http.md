# origyn_nft_reference/storage_http

## Type `HTTPResponse`
``` motoko no-repl
type HTTPResponse = { body : Blob; headers : [http.HeaderField]; status_code : Nat16; streaming_strategy : ?StreamingStrategy }
```


## Type `StreamingStrategy`
``` motoko no-repl
type StreamingStrategy = {#Callback : { callback : shared () -> async (); token : StreamingCallbackToken }}
```


## Type `StreamingCallbackToken`
``` motoko no-repl
type StreamingCallbackToken = { content_encoding : Text; index : Nat; key : Text }
```


## Type `StreamingCallbackResponse`
``` motoko no-repl
type StreamingCallbackResponse = { body : Blob; token : ?StreamingCallbackToken }
```


## Type `HttpRequest`
``` motoko no-repl
type HttpRequest = { body : Blob; headers : [http.HeaderField]; method : Text; url : Text }
```


## Function `gen_access_key`
``` motoko no-repl
func gen_access_key() : async Text
```

* Generates an access key by generating a random string of characters.
    * @returns {Async<Text>} - Returns an AsyncIterable that yields a random string of characters as a Text object.

## Function `handle_stream_content`
``` motoko no-repl
func handle_stream_content(state : Types.StorageState, token_id : Text, library_id : Text, start : ?Nat, end : ?Nat, contentType : Text, data : CandyTypes.DataZone, req : httpparser.ParsedHttpRequest) : HTTPResponse
```

* Handles streaming content for an NFT
    *
    * @param {Types.State} state - The current state of the canister
    * @param {Text} token_id - The ID of the token being streamed
    * @param {Text} library_id - The ID of the library containing the token
    * @param {Nat | null} start - The starting byte position of the streaming content
    * @param {Nat | null} end - The ending byte position of the streaming content
    * @param {Text} contentType - The content type of the streaming content
    * @param {CandyTypes.Workspace} data - The workspace containing the streaming content
    * @param {httpparser.ParsedHttpRequest} req - The parsed HTTP request
    *
    * @returns {HTTPResponse} - The HTTP response containing the streaming content

## Function `handleLargeContent`
``` motoko no-repl
func handleLargeContent(state : Types.StorageState, key : Text, contentType : Text, data : CandyTypes.DataZone, req : httpparser.ParsedHttpRequest) : HTTPResponse
```

* Handles non-streaming large content
    * @param {Types.State} state - The current state
    * @param {string} key - The key of the content to handle
    * @param {string} contentType - The content type of the content
    * @param {CandyTypes.Workspace} data - The workspace containing the content
    * @param {httpparser.ParsedHttpRequest} req - The parsed HTTP request
    * @returns {HTTPResponse} - The response containing the content

## Function `_stream_media`
``` motoko no-repl
func _stream_media(token_id : Text, library_id : Text, index : Nat, data : CandyTypes.DataZone, rStart : Nat, rEnd : Nat, size : Nat) : { payload : Blob; callback : ?StreamingCallbackToken }
```

* Streams the media content for a specific NFT.
    *
    * @param {Text} token_id - The ID of the NFT.
    * @param {Text} library_id - The ID of the library containing the NFT.
    * @param {Nat} index - The starting index for the media content.
    * @param {CandyTypes.Workspace} data - The workspace data containing the media content.
    * @param {Nat} rStart - The starting range for the media content.
    * @param {Nat} rEnd - The ending range for the media content.
    * @param {Nat} size - The size of the media content.
    * @returns {{payload: Blob, callback: ?StreamingCallbackToken}} - An object containing the payload and callback token for the media content.

## Function `_stream_content`
``` motoko no-repl
func _stream_content(key : Text, index : Nat, data : CandyTypes.DataZone) : { payload : Blob; callback : ?StreamingCallbackToken }
```

* Streams content for a specified key.
    *
    * @param {Text} key - The key for the content to be streamed.
    * @param {Nat} index - The starting index for the content.
    * @param {CandyTypes.Workspace} data - The workspace data containing the content.
    * @param {Bool} use_stable - Whether or not to use the stable memory.
    * @param {Types.Stable_Memory} btreemap - The stable memory to use.
    * @returns {{payload: Blob, callback: ?StreamingCallbackToken}} - An object containing the payload and callback token for the content.

## Function `stream_media`
``` motoko no-repl
func stream_media(token_id : Text, library_id : Text, index : Nat, data : CandyTypes.DataZone, rStart : Nat, rEnd : Nat, size : Nat) : StreamingCallbackResponse
```


## Function `renderLibrary`
``` motoko no-repl
func renderLibrary(state : Types.StorageState, req : httpparser.ParsedHttpRequest, metadata : CandyTypes.CandyShared, token_id : Text, library_id : Text) : HTTPResponse
```

* Determines how a library item should be rendered in an HTTP request.
    * @param {Types.State} state - The state of the canister.
    * @param {httpparser.ParsedHttpRequest} req - The HTTP request.
    * @param {CandyTypes.CandyShared} metadata - The metadata for the NFT.
    * @param {string} token_id - The ID of the token.
    * @param {string} library_id - The ID of the library.
    * @returns

## Function `renderSmartRoute`
``` motoko no-repl
func renderSmartRoute(state : Types.StorageState, req : httpparser.ParsedHttpRequest, metadata : CandyTypes.CandyShared, token_id : Text, smartRoute : Text) : HTTPResponse
```


## Function `nftStreamingCallback`
``` motoko no-repl
func nftStreamingCallback(tk : StreamingCallbackToken, state : Types.StorageState) : StreamingCallbackResponse
```

* Callback function used for NFT streaming. Handles streaming NFT content
    * @param tk - StreamingCallbackToken, token containing streaming info
    * @param state - Types.State, state object containing library data and other metadata
    * @returns StreamingCallbackResponse object, containing payload and streaming token

## Function `http_request_streaming_callback`
``` motoko no-repl
func http_request_streaming_callback(tk : StreamingCallbackToken, state : Types.StorageState) : StreamingCallbackResponse
```

* Callback function for streaming large content over HTTP.
    * Determines how a library item should be rendered in an HTTP request.
    *
    * @param {StreamingCallbackToken} tk - Token representing the current streaming session.
    * @param {Types.State} state - State object containing the current allocation and other relevant data.
    * @returns {StreamingCallbackResponse} - A response object containing the payload and callback for the next chunk (if applicable).

## Function `http_owner_check`
``` motoko no-repl
func http_owner_check(stateBody : Types.StorageState, req : httpparser.ParsedHttpRequest) : Result.Result<(), Text>
```


## Function `http_nft_owner_check`
``` motoko no-repl
func http_nft_owner_check(stateBody : Types.StorageState, req : httpparser.ParsedHttpRequest, metadata : CandyTypes.CandyShared) : Result.Result<(), Text>
```


## Function `http_request`
``` motoko no-repl
func http_request(state : Types.StorageState, rawReq : HttpRequest, caller : Principal) : (HTTPResponse)
```

