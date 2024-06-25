use ic_cdk::api::management_canister::main::raw_rand;

pub async fn generate_rand_nonce() -> Result<u64, String> {
    generate_rand_byte_array().await.map(u64::from_be_bytes)
}

pub async fn generate_rand_byte_array() -> Result<[u8; 8], String> {
    match raw_rand().await {
        Ok((random_bytes,)) => {
            let bytes_array: Result<[u8; 8], _> = random_bytes[0..8].try_into();

            match bytes_array {
                Ok(bytes) => Ok(bytes),
                Err(err) => Err(format!("Initialising slicing byte array: {}", err)),
            }
        }
        Err(err) => Err(format!("Random bytes generation error: {:?}", err)),
    }
}
