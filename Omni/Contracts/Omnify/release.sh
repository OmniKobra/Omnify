#!/bin/bash
source .env
# AVALANCHE
forge script --legacy --gas-estimate-multiplier 130 --chain 43114 script/omnify.s.sol:MyScript --rpc-url $AVALANCHE_RPC_URL --broadcast --verify --via-ir --optimize -vvvv
#OPTIMISM
forge script --legacy --gas-estimate-multiplier 130 --chain 10 script/omnify.s.sol:MyScript --rpc-url $OPTIMISM_RPC_URL --broadcast --verify --via-ir --optimize -vvvv
#BSC
forge script --legacy --gas-estimate-multiplier 130 --chain 56 script/omnify.s.sol:MyScript --rpc-url $BNB_RPC_URL --broadcast --verify --via-ir --optimize -vvvv
#ARBITRUM
forge script --legacy --gas-estimate-multiplier 130 --chain 42161 script/omnify.s.sol:MyScript --rpc-url $ARBITRUM_RPC_URL --broadcast --verify --via-ir --optimize -vvvv
#APE
forge script --legacy --gas-estimate-multiplier 130 --chain 33139 script/omnify.s.sol:MyScript --rpc-url $APE_RPC_URL --broadcast --verify --via-ir --optimize -vvvv
#POLYGON
forge script --legacy --gas-estimate-multiplier 130 --chain 137 script/omnify.s.sol:MyScript --rpc-url $POLYGON_RPC_URL --broadcast --verify --via-ir --optimize -vvvv
#FANTOM
forge script --chain 250 script/omnify.s.sol:MyScript --rpc-url $FANTOM_RPC_URL --broadcast --verify --via-ir --optimize -vvvv
#BASE
forge script --legacy --gas-estimate-multiplier 130 --chain 8453 script/omnify.s.sol:MyScript --rpc-url $BASE_RPC_URL --broadcast --verify --via-ir --optimize -vvvv
#LINEA
forge script --legacy --gas-estimate-multiplier 130 --chain 59144 script/omnify.s.sol:MyScript --rpc-url $LINEA_RPC_URL --broadcast --verify --via-ir --optimize -vvvv
#MANTLE
forge script --skip-simulation --chain 5000 script/omnify.s.sol:MyScript --rpc-url $MANTLE_RPC_URL --broadcast --verify --via-ir --optimize -vvvv
#GNOSIS
forge script --chain 100 script/omnify.s.sol:MyScript --rpc-url $GNOSIS_RPC_URL --broadcast --verify --via-ir --optimize -vvvv
#RONIN
#forge script --legacy --gas-estimate-multiplier 130 --chain 2020 script/omnify.s.sol:MyScript --rpc-url $RONIN_RPC_URL --broadcast --verify --via-ir --optimize -vvvv
#CELO
forge script --chain 42220 script/omnify.s.sol:MyScript --rpc-url $CELO_RPC_URL --broadcast --verify --via-ir --optimize -vvvv
#SCROLL
forge script --legacy --gas-estimate-multiplier 130 --chain 534352 script/omnify.s.sol:MyScript --rpc-url $SCROLL_RPC_URL --broadcast --verify --via-ir --optimize -vvvv
#BLAST
forge script --legacy --gas-estimate-multiplier 130 --chain 81457 script/omnify.s.sol:MyScript --rpc-url $BLAST_RPC_URL --broadcast --verify --via-ir --optimize -vvvv
#ETHEREUM
#forge script --chain 1 script/omnify.s.sol:MyScript --rpc-url $ETHEREUM_RPC_URL --broadcast --verify --via-ir --optimize -vvvv

#ZKSYNC
#forge script --use 0.8.24 --legacy --gas-estimate-multiplier 130 --chain 324 script/omnify.s.sol:MyScript --zksync --rpc-url https://mainnet.era.zksync.io --broadcast --slow --verifier-url https://zksync2-mainnet-explorer.zksync.io/contract_verification --etherscan-api-key 6GYSU74HSXZRTIMVCH91Q43IQA61WS58YK --verify --via-ir --optimize -vvvv

#FUJI
#forge script --chain 43113 script/omnify.s.sol:MyScript --rpc-url $FUJI_RPC_URL --broadcast --verify --via-ir --optimize -vvvv
#BNBT
#forge script --chain 97 script/omnify.s.sol:MyScript --rpc-url $BNB_TESTNET_RPC_URL --broadcast --verify --via-ir --optimize -vvvv