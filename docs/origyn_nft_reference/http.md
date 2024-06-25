# origyn_nft_reference/http

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
func gen_access_key() : async* Text
```

* Generates an access key by generating a random string of characters.
    * @returns {Async<Text>} - Returns an AsyncIterable that yields a random string of characters as a Text object.

## Function `handle_stream_content`
``` motoko no-repl
func handle_stream_content(state : Types.State, token_id : Text, library_id : Text, start : ?Nat, end : ?Nat, contentType : Text, data : CandyTypes.Workspace, req : httpparser.ParsedHttpRequest) : HTTPResponse
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
func handleLargeContent(state : Types.State, key : Text, contentType : Text, data : CandyTypes.Workspace, req : httpparser.ParsedHttpRequest) : HTTPResponse
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
func _stream_media(token_id : Text, library_id : Text, index : Nat, data : CandyTypes.Workspace, rStart : Nat, rEnd : Nat, size : Nat) : { payload : Blob; callback : ?StreamingCallbackToken }
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
func _stream_content(key : Text, index : Nat, data : CandyTypes.Workspace, use_stable : Bool) : { payload : Blob; callback : ?StreamingCallbackToken }
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
func stream_media(token_id : Text, library_id : Text, index : Nat, data : CandyTypes.Workspace, rStart : Nat, rEnd : Nat, size : Nat) : StreamingCallbackResponse
```


## Function `handle_range_headers`
``` motoko no-repl
func handle_range_headers(headers : [http.HeaderField]) : { start : ?Nat; end : ?Nat; b_foundRange : Bool }
```

* Handles the range headers from an HTTP request and returns the start and end values, if present
    * @param headers - the headers from the HTTP request
    * @returns an object containing the start and end values and a boolean indicating whether a range header was found

## Function `renderLibrary`
``` motoko no-repl
func renderLibrary(state : Types.State, req : httpparser.ParsedHttpRequest, metadata : CandyTypes.CandyShared, token_id : Text, library_id : Text) : HTTPResponse
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
func renderSmartRoute(state : Types.State, req : httpparser.ParsedHttpRequest, metadata : CandyTypes.CandyShared, token_id : Text, smartRoute : Text) : HTTPResponse
```


## Function `nftStreamingCallback`
``` motoko no-repl
func nftStreamingCallback(tk : StreamingCallbackToken, state : Types.State) : StreamingCallbackResponse
```

* Callback function used for NFT streaming. Handles streaming NFT content
    * @param tk - StreamingCallbackToken, token containing streaming info
    * @param state - Types.State, state object containing library data and other metadata
    * @returns StreamingCallbackResponse object, containing payload and streaming token

## Function `http_request_streaming_callback`
``` motoko no-repl
func http_request_streaming_callback(tk : StreamingCallbackToken, state : Types.State) : StreamingCallbackResponse
```

* Callback function for streaming large content over HTTP.
    * Determines how a library item should be rendered in an HTTP request.
    *
    * @param {StreamingCallbackToken} tk - Token representing the current streaming session.
    * @param {Types.State} state - State object containing the current allocation and other relevant data.
    * @returns {StreamingCallbackResponse} - A response object containing the payload and callback for the next chunk (if applicable).

## Function `json`
``` motoko no-repl
func json(message : CandyTypes.CandyShared, _query : ?Text) : HTTPResponse
```


## Function `splitQuery`
``` motoko no-repl
func splitQuery(q : Text, p : Char) : Result.Result<List.List<sQuery>, Text>
```

* Splits a query string into a list of sQueries.
    * @param {Text} q - The query string to split.
    * @param {Char} p - The character used to separate sQueries.
    * @returns {Result.Result<List.List<sQuery>, Text>} - A Result containing a list of sQueries or an error message.

## Function `get_deep_properties`
``` motoko no-repl
func get_deep_properties(metadata : CandyTypes.CandyShared, qs : List.List<sQuery>) : {#ok : CandyTypes.CandyShared; #err; #back}
```


## Function `split_text`
``` motoko no-repl
func split_text(q : Text, p : Char) : [Text]
```


## Function `http_owner_check`
``` motoko no-repl
func http_owner_check(stateBody : Types.State, req : httpparser.ParsedHttpRequest) : Result.Result<(), Text>
```


## Function `http_nft_owner_check`
``` motoko no-repl
func http_nft_owner_check(stateBody : Types.State, req : httpparser.ParsedHttpRequest, metadata : CandyTypes.CandyShared) : Result.Result<(), Text>
```


## Function `http_request`
``` motoko no-repl
func http_request(state : Types.State, rawReq : HttpRequest, caller : Principal) : (HTTPResponse)
```

