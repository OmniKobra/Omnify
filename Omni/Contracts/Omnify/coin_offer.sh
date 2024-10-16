#!/bin/bash
source .env
# AVALANCHE
forge script --chain 43114 script/ico.s.sol:OfferCoins --rpc-url $AVALANCHE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0xd0AdC46C8Af67382b23AB68b330BDbc3bb6A326a' '0x946e2B2f3E94d621fc8016e28EdA655448831021'
#OPTIMISM
forge script --legacy --gas-estimate-multiplier 130 --chain 10 script/ico.s.sol:OfferCoins --rpc-url $OPTIMISM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0xd73151f3a6aA783B1e90bdCd634b4eF72ca0323B' '0x105097f01655e18c5986B42469E7a92524ba5664'
#BSC
forge script --chain 56 script/ico.s.sol:OfferCoins --rpc-url $BNB_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0xBdc066F91b9DB3b854e3Ec15b6816944896974CD' '0xEe47e2484342eA7Bcf13B9e6d4F9d53B28F1b724'
#ARBITRUM
forge script --legacy --gas-estimate-multiplier 135 --chain 42161 script/ico.s.sol:OfferCoins --rpc-url $ARBITRUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0x9e4bbd964FB2B0B77E7a0103b7559d9544d896a6' '0x9753c27106BE0b7562E1fA87800A674fA760e5b9'
#POLYGON
forge script --legacy --gas-estimate-multiplier 130 --chain 137 script/ico.s.sol:OfferCoins --rpc-url $POLYGON_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0xEe47e2484342eA7Bcf13B9e6d4F9d53B28F1b724' '0x8eAC1C3eD1e78bd373965818816987d525158148'
#FANTOM
forge script --chain 250 script/ico.s.sol:OfferCoins --rpc-url $FANTOM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0xEe47e2484342eA7Bcf13B9e6d4F9d53B28F1b724' '0x8eAC1C3eD1e78bd373965818816987d525158148'
#BASE
forge script --legacy --gas-estimate-multiplier 130 --chain 8453 script/ico.s.sol:OfferCoins --rpc-url $BASE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0xEe47e2484342eA7Bcf13B9e6d4F9d53B28F1b724' '0x8eAC1C3eD1e78bd373965818816987d525158148'
#LINEA
forge script --legacy --gas-estimate-multiplier 130 --chain 59144 script/ico.s.sol:OfferCoins --rpc-url $LINEA_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0xF9b3CBb3D2BCAafA30F04B033B88F9f353bb1003' '0x3Da72342e70440Fa3fd2C5105FB778a4E511040f'
#MANTLE
forge script --skip-simulation --chain 5000 script/ico.s.sol:OfferCoins --rpc-url $MANTLE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0xadAAA1F6b6e729B341C95D654eBb4d1c65B441eC' '0x1540Fdeb5A7D7759Bec11D4557921D9046F22605'
#GNOSIS
forge script --chain 100 script/ico.s.sol:OfferCoins --rpc-url $GNOSIS_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0xf6eDE440FC5524d680C0465f27D0A2E36b8aCB7e' '0x2d4563680b9edB817204f015Ee3C09C5959fE33D'
#RONIN
#forge script --chain 2020 script/ico.s.sol:OfferCoins --rpc-url $RONIN_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' 'coinseller' 'omnicoin'
#CELO
forge script --chain 42220 script/ico.s.sol:OfferCoins --rpc-url $CELO_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0xEe47e2484342eA7Bcf13B9e6d4F9d53B28F1b724' '0x8eAC1C3eD1e78bd373965818816987d525158148'
#SCROLL
forge script --legacy --gas-estimate-multiplier 130 --chain 534352 script/ico.s.sol:OfferCoins --rpc-url $SCROLL_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0xf6eDE440FC5524d680C0465f27D0A2E36b8aCB7e' '0x2d4563680b9edB817204f015Ee3C09C5959fE33D'
#BLAST
forge script --legacy --gas-estimate-multiplier 130 --chain 81457 script/ico.s.sol:OfferCoins --rpc-url $BLAST_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0x946e2B2f3E94d621fc8016e28EdA655448831021' '0xaA01ED5B276A1B61850799FFD8d42f9bc7fe8CC5'
#ETHEREUM
#forge script --chain 1 script/ico.s.sol:OfferCoins --rpc-url $ETHEREUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' 'coinseller' 'omnicoin'

#ZKSYNC
# forge script --use 0.8.24 --legacy --gas-estimate-multiplier 200 --chain 324 script/ico.s.sol:OfferCoins --zksync --rpc-url https://mainnet.era.zksync.io --broadcast --slow --via-ir -vvvv --sig 'run(address,address)' '0xDFc727aB34D89Ef83B4698731a06f9136ab0ffeB' '0x73999642A049d49688499c7D12412f51F01d64cD'

#FUJI
#forge script --chain 43113 script/ico.s.sol:OfferCoins --rpc-url $FUJI_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' '0x5a3A1b445D359b3d1998aff075C73A2c88c29F1C' '0x7c617746Be398758ba704CAb7c4D8523587fbaEe'
#BNBT
#forge script --chain 97 script/ico.s.sol:OfferCoins --rpc-url $BNB_TESTNET_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address)' 'coinseller' 'omnicoin'