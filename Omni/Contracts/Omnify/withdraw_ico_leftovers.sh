#!/bin/bash
source .env
# AVALANCHE
forge script --chain 43114 script/ico.s.sol:WithdrawLeftovers --rpc-url $AVALANCHE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x135d68d97081A7132eb41E107E6b7Ed94202a9A4'
#OPTIMISM
forge script --legacy --gas-estimate-multiplier 130 --chain 10 script/ico.s.sol:WithdrawLeftovers --rpc-url $OPTIMISM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x2300aD45C2BA39c08bb45BE75c1a6C0fe88962Bf'
#BSC
forge script --chain 56 script/ico.s.sol:WithdrawLeftovers --rpc-url $BNB_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05'
#ARBITRUM
forge script --legacy --gas-estimate-multiplier 135 --chain 42161 script/ico.s.sol:WithdrawLeftovers --rpc-url $ARBITRUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05'
#POLYGON
forge script --legacy --gas-estimate-multiplier 130 --chain 137 script/ico.s.sol:WithdrawLeftovers --rpc-url $POLYGON_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05'
#FANTOM
forge script --chain 250 script/ico.s.sol:WithdrawLeftovers --rpc-url $FANTOM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05'
#BASE
forge script --legacy --gas-estimate-multiplier 130 --chain 8453 script/ico.s.sol:WithdrawLeftovers --rpc-url $BASE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05'
#LINEA
forge script --legacy --gas-estimate-multiplier 130 --chain 59144 script/ico.s.sol:WithdrawLeftovers --rpc-url $LINEA_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x2aC581f649D69259AD03ec79A2184e9Eabe805Ad'
#MANTLE
forge script --skip-simulation --chain 5000 script/ico.s.sol:WithdrawLeftovers --rpc-url $MANTLE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05'
#GNOSIS
forge script --chain 100 script/ico.s.sol:WithdrawLeftovers --rpc-url $GNOSIS_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x135d68d97081A7132eb41E107E6b7Ed94202a9A4'
#RONIN
# forge script --chain 2020 script/ico.s.sol:WithdrawLeftovers --rpc-url $RONIN_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'coinseller'
#CELO
forge script --legacy --gas-estimate-multiplier 135 --chain 42220 script/ico.s.sol:WithdrawLeftovers --rpc-url $CELO_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05'
#SCROLL
forge script --legacy --gas-estimate-multiplier 130 --chain 534352 script/ico.s.sol:WithdrawLeftovers --rpc-url $SCROLL_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x901c0D640aa4E3163cDbc2C86157D66d49BcD7BF'
#BLAST
forge script --legacy --gas-estimate-multiplier 130 --chain 81457 script/ico.s.sol:WithdrawLeftovers --rpc-url $BLAST_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05'
#ETHEREUM
#forge script --chain 1 script/ico.s.sol:WithdrawLeftovers --rpc-url $ETHEREUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'coinseller'

#ZKSYNC
# forge script --use 0.8.24 --legacy --gas-estimate-multiplier 130 --chain 324 script/ico.s.sol:WithdrawLeftovers --zksync --rpc-url https://mainnet.era.zksync.io --broadcast --slow --via-ir -vvvv --sig 'run(address)' '0x92609A128FFF40e14d57e15CFE90f764a4A6edaC'

#FUJI
#forge script --chain 43113 script/ico.s.sol:WithdrawLeftovers --rpc-url $FUJI_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x5a3A1b445D359b3d1998aff075C73A2c88c29F1C'
#BNBT
#forge script --chain 97 script/ico.s.sol:WithdrawLeftovers --rpc-url $BNB_TESTNET_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'coinseller'