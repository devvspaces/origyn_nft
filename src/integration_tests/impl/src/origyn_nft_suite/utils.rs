use origyn_nft_reference::origyn_nft_reference_canister::{
  StageChunkArg,
  CandyShared,
  PropertyShared,
};
use candid::{ Nat, Principal };
use serde_bytes::ByteBuf;

enum TokenStandard {
  DIP20,
  Ledger,
  EXTFungible,
  ICRC1,
  Other(CandyShared),
}
struct ICTokenSpec {
  canister: Principal,
  fee: Option<Nat>,
  symbol: String,
  decimals: Nat,
  id: Option<Nat>,
  standard: TokenStandard,
}
struct TokenSpec {
  ic: ICTokenSpec,
  extensible: CandyShared,
}

struct StandardNftReturn {
  metadata: CandyShared,
}

fn standard_nft(
  token_id: String,
  canister: String,
  app: String,
  file_size: u32,
  is_soulbound: bool,
  originator: String
) -> StandardNftReturn {
  StandardNftReturn {
    metadata: CandyShared::Class(
      vec![
        PropertyShared {
          name: "id".to_string(),
          value: Box::new(CandyShared::Text(token_id)),
          immutable: true,
        },
        PropertyShared {
          name: "primary_asset".to_string(),
          value: Box::new(CandyShared::Text("page".to_string())),
          immutable: false,
        },
        PropertyShared {
          name: "preview".to_string(),
          value: Box::new(CandyShared::Text("page".to_string())),
          immutable: true,
        },
        PropertyShared {
          name: "experience".to_string(),
          value: Box::new(CandyShared::Text("page".to_string())),
          immutable: true,
        },
        PropertyShared {
          name: "library".to_string(),
          value: Box::new(
            CandyShared::Array(
              vec![
                Box::new(
                  CandyShared::Class(
                    vec![
                      PropertyShared {
                        name: "library_id".to_string(),
                        value: Box::new(CandyShared::Text("page".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "title".to_string(),
                        value: Box::new(CandyShared::Text("page".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "location_type".to_string(),
                        value: Box::new(CandyShared::Text("canister".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "location".to_string(),
                        value: Box::new(
                          CandyShared::Text(
                            format!("http://localhost:8000/-/1/-/page?canisterId={}", canister)
                          )
                        ),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "content_type".to_string(),
                        value: Box::new(CandyShared::Text("text/html; charset=UTF-8".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "content_hash".to_string(),
                        value: Box::new(CandyShared::Bytes(ByteBuf::from(vec![0, 0, 0, 0]))),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "size".to_string(),
                        value: Box::new(CandyShared::Nat(Nat::from(file_size as u32))),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "sort".to_string(),
                        value: Box::new(CandyShared::Nat(Nat::from(0 as u32))),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "read".to_string(),
                        value: Box::new(CandyShared::Text("public".to_string())),
                        immutable: false,
                      }
                    ]
                  )
                ),
                Box::new(
                  CandyShared::Class(
                    vec![
                      PropertyShared {
                        name: "library_id".to_string(),
                        value: Box::new(CandyShared::Text("preview".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "title".to_string(),
                        value: Box::new(CandyShared::Text("preview".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "location_type".to_string(),
                        value: Box::new(CandyShared::Text("canister".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "location".to_string(),
                        value: Box::new(
                          CandyShared::Text(
                            format!("http://localhost:8000/-/1/-/preview?canisterId={}", canister)
                          )
                        ),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "content_type".to_string(),
                        value: Box::new(CandyShared::Text("text/html; charset=UTF-8".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "content_hash".to_string(),
                        value: Box::new(CandyShared::Bytes(ByteBuf::from(vec![0, 0, 0, 0]))),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "size".to_string(),
                        value: Box::new(CandyShared::Nat(Nat::from(file_size as u32))),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "sort".to_string(),
                        value: Box::new(CandyShared::Nat(Nat::from(0 as u32))),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "read".to_string(),
                        value: Box::new(CandyShared::Text("public".to_string())),
                        immutable: false,
                      }
                    ]
                  )
                ),
                Box::new(
                  CandyShared::Class(
                    vec![
                      PropertyShared {
                        name: "library_id".to_string(),
                        value: Box::new(CandyShared::Text("hidden".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "title".to_string(),
                        value: Box::new(CandyShared::Text("hidden".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "location_type".to_string(),
                        value: Box::new(CandyShared::Text("canister".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "location".to_string(),
                        value: Box::new(
                          CandyShared::Text(
                            format!("http://localhost:8000/-/1/-/hidden?canisterId={}", canister)
                          )
                        ),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "content_type".to_string(),
                        value: Box::new(CandyShared::Text("text/html; charset=UTF-8".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "content_hash".to_string(),
                        value: Box::new(CandyShared::Bytes(ByteBuf::from(vec![0, 0, 0, 0]))),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "size".to_string(),
                        value: Box::new(CandyShared::Nat(Nat::from(file_size as u32))),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "sort".to_string(),
                        value: Box::new(CandyShared::Nat(Nat::from(0 as u32))),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "read".to_string(),
                        value: Box::new(CandyShared::Text("public".to_string())),
                        immutable: false,
                      }
                    ]
                  )
                ),
                Box::new(
                  CandyShared::Class(
                    vec![
                      PropertyShared {
                        name: "library_id".to_string(),
                        value: Box::new(CandyShared::Text("collection_banner".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "title".to_string(),
                        value: Box::new(CandyShared::Text("collection_banner".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "location_type".to_string(),
                        value: Box::new(CandyShared::Text("collection".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "location".to_string(),
                        value: Box::new(
                          CandyShared::Text(
                            format!("http://localhost:8000/-/1/-/collection_banner?canisterId={}", canister)
                          )
                        ),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "content_type".to_string(),
                        value: Box::new(CandyShared::Text("text/html; charset=UTF-8".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "content_hash".to_string(),
                        value: Box::new(CandyShared::Bytes(ByteBuf::from(vec![0, 0, 0, 0]))),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "size".to_string(),
                        value: Box::new(CandyShared::Nat(Nat::from(file_size as u32))),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "sort".to_string(),
                        value: Box::new(CandyShared::Nat(Nat::from(0 as u32))),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "read".to_string(),
                        value: Box::new(CandyShared::Text("public".to_string())),
                        immutable: false,
                      }
                    ]
                  )
                ),
                Box::new(
                  CandyShared::Class(
                    vec![
                      PropertyShared {
                        name: "library_id".to_string(),
                        value: Box::new(CandyShared::Text("immutable_item".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "title".to_string(),
                        value: Box::new(CandyShared::Text("immutable".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "location_type".to_string(),
                        value: Box::new(CandyShared::Text("canister".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "location".to_string(),
                        value: Box::new(
                          CandyShared::Text(
                            format!("http://localhost:8000/-/1/-/immutable_item?canisterId={}", canister)
                          )
                        ),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "content_type".to_string(),
                        value: Box::new(CandyShared::Text("text/html; charset=UTF-8".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "content_hash".to_string(),
                        value: Box::new(CandyShared::Bytes(ByteBuf::from(vec![0, 0, 0, 0]))),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "size".to_string(),
                        value: Box::new(CandyShared::Nat(Nat::from(file_size as u32))),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "sort".to_string(),
                        value: Box::new(CandyShared::Nat(Nat::from(0 as u32))),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "read".to_string(),
                        value: Box::new(CandyShared::Text("public".to_string())),
                        immutable: false,
                      },
                      PropertyShared {
                        name: "com.origyn.immutable_library".to_string(),
                        value: Box::new(CandyShared::Bool(true)),
                        immutable: false,
                      }
                    ]
                  )
                )
              ]
            )
          ),
          immutable: false,
        },
        PropertyShared {
          name: "__apps".to_string(),
          value: Box::new(
            CandyShared::Array(
              vec![
                Box::new(
                  CandyShared::Class(
                    vec![
                      PropertyShared {
                        name: "com.test.__public".to_string(),
                        value: Box::new(CandyShared::Text("com.test.__public".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "read".to_string(),
                        value: Box::new(CandyShared::Text("public".to_string())),
                        immutable: false,
                      },
                      PropertyShared {
                        name: "write".to_string(),
                        value: Box::new(
                          CandyShared::Class(
                            vec![
                              PropertyShared {
                                name: "type".to_string(),
                                value: Box::new(CandyShared::Text("allow".to_string())),
                                immutable: false,
                              },
                              PropertyShared {
                                name: "list".to_string(),
                                value: Box::new(
                                  CandyShared::Array(
                                    vec![
                                      Box::new(
                                        CandyShared::Principal_(
                                          Principal::from_text(app.clone()).unwrap_or_else(|_|
                                            Principal::anonymous()
                                          )
                                        )
                                      )
                                    ]
                                  )
                                ),
                                immutable: false,
                              }
                            ]
                          )
                        ),
                        immutable: false,
                      },
                      PropertyShared {
                        name: "permissions".to_string(),
                        value: Box::new(
                          CandyShared::Class(
                            vec![
                              PropertyShared {
                                name: "type".to_string(),
                                value: Box::new(CandyShared::Text("allow".to_string())),
                                immutable: false,
                              },
                              PropertyShared {
                                name: "list".to_string(),
                                value: Box::new(
                                  CandyShared::Array(
                                    vec![
                                      Box::new(
                                        CandyShared::Principal_(
                                          Principal::from_text(app.clone()).unwrap_or_else(|_|
                                            Principal::anonymous()
                                          )
                                        )
                                      )
                                    ]
                                  )
                                ),
                                immutable: false,
                              }
                            ]
                          )
                        ),
                        immutable: false,
                      },
                      PropertyShared {
                        name: "data".to_string(),
                        value: Box::new(
                          CandyShared::Class(
                            vec![
                              PropertyShared {
                                name: "val1".to_string(),
                                value: Box::new(CandyShared::Text("val1".to_string())),
                                immutable: false,
                              },
                              PropertyShared {
                                name: "val2".to_string(),
                                value: Box::new(CandyShared::Text("val2".to_string())),
                                immutable: false,
                              },
                              PropertyShared {
                                name: "val3".to_string(),
                                value: Box::new(
                                  CandyShared::Class(
                                    vec![
                                      PropertyShared {
                                        name: "data".to_string(),
                                        value: Box::new(CandyShared::Text("val3".to_string())),
                                        immutable: false,
                                      },
                                      PropertyShared {
                                        name: "read".to_string(),
                                        value: Box::new(CandyShared::Text("public".to_string())),
                                        immutable: false,
                                      },
                                      PropertyShared {
                                        name: "write".to_string(),
                                        value: Box::new(
                                          CandyShared::Class(
                                            vec![
                                              PropertyShared {
                                                name: "type".to_string(),
                                                value: Box::new(
                                                  CandyShared::Text("allow".to_string())
                                                ),
                                                immutable: false,
                                              },
                                              PropertyShared {
                                                name: "list".to_string(),
                                                value: Box::new(
                                                  CandyShared::Array(
                                                    vec![
                                                      Box::new(
                                                        CandyShared::Principal_(
                                                          Principal::from_text(
                                                            app.clone()
                                                          ).unwrap_or_else(|_|
                                                            Principal::anonymous()
                                                          )
                                                        )
                                                      )
                                                    ]
                                                  )
                                                ),
                                                immutable: false,
                                              }
                                            ]
                                          )
                                        ),
                                        immutable: false,
                                      }
                                    ]
                                  )
                                ),
                                immutable: false,
                              },
                              PropertyShared {
                                name: "val4".to_string(),
                                value: Box::new(
                                  CandyShared::Class(
                                    vec![
                                      PropertyShared {
                                        name: "data".to_string(),
                                        value: Box::new(CandyShared::Text("val4".to_string())),
                                        immutable: false,
                                      },
                                      PropertyShared {
                                        name: "read".to_string(),
                                        value: Box::new(
                                          CandyShared::Class(
                                            vec![
                                              PropertyShared {
                                                name: "type".to_string(),
                                                value: Box::new(
                                                  CandyShared::Text("allow".to_string())
                                                ),
                                                immutable: false,
                                              },
                                              PropertyShared {
                                                name: "list".to_string(),
                                                value: Box::new(
                                                  CandyShared::Array(
                                                    vec![
                                                      Box::new(
                                                        CandyShared::Principal_(
                                                          Principal::from_text(
                                                            app.clone()
                                                          ).unwrap_or_else(|_|
                                                            Principal::anonymous()
                                                          )
                                                        )
                                                      )
                                                    ]
                                                  )
                                                ),
                                                immutable: false,
                                              }
                                            ]
                                          )
                                        ),
                                        immutable: false,
                                      },
                                      PropertyShared {
                                        name: "write".to_string(),
                                        value: Box::new(
                                          CandyShared::Class(
                                            vec![
                                              PropertyShared {
                                                name: "type".to_string(),
                                                value: Box::new(
                                                  CandyShared::Text("allow".to_string())
                                                ),
                                                immutable: false,
                                              },
                                              PropertyShared {
                                                name: "list".to_string(),
                                                value: Box::new(
                                                  CandyShared::Array(
                                                    vec![
                                                      Box::new(
                                                        CandyShared::Principal_(
                                                          Principal::from_text(
                                                            app.clone()
                                                          ).unwrap_or_else(|_|
                                                            Principal::anonymous()
                                                          )
                                                        )
                                                      )
                                                    ]
                                                  )
                                                ),
                                                immutable: false,
                                              }
                                            ]
                                          )
                                        ),
                                        immutable: false,
                                      }
                                    ]
                                  )
                                ),
                                immutable: false,
                              }
                            ]
                          )
                        ),
                        immutable: false,
                      }
                    ]
                  )
                ),
                Box::new(
                  CandyShared::Class(
                    vec![
                      PropertyShared {
                        name: "com.test.__private".to_string(),
                        value: Box::new(CandyShared::Text("com.test.__private".to_string())),
                        immutable: true,
                      },
                      PropertyShared {
                        name: "read".to_string(),
                        value: Box::new(
                          CandyShared::Class(
                            vec![
                              PropertyShared {
                                name: "type".to_string(),
                                value: Box::new(CandyShared::Text("allow".to_string())),
                                immutable: false,
                              },
                              PropertyShared {
                                name: "list".to_string(),
                                value: Box::new(
                                  CandyShared::Array(
                                    vec![
                                      Box::new(
                                        CandyShared::Principal_(
                                          Principal::from_text(app.clone()).unwrap_or_else(|_|
                                            Principal::anonymous()
                                          )
                                        )
                                      )
                                    ]
                                  )
                                ),
                                immutable: false,
                              }
                            ]
                          )
                        ),
                        immutable: false,
                      },
                      PropertyShared {
                        name: "write".to_string(),
                        value: Box::new(
                          CandyShared::Class(
                            vec![
                              PropertyShared {
                                name: "type".to_string(),
                                value: Box::new(CandyShared::Text("allow".to_string())),
                                immutable: false,
                              },
                              PropertyShared {
                                name: "list".to_string(),
                                value: Box::new(
                                  CandyShared::Array(
                                    vec![
                                      Box::new(
                                        CandyShared::Principal_(
                                          Principal::from_text(app.clone()).unwrap_or_else(|_|
                                            Principal::anonymous()
                                          )
                                        )
                                      )
                                    ]
                                  )
                                ),
                                immutable: false,
                              }
                            ]
                          )
                        ),
                        immutable: false,
                      },
                      PropertyShared {
                        name: "permissions".to_string(),
                        value: Box::new(
                          CandyShared::Class(
                            vec![
                              PropertyShared {
                                name: "type".to_string(),
                                value: Box::new(CandyShared::Text("allow".to_string())),
                                immutable: false,
                              },
                              PropertyShared {
                                name: "list".to_string(),
                                value: Box::new(
                                  CandyShared::Array(
                                    vec![
                                      Box::new(
                                        CandyShared::Principal_(
                                          Principal::from_text(app.clone()).unwrap_or_else(|_|
                                            Principal::anonymous()
                                          )
                                        )
                                      )
                                    ]
                                  )
                                ),
                                immutable: false,
                              }
                            ]
                          )
                        ),
                        immutable: false,
                      },
                      PropertyShared {
                        name: "data".to_string(),
                        value: Box::new(
                          CandyShared::Class(
                            vec![
                              PropertyShared {
                                name: "val1".to_string(),
                                value: Box::new(CandyShared::Text("val1".to_string())),
                                immutable: false,
                              },
                              PropertyShared {
                                name: "val2".to_string(),
                                value: Box::new(CandyShared::Text("val2".to_string())),
                                immutable: false,
                              },
                              PropertyShared {
                                name: "val3".to_string(),
                                value: Box::new(
                                  CandyShared::Class(
                                    vec![
                                      PropertyShared {
                                        name: "data".to_string(),
                                        value: Box::new(CandyShared::Text("val3".to_string())),
                                        immutable: false,
                                      },
                                      PropertyShared {
                                        name: "read".to_string(),
                                        value: Box::new(CandyShared::Text("public".to_string())),
                                        immutable: false,
                                      },
                                      PropertyShared {
                                        name: "write".to_string(),
                                        value: Box::new(
                                          CandyShared::Class(
                                            vec![
                                              PropertyShared {
                                                name: "type".to_string(),
                                                value: Box::new(
                                                  CandyShared::Text("allow".to_string())
                                                ),
                                                immutable: false,
                                              },
                                              PropertyShared {
                                                name: "list".to_string(),
                                                value: Box::new(
                                                  CandyShared::Array(
                                                    vec![
                                                      Box::new(
                                                        CandyShared::Principal_(
                                                          Principal::from_text(
                                                            app.clone()
                                                          ).unwrap_or_else(|_|
                                                            Principal::anonymous()
                                                          )
                                                        )
                                                      )
                                                    ]
                                                  )
                                                ),
                                                immutable: false,
                                              }
                                            ]
                                          )
                                        ),
                                        immutable: false,
                                      }
                                    ]
                                  )
                                ),
                                immutable: false,
                              },
                              PropertyShared {
                                name: "val4".to_string(),
                                value: Box::new(
                                  CandyShared::Class(
                                    vec![
                                      PropertyShared {
                                        name: "data".to_string(),
                                        value: Box::new(CandyShared::Text("val4".to_string())),
                                        immutable: false,
                                      },
                                      PropertyShared {
                                        name: "read".to_string(),
                                        value: Box::new(
                                          CandyShared::Class(
                                            vec![
                                              PropertyShared {
                                                name: "type".to_string(),
                                                value: Box::new(
                                                  CandyShared::Text("allow".to_string())
                                                ),
                                                immutable: false,
                                              },
                                              PropertyShared {
                                                name: "list".to_string(),
                                                value: Box::new(
                                                  CandyShared::Array(
                                                    vec![
                                                      Box::new(
                                                        CandyShared::Principal_(
                                                          Principal::from_text(
                                                            app.clone()
                                                          ).unwrap_or_else(|_|
                                                            Principal::anonymous()
                                                          )
                                                        )
                                                      )
                                                    ]
                                                  )
                                                ),
                                                immutable: false,
                                              }
                                            ]
                                          )
                                        ),
                                        immutable: false,
                                      },
                                      PropertyShared {
                                        name: "write".to_string(),
                                        value: Box::new(
                                          CandyShared::Class(
                                            vec![
                                              PropertyShared {
                                                name: "type".to_string(),
                                                value: Box::new(
                                                  CandyShared::Text("allow".to_string())
                                                ),
                                                immutable: false,
                                              },
                                              PropertyShared {
                                                name: "list".to_string(),
                                                value: Box::new(
                                                  CandyShared::Array(
                                                    vec![
                                                      Box::new(
                                                        CandyShared::Principal_(
                                                          Principal::from_text(
                                                            app.clone()
                                                          ).unwrap_or_else(|_|
                                                            Principal::anonymous()
                                                          )
                                                        )
                                                      )
                                                    ]
                                                  )
                                                ),
                                                immutable: false,
                                              }
                                            ]
                                          )
                                        ),
                                        immutable: false,
                                      }
                                    ]
                                  )
                                ),
                                immutable: false,
                              }
                            ]
                          )
                        ),
                        immutable: false,
                      }
                    ]
                  )
                )
              ]
            )
          ),
          immutable: false,
        },
        PropertyShared {
          name: "primary_host".to_string(),
          value: Box::new(CandyShared::Text("localhost".to_string())),
          immutable: false,
        },
        PropertyShared {
          name: "primary_port".to_string(),
          value: Box::new(CandyShared::Text("8000".to_string())),
          immutable: false,
        },
        PropertyShared {
          name: "primary_protocol".to_string(),
          value: Box::new(CandyShared::Text("http".to_string())),
          immutable: false,
        },
        PropertyShared {
          name: "owner".to_string(),
          value: Box::new(
            CandyShared::Principal_(
              Principal::from_text(canister).unwrap_or_else(|_| Principal::anonymous())
            )
          ),
          immutable: false,
        },
        PropertyShared {
          name: "com.origyn.originator.override".to_string(),
          value: Box::new(
            CandyShared::Principal_(
              Principal::from_text(originator).unwrap_or_else(|_| Principal::anonymous())
            )
          ),
          immutable: true,
        },
        PropertyShared {
          name: "is_soulbound".to_string(),
          value: Box::new(CandyShared::Bool(is_soulbound)),
          immutable: is_soulbound,
        }
      ]
    ),
  }
}

// fn standardCollection(
//   canister: Principal,
//   app: Principal,
//   node: Principal,
//   originator: Principal,
//   file_size: Nat,
//   broker_override: Bool,
//   ledgerToken: ICTokenSpec
// ) -> CandyShared {
//   CandyShared {
//     vec![
//       PropertyShared {
//         name: "id".to_string(),
//         value: Box::new( CandyShared::Text("".to_string())),
//         immutable: true,
//       },
//       PropertyShared {
//         name: "primary_asset".to_string(),
//         value: Box::new( CandyShared::Text("collection_banner".to_string())),
//         immutable: true,
//       },
//       PropertyShared {
//         name: "preview".to_string(),
//         value: Box::new( CandyShared::Text("collection_banner".to_string())),
//         immutable: true,
//       },
//       PropertyShared {
//         name: "experience".to_string(),
//         value: Box::new( CandyShared::Text("collection_banner".to_string())),
//         immutable: true,
//       },
//       PropertyShared {
//         name: "com.origyn.node".to_string(),
//         value: Box::new( CandyShared::Principal_(node)),
//         immutable: true,
//       },
//       PropertyShared {
//         name: "com.origyn.originator".to_string(),
//         value: Box::new( CandyShared::Principal_(node)),
//         immutable: true,
//       },
//       PropertyShared {
//         name: "com.origyn.royalties.primary.default".to_string(),
//         value: Box::new( CandyShared::Array(
//           vec![
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: "tag".to_string(),
//                 value: Box::new( CandyShared::Text("com.origyn.royalty.broker".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "rate".to_string(),
//                 value: Box::new( CandyShared::Float(0.06)),
//                 immutable: true,
//               },
//             ],
//           },
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: "tag".to_string(),
//                 value: Box::new( CandyShared::Text("com.origyn.royalty.node".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "rate".to_string(),
//                 value: Box::new( CandyShared::Float(0.07777)),
//                 immutable: true,
//               },
//             ],
//           },
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: "tag".to_string(),
//                 value: Box::new( CandyShared::Text("com.origyn.royalty.network".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "rate".to_string(),
//                 value: Box::new( CandyShared::Float(0.005)),
//                 immutable: true,
//               },
//             ],
//           },
//         ]
//         )),
//         immutable: false,
//       },
//       PropertyShared {
//         name: "com.origyn.royalties.secondary.default".to_string(),
//         value: Box::new( CandyShared::Array(
//           vec![
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: "tag".to_string(),
//                 value: Box::new( CandyShared::Text("com.origyn.royalty.broker".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "rate".to_string(),
//                 value: Box::new( CandyShared::Float(0.01)),
//                 immutable: true,
//               },
//             ],
//           },
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: "tag".to_string(),
//                 value: Box::new( CandyShared::Text("com.origyn.royalty.node".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "rate".to_string(),
//                 value: Box::new( CandyShared::Float(0.02)),
//                 immutable: true,
//               },
//             ],
//           },
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: "tag".to_string(),
//                 value: Box::new( CandyShared::Text("com.origyn.royalty.originator".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "rate".to_string(),
//                 value: Box::new( CandyShared::Float(0.03333333333)),
//                 immutable: true,
//               },
//             ],
//           },
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: "tag".to_string(),
//                 value: Box::new( CandyShared::Text("com.origyn.royalty.custom".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "rate".to_string(),
//                 value: Box::new( CandyShared::Float(0.04)),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "account".to_string(),
//                 value: Box::new( CandyShared::Principal_(originator)),
//                 immutable: true,
//               },
//             ],
//           },
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: "tag".to_string(),
//                 value: Box::new( CandyShared::Text("com.origyn.royalty.network".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "rate".to_string(),
//                 value: Box::new( CandyShared::Float(0.005)),
//                 immutable: true,
//               },
//             ],
//           },
//         ]
//         )),
//         immutable: false,
//       },
//       PropertyShared {
//         name: "com.origyn.royalties.primary.default".to_string(),
//         value: Box::new( CandyShared::Array(
//           vec![
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: "tag".to_string(),
//                 value: Box::new( CandyShared::Text("com.origyn.royalty.broker".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "rate".to_string(),
//                 value: Box::new( CandyShared::Float(0.06)),
//                 immutable: true,
//               },
//             ],
//           },
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: "tag".to_string(),
//                 value: Box::new( CandyShared::Text("com.origyn.royalty.node".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "rate".to_string(),
//                 value: Box::new( CandyShared::Float(0.07777)),
//                 immutable: true,
//               },
//             ],
//           },
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: "tag".to_string(),
//                 value: Box::new( CandyShared::Text("com.origyn.royalty.network".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "rate".to_string(),
//                 value: Box::new( CandyShared::Float(0.005)),
//                 immutable: true,
//               },
//             ],
//           },
//         ]
//         )),
//         immutable: false,
//       },
//       PropertyShared {
//         name: "com.origyn.royalties.fixed.default".to_string(),
//         value: Box::new( CandyShared::Array(
//           vec![
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: "tag".to_string(),
//                 value: Box::new( CandyShared::Text("com.origyn.royalty.broker".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "fixedXDR".to_string(),
//                 value: Box::new( CandyShared::Float(1000000.0)),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenCanister".to_string(),
//                 value: Box::new( CandyShared::Principal_(ledgerToken.canister)),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenSymbol".to_string(),
//                 value: Box::new( CandyShared::Text(ledgerToken.symbol)),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenDecimals".to_string(),
//                 value: Box::new( CandyShared::Nat(Nat::from(ledgerToken.decimals as u32))),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenFee".to_string(),
//                 value: Box::new( match ledgerToken.fee {
//                   null => CandyShared::Option(None),
//                   val => CandyShared::Option(Some(val)),
//                 },)
//                 immutable: true,
//               },
//             ],
//           },
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: "tag".to_string(),
//                 value: Box::new( CandyShared::Text("com.origyn.royalty.node".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "fixedXDR".to_string(),
//                 value: Box::new( CandyShared::Float(1000000.0)),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenCanister".to_string(),
//                 value: Box::new( CandyShared::Principal_(ledgerToken.canister)),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenSymbol".to_string(),
//                 value: Box::new( CandyShared::Text(ledgerToken.symbol)),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenDecimals".to_string(),
//                 value: Box::new( CandyShared::Nat(Nat::from(ledgerToken.decimals as u32))),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenFee".to_string(),
//                 value: Box::new( match ledgerToken.fee {
//                   null => CandyShared::Option(None),
//                   val => CandyShared::Option(Some(val)),
//                 },)
//                 immutable: true,
//               },
//             ],
//           },
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: "tag".to_string(),
//                 value: Box::new( CandyShared::Text("com.origyn.royalty.originator".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "fixedXDR".to_string(),
//                 value: Box::new( CandyShared::Float(1000000.0)),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenCanister".to_string(),
//                 value: Box::new( CandyShared::Principal_(ledgerToken.canister)),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenSymbol".to_string(),
//                 value: Box::new( CandyShared::Text(ledgerToken.symbol)),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenDecimals".to_string(),
//                 value: Box::new( CandyShared::Nat(Nat::from(ledgerToken.decimals as u32))),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenFee".to_string(),
//                 value: Box::new( match ledgerToken.fee {
//                   null => CandyShared::Option(None),
//                   val => CandyShared::Option(Some(val)),
//                 },)
//                 immutable: true,
//               },
//             ],
//           },
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: "tag".to_string(),
//                 value: Box::new( CandyShared::Text("com.origyn.royalty.custom".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "fixedXDR".to_string(),
//                 value: Box::new( CandyShared::Float(1000000.0)),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenCanister".to_string(),
//                 value: Box::new( CandyShared::Principal_(ledgerToken.canister)),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenSymbol".to_string(),
//                 value: Box::new( CandyShared::Text(ledgerToken.symbol)),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenDecimals".to_string(),
//                 value: Box::new( CandyShared::Nat(Nat::from(ledgerToken.decimals as u32))),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenFee".to_string(),
//                 value: Box::new( match ledgerToken.fee {
//                   null => CandyShared::Option(None),
//                   val => CandyShared::Option(Some(val)),
//                 },)
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "account".to_string(),
//                 value: Box::new( CandyShared::Principal_(originator)),
//                 immutable: true,
//               },
//             ],
//           },
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: "tag".to_string(),
//                 value: Box::new( CandyShared::Text("com.origyn.royalty.network".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "fixedXDR".to_string(),
//                 value: Box::new( CandyShared::Float(1000000.0)),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenCanister".to_string(),
//                 value: Box::new( CandyShared::Principal_(ledgerToken.canister)),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenSymbol".to_string(),
//                 value: Box::new( CandyShared::Text(ledgerToken.symbol)),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenDecimals".to_string(),
//                 value: Box::new( CandyShared::Nat(Nat::from(ledgerToken.decimals as u32))),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "tokenFee".to_string(),
//                 value: Box::new( match ledgerToken.fee {
//                   null => CandyShared::Option(None),
//                   val => CandyShared::Option(Some(val)),
//                 },)
//                 immutable: true,
//               },
//             ],
//           },
//         ]
//         )),
//         immutable: false,
//       },
//       PropertyShared {
//         name: "library".to_string(),
//         value: Box::new( CandyShared::Array(
//           vec![
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: "library_id".to_string(),
//                 value: Box::new( CandyShared::Text("collection_banner".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "title".to_string(),
//                 value: Box::new( CandyShared::Text("collection_banner".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "location_type".to_string(),
//                 value: Box::new( CandyShared::Text("canister".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "location".to_string(),
//                 value: Box::new( CandyShared::Text(format!(
//                   "https://{}.raw.icp0.io/collection/-/collection_banner",
//                   canister
//                 ))),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "content_type".to_string(),
//                 value: Box::new( CandyShared::Text("text/html; charset=UTF-8".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "content_hash".to_string(),
//                 value: Box::new( CandyShared::Bytes(ByteBuf::from(vec![0, 0, 0, 0]))),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "size".to_string(),
//                 value: Box::new( CandyShared::Nat(Nat::from(file_size as u32))),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "sort".to_string(),
//                 value: Box::new( CandyShared::Nat(Nat::from(0 as u32))),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "read".to_string(),
//                 value: Box::new( CandyShared::Text("public".to_string())),
//                 immutable: false,
//               },
//             ],
//             immutable: false,
//           },
//         ]
//         )),
//         immutable: false,
//       },
//       PropertyShared {
//         name: "__apps".to_string(),
//         value: Box::new( CandyShared::Array(
//           vec![
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: Types.metadata.__apps_app_id.to_string(),
//                 value: Box::new( CandyShared::Text("com.test.__public".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "read".to_string(),
//                 value: Box::new( CandyShared::Text("public".to_string())),
//                 immutable: false,
//               },
//               PropertyShared {
//                 name: "write".to_string(),
//                 value: Box::new( CandyShared::Class(vec![
//                   PropertyShared {
//                     name: "type".to_string(),
//                     value: Box::new( CandyShared::Text("allow".to_string())),
//                     immutable: false,
//                   },
//                   PropertyShared {
//                     name: "list".to_string(),
//                     value: Box::new( CandyShared::Array(vec![CandyShared::Principal_(app)])),
//                     immutable: false,
//                   },
//                 ])),
//                 immutable: false,
//               },
//               PropertyShared {
//                 name: "permissions".to_string(),
//                 value: Box::new( CandyShared::Class(vec![
//                   PropertyShared {
//                     name: "type".to_string(),
//                     value: Box::new( CandyShared::Text("allow".to_string())),
//                     immutable: false,
//                   },
//                   PropertyShared {
//                     name: "list".to_string(),
//                     value: Box::new( CandyShared::Array(vec![CandyShared::Principal_(app)])),
//                     immutable: false,
//                   },
//                 ])),
//                 immutable: false,
//               },
//               PropertyShared {
//                 name: "data".to_string(),
//                 value: Box::new( CandyShared::Class(vec![
//                   PropertyShared {
//                     name: "val1".to_string(),
//                     value: Box::new( CandyShared::Text("val1".to_string())),
//                     immutable: false,
//                   },
//                   PropertyShared {
//                     name: "val2".to_string(),
//                     value: Box::new( CandyShared::Text("val2".to_string())),
//                     immutable: false,
//                   },
//                   PropertyShared {
//                     name: "val3".to_string(),
//                     value: Box::new( CandyShared::Class(vec![
//                       PropertyShared {
//                         name: "data".to_string(),
//                         value: Box::new( CandyShared::Text("val3".to_string())),
//                         immutable: false,
//                       },
//                       PropertyShared {
//                         name: "read".to_string(),
//                         value: Box::new( CandyShared::Text("public".to_string())),
//                         immutable: false,
//                       },
//                       PropertyShared {
//                         name: "write".to_string(),
//                         value: Box::new( CandyShared::Class(vec![
//                           PropertyShared {
//                             name: "type".to_string(),
//                             value: Box::new( CandyShared::Text("allow".to_string())),
//                             immutable: false,
//                           },
//                           PropertyShared {
//                             name: "list".to_string(),
//                             value: Box::new( CandyShared::Array(vec![CandyShared::Principal_(app)])),
//                             immutable: false,
//                           },
//                         ])),
//                         immutable: false,
//                       },
//                     ])),
//                     immutable: false,
//                   },
//                   PropertyShared {
//                     name: "val4".to_string(),
//                     value: Box::new( CandyShared::Class(vec![
//                       PropertyShared {
//                         name: "data".to_string(),
//                         value: Box::new( CandyShared::Text("val4".to_string())),
//                         immutable: false,
//                       },
//                       PropertyShared {
//                         name: "read".to_string(),
//                         value: Box::new( CandyShared::Class(vec![
//                           PropertyShared {
//                             name: "type".to_string(),
//                             value: Box::new( CandyShared::Text("allow".to_string())),
//                             immutable: false,
//                           },
//                           PropertyShared {
//                             name: "list".to_string(),
//                             value: Box::new( CandyShared::Array(vec![CandyShared::Principal_(app)])),
//                             immutable: false,
//                           },
//                         ])),
//                         immutable: false,
//                       },
//                       PropertyShared {
//                         name: "write".to_string(),
//                         value: Box::new( CandyShared::Class(vec![
//                           PropertyShared {
//                             name: "type".to_string(),
//                             value: Box::new( CandyShared::Text("allow".to_string())),
//                             immutable: false,
//                           },
//                           PropertyShared {
//                             name: "list".to_string(),
//                             value: Box::new( CandyShared::Array(vec![CandyShared::Principal_(app)])),
//                             immutable: false,
//                           },
//                         ])),
//                         immutable: false,
//                       },
//                     ]),
//                     immutable: false,
//                   )},
//                 ]),
//                 immutable: false,
//               )},
//             ],
//             immutable: false,
//           },
//           CandyShared::Class (
//             vec![
//               PropertyShared {
//                 name: Types.metadata.__apps_app_id.to_string(),
//                 value: Box::new( CandyShared::Text("com.test.__private".to_string())),
//                 immutable: true,
//               },
//               PropertyShared {
//                 name: "read".to_string(),
//                 value: Box::new( CandyShared::Class(vec![
//                   PropertyShared {
//                     name: "type".to_string(),
//                     value: Box::new( CandyShared::Text("allow".to_string())),
//                     immutable: false,
//                   },
//                   PropertyShared {
//                     name: "list".to_string(),
//                     value: Box::new( CandyShared::Array(vec![CandyShared::Principal_(app)])),
//                     immutable: false,
//                   },
//                 ])),
//                 immutable: false,
//               },
//               PropertyShared {
//                 name: "write".to_string(),
//                 value: Box::new( CandyShared::Class(vec![
//                   PropertyShared {
//                     name: "type".to_string(),
//                     value: Box::new( CandyShared::Text("allow".to_string())),
//                     immutable: false,
//                   },
//                   PropertyShared {
//                     name: "list".to_string(),
//                     value: Box::new( CandyShared::Array(vec![CandyShared::Principal_(app)])),
//                     immutable: false,
//                   },
//                 ])),
//                 immutable: false,
//               },
//               PropertyShared {
//                 name: "permissions".to_string(),
//                 value: Box::new( CandyShared::Class(vec![
//                   PropertyShared {
//                     name: "type".to_string(),
//                     value: Box::new( CandyShared::Text("allow".to_string())),
//                     immutable: false,
//                   },
//                   PropertyShared {
//                     name: "list".to_string(),
//                     value: Box::new( CandyShared::Array(vec![CandyShared::Principal_(app)])),
//                     immutable: false,
//                   },
//                 ])),
//                 immutable: false,
//               },
//               PropertyShared {
//                 name: "data".to_string(),
//                 value: Box::new( CandyShared::Class(vec![
//                   PropertyShared {
//                     name: "val1".to_string(),
//                     value: Box::new( CandyShared::Text("val1".to_string())),
//                     immutable: false,
//                   },
//                   PropertyShared {
//                     name: "val2".to_string(),
//                     value: Box::new( CandyShared::Text("val2".to_string())),
//                     immutable: false,
//                   },
//                   PropertyShared {
//                     name: "val3".to_string(),
//                     value: Box::new( CandyShared::Class(vec![
//                       PropertyShared {
//                         name: "data".to_string(),
//                         value: Box::new( CandyShared::Text("val3".to_string())),
//                         immutable: false,
//                       },
//                       PropertyShared {
//                         name: "read".to_string(),
//                         value: Box::new( CandyShared::Text("public".to_string())),
//                         immutable: false,
//                       },
//                       PropertyShared {
//                         name: "write".to_string(),
//                         value: Box::new( CandyShared::Class(vec![
//                           PropertyShared {
//                             name: "type".to_string(),
//                             value: Box::new( CandyShared::Text("allow".to_string())),
//                             immutable: false,
//                           },
//                           PropertyShared {
//                             name: "list".to_string(),
//                             value: Box::new( CandyShared::Array(vec![CandyShared::Principal_(app)])),
//                             immutable: false,
//                           },
//                         ])),
//                         immutable: false,
//                       },
//                     ])),
//                     immutable: false,
//                   },
//                   PropertyShared {
//                     name: "val4".to_string(),
//                     value: Box::new( CandyShared::Class(vec![
//                       PropertyShared {
//                         name: "data".to_string(),
//                         value: Box::new( CandyShared::Text("val4".to_string())),
//                         immutable: false,
//                       },
//                       PropertyShared {
//                         name: "read".to_string(),
//                         value: Box::new( CandyShared::Class(vec![
//                           PropertyShared {
//                             name: "type".to_string(),
//                             value: Box::new( CandyShared::Text("allow".to_string())),
//                             immutable: false,
//                           },
//                           PropertyShared {
//                             name: "list".to_string(),
//                             value: Box::new( CandyShared::Array(vec![CandyShared::Principal_(app)])),
//                             immutable: false,
//                           },
//                         ])),
//                         immutable: false,
//                       },
//                       PropertyShared {
//                         name: "write".to_string(),
//                         value: Box::new( CandyShared::Class(vec![
//                           PropertyShared {
//                             name: "type".to_string(),
//                             value: Box::new( CandyShared::Text("allow".to_string()),
//                             immutable: false,
//                           },
//                           PropertyShared {
//                             name: "list".to_string(),
//                             value: Box::new( CandyShared::Array(vec![CandyShared::Principal_(app)])),
//                             immutable: false,
//                           },
//                         ])),
//                         immutable: false,
//                       },
//                     ]),
//                     immutable: false,
//                   )},
//                 ]),
//                 immutable: false,
//               )},
//             ],
//             immutable: false,
//           },
//         ]
//         )),
//         immutable: false,
//       },
//       PropertyShared {
//         name: "owner".to_string(),
//         value: Box::new( CandyShared::Principal_(canister)),
//         immutable: false,
//       },
//       PropertyShared {
//         name: "is_soulbound".to_string(),
//         value: Box::new( CandyShared::Bool(false)),
//         immutable: false,
//       },
//       PropertyShared {
//         name: "primary_host".to_string(),
//         value: Box::new( CandyShared::Text("localhost".to_string())),
//         immutable: false,
//       },
//       PropertyShared {
//         name: "primary_port".to_string(),
//         value: Box::new( CandyShared::Text("8000".to_string())),
//         immutable: false,
//       },
//       PropertyShared {
//         name: "primary_protocol".to_string(),
//         value: Box::new( CandyShared::Text("http".to_string())),
//         immutable: false,
//       },
//       PropertyShared {
//         name: "com.origyn.royalties.broker_dev_fund_override".to_string(),
//         value: Box::new( if broker_override {
//           CandyShared::Bool(true)
//         } else {
//           CandyShared::Bool(false)
//         }),
//         immutable: false,
//       }
//     ],
//   }
// }

// fn standardFileChunk(
//   token_id: String,
//   library_id: String,
//   text: String,
//   filedata: CandyShared,
//   chunk: Nat
// ) -> StageChunkArg {
//   StageChunkArg {
//     token_id: token_id,
//     library_id: library_id,
//     filedata: Box::new(filedata),
//     chunk: chunk,
//     content: Blob.fromText(text),
//   }
// }
