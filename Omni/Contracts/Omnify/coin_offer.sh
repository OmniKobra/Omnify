#!/bin/bash
source .env
# AVALANCHE
forge script --chain 43114 script/ico.s.sol:OfferCoins --rpc-url $AVALANCHE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0x135d68d97081A7132eb41E107E6b7Ed94202a9A4' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05'
#OPTIMISM
forge script --legacy --gas-estimate-multiplier 130 --chain 10 script/ico.s.sol:OfferCoins --rpc-url $OPTIMISM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0x2300aD45C2BA39c08bb45BE75c1a6C0fe88962Bf' '0x92Ac7055FAB975C29059493408aA7965cad43E23'
#BSC
forge script --chain 56 script/ico.s.sol:OfferCoins --rpc-url $BNB_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05' '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9'
#ARBITRUM
forge script --legacy --gas-estimate-multiplier 135 --chain 42161 script/ico.s.sol:OfferCoins --rpc-url $ARBITRUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05' '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9'
#POLYGON
forge script --legacy --gas-estimate-multiplier 130 --chain 137 script/ico.s.sol:OfferCoins --rpc-url $POLYGON_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05' '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9'
#FANTOM
forge script --chain 250 script/ico.s.sol:OfferCoins --rpc-url $FANTOM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05' '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9'
#BASE
forge script --legacy --gas-estimate-multiplier 130 --chain 8453 script/ico.s.sol:OfferCoins --rpc-url $BASE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05' '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9'
#LINEA
forge script --legacy --gas-estimate-multiplier 130 --chain 59144 script/ico.s.sol:OfferCoins --rpc-url $LINEA_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0x2aC581f649D69259AD03ec79A2184e9Eabe805Ad' '0xa1B6863BC753FfCE82c3e606D9BC1fBcBbCa40Ae'
#MANTLE
forge script --skip-simulation --legacy --gas-estimate-multiplier 130 --chain 5000 script/ico.s.sol:OfferCoins --rpc-url $MANTLE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05' '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9'
#GNOSIS
forge script --chain 100 script/ico.s.sol:OfferCoins --rpc-url $GNOSIS_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0x135d68d97081A7132eb41E107E6b7Ed94202a9A4' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05'
#RONIN
#forge script --chain 2020 script/ico.s.sol:OfferCoins --rpc-url $RONIN_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' 'coinseller' 'omnicoin'
#CELO
forge script --chain 42220 script/ico.s.sol:OfferCoins --rpc-url $CELO_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05' '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9'
#SCROLL
forge script --legacy --gas-estimate-multiplier 130 --chain 534352 script/ico.s.sol:OfferCoins --rpc-url $SCROLL_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0x901c0D640aa4E3163cDbc2C86157D66d49BcD7BF' '0x2300aD45C2BA39c08bb45BE75c1a6C0fe88962Bf'
#BLAST
forge script --legacy --gas-estimate-multiplier 130 --chain 81457 script/ico.s.sol:OfferCoins --rpc-url $BLAST_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05' '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9'
#ETHEREUM
#forge script --chain 1 script/ico.s.sol:OfferCoins --rpc-url $ETHEREUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' 'coinseller' 'omnicoin'

#ZKSYNC
# forge script --use 0.8.24 --legacy --gas-estimate-multiplier 200 --chain 324 script/ico.s.sol:OfferCoins --zksync --rpc-url https://mainnet.era.zksync.io --broadcast --slow --via-ir -vvvv --sig 'run(address,address)' '0x92609A128FFF40e14d57e15CFE90f764a4A6edaC' '0x626cb53cD4A51F04B3701f2029B452732F897479'

#FUJI
#forge script --chain 43113 script/ico.s.sol:OfferCoins --rpc-url $FUJI_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0x5a3A1b445D359b3d1998aff075C73A2c88c29F1C' '0x7c617746Be398758ba704CAb7c4D8523587fbaEe'
#BNBT
#forge script --chain 97 script/ico.s.sol:OfferCoins --rpc-url $BNB_TESTNET_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' 'coinseller' 'omnicoin'