#!/bin/bash
source .env
# AVALANCHE
forge script --chain 43114 script/ico.s.sol:WithdrawLeftovers --rpc-url $AVALANCHE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xd0AdC46C8Af67382b23AB68b330BDbc3bb6A326a'
#OPTIMISM
forge script --legacy --gas-estimate-multiplier 130 --chain 10 script/ico.s.sol:WithdrawLeftovers --rpc-url $OPTIMISM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xd73151f3a6aA783B1e90bdCd634b4eF72ca0323B'
#BSC
forge script --chain 56 script/ico.s.sol:WithdrawLeftovers --rpc-url $BNB_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xBdc066F91b9DB3b854e3Ec15b6816944896974CD'
#ARBITRUM
forge script --legacy --gas-estimate-multiplier 135 --chain 42161 script/ico.s.sol:WithdrawLeftovers --rpc-url $ARBITRUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x9e4bbd964FB2B0B77E7a0103b7559d9544d896a6'
#POLYGON
forge script --legacy --gas-estimate-multiplier 130 --chain 137 script/ico.s.sol:WithdrawLeftovers --rpc-url $POLYGON_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xEe47e2484342eA7Bcf13B9e6d4F9d53B28F1b724'
#FANTOM
forge script --chain 250 script/ico.s.sol:WithdrawLeftovers --rpc-url $FANTOM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xEe47e2484342eA7Bcf13B9e6d4F9d53B28F1b724'
#BASE
forge script --legacy --gas-estimate-multiplier 130 --chain 8453 script/ico.s.sol:WithdrawLeftovers --rpc-url $BASE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xEe47e2484342eA7Bcf13B9e6d4F9d53B28F1b724'
#LINEA
forge script --legacy --gas-estimate-multiplier 130 --chain 59144 script/ico.s.sol:WithdrawLeftovers --rpc-url $LINEA_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xF9b3CBb3D2BCAafA30F04B033B88F9f353bb1003'
#MANTLE
forge script --skip-simulation --chain 5000 script/ico.s.sol:WithdrawLeftovers --rpc-url $MANTLE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xadAAA1F6b6e729B341C95D654eBb4d1c65B441eC'
#GNOSIS
forge script --chain 100 script/ico.s.sol:WithdrawLeftovers --rpc-url $GNOSIS_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xf6eDE440FC5524d680C0465f27D0A2E36b8aCB7e'
#RONIN
# forge script --chain 2020 script/ico.s.sol:WithdrawLeftovers --rpc-url $RONIN_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'coinseller'
#CELO
forge script --legacy --gas-estimate-multiplier 135 --chain 42220 script/ico.s.sol:WithdrawLeftovers --rpc-url $CELO_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xEe47e2484342eA7Bcf13B9e6d4F9d53B28F1b724'
#SCROLL
forge script --legacy --gas-estimate-multiplier 130 --chain 534352 script/ico.s.sol:WithdrawLeftovers --rpc-url $SCROLL_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xf6eDE440FC5524d680C0465f27D0A2E36b8aCB7e'
#BLAST
forge script --legacy --gas-estimate-multiplier 130 --chain 81457 script/ico.s.sol:WithdrawLeftovers --rpc-url $BLAST_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x946e2B2f3E94d621fc8016e28EdA655448831021'
#ETHEREUM
#forge script --chain 1 script/ico.s.sol:WithdrawLeftovers --rpc-url $ETHEREUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'coinseller'

#ZKSYNC
# forge script --use 0.8.24 --legacy --gas-estimate-multiplier 130 --chain 324 script/ico.s.sol:WithdrawLeftovers --zksync --rpc-url https://mainnet.era.zksync.io --broadcast --slow --via-ir -vvvv --sig 'run(address)' '0xDFc727aB34D89Ef83B4698731a06f9136ab0ffeB'

#FUJI
#forge script --chain 43113 script/ico.s.sol:WithdrawLeftovers --rpc-url $FUJI_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x5a3A1b445D359b3d1998aff075C73A2c88c29F1C'
#BNBT
#forge script --chain 97 script/ico.s.sol:WithdrawLeftovers --rpc-url $BNB_TESTNET_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'coinseller'