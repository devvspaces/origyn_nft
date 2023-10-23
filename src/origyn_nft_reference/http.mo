import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Char "mo:base/Char";
import D "mo:base/Debug";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Int16 "mo:base/Int16";
import Int32 "mo:base/Int32";
import Int64 "mo:base/Int64";
import Int8 "mo:base/Int8";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Nat8 "mo:base/Nat8";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Random "mo:base/Random";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import TrieMap "mo:base/TrieMap";

import CandyHex "mo:candy/hex";
import Map "mo:map/Map";
import StableBTreeTypes "mo:stableBTree/types";
import http "mo:http/Http";
import httpparser "mo:httpparser/lib";

import Metadata "metadata";
import NFTUtils "utils";
import Types "types";
import MigrationTypes "./migrations/types";

module {

    

    let debug_channel = {
        streaming = false;
        large_content = false;
        library = false;
        request = false;
        stablebtree = false;
    };

    let SB = MigrationTypes.Current.SB;
    let CandyTypes = MigrationTypes.Current.CandyTypes;
    let Conversion = MigrationTypes.Current.Conversions;
    let Properties = MigrationTypes.Current.Properties;
    let JSON = MigrationTypes.Current.JSON;

    let { ihash; nhash; thash; phash; calcHash } = Map;

    //the max size of a streaming chunk
    private let __MAX_STREAM_CHUNK = 2048000;

    public type HTTPResponse = {
        body               : Blob;
        headers            : [http.HeaderField];
        status_code        : Nat16;
        streaming_strategy : ?StreamingStrategy;
    };

    public type StreamingStrategy = {
        #Callback: {
            callback : shared () -> async ();
            token    : StreamingCallbackToken;
        };
    };

    public type StreamingCallbackToken =  {
        content_encoding : Text;
        index            : Nat;
        key              : Text;
    };

    public type StreamingCallbackResponse = {
        body  : Blob;
        token : ?StreamingCallbackToken;
    };

    

    public type HttpRequest = {
        body: Blob;
        headers: [http.HeaderField];
        method: Text;
        url: Text;
    };

    // generates a random access key for use with procuring owner's assets
    /**
    * Generates an access key by generating a random string of characters.
    * @returns {Async<Text>} - Returns an AsyncIterable that yields a random string of characters as a Text object.
    */
    public func gen_access_key(): async* Text {
        let entropy = await Random.blob(); // get initial entropy
        var rand = Text.replace(debug_show(entropy), #text("\\"), "");
        Text.replace(rand, #text("\""), "");
    };

    //handels stream content with chunk requests
    /**
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
    */
    public func handle_stream_content(
        state : Types.State,
        token_id         : Text,
        library_id      : Text,
        start       : ?Nat,
        end         : ?Nat,
        contentType : Text,
        data        : CandyTypes.Workspace,
        req         : httpparser.ParsedHttpRequest
    ) : HTTPResponse {


        let canister_id: Text = Principal.toText(state.canister());
        let canister = actor (canister_id) : actor { nftStreamingCallback : shared () -> async () };


                        debug if(debug_channel.streaming) D.print("Handling an range streaming NFT" # debug_show(token_id));
        var size : Nat = 0;
        //find the right data zone
        let ?zone = SB.getOpt(data, 1) else {
          debug if(debug_channel.streaming) D.print("Couldn't find the data zone" # debug_show((token_id, library_id, start, end, contentType)));
          return {
                status_code        = 500;
                headers            = [];
                body               = Text.encodeUtf8("Couldn't find the data zone" # debug_show((token_id, library_id, start, end, contentType)));
                streaming_strategy = null;
            };
        };
        
        var zoneTracker = 0;
        for(this_item in SB.vals(zone)){
            switch(this_item){
                case(#Bytes(bytes)){
                  size := size + SB.size(bytes);
                };
                case(#Blob(bytes)){                    
                    size := size + bytes.size();                        
                };
                case(#Nat32(key)){
                    // D.print("#use_stablebtree handle_stream_content #Nat32 option");
                    let sizeZone = switch(SB.getOpt(data,2)){
                      case(null){0;};
                      case(?val){
                        switch(SB.getOpt(val, zoneTracker)){
                          case (null) 0;
                          case(?val) {
                            switch(val){
                              case(#Nat(val)) val;
                              case(_) 0;
                            };
                          }
                        }
                      };
                    };
                    size := size + sizeZone;
                };
                case(_){};
            };
          zoneTracker += 1;
        };

        var rEnd = switch(end){
            case(null){size-1 : Nat;};
            case(?v){v};
        };

        let rStart = switch(start){
            case(null){0;};
            case(?v){v};
        };

                        debug if(debug_channel.streaming)D.print( Nat.toText(rStart) # " - " # Nat.toText(rEnd) # " / " #Nat.toText(size));

        if(rEnd - rStart : Nat > __MAX_STREAM_CHUNK){
            rEnd := rStart + __MAX_STREAM_CHUNK - 1;
        };

        if(rEnd - rStart : Nat > __MAX_STREAM_CHUNK){
                                debug if(debug_channel.streaming) D.print("handling big branch");
            
            let cbt = _stream_media(token_id, library_id, rStart, data, rStart, rEnd, size);

                                debug if(debug_channel.streaming)D.print("The cbt: " # debug_show(cbt.callback));
            {
                //need to use streaming strategy
                status_code        = 206;
                headers            = [
                    ("Content-Type", contentType),
                    ("Accept-Ranges", "bytes"),
                    //("Content-Range", "bytes 0-1/" # Nat.toText(size)),
                    ("Content-Range", "bytes " # Nat.toText(rStart) # "-" # Nat.toText(rEnd) # "/" # Nat.toText(size)),
                    //("Content-Range", "bytes 0-"#  Nat.toText(size-1) # "/" # Nat.toText(size)),
                    ("Content-Length",  Nat.toText(cbt.payload.size())),
                    ("Cache-Control","private"),
                    ];
                body               = cbt.payload;
                streaming_strategy = switch (cbt.callback) {
                    case (null) { null; };
                    case (? tk) {
                        ?#Callback({
                            token    = tk;
                            callback = canister.nftStreamingCallback;
                        });
                    };
                };
            };
        } else  {
            //just one chunk
                                debug if(debug_channel.streaming) D.print("returning short array");

            let cbt = _stream_media(token_id, library_id, rStart, data, rStart, rEnd, size);

                               debug if(debug_channel.streaming) D.print("the size " # Nat.toText(cbt.payload.size()));
            return {
                status_code        = 206;
                headers            = [
                    ("Content-Type", contentType),
                    ("Accept-Ranges", "bytes"),
                    ("Content-Range", "bytes " # Nat.toText(rStart) # "-" # Nat.toText(rEnd) # "/" # Nat.toText(size)),
                    //("Content-Range", "bytes 0-"#  Nat.toText(size-1) # "/" # Nat.toText(size)),
                    ("Content-Length",  Nat.toText(cbt.payload.size())),
                    ("Cache-Control","private")
                ];
                body               = cbt.payload;
                streaming_strategy = null;
            };
        };


    };

    //handles non-streaming large content
    /**
    * Handles non-streaming large content
    * @param {Types.State} state - The current state
    * @param {string} key - The key of the content to handle
    * @param {string} contentType - The content type of the content
    * @param {CandyTypes.Workspace} data - The workspace containing the content
    * @param {httpparser.ParsedHttpRequest} req - The parsed HTTP request
    * @returns {HTTPResponse} - The response containing the content
    */
    public func handleLargeContent(
        state : Types.State,
        key         : Text,
        contentType : Text,
        data        : CandyTypes.Workspace,
        req         : httpparser.ParsedHttpRequest
    ) : HTTPResponse {
        let result = _stream_content(key, 0, data, state.state.use_stableBTree, 
        //state.btreemap
        );

                            debug if(debug_channel.large_content)D.print("handling large content " # debug_show(result.callback));
                           
        let canister_id: Text = Principal.toText(state.canister());
        let canister = actor (canister_id) : actor { nftStreamingCallback : shared () -> async () };

        var b_foundRange : Bool = false;
        var start_range : Nat = 0;
        var end_range : Nat = 0;

        //nyi: should the data zone cache this?
        {
            status_code        = 200;
            headers            = [
                ("Content-Type", contentType),
                ("accept-ranges", "bytes"),
                ("Cache-Control","private"),
            ];
            body               = result.payload;
            streaming_strategy = switch (result.callback) {
                case (null) { null; };
                case (? tk) {
                    ?#Callback({
                        token    = tk;
                        callback = canister.nftStreamingCallback;
                    });
                };
            };
        };

    };

    /**
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
    */
    public func _stream_media(
        token_id : Text,
        library_id :Text,
        index : Nat,
        data  : CandyTypes.Workspace,
        rStart : Nat,
        rEnd : Nat,
        size : Nat,

    ) : {
        payload: Blob;                        // Payload based on the index.
        callback: ?StreamingCallbackToken // Callback for next chunk (if applicable).
    } {

                            debug if(debug_channel.streaming) D.print("in _stream_media");
                            debug if(debug_channel.streaming)D.print("token_id " # debug_show(token_id));
                            debug if(debug_channel.streaming)D.print("library_id " # debug_show(library_id));
                            debug if(debug_channel.streaming)D.print("index " # debug_show(index));
                            debug if(debug_channel.streaming)D.print(debug_show(rEnd) # " " # debug_show(rStart) # " ");
       
        var tracker : Nat = 0;
        let buf_size = if(Nat.sub(rEnd,index) >= __MAX_STREAM_CHUNK){
            __MAX_STREAM_CHUNK;
        } else {
            rEnd - index + 1 : Nat;
        };

        
                            debug if(debug_channel.streaming)D.print("buffer of size " # debug_show(buf_size));
        let payload : Buffer.Buffer<Nat8> =  Buffer.Buffer<Nat8>(buf_size);
        var blob_payload = Blob.fromArray([]);

        let zone = switch(SB.getOpt(data,1)){
          case(null){
            debug if(debug_channel.streaming)D.print("zone didn't exist that should have existed " # debug_show(buf_size));
            return {
                payload = "" : Blob;                        // Payload based on the index.
                callback = null // Callback for next chunk (if applicable).
            }
          };
          case(?val) val;
        };
        
        label getData for(this_item in SB.vals(zone)){

                            debug if(debug_channel.streaming) D.print("zone processing" # debug_show(tracker) # "nft-m/" # token_id # "|" # library_id # "|" # Nat.toText(rStart) # "|" # Nat.toText(rEnd) # "|" # Nat.toText(size));
            let chunk = Conversion.candyToBlob(this_item);
            
            let chunkSize = chunk.size();
            if(chunkSize + tracker < index){
                                debug if(debug_channel.streaming) D.print("skipping chunk");
                tracker += chunkSize;
                continue getData;
            };

                                debug if(debug_channel.streaming) D.print("current " # debug_show((rStart, rEnd, tracker, chunk.size())));

            if( 
                (tracker == rStart) and (tracker + chunk.size()  == rEnd + 1)
            ){
                                    debug if(debug_channel.streaming)D.print("matched rstart and rend on whole chunk");
                blob_payload := chunk;
                break getData;
            };

                                debug if(debug_channel.streaming)D.print("got past the chunk check" # "nft-m/" # token_id # "|" # library_id # "|" # Nat.toText(rStart) # "|" # Nat.toText(rEnd) # "|" # Nat.toText(size));
                                debug if(debug_channel.streaming) D.print(debug_show(chunk.size()));
            for(this_byte in chunk.vals()){
                                    debug if(tracker % 1000000 == 0){
                                        debug if(debug_channel.streaming) D.print(debug_show(tracker % 10000000) # " " # debug_show(tracker) # "  " # debug_show(index) # "  " # "nft-m/" # token_id # "|" # library_id # "|" # Nat.toText(rStart) # "|" # Nat.toText(rEnd) # "|" # Nat.toText(size));
                                    };
                if(tracker >= index){
                    payload.add(this_byte);
                };
                tracker += 1;
                if(tracker > rEnd or tracker > Nat.sub(index + __MAX_STREAM_CHUNK, 1)){
                    //D.print("broke tracker at " # debug_show(tracker) # " nft-m/" # token_id # "|" # library_id # "|" # Nat.toText(rStart) # "|" # Nat.toText(rEnd) # "|" # Nat.toText(size));
                    break getData;
                }
            };
        };
        //D.print("should have the buffer" # debug_show(payload.size()));
        //D.print("tracker: " # Nat.toText(tracker));

        if(blob_payload.size() == 0){
            blob_payload := Blob.fromArray(Buffer.toArray(payload));
        };

        let token = if(tracker >= size or tracker >= rEnd){
                                debug if(debug_channel.streaming) D.print("found the end, returning null" # "nft-m/" # token_id # "|" # library_id # "|" # Nat.toText(rStart) # "|" # Nat.toText(rEnd) # "|" # Nat.toText(size));
            null;
        } else {
                                debug if(debug_channel.streaming) D.print("_streaming returning the key " # "nft-m/" # token_id # "|" # library_id # "|" # Nat.toText(rStart) # "|" # Nat.toText(rEnd) # "|" # Nat.toText(size));
            ?{
                content_encoding = "gzip";
                index            = tracker;
                key              = "nft-m/" # token_id # "|" # library_id # "|" # Nat.toText(rStart) # "|" # Nat.toText(rEnd) # "|" # Nat.toText(size);
                //key              = "nft-m/" # token_id # "|" # library_id # "|" # Nat.toText(tracker) # "|" # Nat.toText(rEnd) # "|" # Nat.toText(size);
            }
        };

        {payload = blob_payload; callback =token};
    };

    
    /**
    * Streams content for a specified key.
    *
    * @param {Text} key - The key for the content to be streamed.
    * @param {Nat} index - The starting index for the content.
    * @param {CandyTypes.Workspace} data - The workspace data containing the content.
    * @param {Bool} use_stable - Whether or not to use the stable memory.
    * @param {Types.Stable_Memory} btreemap - The stable memory to use.
    * @returns {{payload: Blob, callback: ?StreamingCallbackToken}} - An object containing the payload and callback token for the content.
    */
    public func _stream_content(
        key   : Text,
        index : Nat,
        data  : CandyTypes.Workspace,
        use_stable : Bool,
        //btreemap : Types.Stable_Memory,
    ) : {
        payload: Blob;                        // Payload based on the index.
        callback: ?StreamingCallbackToken // Callback for next chunk (if applicable).
    } {
        //D.print("-in _stream content" # debug_show(key, index, use_stable));
        let zone = switch(SB.getOpt(data,1)){
          case(null){
            return {
              payload = "" : Blob;
              callback = null;
            }
          };
          case(?val) val;
        };

        debug if(debug_channel.streaming) D.print("have zone" # debug_show(SB.size(zone), index));

        let payload = SB.get(zone, index);
                            debug if(debug_channel.streaming) D.print("in private call back");
                            debug if(debug_channel.streaming)D.print(debug_show(SB.size(data)));
                            debug if(debug_channel.stablebtree) D.print("#stablebtree - _stream_content");
        
        // Stablebtree logic ////////////////////////////////
        var pay : Blob = "";
        var k : Nat32 = 0;

        

        if(use_stable){/*
            switch(payload){                
                case(#Nat32(val)){
                    k := val;
                };
                case (_) { k := 0 };
            };
            let size = switch(data.get(2).get(index)){
              case(#Nat(val)) val;
              case(_) {
                D.print("Could not find size for item!");
                0;
              };
            };

            let result = NFTUtils.getMemoryBySize(size, btreemap).get(k);
            switch(result){
                case null { D.print("Could not find data for stabletree - _stream_content") };
                case (?val) { 
                    pay := Blob.fromArray(val);
                };
            };
            */
        } else {
            pay := Conversion.candyToBlob(payload);
        };
        /////////////////////////////////////////////////////


        if (index + 1 == SB.size(zone)) return {payload = pay; callback = null};
                            debug if(debug_channel.streaming)D.print("returning a new key" # key);
                            debug if(debug_channel.streaming)D.print(debug_show(key));
        {payload = pay;
        callback =  ?{
            content_encoding = "gzip";
            index            = index + 1;
            key              = key;
        }};
    };

    //passthrough function..cnadiate for refactoring
    public func stream_media(
        token_id   : Text,
        library_id : Text,
        index : Nat,
        data  : CandyTypes.Workspace,
        rStart : Nat,
        rEnd : Nat,
        size : Nat
    ) : StreamingCallbackResponse {
        let result = _stream_media(
            token_id,
            library_id,
            index,
            data,
            rStart,
            rEnd,
            size
        );

                        debug if(debug_channel.streaming)D.print("the media content");
                        debug if(debug_channel.streaming)D.print(debug_show(result));
        {body = result.payload; token = result.callback}; 
    };

    /**
      * Builds the URL address for a given canister and path, either using the primary host, port, and protocol from the state or the location parameter
      * @param state - the state of the NFT Collection
      * @param use_token_id - the token ID to use (empty string for collection)
      * @param allocation_canister - the canister the NFT is allocated to
      * @param location - the location parameter from the library metadata
      * @param path - the path to use for the address
      * @returns the complete URL address
      */
    private func _build_address(state : Types.State, use_token_id : Text, allocation_canister: Principal, location : Text, path :Text ) : Text {
      switch(
      Metadata.get_primary_host(state, use_token_id, Principal.fromBlob("\04")),
      Metadata.get_primary_port(state, use_token_id, Principal.fromBlob("\04")),
      Metadata.get_primary_protocol(state, use_token_id, Principal.fromBlob("\04"))){
        case(#ok(host), #ok(port), #ok(protocol)){
            //branch is used for local testing
            protocol # "://" # host # (if(port=="443" or port == "80"){""}else{":" # port}) # "/" # path # "?canisterId=" # Principal.toText(allocation_canister)
        };
        
        case(_,_,_){
          if(Text.startsWith(location, #text("http")) == true){
            //if the location is a full http address
            location
          } else {
            //for relative paths
            "https://" # Principal.toText(allocation_canister) # ".raw.icp0.io/" # location
          };
          
        };
      };

    };

    /**
    * Redirects to the storage canister for an item that is not stored on the current server
    * @param state - the state of the canister
    * @param library_meta - the metadata for the library
    * @param token_id - the ID of the NFT
    * @param library_id - the ID of the library
    * @param location - the location parameter from the library metadata
    * @param use_token_id - the token ID to use (empty string for collection)
    * @param allocation_canister - the canister the NFT is allocated to
    * @returns the HTTP response for the redirect
    */
    private func _redirect_to_storage_canister(
      state: Types.State, 
      library_meta: CandyTypes.CandyShared,
      token_id : Text, 
      library_id : Text,
      location : Text,
      use_token_id :Text,
      allocation_canister : Principal) : HTTPResponse {
      debug if(debug_channel.library)  D.print("item is not on this server redir to " # Principal.toText(allocation_canister));
            let #ok(location) = Metadata.get_nft_text_property(library_meta, "location") else
              return _not_found("location not found" # token_id # " " # library_id);

            debug if(debug_channel.library) D.print("have location" # debug_show(location));

            let path = if(use_token_id == ""){
                "collection/-/" # library_id
            } else {
                "-/" # use_token_id # "/-/" # library_id
            };

            debug if(debug_channel.library)  D.print("got a path " # path);

            debug if(debug_channel.library) D.print("trying " # debug_show(Metadata.get_primary_host(state, use_token_id, Principal.fromBlob("\04")), Metadata.get_primary_port(state, use_token_id, Principal.fromBlob("\04")), Metadata.get_primary_protocol(state, use_token_id,Principal.fromBlob("\04"))));

            let address = _build_address(state, use_token_id, allocation_canister, location, path);

            debug if(debug_channel.library)  D.print("got a location " # address);

            debug if(debug_channel.library) D.print("trying " # debug_show(Metadata.get_primary_host(state, use_token_id,Principal.fromBlob("\04")), Metadata.get_primary_port(state,use_token_id,  Principal.fromBlob("\04")), Metadata.get_primary_protocol(state, use_token_id, Principal.fromBlob("\04"))));


            return {
                body = "";
                headers = [("Location", address),("icx-proxy-forward","true")];
                status_code = 307;
                streaming_strategy = null;
            };
    };

    /**
    * Handles the range headers from an HTTP request and returns the start and end values, if present
    * @param headers - the headers from the HTTP request
    * @returns an object containing the start and end values and a boolean indicating whether a range header was found
    */
    public func handle_range_headers(headers: [http.HeaderField]) : {
      start : ?Nat;
      end : ?Nat;
      b_foundRange : Bool;
    } {
      var split : [Text] = [];
      var split2 : [Text] = [];
      var start : ?Nat = null;
      var end : ?Nat = null;
      var b_foundRange : Bool = false;
      for(this_header in headers.vals()){
          if(this_header.0 == "range" or this_header.0 == "Range"){
            //handle range headers
            b_foundRange := true;
            split := Iter.toArray(Text.tokens(this_header.1, #char('=')));
            split2 := Iter.toArray(Text.tokens(split[1],#char('-')));
            if(split2.size() == 1){
                start := Conversion.textToNat(split2[0]);
            } else {
                start := Conversion.textToNat(split2[0]);
                end := Conversion.textToNat(split2[1]);
            };
            debug if(debug_channel.library) D.print("split2 " # debug_show(split2));
          };
      };
      return {
        start;
        end;
        b_foundRange;
      };
    };

    //determines how a library item should be rendere in an http request
    /**
    * Determines how a library item should be rendered in an HTTP request.
    * @param {Types.State} state - The state of the canister.
    * @param {httpparser.ParsedHttpRequest} req - The HTTP request.
    * @param {CandyTypes.CandyShared} metadata - The metadata for the NFT.
    * @param {string} token_id - The ID of the token.
    * @param {string} library_id - The ID of the library.
    * @returns
    */
    public func renderLibrary(
        state : Types.State,
        req : httpparser.ParsedHttpRequest,
        metadata : CandyTypes.CandyShared,
        token_id: Text,
        library_id: Text) : HTTPResponse {

        debug if(debug_channel.library) D.print("in render library)");

        let #ok(library_meta) = Metadata.get_library_meta(metadata, library_id) else return _not_found("meta not found - " # token_id # " " # library_id);

        debug if(debug_channel.library) D.print("library meta" #debug_show(library_meta));

        let #ok(location_type) = Metadata.get_nft_text_property(library_meta, "location_type") else
            return _not_found("location type not found" # token_id # " " # library_id);

        let #ok(read_type) = Metadata.get_nft_text_property(library_meta, "read") else return _not_found("read type not found" # token_id # " " # library_id);

        let #ok(location) = (Metadata.get_nft_text_property(library_meta, "location")) else return _not_found("location type not found" # token_id # " " # library_id);

        let use_token_id = if(location_type == "canister"){
            debug if(debug_channel.library) D.print("location type is canister");
            token_id;
        } else if(location_type == "collection"){
            debug if(debug_channel.library) D.print("location type is collection");
            "";
        } else if(location_type == "web"){
            return {
                body = "";
                headers = [("Location", location)];
                status_code = 307;
                streaming_strategy = null;
            };
        }else {
            return _not_found("library hosted off chain - " # token_id # " " # library_id  # " " # location_type);
        };

        debug if(debug_channel.library)  D.print("comparing library in allocation" # debug_show((use_token_id, library_id, state.state.allocations)));
        let ?allocation = Map.get<(Text, Text), Types.AllocationRecord>(
          state.state.allocations, 
          (NFTUtils.library_hash, NFTUtils.library_equal), 
          (use_token_id, library_id)) else return _not_found("allocation for token, library not found - " # use_token_id # " " # library_id);
                        
        debug if(debug_channel.library) D.print("found allocation" # debug_show((allocation.canister, state.canister())));
        
       
        if(allocation.canister != state.canister()){
             return _redirect_to_storage_canister(state, library_meta, token_id, library_id, location, use_token_id, allocation.canister);
        };

        if(read_type == "owner"){ //own this NFT
            switch(http_nft_owner_check(state, req, metadata)) {
                case(#err(err)) {
                   return _not_found(err);
                };
                case(#ok()) {};
            };
        };

        if(read_type == "collection_owner"){ //own the collection
            switch(http_owner_check(state, req)) {
                case(#err(err)) {
                   return _not_found(err);
                };
                case(#ok()) {};
            };
        };

        let header_result = handle_range_headers(req.headers.original);

        if(location_type == "canister"){
            //on this canister
            debug if(debug_channel.library)  D.print("canister");
            let #ok(content_type) = Metadata.get_nft_text_property(library_meta, "content_type") else return _not_found("content type not found");

            let #ok(item) = Metadata.get_library_item_from_store(state.nft_library, token_id, library_id) else return _not_found("item not found");

            switch(SB.getOpt(item,1)){
                case(null){
                    //nofiledata
                    return _not_found("file data not found");
                };
                case(?zone){
                    debug if(debug_channel.library)  D.print("size of zone" # debug_show(SB.size(zone)));
                    debug if(debug_channel.stablebtree)  D.print("#use_stablebtree - zone");

                    if(header_result.b_foundRange == true){
                        //range request
                         debug if(debug_channel.library)  D.print("dealing with a range request");
                        let result = handle_stream_content(
                                state,
                                token_id,
                                library_id,
                                header_result.start,
                                header_result.end,
                                content_type,
                                item,
                                req
                            );
                            debug if(debug_channel.library)D.print("returning with callback:");
                            debug if(debug_channel.library)D.print(debug_show(Option.isSome(result.streaming_strategy)));
                            return result;

                    } else {
                        debug if(debug_channel.library)D.print("Not a range requst");

                        /*
                        remove this comment to get a dump of the actual headers that made it through.
                        return {
                                status_code        = 200;
                                headers            = [("Content-Type", "text/plain")];
                                body               = Conversion.candySharedToBlob(#Text(debug_show(req.headers.original) # "|||" # debug_show(req.original.headers)));
                                streaming_strategy = null;
                            }; */
                        //standard content request
                        if(SB.size(zone) > 1){
                            //streaming required
                            let result = handleLargeContent(
                                state,
                                "nft/" # token_id # "|" # library_id,
                                content_type,
                                item,
                                req
                            );
                            debug if(debug_channel.library)D.print("returning with callback");
                            debug if(debug_channel.library)D.print(debug_show(Option.isSome(result.streaming_strategy)));
                            return result;
                        } else {
                            debug if(debug_channel.stablebtree)D.print("#use_stablebtree - insert - renderLibrary 1");

                            // Stablebtree  /////////////

                            var httpbody : Blob = "";
                            var k : Nat32 = 0;

                            if(state.state.use_stableBTree){
                              /*
                                switch(zone.get(0)){                                    
                                    case(#Nat32(val)){
                                        k := val;
                                    };
                                    case (_) { k := 0 };
                                };

                                let size = switch(item.get(2).get(0)){
                                  case(#Nat(val)) val;
                                  case(_){
                                     D.print("Could not find size for stabletree - renderLibrary");
                                     0;
                                  };
                                };

                                let result = NFTUtils.getMemoryBySize(size, state.btreemap).get(k);

                                switch(result){
                                    case null { D.print("Could not find data for stabletree - renderLibrary") };
                                    case (?val) { 
                                        httpbody := Blob.fromArray(val);                                    
                                    };
                                };
                                */
                            } else {
                                httpbody := Conversion.candyToBlob(SB.get(zone,0));
                            };
                            //////////////////////////////////


                            //only one chunck
                            return {
                                status_code        = 200;
                                headers            = [("Content-Type", content_type)];
                                body               = httpbody;
                                streaming_strategy = null;
                            };
                        };
                    };

                };
            };
        } else  if(location_type == "collection"){
            //on this canister but with collection id
            debug if(debug_channel.library)D.print("collection");

            let use_token_id = "";

            let #ok(content_type) = Metadata.get_nft_text_property(library_meta, "content_type") else return _not_found("content type not found");

            debug if(debug_channel.library)D.print("collection content type is " # content_type);

            let #ok(item) = Metadata.get_library_item_from_store(state.nft_library, use_token_id, library_id) else return _not_found("item not found");

            switch(SB.getOpt(item,1)){
                case(null){
                    //nofiledata
                    return _not_found("file data not found");
                };
                case(?zone){
                    debug if(debug_channel.library) D.print("size of zone");
                    debug if(debug_channel.library) D.print(debug_show(SB.size(zone)));

                    if(header_result.b_foundRange == true){
                        //range request
                                                debug if(debug_channel.library) D.print("dealing with a range request");
                        let result = handle_stream_content(
                                state,
                                use_token_id,
                                library_id,
                                header_result.start,
                                header_result.end,
                                content_type,
                                item,
                                req
                            );
                            debug if(debug_channel.library) D.print("returning with callback:");
                            debug if(debug_channel.library) D.print(debug_show(Option.isSome(result.streaming_strategy)));
                            return result;

                    } else {
                        debug if(debug_channel.library) D.print("Not a range requst");

                        /*
                        remove this comment to get a dump of the actual headers that made it through.
                        return {
                                status_code        = 200;
                                headers            = [("Content-Type", "text/plain")];
                                body               = Conversion.candySharedToBlob(#Text(debug_show(req.headers.original) # "|||" # debug_show(req.original.headers)));
                                streaming_strategy = null;
                            }; */
                        //standard content request
                        if(SB.size(zone) > 1){
                            //streaming required
                            let result = handleLargeContent(
                                state,
                                "nft/" # use_token_id # "|" # library_id,
                                content_type,
                                item,
                                req
                            );
                            debug if(debug_channel.library) D.print("returning with callback");
                            debug if(debug_channel.library) D.print(debug_show(Option.isSome(result.streaming_strategy)));
                            return result;
                        } else {
                            debug if(debug_channel.stablebtree)D.print("#use_stablebtree - insert - renderLibrary 2");
                            // Stablebtree  /////////////

                            var httpbody : Blob = "";
                            var k : Nat32 = 0;

                            if(state.state.use_stableBTree){
                              /*
                                switch(zone.get(0)){                                    
                                    case(#Nat32(val)){
                                        k := val;
                                    };
                                    case (_) { k := 0 };
                                };

                                let size = switch(item.get(2).get(0)){
                                  case(#Nat(val)) val;
                                  case(_) {
                                    D.print("Could not find size for item!");
                                    0;
                                  };
                                };


                                let result = NFTUtils.getMemoryBySize(size, state.btreemap).get(k);
                                switch(result){
                                    case null { D.print("Could not find data for stabletree - renderLibrary") };
                                    case (?val) { 
                                        httpbody := Blob.fromArray(val);                                    
                                    };
                                };
                                */
                            } else {
                                httpbody := Conversion.candyToBlob(SB.get(zone, 0));
                            };
                            //////////////////////////////////
                            //only one chunck
                            return {
                                status_code        = 200;
                                headers            = [("Content-Type", content_type)];
                                body               = httpbody;
                                streaming_strategy = null;
                            };
                        };
                    };

                };
            };
        } else {
            //redirect to asset
            let location = switch(Metadata.get_nft_text_property(library_meta, "location")){
                case(#err(err)){return _not_found("location not found");};
                case(#ok(val)){val};
            };
                                debug if(debug_channel.library) D.print("redirecting to asset" # location);
            return {
                body = "";
                headers = [("Location", location)];
                status_code = 307;
                streaming_strategy = null;
            };
        };
    };

    //passthrough function...candidate for refactoring
    public func renderSmartRoute(
        state : Types.State,
        req : httpparser.ParsedHttpRequest,
        metadata : CandyTypes.CandyShared,
        token_id: Text, smartRoute: Text) : HTTPResponse {
        //D.print("path is ex");
        let library_id = switch(Metadata.get_nft_text_property(metadata, smartRoute)){
            case(#err(err)){return _not_found("library not found");};
            case(#ok(val)){val};
        };
        //D.print(library_id);

        return renderLibrary(state, req,  metadata, token_id, library_id);
    };

    //standard response for a 404
    private func _not_found(message: Text) : HTTPResponse{
        return{
            body = Text.encodeUtf8("404 Not found :" # message);
            headers : [http.HeaderField] = [];
            status_code  : Nat16= 404;
            streaming_strategy : ?StreamingStrategy = null;
        };
    };

    /**
    * Callback function used for NFT streaming. Handles streaming NFT content
    * @param tk - StreamingCallbackToken, token containing streaming info
    * @param state - Types.State, state object containing library data and other metadata
    * @returns StreamingCallbackResponse object, containing payload and streaming token
    */
    public func nftStreamingCallback(
        tk : StreamingCallbackToken,
        state: Types.State) :  StreamingCallbackResponse {
        debug if(debug_channel.streaming) D.print("in streaming callback");
        let path = Iter.toArray(Text.tokens(tk.key, #text("/")));
        debug if(debug_channel.streaming) D.print(debug_show(path));
        if (path.size() == 2 and path[0] == "nft") {
          debug if(debug_channel.streaming) D.print("private nft");
          let path2 = Iter.toArray(Text.tokens(path[1], #text("|")));

          let (token_id, library_id) = if(path2.size() == 1){
              ("", path2[0]);
          } else {
              ( path2[0], path2[1]);
          };

          debug if(debug_channel.streaming) D.print("path2 " # debug_show(path2));
          
          let item = switch(Metadata.get_library_item_from_store(state.nft_library, token_id, library_id)){
              case(#err(err)){
                  debug if(debug_channel.streaming) D.print("an error" # debug_show(err));
                  return {
                      body  = Blob.fromArray([]);
                      token = null;
                  }};
              case(#ok(val)){val};
          };
          //D.print("past it");

          //debug if(debug_channel.streaming) D.print("item:" # debug_show(item));

          //D.print("what?");
          
          switch(SB.getOpt(item,1)){
              case(null){
                  //nofiledata
                  debug if(debug_channel.streaming) D.print("no file data");
                  return {
                      body  = Blob.fromArray([]);
                      token = null;
                  };
              };
              case(?zone){
                  debug if(debug_channel.streaming) D.print("callint stream conent" # debug_show(tk.key, tk.index, state.state.use_stableBTree));
                  return stream_content(
                      tk.key,
                      tk.index,
                      item,
                      state.state.use_stableBTree,
                      //state.btreemap,
                  );
              };
          };


        } else if(path.size() == 2 and path[0] == "nft-m"){
            //have to get data differently
                                debug if(debug_channel.streaming) D.print("in media pathway");
            let path2 = Iter.toArray(Text.tokens(path[1], #text("|")));
            //nyi: handle private nft
            let (token_id, library_id, rStartText, rEndText, sizeText) = if(path2.size() == 1){
                ("", path2[0], path2[1],  path2[2], path2[3]);
            } else {
                ( path2[0], path2[1], path2[2], path2[3], path2[4]);
            };
                                debug if(debug_channel.streaming) D.print(debug_show(path2));
            let item = switch(Metadata.get_library_item_from_store(state.nft_library, token_id, library_id)){
                case(#err(err)){
                                        debug if(debug_channel.streaming) D.print("no item");
                    return {
                                    body  = Blob.fromArray([]);
                                    token = null;
                                }};
                case(#ok(val)){val};
            };
            switch(SB.getOpt(item,1)){
                case(null){
                    //nofiledata
                                        debug if(debug_channel.streaming) D.print("no file bytes found");
                    return {
                                body  = Blob.fromArray([]);
                                token = null;
                            };
                };
                case(?zone){
                                        debug if(debug_channel.streaming) D.print("about to call stream media from the callback pathway");
                    let rStart = Option.get(Conversion.textToNat(rStartText),0);
                    let rEnd = Option.get(Conversion.textToNat(rEndText),0);
                    let size = Option.get(Conversion.textToNat(sizeText),0);
                    debug if(debug_channel.streaming) D.print(debug_show(rStart, rEnd, size));
                    return stream_media(
                        token_id,
                        library_id,
                        tk.index,
                        item,
                        rStart,
                        rEnd,
                        size
                    );
                };
            };

        };
        {
            body  = Blob.fromArray([]);
            token = null;
        };
    };


    /**
    * Callback function for streaming content from NFT Library.
    * @param {StreamingCallbackToken} tk - The token containing the index of the chunk to retrieve.
    * @param {Types.State} state - The state of the NFT Library canister.
    * @returns {StreamingCallbackResponse} - The response containing the payload and the next callback token.
    */
    private func stream_content(
        key   : Text,
        index : Nat,
        data  : CandyTypes.Workspace,
        use_stable : Bool,
        //btreemap : Types.Stable_Memory,
    ) : StreamingCallbackResponse {
        //D.print("in stream_content");
        let result = _stream_content(
            key,
            index,
            data,
            use_stable,
            //btreemap,
        );

        debug if(debug_channel.streaming) D.print("the stream content " # key);
        debug if(debug_channel.streaming) D.print(debug_show(result));
        {
            body  = result.payload;
            token = result.callback;
        };
    };


    /**
    * Callback function for streaming large content over HTTP.
    * Determines how a library item should be rendered in an HTTP request.
    *
    * @param {StreamingCallbackToken} tk - Token representing the current streaming session.
    * @param {Types.State} state - State object containing the current allocation and other relevant data.
    * @returns {StreamingCallbackResponse} - A response object containing the payload and callback for the next chunk (if applicable).
    */
    public func http_request_streaming_callback(
        tk : StreamingCallbackToken,
        state : Types.State) : StreamingCallbackResponse {

                            debug if(debug_channel.large_content) D.print("in the request_streamint callbak");
                            debug if(debug_channel.large_content) D.print(debug_show(tk));
        if (Text.startsWith(tk.key, #text("nft/"))) {
            let path = Iter.toArray(Text.tokens(tk.key, #text("/")));

            let path2 = Iter.toArray(Text.tokens(path[1], #text("|")));


                                //nyi: handle private nft
                                debug if(debug_channel.large_content) D.print(debug_show(path));
                                debug if(debug_channel.large_content) D.print(debug_show(path2));

            let (token_id, library_id) = if(path2.size() == 1){
                ("", path2[0]);
            } else {
                ( path2[0], path2[1]);
            };

            let item = switch(Metadata.get_library_item_from_store(state.nft_library, token_id, library_id)){
                case(#err(err)){return {
                        body  = Blob.fromArray([]);
                        token = null;
                    };
                };
                case(#ok(val)){val};
            };

            //D.print("have item");

            switch (SB.getOpt(item,1)) {
                case (null) { };
                case (?zone)  {
                    return stream_content(
                        tk.key,
                        tk.index,
                        item,
                        state.state.use_stableBTree,
                        //state.btreemap,
                    );
                };
            };
        } else if (Text.startsWith(tk.key, #text("nft-m/"))){
            let path = Iter.toArray(Text.tokens(tk.key, #text("/")));

            let path2 = Iter.toArray(Text.tokens(path[1], #text("|")));
                                //nyi: handle private nft
                                debug if(debug_channel.large_content) D.print(debug_show(path));
                                debug if(debug_channel.large_content) D.print(debug_show(path2));

            let (token_id, library_id, rStartText, rEndText, sizeText) = if(path2.size() == 1){
                ("", path2[0], path2[1],  path2[2], path2[3]);
            } else {
                ( path2[0], path2[1], path2[2], path2[3], path2[4]);
            };

            let item = switch(Metadata.get_library_item_from_store(state.nft_library, token_id, library_id)){
              case(#err(err)){return {
                  body  = Blob.fromArray([]);
                  token = null;
                };
              };
              case(#ok(val)){val};
            };

                                debug if(debug_channel.large_content) //D.print("have item");

            switch (SB.getOpt(item,1)) {
                case (null) { };
                case (?zone)  {
                    return stream_media(
                        token_id,
                        library_id,

                        tk.index,
                        item,
                        Option.get(Conversion.textToNat(rStartText),0),//rstart

                        Option.get(Conversion.textToNat(rEndText),0),//rend
                        Option.get(Conversion.textToNat(sizeText),0),//size
                    );
                };
            };

        } else {
            //handle static assests if we have them
        };
        return {
            body  = Blob.fromArray([]);
            token = null;
        };
    };

    //formats a candy value to json
    public func json(message: CandyTypes.CandyShared, _query: ?Text) : HTTPResponse {
        let message_response = switch(_query) {
            case(null) {
                message
            };
            case(?q) {
                switch(splitQuery(Text.replace(q, #text("--"), "~"), '~')) {
                    case(#ok(qs)) {
                        switch(get_deep_properties(message, qs)) {
                            case(#ok(data)) {
                                data;
                            };
                            case(#back){
                              message;
                            };
                            case(#err(err)) {
                                return _not_found("properties not found: " # q);
                            };
                           
                        };
                    };
                    case(#err(err)) {
                        return _not_found(err);
                    };
                    /* case(_){
                        return _not_found("unexpected value: " # debug_show(message));
                    }; */
                };
            };
        };

        return {
            body = Text.encodeUtf8(JSON.value_to_json(message_response));
            headers = [(("Content-Type", "application/json")),(("Access-Control-Allow-Origin", "*"))];
            status_code = 200;
            streaming_strategy = null;
        };
    };

    type sQuery = { #standard: Text; #multi: Text };

    //handles queries
    /**
    * Splits a query string into a list of sQueries.
    * @param {Text} q - The query string to split.
    * @param {Char} p - The character used to separate sQueries.
    * @returns {Result.Result<List.List<sQuery>, Text>} - A Result containing a list of sQueries or an error message.
    */
    public func splitQuery(q: Text, p: Char): Result.Result<List.List<sQuery>, Text> {
        var queries = List.nil<sQuery>();
        var key : Text = "";
        var multi : Bool  = false;
        var open : Bool  = false;

        let addQueries = func(key: Text, current: List.List<sQuery>, multi: Bool): Result.Result<List.List<sQuery>, Text> {
            //D.print(debug_show(multi, key));
            if(multi) {
                if(Text.contains(key, #char(p))) {
                   return #err("multi: not supported split")
                };
                #ok(List.push<sQuery>(#multi(key), current));
            } else {
                if(Text.contains(key, #char(','))) {
                    return #err("Standard: not supported [,]");
                };
                #ok(List.push<sQuery>(#standard(key), current));
            };
        };

        for(thisChar in Text.toIter(q)) {
            if(thisChar == '[') {
                open := true;
                multi := true;
            } else if(thisChar == ']') {
                 open := false;
            } else {
                if(thisChar == p and open == false) {
                    switch(addQueries(key, queries, multi)) {
                        case(#ok(res)){queries:=res;};
                        case(err){return err;};
                    };
                    multi := false;
                    key := "";
                } else {
                    key:= key # Char.toText(thisChar);
                };
            };
        };

        switch(addQueries(key, queries, multi)) {
            case(#ok(res)){queries:=res;};
            case(err){return err;};
        };
        return #ok(List.reverse(queries));
    };

    //gets prroperties from deep in a structure
    public func get_deep_properties(metadata: CandyTypes.CandyShared, qs: List.List<sQuery>): {#ok: CandyTypes.CandyShared; #err; #back} {
        if(List.isNil(qs)) {
            return #back();
        };

        let item = List.pop(qs);

        let key = switch(item.0){
          case(null){return #err;};
          case(?val){val;};
        };
        let listQs = item.1;

        switch(metadata) {
            case(#Class(properties)) {
                switch(key) {
                    case(#standard(standard)) {
                        switch(Properties.getClassPropertyShared(metadata, standard)){
                            case(null) {
                                return #err();
                            };
                            case(?val){
                                switch(get_deep_properties(val.value, listQs)) {
                                    case(#ok(res)){#ok(res);};
                                    case(#back()){#ok(#Class([val]));};
                                    case(err){err;};
                                };
                            };
                        };
                    };
                    case(#multi(multi)) {
                        if(List.isNil(listQs)) {
                            let props = Array.map<Text, CandyTypes.Query>(
                                split_text(multi, ','),
                                func (key: Text): CandyTypes.Query {
                                    return {
                                        name = key;
                                        next = [];
                                    };
                                }
                            );

                            return switch(Properties.getPropertiesShared(properties, props)) {
                                case(#ok(val)){#ok(#Class(val));};
                                case(#err(err)){#err()};
                            };
                        } else {
                            return #err();
                        };
                    };
                };
            };
            case(#Array(_)) {
                switch(key) {
                    case(#standard(standard)) {
                        var len = 0;
                        for(this_item in Conversion.candySharedToValueArray(metadata).vals()) {
                            if(Nat.toText(len) == standard) {
                                switch(get_deep_properties(this_item, listQs)) {
                                    case(#ok(res)){return #ok(res);};
                                    case(#back()){return #ok(this_item);};
                                    case(err){return err;};
                                };
                            };
                            len := len + 1;
                        };
                    };
                    case(#multi(multi)) {
                        var splitMulti: [Text] = split_text(multi, ',');
                        let list: Buffer.Buffer<CandyTypes.CandyShared> = Buffer.Buffer<CandyTypes.CandyShared>(1);
                        var len = 0;
                        for(this_item in Conversion.candySharedToValueArray(metadata).vals()) {
                            switch(Array.find<Text>(splitMulti, func (key: Text) {
                                return key == Nat.toText(len);
                            })) {
                                case(null) {};
                                case(?find) {
                                    switch(get_deep_properties(this_item, listQs)) {
                                        case(#ok(res)){
                                            list.add(res);
                                        };
                                        case(#back()){
                                            list.add(this_item);
                                        };
                                        case(err){return err;};
                                    };
                                };
                            };
                            len := len + 1;
                        };

                        if(list.size() == splitMulti.size()) {
                            return #ok(#Array(Buffer.toArray(list)));
                        } else {
                            return #err();
                        };
                    };
                };

                return #err();
            };
            case(_) {
                if(List.isNil(qs)) {
                    return #back();
                };

               return #err();
            };
        };
    };

    public func split_text(q: Text, p: Char): [Text] {
        var queries: Buffer.Buffer<Text> = Buffer.Buffer<Text>(1);
        var key : Text = "";

        for(thisChar in Text.toIter(q)) {
            if(thisChar != '[' and thisChar != ']') {
                if(thisChar == p) {
                    queries.add(key);
                    key := "";
                } else {
                    key:= key # Char.toText(thisChar);
                };
            };
        };
        queries.add(key);
        return Buffer.toArray(queries);
    };

    //checks that a access token holder is the collection owner
    //**NOTE:  NOTE:  Data stored on the IC should not be considered secure. It is possible(though not probable) that node operators could look at the data at rest and see access tokens. The only current method for hiding data from node providers is to encrypt the data before putting it into a canister. It is highly recommended that any personally identifiable information is encrypted before being stored on a canister with a separate and secure decryption system in place.**
    public func http_owner_check(stateBody : Types.State, req : httpparser.ParsedHttpRequest): Result.Result<(), Text> {
      switch(req.url.queryObj.get("access")) {
        case(null) {
          return #err("no access code in request when nft not minted");
        };
        case(?access_token) {
          switch(Map.get(stateBody.state.access_tokens, thash, access_token)) {
            case(null) return #err("identity not found by access_token : " # access_token);
            case(?info) {
              let { identity; expires; } = info;

              if(stateBody.state.collection_data.owner != identity) return #err("not an owner");
            
              if(expires < Time.now()) return #err("access expired");
            };
          };
        };
      };
      #ok();
    };

    //checks that a access token holder is an owner of an NFT
    //**NOTE:  NOTE:  Data stored on the IC should not be considered secure. It is possible(though not probable) that node operators could look at the data at rest and see access tokens. The only current method for hiding data from node providers is to encrypt the data before putting it into a canister. It is highly recommended that any personally identifiable information is encrypted before being stored on a canister with a separate and secure decryption system in place.**
    public func http_nft_owner_check(stateBody : Types.State, req : httpparser.ParsedHttpRequest, metadata: CandyTypes.CandyShared): Result.Result<(), Text> {
        let ?access_token = req.url.queryObj.get("access") else return #err("no access code in request when nft not minted");

        let ?info = Map.get(stateBody.state.access_tokens, thash,access_token) else return #err("identity not found by access_token : " # access_token);

        let { identity; expires; } = info;

        switch(Metadata.is_nft_owner(metadata, #principal(identity))){
          case(#ok(val)){
            if(val == false) return #err("not an owner");
          };
          case(#err(err)) return #err("identity not found by access_token : " # access_token);
        };

        if(expires < Time.now()) return #err("access expired");

        #ok();
    };

    //handles http requests
    public func http_request(
        state : Types.State,
        rawReq: HttpRequest,
        caller : Principal): (HTTPResponse) {

                        debug if(debug_channel.request) D.print("a page was requested");

        let req = httpparser.parse({
            body = rawReq.body;
            headers = rawReq.headers;
            method = rawReq.method;
            url = Text.replace(rawReq.url, #text("%20"), " ");
        });
        let {host; port; protocol; path; queryObj; anchor; original = url} = req.url;


        let path_size = req.url.path.array.size();
        let path_array = req.url.path.array;


        debug if(debug_channel.request) D.print(debug_show(rawReq));
        
        if(path_size == 0) {
            switch(queryObj.get("tokenid")){
            case(null){};
            case(?found_ext_id){

              var metadata : CandyTypes.CandyShared = #Option(null);
              if(found_ext_id == "") return {
                  body = Text.encodeUtf8 ("<html><head><title>Bad NFT ID</title></head><body></body></html>\n");
                  headers = [];
                  status_code = 200;
                  streaming_strategy = null;
              };

              label search for(this_nft in Map.entries(state.state.nft_metadata)){
                  if(Types._getEXTTokenIdentifier(this_nft.0, state.canister()) == found_ext_id) {
                    metadata := this_nft.1;
                    break search;
                  };
              };

              if(metadata == #Option(null)){
                return {
                  body = Text.encodeUtf8 ("<html><head><title>Bad NFT ID</title></head><body></body></html>\n");
                  headers = [];
                  status_code = 200;
                  streaming_strategy = null;
                };
              };
              let token_id = Conversion.candySharedToText(
                switch(Properties.getClassPropertyShared(metadata, "id")){
                    case(null){
                        return {
                          body = Text.encodeUtf8 ("<html><head><title>Bad NFT ID</title></head><body></body></html>\n");
                          headers = [];
                          status_code = 200;
                          streaming_strategy = null;
                        };
                    };
                    case(?found){
                        found.value;
                    };
                });
              let is_minted = Metadata.is_minted(metadata);

              switch(queryObj.get("type")){
                case(null){
                  //return primary
                  if(is_minted == false){
                      return renderSmartRoute(state,req, metadata, token_id, Types.metadata.hidden_asset);
                  };
                  return renderSmartRoute(state,req, metadata, token_id, Types.metadata.primary_asset);
                };
                case(?val){
                  if(val=="thumbnail"){
                    //return preview
                    if(is_minted == false){
                        return renderSmartRoute(state,req, metadata, token_id, Types.metadata.hidden_asset);
                    };
                    var aResponse = renderSmartRoute(state,req, metadata, token_id, Types.metadata.preview_asset);
                    if(aResponse.status_code==404){
                        //default to primary asset
                        aResponse := renderSmartRoute(state ,req, metadata, token_id, Types.metadata.primary_asset)
                    };
                    return aResponse;
                  } else {
                    //return primary
                    if(is_minted == false){
                        return renderSmartRoute(state,req, metadata, token_id, Types.metadata.hidden_asset);
                    };
                    return renderSmartRoute(state,req, metadata, token_id, Types.metadata.primary_asset);
                  };
                };
              }
            };
          };
            return {
                body = Text.encodeUtf8 ("<html><head><title> An Origyn NFT Canister </title></head><body></body></html>\n");
                headers = [];
                status_code = 200;
                streaming_strategy = null;
            };
        };


        if(path_size > 0){
            if(path_array[0] == "-"){
                if(path_size > 1){
                    debug if(debug_channel.request) D.print("on path print area");
                    debug if(debug_channel.request) D.print(debug_show(path_size));
                    let token_id = path_array[1];

                    let metadata = switch(Map.get(state.state.nft_metadata, Map.thash, token_id)){
                        case(null){
                            return _not_found("metadata not found");
                        };
                        case(?val){
                            val;
                        };
                    };
                    let is_minted = Metadata.is_minted(metadata);
                    if(path_size == 2){
                        //show the main asset
                        debug if(debug_channel.request) D.print("should be showing the main asset unless unmited" # debug_show(is_minted));
                        if(is_minted == false){
                            return renderSmartRoute(state, req, metadata, token_id, Types.metadata.hidden_asset);
                        };
                        return renderSmartRoute(state, req, metadata, token_id, Types.metadata.primary_asset);
                    };
                    if(path_size >= 3){
                        if(path_array[2] == "ex"){
                            var aResponse = renderSmartRoute(state ,req, metadata, token_id, Types.metadata.experience_asset);
                            if(aResponse.status_code==404){
                                //default to the primary asset
                                aResponse := renderSmartRoute(state ,req, metadata, token_id, Types.metadata.primary_asset)
                            };
                            if(is_minted == false and aResponse.status_code==404){
                                return renderSmartRoute(state ,req, metadata, token_id, Types.metadata.hidden_asset);
                            };
                            return aResponse;
                        };
                        if(path_array[2] == "preview"){
                            if(is_minted == false){
                                return renderSmartRoute(state,req, metadata, token_id, Types.metadata.hidden_asset);
                            };
                            var aResponse = renderSmartRoute(state,req, metadata, token_id, Types.metadata.preview_asset);
                            if(aResponse.status_code==404){
                                //default to primary asset
                                aResponse := renderSmartRoute(state ,req, metadata, token_id, Types.metadata.primary_asset)
                            };
                            return aResponse;
                        };
                        if(path_array[2] == "hidden"){
                            return renderSmartRoute(state,req, metadata, token_id, Types.metadata.hidden_asset);
                        };
                        if(path_array[2] == "primary"){
                            if(is_minted == false){
                                return renderSmartRoute(state,req, metadata, token_id, Types.metadata.hidden_asset);
                            };
                            return renderSmartRoute(state,req, metadata, token_id, Types.metadata.primary_asset);
                        };
                        if(path_array[2] == "info"){
                            return json(Metadata.get_clean_metadata(metadata, caller), queryObj.get("query"));
                        };
                        if(path_array[2] == "library"){
                            let libraries = switch(Metadata.get_nft_library(Metadata.get_clean_metadata(metadata, caller), ?caller)){
                                case(#err(err)){return _not_found("libraries not found");};
                                case(#ok(val)){ val };
                            };
                            return json(libraries, null);
                        };
                        if(path_array[2] == "ledger_info"){
                          debug if(debug_channel.request) D.print("render ledger_info "  # token_id );

                          let ?ledger = Map.get(state.state.nft_ledgers, Map.thash, token_id) else return json(#Option(null), null);
                          
                          let page = if(path_array.size() > 3){
                            switch(Conversion.textToNat(path_array[3])){
                              case(null){0};
                              case(?val){val;};
                            }
                          } else {0};

                          let size = if(path_array.size() > 4){
                            switch(Conversion.textToNat(path_array[4])){
                              case(null){10000};
                              case(?val){val;};
                            }
                          } else {10000};


                          return json(#Array(Metadata.ledger_to_candy(ledger, page, size)), null);
                        };

                        if(path_array[2] == "translate"){

                          debug if(debug_channel.request) D.print("render translate "  # token_id );

                          let translation =  #Class([
                              {name="origyn_nft"; value=#Text(token_id); immutable=true;},
                              {name="ext"; value=#Text(Types._getEXTTokenIdentifier(token_id, state.canister())); immutable=true;},
                              {name="dip721"; value=#Text(Nat.toText(NFTUtils.get_token_id_as_nat(token_id))); immutable=true;}
                            ]);
                      

                          
                          return json(translation, null);
                        };
                        
                    
                        if(path_size > 3){
                          if(path_array[2] == "-") {

                              if (is_minted == false) {
                                switch(http_owner_check(state, req)) {
                                  case(#err(err)) {
                                    return _not_found(err);
                                  };
                                  case(#ok()) {};
                                };
                              };
                              let library_id_buffer = Buffer.Buffer<Text>(1);
                              let bIsInfo = path_array[path_array.size()-1] == "info";

                              var tracker : Nat = 0;
                              
                              for(thisItem in path_array.vals()){
                                if(tracker > 2){
                                  if(bIsInfo and tracker == Nat.sub(path_array.size(),1)){

                                  } else {
                                    library_id_buffer.add(thisItem)
                                  };
                                };
                                tracker += 1;
                              };

                                let library_id =if(library_id_buffer.size() > 1){
                                Text.join("/", Buffer.toArray(library_id_buffer).vals());
                              } else {
                                library_id_buffer.get(0);
                              };

                              if(path_size >= 5 and path_array[path_array.size()-1] == "info"){
                                let library_meta = switch(Metadata.get_library_meta(metadata, library_id)){
                                    case(#err(err)){return _not_found("library by " # library_id # " not found");};
                                    case(#ok(val)){val};
                                };
                                return json(library_meta, queryObj.get("query"));
                              };

                              return renderLibrary(state, req, metadata, token_id, library_id);
                          };
                        };
                    };
                };
            } else if(path_array[0] == "collection"){
                debug if(debug_channel.request) D.print("found collection");


                debug if(debug_channel.request) D.print("on path print area");
                debug if(debug_channel.request) D.print(debug_show(path_size));
                let token_id = "";

                let ?metadata = Map.get(state.state.nft_metadata, Map.thash,token_id) else return _not_found("metadata not found");

                if(path_size > 1){
                    if(path_array[1] == "-"){

                        debug if(debug_channel.request) D.print("found -");

                        if(path_size == 2){
                            // https://exos.surf/-/canister_id/collection/
                            debug if(debug_channel.request) D.print("render smart route 2 collection" # token_id);
                            debug if(debug_channel.request) D.print("primary asset");
                            return renderSmartRoute(state, req, metadata, token_id, Types.metadata.primary_asset);
                        };
                        if(path_size > 2){

                          debug if(debug_channel.request) D.print("building library id");
                          let library_id_buffer = Buffer.Buffer<Text>(1);
                          let bIsInfo = path_array[path_array.size()-1] == "info";

                          var tracker : Nat = 0;
                          
                          for(thisItem in path_array.vals()){
                            if(tracker > 1){
                              if(bIsInfo and tracker == Nat.sub(path_array.size(),1)){

                              } else {
                                library_id_buffer.add(thisItem)
                              };
                            };
                            tracker += 1;
                          };

                            let library_id = if(library_id_buffer.size() > 1){
                            Text.join("/", Buffer.toArray(library_id_buffer).vals());
                          } else {
                            library_id_buffer.get(0);
                          };

                          if(path_size >= 3 and path_array[path_array.size()-1] == "info"){
                            let #ok(library_meta) = Metadata.get_library_meta(metadata, library_id) else return _not_found("library by " # library_id # " not found");

                            return json(library_meta, queryObj.get("query"));
                          };
                          debug if(debug_channel.request) D.print("library id "  # library_id);

                          return renderLibrary(state, req, metadata, token_id, library_id);
                        };
                    };
                    if(path_array[1] == "ex"){
                        debug if(debug_channel.request) D.print("render ex "  # token_id );
                        var aResponse = renderSmartRoute(state ,req, metadata, token_id, Types.metadata.experience_asset);
                        if(aResponse.status_code==404){
                            aResponse := renderSmartRoute(state ,req, metadata, token_id, Types.metadata.primary_asset)
                        };
                        return aResponse;
                    };
                    if(path_array[1] == "preview"){
                        debug if(debug_channel.request) D.print("render perview "  # token_id );
                                           
                        var aResponse = renderSmartRoute(state,req, metadata, token_id, Types.metadata.preview_asset);
                        if(aResponse.status_code==404){
                            aResponse := renderSmartRoute(state ,req, metadata, token_id, Types.metadata.primary_asset)
                        };
                        return aResponse;
                    };
                    if(path_array[1] == "hidden"){
                        debug if(debug_channel.request) D.print("render hidden "  # token_id );
                        return renderSmartRoute(state,req, metadata, token_id, Types.metadata.hidden_asset);
                    };
                    if(path_array[1] == "primary"){
                        debug if(debug_channel.request) D.print("render primary "  # token_id );
                        return renderSmartRoute(state,req, metadata, token_id, Types.metadata.primary_asset);
                    };
                    if(path_array[1] == "info"){
                        debug if(debug_channel.request) D.print("render info "  # token_id );
                        return json(Metadata.get_clean_metadata(metadata, caller), queryObj.get("query"));
                    };
                    if(path_array[1] == "library"){
                        debug if(debug_channel.request) D.print("render library "  # token_id );
                        let #ok(libraries) = Metadata.get_nft_library(Metadata.get_clean_metadata(metadata, caller), ?caller) else return _not_found("libraries not found");
                        return json(libraries, null);
                    };
                    if(path_array[1] == "ledger_info"){
                        debug if(debug_channel.request) D.print("render ledger_info "  # token_id );

                        let ?ledger = Map.get(state.state.nft_ledgers, Map.thash, token_id) else return json(#Option(null), null);
                        
                        let page = if(path_array.size() > 2){
                          switch(Conversion.textToNat(path_array[2])){
                              case(null){0};
                              case(?val){val;};
                            }
                        } else {0};

                        let size = if(path_array.size() > 3){
                          switch(Conversion.textToNat(path_array[3])){
                              case(null){10000};
                              case(?val){val;};
                            }
                        } else {10000};

                        return json(#Array(Metadata.ledger_to_candy(ledger, page, size)), null);
                    };
                    if(path_array[1]== "translate"){
                      let rawkeys = if(NFTUtils.is_owner_manager_network(state, caller) == true){
                          Iter.toArray<Text>(Iter.filter<Text>(Map.keys(state.state.nft_metadata), func (x : Text){ x != ""}));
                          
                        } else {
                          Iter.toArray<Text>(Iter.filter<Text>(Map.keys(state.state.nft_ledgers), func (x : Text){ x != ""}));
                        };
                          
                          let translation = Array.map<Text, CandyTypes.CandyShared>(rawkeys, func(x){
                            
                          return #Class([
                            {name="origyn_nft"; value=#Text(x); immutable=true;},
                            {name="ext"; value=#Text(Types._getEXTTokenIdentifier(x, state.canister())); immutable=true;},
                            {name="dip721"; value=#Text(Nat.toText(NFTUtils.get_token_id_as_nat(x))); immutable=true;}
                          ]);
                        });

                        
                        return json(#Array(translation), null);
                            
                    };
                } else {
                  debug if(debug_channel.request) D.print("collection info");
                  let rawkeys = if(NFTUtils.is_owner_manager_network(state, caller) == true){
                    Iter.toArray<Text>(Iter.filter<Text>(Map.keys(state.state.nft_metadata), func (x : Text){ x != ""}));
                    
                  } else {
                    Iter.toArray<Text>(Iter.filter<Text>(Map.keys(state.state.nft_ledgers), func (x : Text){ x != ""}));
                  };

                  let keys = let keys = if(NFTUtils.is_owner_manager_network(state, caller) == true){
                    Array.map<Text, CandyTypes.CandyShared>(rawkeys, func (x:Text){#Text(x)}); // Should always have the "" item and need to remove it
                  } else {
                    Array.map<Text, CandyTypes.CandyShared>(rawkeys, func (x:Text){#Text(x)}); // Should always have the "" item and need to remove it
                  };
                  
                  return json(#Array(keys), null);
                 
                };
            } else if(path_array[0] == "metrics"){
                return {
                    body = Text.encodeUtf8("Metrics page :");
                    headers = [];
                    status_code = 200;
                    streaming_strategy = null;
                };
            };
        };
        return _not_found("nyi");
    };


}
