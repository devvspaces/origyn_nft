
import AccountIdentifier "mo:principalmo/AccountIdentifier";
import Array "mo:base/Array";
import C "mo:matchers/Canister";
import Buffer "mo:base/Buffer";


import DFXTypes "../origyn_nft_reference/dfxtypes";
import D "mo:base/Debug";
import Iter "mo:base/Iter";
import Blob "mo:base/Blob";
import M "mo:matchers/Matchers";
import NFTUtils "../origyn_nft_reference/utils";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import S "mo:matchers/Suite";
import T "mo:matchers/Testable";
import TestWalletDef "test_wallet";
import Time "mo:base/Time";
import Types "../origyn_nft_reference/types";
import utils "test_utils";
import MigrationTypes "../origyn_nft_reference/migrations/types";



shared (deployer) actor class test_runner(dfx_ledger: Principal, dfx_ledger2: Principal) = this {

    let CandyTypes = MigrationTypes.Current.CandyTypes;
    let Conversions = MigrationTypes.Current.Conversions;
    let Properties = MigrationTypes.Current.Properties;
    let Workspace = MigrationTypes.Current.Workspace;
    
    let it = C.Tester({ batchSize = 8 });

    
    private var DAY_LENGTH = 60 * 60 * 24 * 10 ** 9;
    private var dip20_fee = ?200_000;

    private func get_time() : Int{
        return Time.now();
    };

    private type canister_factory_actor = actor {
        create : ({owner: Principal; storage_space: ?Nat}) -> async Principal;
    };
    private type storage_factory_actor = actor {
        create : ({owner: Principal; storage_space: ?Nat}) -> async Principal;
    };

    private var g_canister_factory : canister_factory_actor = actor(Principal.toText(Principal.fromBlob("\04")));
    private var g_storage_factory: storage_factory_actor = actor(Principal.toText(Principal.fromBlob("\04")));
    
    
    

    public shared func test(canister_factory : Principal, storage_factory: Principal) : async {#success; #fail : Text} {
        g_canister_factory := actor(Principal.toText(canister_factory));
        g_storage_factory := actor(Principal.toText(storage_factory));
        
        let suite = S.suite("test nft", [
          S.test("testRewriteLibrary", switch(await testRewriteLibrary()){case(#success){true};case(_){false};}, M.equals<Bool>(T.bool(true))),
            
            S.test("testDataInterface", switch(await testDataInterface()){case(#success){true};case(_){false};}, M.equals<Bool>(T.bool(true))),
            S.test("testImmutableLibrary", switch(await testImmutableLibrary()){case(#success){true};case(_){false};}, M.equals<Bool>(T.bool(true))),
            S.test("testDeleteLibrary", switch(await testDeleteLibrary()){case(#success){true};case(_){false};}, M.equals<Bool>(T.bool(true))),
            S.test("testRedeemedCantSell", switch(await testRedeemedCantSell()){case(#success){true};case(_){false};}, M.equals<Bool>(T.bool(true))),

            
            
            ]);
        S.run(suite);

        return #success;
    };

    public shared func testDataInterface() : async {#success; #fail : Text} {
        //D.print("running testDataInterface");

        let a_wallet = await TestWalletDef.test_wallet();
        let b_wallet = await TestWalletDef.test_wallet();
        

        let newPrincipal = await g_canister_factory.create({
            owner = Principal.fromActor(this);
            storage_space = null;
        });

        let canister : Types.Service =  actor(Principal.toText(newPrincipal));

                let standardStage = await utils.buildStandardNFT("1", canister, Principal.fromActor(this), 1024, false, Principal.fromActor(this));
        //D.print("Minting");
        let mint_attempt = await canister.mint_nft_origyn("1", #principal(Principal.fromActor(a_wallet)));

        //try to get public data DATA0001
        //try to get private data DATA0002
        let getNFTAttempt = await b_wallet.try_get_nft(Principal.fromActor(canister),"1");
        let new_data = #Class([
                    {name = Types.metadata.__apps_app_id; value=#Text("com.test.__public"); immutable= true},
                    {name = "read"; value=#Text("public");
                        immutable=false;},
                    {name = "write"; value=#Class([
                        {name = "type"; value=#Text("allow"); immutable= false},
                        {name = "list"; value=#Array([#Principal(Principal.fromActor(this))]);
                        immutable=false;}]);
                        immutable=false;},
                    {name = "permissions"; value=#Class([
                        {name = "type"; value=#Text("allow"); immutable= false},
                        {name = "list"; value=#Array([#Principal(Principal.fromActor(this))]);
                        immutable=false;}]);
                    immutable=false;},
                    {name = "data"; value=#Class([
                        {name = "val1"; value=#Text("val1-modified"); immutable= false},
                        {name = "val2"; value=#Text("val2-modified"); immutable= false},
                        {name = "val3"; value=#Class([
                            {name = "data"; value=#Text("val3-modified"); immutable= false},
                            {name = "read"; value=#Text("public");
                            immutable=false;},
                            {name = "write"; value=#Class([
                                {name = "type"; value=#Text("allow"); immutable= false},
                                {name = "list"; value=#Array([#Principal(Principal.fromActor(this))]);
                                immutable=false;}]);
                            immutable=false;}]);
                        immutable=false;},
                        {name = "val4"; value=#Class([
                            {name = "data"; value=#Text("val4-modified"); immutable= false},
                            {name = "read"; value=#Class([
                                {name = "type"; value=#Text("allow"); immutable= false},
                                {name = "list"; value=#Array([#Principal(Principal.fromActor(this))]);
                                immutable=false;}]);
                            immutable=false;},
                            {name = "write"; value=#Class([
                                {name = "type"; value=#Text("allow"); immutable= false},
                                {name = "list"; value=#Array([#Principal(Principal.fromActor(this))]);
                                immutable=false;}]);
                            immutable=false;}]);
                        immutable=false;}]);
                    immutable=false;}
                    ]);
        //DATA0010
        let setNFTAttemp_fail = await b_wallet.try_set_nft(Principal.fromActor(canister),"1", new_data);
        
        //DATA0012
        //D.print("should be sucessful");
        let setNFTAttemp = await canister.update_app_nft_origyn(#replace{token_id= "1"; data = new_data});
        //D.print(debug_show(setNFTAttemp));


        

        let getNFTAttempt2 = await b_wallet.try_get_nft(Principal.fromActor(canister),"1");
        //D.print(debug_show(getNFTAttempt2));

        //D.print("have meta");
        let suite = S.suite("test staged Nft", [

            S.test("test getNFT Attempt", switch(getNFTAttempt){case(#ok(res)){
                
                switch(Properties.getClassPropertyShared(res.metadata, Types.metadata.__apps)){
                    case(?app){
                        //D.print("have app");
                        switch(app.value){
                            case(#Array(val)){
                                //D.print("have val");
                                
                                var b_foundPublic = false;
                                var b_foundPrivate = false;
                                var b_foundVal3 = false;
                                var b_foundVal4 = false;
                                //D.print("have classes");
                                for(this_item in Iter.fromArray<CandyTypes.CandyShared>(val)){
                                    //D.print("checking");
                                    //D.print(debug_show(val));
                                    let a_app : CandyTypes.PropertyShared = Option.get<CandyTypes.PropertyShared>(Properties.getClassPropertyShared(this_item,Types.metadata.__apps_app_id), {immutable = false; name="app"; value =#Text("")});
                                    //D.print("have a_app");
                                    //D.print(debug_show(a_app));
                                    //DATA0001
                                    if(Conversions.candySharedToText(a_app.value) == "com.test.__public"){
                                        b_foundPublic := true;
                                        //try to find val3 which should be hidden
                                        //D.print("looking for val3");
                                        let a_data : CandyTypes.PropertyShared = Option.get<CandyTypes.PropertyShared>(Properties.getClassPropertyShared(this_item,"data"), {immutable = false; name="data"; value =#Text("")});
                                        //D.print("have a data");
                                        //D.print(debug_show(a_data));
                                        let a_val : CandyTypes.PropertyShared = Option.get<CandyTypes.PropertyShared>(Properties.getClassPropertyShared(a_data.value,"val3"), {immutable = false; name="data"; value =#Text("")});
                                        let a_val2 : CandyTypes.PropertyShared = Option.get<CandyTypes.PropertyShared>(Properties.getClassPropertyShared(a_data.value,"val4"), {immutable = false; name="data"; value =#Text("")});
                                        //D.print("have a val");
                                        switch(a_val.value){
                                            case(#Class(valInfo)){
                                                let a_data_data : CandyTypes.PropertyShared = Option.get<CandyTypes.PropertyShared>(Properties.getClassPropertyShared(a_val.value,"data"), {immutable = false; name="data"; value =#Text("")});
                                                //D.print("have a data data");
                                                
                                                if(Conversions.candySharedToText(a_data_data.value) == "val3"){
                                                    //D.print("found it");
                                                    b_foundVal3 := true;
                                                } else {
                                                    //D.print("didn't find it");
                                                }
                                            };
                                            case(_){

                                            };
                                        };
                                        switch(a_val2.value){
                                            case(#Class(valInfo)){
                                                let a_data_data : CandyTypes.PropertyShared = Option.get<CandyTypes.PropertyShared>(Properties.getClassPropertyShared(a_val2.value,"data"), {immutable = false; name="data"; value =#Text("")});
                                                //D.print("have a data data");
                                                
                                                if(Conversions.candySharedToText(a_data_data.value) == "val4"){
                                                    //D.print("found it");
                                                    b_foundVal3 := true;
                                                } else {
                                                    //D.print("didn't find it");
                                                }
                                            };
                                            case(_){

                                            };
                                        };
                                    };
                                    //DATA0002
                                    if(Conversions.candySharedToText(a_app.value) == "com.test.__private"){
                                        b_foundPrivate := true;
                                    }
                                };

                            
                                switch(b_foundPublic, b_foundPrivate, b_foundVal3, b_foundVal4){
                                    case(true, false, true, false){
                                        "correct response";
                                    };
                                    case(_,_,_,_){
                                        "something missing or something extra";
                                    };
                                };

                                   
                            };
                            case(_){
                                "not an array";
                            };
                        
                        };
                    };
                    case(null){
                        "can't find app";
                    };
                };
            };case(#err(err)){"unexpected error: " # err.flag_point};}, M.equals<Text>(T.text("correct response"))), //DATA0001, DATA0002
            S.test("fail if non allowed calls write", switch(setNFTAttemp_fail){case(#ok(res)){"unexpected success"};case(#err(err)){
                if(err.number == 2000){ //unauthorized
                    "correct number"
                } else{
                    "wrong error " # debug_show(err);
                }};}, M.equals<Text>(T.text("correct number"))), //DATA0010
            S.test("allowed user can write", switch(getNFTAttempt2){case(#ok(res)){
                
                switch(Properties.getClassPropertyShared(res.metadata, Types.metadata.__apps)){
                    case(?app){
                        //D.print("have app");
                        switch(app.value){
                            case(#Array(val)){
                                //D.print("have val");
                                
                              var b_foundPublic = false;
                              var b_foundPrivate = false;
                              var b_foundVal3 = false;
                              var b_foundVal4 = false;
                              //D.print("have classes");
                              for(this_item in Iter.fromArray<CandyTypes.CandyShared>(val)){
                                  //D.print("checking");
                                  //D.print(debug_show(val));
                                  let a_app : CandyTypes.PropertyShared = Option.get<CandyTypes.PropertyShared>(Properties.getClassPropertyShared(this_item, Types.metadata.__apps_app_id), {immutable = false; name="app"; value =#Text("")});
                                  //D.print("have a_app");
                                  //D.print(debug_show(a_app));
                                  //DATA0001
                                  if(Conversions.candySharedToText(a_app.value) == "com.test.__public"){
                                      b_foundPublic := true;
                                      //try to find val3 which should be hidden
                                      //D.print("looking for val3");
                                      let a_data : CandyTypes.PropertyShared = Option.get<CandyTypes.PropertyShared>(Properties.getClassPropertyShared(this_item,"data"), {immutable = false; name="data"; value =#Text("")});
                                      //D.print("have a data");
                                      //D.print(debug_show(a_data));
                                      let a_val : CandyTypes.PropertyShared = Option.get<CandyTypes.PropertyShared>(Properties.getClassPropertyShared(a_data.value,"val3"), {immutable = false; name="data"; value =#Text("")});
                                      let a_val2 : CandyTypes.PropertyShared = Option.get<CandyTypes.PropertyShared>(Properties.getClassPropertyShared(a_data.value,"val4"), {immutable = false; name="data"; value =#Text("")});
                                      //D.print("have a val");
                                      switch(a_val.value){
                                          case(#Class(valInfo)){
                                              let a_data_data : CandyTypes.PropertyShared = Option.get<CandyTypes.PropertyShared>(Properties.getClassPropertyShared(a_val.value,"data"), {immutable = false; name="data"; value =#Text("")});
                                              //D.print("have a data data");
                                              
                                              if(Conversions.candySharedToText(a_data_data.value) == "val3-modified"){
                                                  //D.print("found it");
                                                  b_foundVal3 := true;
                                              } else {
                                                  //D.print("didn't find it");
                                              }
                                          };
                                          case(_){

                                          };
                                      };
                                      switch(a_val2.value){
                                          case(#Class(valInfo)){
                                              let a_data_data : CandyTypes.PropertyShared = Option.get<CandyTypes.PropertyShared>(Properties.getClassPropertyShared(a_val2.value,"data"), {immutable = false; name="data"; value =#Text("")});
                                              //D.print("have a data data");
                                              
                                              if(Conversions.candySharedToText(a_data_data.value) == "val4-modified"){
                                                  //D.print("found it");
                                                  b_foundVal3 := true;
                                              } else {
                                                  //D.print("didn't find it");
                                              }
                                          };
                                          case(_){

                                          };
                                      };
                                  };
                                  //DATA0002
                                  if(Conversions.candySharedToText(a_app.value) == "com.test.__private"){
                                      b_foundPrivate := true;
                                  }
                              };

                          
                              switch(b_foundPublic, b_foundPrivate, b_foundVal3, b_foundVal4){
                                  case(true, false, true, false){
                                      "correct response";
                                  };
                                  case(_,_,_,_){
                                      "something missing or something extra";
                                  };
                              };

                                    
                            };
                            case(_){
                                "not an array";
                            };
                        
                        };
                    };
                    case(null){
                        "can't find app";
                    };
                };
            };case(#err(err)){"unexpected error: " # err.flag_point};}, M.equals<Text>(T.text("correct response"))), //DATA0012
            
            
        ]);

        S.run(suite);

        return #success;
        
          

    };


    public shared func testImmutableLibrary() : async {#success; #fail : Text} {
        //D.print("running testDataInterface");

        let a_wallet = await TestWalletDef.test_wallet();
        let b_wallet = await TestWalletDef.test_wallet();
        

        let newPrincipal = await g_canister_factory.create({
            owner = Principal.fromActor(this);
            storage_space = null;
        });

        let canister : Types.Service =  actor(Principal.toText(newPrincipal));

                let standardStage = await utils.buildStandardNFT("1", canister, Principal.fromActor(this), 1024, false, Principal.fromActor(this));
        //attempt to change the metadata of a library before mint

        let reStageLibrary = await canister.stage_library_nft_origyn(
          {
            token_id = "1";
            library_id = "immutable_item";
            filedata  = #Class([
              {name = "library_id"; value=#Text("immutable_item"); immutable= true},
              {name = "title"; value=#Text("immutable-updated"); immutable= true},
              {name = "location_type"; value=#Text("canister"); immutable= true},
              {name = "location"; value=#Text("http://localhost:8000/-/1/-/immutable_item?canisterId="); immutable= true},
              {name = "content_type"; value=#Text("text/html; charset=UTF-8"); immutable= true},
              {name = "content_hash"; value=#Bytes([0,0,0,0]); immutable= true},
              {name = "size"; value=#Nat(40); immutable= true},
              {name = "sort"; value=#Nat(0); immutable= true},
              {name = "read"; value=#Text("public");immutable=false;},
              {name = "com.origyn.immutable_library"; value=#Bool(true);immutable=false;},
            ]);
            chunk = 0;
            content = Blob.fromArray([]);// content = #Bytes(nat8array);
          }
        );
        
        D.print("reStageLibrary:" # debug_show(reStageLibrary));
        

        //D.print("Minting");
        let mint_attempt = await canister.mint_nft_origyn("1", #principal(Principal.fromActor(a_wallet)));

        //attempt to change the metadata of a library before mint
        D.print("mint_attempt:" # debug_show(mint_attempt));

        let reStageLibrary_after_mint = await canister.stage_library_nft_origyn(
          {
            token_id = "1";
            library_id = "immutable_item";
            filedata  = #Class([
              {name = "library_id"; value=#Text("immutable_item"); immutable= true},
              {name = "title"; value=#Text("immutable-updated-2"); immutable= true},
              {name = "location_type"; value=#Text("canister"); immutable= true},
              {name = "location"; value=#Text("http://localhost:8000/-/1/-/immutable_item?canisterId="); immutable= true},
              {name = "content_type"; value=#Text("text/html; charset=UTF-8"); immutable= true},
              {name = "content_hash"; value=#Bytes([0,0,0,0]); immutable= true},
              {name = "size"; value=#Nat(40); immutable= true},
              {name = "sort"; value=#Nat(0); immutable= true},
              {name = "read"; value=#Text("public");immutable=false;},
              {name = "com.origyn.immutable_library"; value=#Bool(true);immutable=false;},
            ]);
            chunk = 0;
            content = Blob.fromArray([]);// content = #Bytes(nat8array);
          }
        );

        D.print("reStageLibrary_after_mint:" # debug_show(reStageLibrary_after_mint));

        let getNFTAttempt = await b_wallet.try_get_nft(Principal.fromActor(canister),"1");
        
        D.print("getNFTAttempt:" # debug_show(getNFTAttempt));


        
        //D.print("have meta");
        let suite = S.suite("testImmutable", [

            S.test("reStageLibrary should succeed", switch(reStageLibrary){case(#ok(res)){
                
               "correct response";
            };case(#err(err)){"unexpected error: " # err.flag_point};}, M.equals<Text>(T.text("correct response"))), 
            S.test("fail if already minted", switch(reStageLibrary_after_mint){case(#ok(res)){"unexpected success " # debug_show(res)};case(#err(err)){
                if(err.number == 1000){ //update class error
                    "correct number"
                } else{
                    "wrong error " # debug_show(err);
                }};}, M.equals<Text>(T.text("correct number"))), //DATA0010
            S.test("Data is correct", switch(getNFTAttempt){case(#ok(res)){
                
                switch(Properties.getClassPropertyShared(res.metadata, Types.metadata.library)){
                    case(?library){
                        //D.print("have app");
                        switch(library.value){
                            case(#Array(val)){
                                //D.print("have val");
                                
                                var b_found_immutable : Bool = false;
                                var b_found_updated : Bool = false;
                                //D.print("have classes");
                                for(this_item in Iter.fromArray<CandyTypes.CandyShared>(val)){
                                    //D.print("checking");
                                    //D.print(debug_show(classes));
                                    let a_app : CandyTypes.PropertyShared = Option.get<CandyTypes.PropertyShared>(Properties.getClassPropertyShared(this_item, Types.metadata.library_id), {immutable = false; name="library_id"; value =#Text("")});
                                    //D.print("have a_app");
                                    //D.print(debug_show(a_app));
                                    //DATA0001
                                    if(Conversions.candySharedToText(a_app.value) == "immutable_item"){
                                        b_found_immutable := true;
                                        //try to find val3 which should be hidden
                                        //D.print("looking for val3");
                                        let title_data : CandyTypes.PropertyShared = Option.get<CandyTypes.PropertyShared>(Properties.getClassPropertyShared(this_item,"title"), {immutable = false; name="title"; value =#Text("")});
                                        
                                        if(Conversions.candySharedToText(title_data.value) == "immutable-updated"){
                                          b_found_updated := true;
                                        };
                                        
                                    };
                                    
                                };

                            
                                switch(b_found_immutable, b_found_updated){
                                    case(true, true){
                                        "correct response";
                                    };
                                    case(_,_){
                                        "something missing or something extra";
                                    };
                                };

                            
                            };
                            case(_){
                                "not an array";
                            };
                        
                        };
                    };
                    case(null){
                        "can't find library";
                    };
                };
            };case(#err(err)){"unexpected error: " # err.flag_point};}, M.equals<Text>(T.text("correct response"))), //DATA0012
            
            
        ]);

        S.run(suite);

        return #success;

    };


    public shared func testDeleteLibrary() : async {#success; #fail : Text} {
        //D.print("running testDataInterface");

        let a_wallet = await TestWalletDef.test_wallet();
        let b_wallet = await TestWalletDef.test_wallet();
        

        let newPrincipal = await g_canister_factory.create({
            owner = Principal.fromActor(this);
            storage_space = null;
        });

        let canister : Types.Service =  actor(Principal.toText(newPrincipal));

                let standardStage = await utils.buildStandardNFT("1", canister, Principal.fromActor(this), 1024, false, Principal.fromActor(this));
        //attempt to delete page before minting

        let deletePage = await canister.stage_library_nft_origyn(
          {
            token_id = "1";
            library_id = "page";
            filedata  = #Bool(false);
            chunk = 0;
            content = Blob.fromArray([]);// content = #Bytes(nat8array);
          }
        );
        
        D.print("deletePage:" # debug_show(deletePage));
        

        //D.print("Minting");
        let mint_attempt = await canister.mint_nft_origyn("1", #principal(Principal.fromActor(a_wallet)));

        //attempt to delete preview after mint
        D.print("mint_attempt:" # debug_show(mint_attempt));

        let deletePreview = await canister.stage_library_nft_origyn(
          {
            token_id = "1";
            library_id = "preview";
            filedata  = #Bool(false);
            chunk = 0;
            content = Blob.fromArray([]);// content = #Bytes(nat8array);
          }
        );
        D.print("deletePreview:" # debug_show(deletePreview));


        

        let deleteImmutable = await canister.stage_library_nft_origyn(
          {
            token_id = "1";
            library_id = "immutable_item";
            filedata  = #Bool(false);
            chunk = 0;
            content = Blob.fromArray([]);// content = #Bytes(nat8array);
          }
        );

        //attempt to delete preview after mint
        D.print("deleteImmutable:" # debug_show(deleteImmutable));


        let getNFTAttempt = await b_wallet.try_get_nft(Principal.fromActor(canister),"1");
        
        D.print("getNFTAttempt:" # debug_show(getNFTAttempt));


        
        //D.print("have meta");
        let suite = S.suite("testDeleteLibrary", [

            S.test("delete page succeed", switch(deletePage){case(#ok(res)){
                
               "correct response";
            };case(#err(err)){"unexpected error: " # err.flag_point};}, M.equals<Text>(T.text("correct response"))), 
            S.test("delete preview succeed", switch(deletePreview){case(#ok(res)){
                
               "correct response";
            };case(#err(err)){"unexpected error: " # err.flag_point};}, M.equals<Text>(T.text("correct response"))), 
            S.test("deleteImmutable should fail", switch(deleteImmutable){case(#ok(res)){"unexpected success " # debug_show(res)};case(#err(err)){
                if(err.number == 1000){ //update class error
                    "correct number"
                } else{
                    "wrong error " # debug_show(err);
                }};}, M.equals<Text>(T.text("correct number"))), //DATA0010
            S.test("Data is correct", switch(getNFTAttempt){case(#ok(res)){
                
                switch(Properties.getClassPropertyShared(res.metadata, Types.metadata.library)){
                    case(?library){
                        //D.print("have app");
                        switch(library.value){
                            case(#Array(val)){
                                //D.print("have val");
                        
                                var b_found_page : Bool = false;
                                var b_found_preview : Bool = false;
                                var b_found_immutable : Bool = false;
                                //D.print("have classes");
                                for(this_item in Iter.fromArray<CandyTypes.CandyShared>(val)){
                                    
                                    let a_app : CandyTypes.PropertyShared = Option.get<CandyTypes.PropertyShared>(Properties.getClassPropertyShared(this_item, Types.metadata.library_id), {immutable = false; name="library_id"; value =#Text("")});

                                    if(Conversions.candySharedToText(a_app.value) == "immutable_item"){
                                        b_found_immutable := true;
                                    };
                                    if(Conversions.candySharedToText(a_app.value) == "page"){
                                        b_found_page := true;
                                    };
                                    if(Conversions.candySharedToText(a_app.value) == "preview"){
                                        b_found_preview := true;
                                    };
                                    
                                };

                            
                                switch(b_found_immutable, b_found_page, b_found_preview){
                                    case(true, false, false){
                                        "correct response";
                                    };
                                    case(_,_,_){
                                        "something missing or something extra " # debug_show((b_found_immutable, b_found_page, b_found_preview));
                                    };
                                };

                            
                            };
                            case(_){
                                "not an array";
                            };
                        
                        };
                    };
                    case(null){
                        "can't find library";
                    };
                };
            };case(#err(err)){"unexpected error: " # err.flag_point};}, M.equals<Text>(T.text("correct response"))), //DATA0012
            
            
        ]);

        S.run(suite);

        return #success;

    };

    public shared func testRewriteLibrary() : async {#success; #fail : Text} {
        //D.print("running testDataInterface");

        let a_wallet = await TestWalletDef.test_wallet();
        let b_wallet = await TestWalletDef.test_wallet();
        

        let newPrincipal = await g_canister_factory.create({
            owner = Principal.fromActor(this);
            storage_space = null;
        });

        let canister : Types.Service =  actor(Principal.toText(newPrincipal));

        let standardStage = await utils.buildStandardNFT("1", canister, Principal.fromActor(this), 1024, false, Principal.fromActor(this));

        //attempt to delete page before minting

        let deletePage = await canister.stage_library_nft_origyn(
          {
            token_id = "1";
            library_id = "page";
            filedata  = #Bool(false);
            chunk = 0;
            content = Blob.fromArray([]);// content = #Bytes(nat8array);
          }
        );
        
        D.print("deletePage:" # debug_show(deletePage));

        //let stage = await canister.stage_nft_origyn(utils.standardNFT("1", Principal.fromActor(canister), Principal.fromActor(this), 1024, false, Principal.fromActor(this)));
        let fileStage = await canister.stage_library_nft_origyn(utils.standardFileChunk("1","page","hello world replace larger", #Class([
                    {name = "library_id"; value=#Text("page"); immutable= true},
                    {name = "title"; value=#Text("page"); immutable= true},
                    {name = "location_type"; value=#Text("canister"); immutable= true},// ipfs, arweave, portal
                    {name = "location"; value=#Text("http://localhost:8000/-/1/-/page?canisterId=" # Principal.toText(Principal.fromActor(canister))); immutable= true},
                    {name = "content_type"; value=#Text("text/html; charset=UTF-8"); immutable= true},
                    {name = "content_hash"; value=#Bytes([0,0,0,0]); immutable= true},
                    {name = "size"; value=#Nat(1025); immutable= true},
                    {name = "sort"; value=#Nat(0); immutable= true},
                    {name = "read"; value=#Text("public"); immutable=false;},
                ])));

        let deletePage2 = await canister.stage_library_nft_origyn(
          {
            token_id = "1";
            library_id = "page";
            filedata  = #Bool(false);
            chunk = 0;
            content = Blob.fromArray([]);// content = #Bytes(nat8array);
          }
        );


        
        D.print("deletePage2:" # debug_show(deletePage2));

        let fileStage2 = await canister.stage_library_nft_origyn(utils.standardFileChunk("1","page","hello world replace smaller", #Class([
                    {name = "library_id"; value=#Text("page"); immutable= true},
                    {name = "title"; value=#Text("page"); immutable= true},
                    {name = "location_type"; value=#Text("canister"); immutable= true},// ipfs, arweave, portal
                    {name = "location"; value=#Text("http://localhost:8000/-/1/-/page?canisterId=" # Principal.toText(Principal.fromActor(canister))); immutable= true},
                    {name = "content_type"; value=#Text("text/html; charset=UTF-8"); immutable= true},
                    {name = "content_hash"; value=#Bytes([0,0,0,0]); immutable= true},
                    {name = "size"; value=#Nat(1023); immutable= true},
                    {name = "sort"; value=#Nat(0); immutable= true},
                    {name = "read"; value=#Text("public"); immutable=false;},
                ])));

        
        let getNFTAttempt = await canister.nft_origyn("1");
        
        D.print("getNFTAttempt:" # debug_show(getNFTAttempt));


        
        //D.print("have meta");
        let suite = S.suite("testRewriteLibrary", [

            
            S.test("delete page succeed", switch(deletePage){case(#ok(res)){
                
               "correct response";
            };case(#err(err)){"unexpected error: " # err.flag_point};}, M.equals<Text>(T.text("correct response"))), 
            S.test("delete page 2 succeed", switch(deletePage2){case(#ok(res)){
                
               "correct response";
            };case(#err(err)){"unexpected error: " # err.flag_point};}, M.equals<Text>(T.text("correct response"))), 
           
            S.test("Data is correct", switch(getNFTAttempt){case(#ok(res)){
                
                switch(Properties.getClassPropertyShared(res.metadata, Types.metadata.library)){
                    case(?library){
                        //D.print("have app");
                        switch(library.value){
                            case(#Array(val)){
                                
                              var b_found_page : Bool = false;
                              //D.print("have classes");
                              for(this_item in Iter.fromArray<CandyTypes.CandyShared>(val)){
                                  
                                  let a_app : CandyTypes.PropertyShared = Option.get<CandyTypes.PropertyShared>(Properties.getClassPropertyShared(this_item, Types.metadata.library_id), {immutable = false; name="library_id"; value =#Text("")});

                                  
                                  if(Conversions.candySharedToText(a_app.value) == "page"){
                                      b_found_page := true;
                                  };

                                  
                              };

                          
                              switch(b_found_page){
                                  case(true){
                                      "correct response";
                                  };
                                  case(_){
                                      "something missing or something extra " # debug_show((b_found_page));
                                  };
                              };

                          
                            };
                            case(_){
                                "not an array";
                            };
                        
                        };
                    };
                    case(null){
                        "can't find library";
                    };
                };
            };case(#err(err)){"unexpected error: " # err.flag_point};}, M.equals<Text>(T.text("correct response"))), //DATA0012
            
            
        ]);

        S.run(suite);

        return #success;

    };

        public shared func testRedeemedCantSell() : async { #success; #fail : Text } {
        D.print("running Redeemed cant sell");

        let dfx : DFXTypes.Service = actor (Principal.toText(dfx_ledger));

        let dfx2 : DFXTypes.Service = actor (Principal.toText(dfx_ledger2));

        let a_wallet = await TestWalletDef.test_wallet();
        let b_wallet = await TestWalletDef.test_wallet();
        
        let funding_result_a = await dfx.icrc1_transfer({
            to =  {owner = Principal.fromActor(a_wallet); subaccount = null};
            fee = ?200_000;
            memo = utils.memo_one;
            from_subaccount = null;
            created_at_time = null;
            amount =  1000 * 10 ** 8;});
            
            
        let funding_result_b =  await dfx.icrc1_transfer({
            to =  {owner = Principal.fromActor(b_wallet); subaccount = null};
            fee = ?200_000;
            memo = utils.memo_one;
            from_subaccount = null;
            created_at_time = null;
            amount =  1000 * 10 ** 8;});

        let funding_result_b2 = await dfx2.icrc1_transfer({
            to =  {owner = Principal.fromActor(b_wallet); subaccount = null};
            fee = ?200_000;
            memo = utils.memo_one;
            from_subaccount = null;
            created_at_time = null;
            amount =  1000 * 10 ** 8;}); 

        D.print("funding result b2 " # debug_show (funding_result_b2));

        let newPrincipal = await g_canister_factory.create({
            owner = Principal.fromActor(this);
            storage_space = null;
        });

        let initialOwnerBalance = await dfx.icrc1_balance_of( {owner = Principal.fromActor(this); subaccount = null});

        D.print("initialOwnerBalance = " # debug_show(initialOwnerBalance)); 

        let canister : Types.Service = actor (Principal.toText(newPrincipal));

        let mode = canister.__set_time_mode(#test);
        let atime = canister.__advance_time(Time.now());

        let updateNetwork = canister.collection_update_nft_origyn(#UpdateNetwork(?Principal.fromActor(this)));

        let standardStage = await utils.buildStandardNFT("1", canister, Principal.fromActor(this), 1024, false, Principal.fromActor(this)); //for auctioning a minted item
        let standardStage2 = await utils.buildStandardNFT("2", canister, Principal.fromActor(this), 1024, false, Principal.fromActor(this)); //for auctioning an unminted item

        //set items to phisical
        let setNFTAttempt1 = await canister.governance_nft_origyn(#update_system_var({
          token_id = "1";
          key = Types.metadata.__system_physical;
          val = #Bool(true);
        }));

        let setNFTAttempt2 = await canister.governance_nft_origyn(#update_system_var({
          token_id = "2";
          key = Types.metadata.__system_physical;
          val = #Bool(true);
        }));

        D.print("setNFTAttempt1 " # debug_show ((setNFTAttempt1, setNFTAttempt2)));
        

        D.print("Minting");
        let mint_attempt = await canister.mint_nft_origyn("1", #principal(Principal.fromActor(this))); //mint to the test account
        let mint_attempt2 = await canister.mint_nft_origyn("2", #principal(Principal.fromActor(this))); //mint to the test account

        D.print("start auction fail " # debug_show ((mint_attempt, mint_attempt2)));
        

        D.print("start auction owner");
        let option_buffer = Buffer.fromArray<MigrationTypes.Current.AskFeature>([
                    #reserve(100 * 10 ** 8),
                    #token(#ic({
                      canister = Principal.fromActor(dfx);
                      standard =  #Ledger;
                      decimals = 8;
                      symbol = "LDG";
                      fee = ?200000;
                      id = null;
                    })),
                    #buy_now(500 * 10 ** 8),
                    #start_price(1 * 10 ** 8),
                    #ending(#date(get_time() + DAY_LENGTH)),
                    #min_increase(#amount(10*10**8)),
                    #notify([Principal.fromActor(a_wallet),
                    Principal.fromActor(b_wallet)])
                ]);
        //start an auction by owner
        let start_auction_attempt_owner = await canister.market_transfer_nft_origyn({
            token_id = "1";
            sales_config = {
                escrow_receipt = null;
                broker_id = null;
                pricing = #ask (?Buffer.toArray<MigrationTypes.Current.AskFeature>(option_buffer));
            };
        });

        D.print("start_auction_attempt_owner" # debug_show(start_auction_attempt_owner));

        //above should fail due to phisical item

        //put the item in escrow and try again

        let setNFTAttempt3 = await canister.governance_nft_origyn(#update_system_var({
          token_id = "1";
          key = Types.metadata.__system_escrowed;
          val = #Bool(true);
        }));

         D.print("setNFTAttempt3" # debug_show(setNFTAttempt3));

        let setNFTAttempt6 = await canister.governance_nft_origyn(#update_system_var({
          token_id = "2";
          key = Types.metadata.__system_escrowed;
          val = #Bool(true);
        }));


         D.print("setNFTAttempt6" # debug_show(setNFTAttempt6));


        //start an auction by owner
        let start_auction_attempt_owner2 = await canister.market_transfer_nft_origyn({
            token_id = "1";
            sales_config = {
                escrow_receipt = null;
                broker_id = null;
                pricing = #ask (?Buffer.toArray<MigrationTypes.Current.AskFeature>(option_buffer));
            };
        });



         D.print("start_auction_attempt_owner2" # debug_show(start_auction_attempt_owner2));

        D.print("get sale id " # debug_show (start_auction_attempt_owner2));
        let current_sales_id = switch (start_auction_attempt_owner2) {
            case (#ok(val)) {
                switch (val.txn_type) {
                    case (#sale_opened(sale_data)) {
                        sale_data.sale_id;
                    };
                    case (_) {
                        D.print("Didn't find expected sale_opened");
                        return #fail("Didn't find expected sale_opened");
                    };
                };

            };
            case (#err(item)) {
                D.print("error with auction start");
                return #fail("error with auction start");
            };
        };

       let active_sale_info_1 = await canister.sale_info_nft_origyn(#active(null));

        D.print("active_sale_info_1" # debug_show(active_sale_info_1));

        //force a round?

        let aRandom = await TestWalletDef.test_wallet();

        let aRandom2 = await TestWalletDef.test_wallet();
        let aRandom3 = await TestWalletDef.test_wallet();
        let aRandom4 = await TestWalletDef.test_wallet();


        //set redeemed and sale should be closed

        let setNFTAttempt4 = await canister.governance_nft_origyn(#update_system_var({
          token_id = "1";
          key = Types.metadata.__system_redeemed;
          val = #Bool(true);
        }));


        D.print("setNFTAttempt4 " # debug_show(setNFTAttempt4));

        let aRandom5 = await TestWalletDef.test_wallet();

        let aRandom6 = await TestWalletDef.test_wallet();
        let aRandom7 = await TestWalletDef.test_wallet();
        let aRandom8 = await TestWalletDef.test_wallet();


        let saleStatus = await canister.sale_info_nft_origyn(#status(current_sales_id));

        D.print("the sale is");
        D.print(debug_show (saleStatus));


        //now try to set sell the item againa and it shoudl fail

        let start_auction_attempt_owner3 = await canister.market_transfer_nft_origyn({
            token_id = "1";
            sales_config = {
                escrow_receipt = null;
                broker_id = null;
                pricing = #ask (?Buffer.toArray<MigrationTypes.Current.AskFeature>(option_buffer));
            };
        });

        D.print("start_auction_attempt_owner3" # debug_show(start_auction_attempt_owner2));


        //force a round?

        let aRandom9 = await TestWalletDef.test_wallet();

        let aRandom10 = await TestWalletDef.test_wallet();
        let aRandom11 = await TestWalletDef.test_wallet();
        let aRandom12 = await TestWalletDef.test_wallet();

        //make an auction that is open and can't be settled:

        let option_buffer2 = Buffer.fromArray<MigrationTypes.Current.AskFeature>([
                    #reserve(100 * 10 ** 8),
                    #token(#ic({
                      canister = Principal.fromActor(dfx);
                      standard =  #Ledger;
                      decimals = 8;
                      symbol = "LDG";
                      fee = ?200000;
                      id = null;
                    })),
                    #start_price(1 * 10 ** 8),
                    #ending(#date(get_time() + DAY_LENGTH)),
                    #min_increase(#amount(10*10**8)),
                    
                ]);
        //start an auction by owner
        let start_auction_attempt_owner4 = await canister.market_transfer_nft_origyn({
            token_id = "2";
            sales_config = {
                escrow_receipt = null;
                broker_id = null;
                pricing = #ask (?Buffer.toArray<MigrationTypes.Current.AskFeature>(option_buffer2));
            };
        });

        let atime2 = canister.__advance_time(Time.now() + 10);

        let aRandom13 = await TestWalletDef.test_wallet();
        let aRandom14 = await TestWalletDef.test_wallet();
        let aRandom15 = await TestWalletDef.test_wallet();

         D.print("start_auction_attempt_owner4 " # debug_show (start_auction_attempt_owner4));
        //place bid

        //claiming first escrow
        let a_wallet_try_escrow_general_staged = await a_wallet.send_ledger_escrow(Principal.fromActor(dfx), 
          {
            token = #ic({
                        canister = Principal.fromActor(dfx);
                        standard =  #Ledger;
                        decimals = 8;
                        symbol = "LDG";
                        fee = ?200000;
                        id = null;
                      });
            seller = #principal(Principal.fromActor(this));
            buyer = #principal(Principal.fromActor(a_wallet));
            token_id = "2";
            amount = 1 * 10 ** 8
          },  Principal.fromActor(canister));

          D.print("a_wallet_try_escrow_general_staged " # debug_show (a_wallet_try_escrow_general_staged));

          let current_sales_id2 = switch (start_auction_attempt_owner4) {
            case (#ok(val)) {
                switch (val.txn_type) {
                    case (#sale_opened(sale_data)) {
                        sale_data.sale_id;
                    };
                    case (_) {
                        D.print("Didn't find expected sale_opened");
                        return #fail("Didn't find expected sale_opened");
                    };
                };

            };
            case (#err(item)) {
                D.print("error with auction start");
                return #fail("error with auction start");
            };
        };


        let a_wallet_try_bid_valid = await a_wallet.try_bid(Principal.fromActor(canister), Principal.fromActor(this), Principal.fromActor(dfx), 1 * 10 ** 8, "2", current_sales_id2, null, null);

        D.print("a_wallet_try_bid_valid " # debug_show (a_wallet_try_bid_valid));

        //should fail due to open bid and no buy now
        let setNFTAttempt7 = await canister.governance_nft_origyn(#update_system_var({
          token_id = "2";
          key = Types.metadata.__system_redeemed;
          val = #Bool(true);
        }));


        

        let suite = S.suite(
            "test reddemed Nft",
            [

                S.test(
                    "test physical cant be sold",
                    switch (start_auction_attempt_owner) {
                        case (#err(err)) {
                            if (err.number == 4_009) {
                                //physical item
                                "correct response";
                            } else {
                                "wrong error " # debug_show (err);
                            };
                            

                        };
                        case (#ok(val)) {
                            "unexpected error: " # debug_show(start_auction_attempt_owner);
                        };
                    },
                    M.equals<Text>(T.text("correct response")),
                ),
                S.test(
                    "item in escrow can be sold",
                    switch (start_auction_attempt_owner2) {
                        case (#ok(res)) { "expected" };
                        case (#err(err)) {
                                "wrong error " # debug_show (err);
                        };
                    },
                    M.equals<Text>(T.text("expected")),
                ), //MKT0019
                
               
                S.test(
                    "redeemeing cancels sale if no bids",
                    switch (saleStatus) {
                        case (#ok(#status(?res))) {
                          switch(res.sale_type){
                              case(#auction(val)){
                                if(val.status == #closed){
                                    "correct response";
                                } else {
                                    "wrong sale type" # debug_show (saleStatus);
                                };
                              };
                              case(_){
                                  "wrong sale type" # debug_show (saleStatus);
                              };
                          };
                        };
                        case(_){
                           "wrong sale type" # debug_show (saleStatus);
                        };
                    },
                    M.equals<Text>(T.text("correct response")),
                ), //MKT0027
                S.test(
                    "redeemeing does not cancels sale if no bids",
                    switch (setNFTAttempt7) {
                        case (#err(res)) {
                          if(res.number == 4_007){
                              "correct response";
                          } else {
                              "unexpected error: " # debug_show(setNFTAttempt7);
                          };
                        };
                        case (_) {
                            "unexpected error: " # debug_show(setNFTAttempt7);
                        };
                    },
                    M.equals<Text>(T.text("correct response")),
                ), //TRX0005, MKT0033
                
         ]);

         D.print("suite running");

         S.run(suite);

          D.print("suite over");

        return #success;

    };





}