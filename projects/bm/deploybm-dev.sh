set -ex
env_network='ic'
env_prod='true'
env_name='origyn_nft_reference_dev'
env_name_sale='dev_sales_canister'
export env_network
export env_prod
export env_name
export env_name_sale
bash ./projects/bm/deploybm.sh