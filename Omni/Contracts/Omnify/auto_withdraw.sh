#!/bin/bash
source .env
# AVALANCHE
forge script --chain 43114 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $AVALANCHE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x7e688b0a2eE53B3136EDE687Fe4260d7Dc578674'
#OPTIMISM
forge script --legacy --gas-estimate-multiplier 130 --chain 10 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $OPTIMISM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x9753c27106BE0b7562E1fA87800A674fA760e5b9'
#BSC
forge script --chain 56 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $BNB_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xC94bbe8954C960ca26782Fb7A63ad0e8e0a98Ba9'
#ARBITRUM
forge script --legacy --gas-estimate-multiplier 130 --chain 42161 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $ARBITRUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x855b3389f56Ed63A00684AF8522fadba4A14984b'
#APE
forge script --legacy --gas-estimate-multiplier 130 --chain 33139 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $APE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x883bA282D409e0E984Bef70B338f641D0045942F'
#POLYGON
forge script --legacy --gas-estimate-multiplier 130 --chain 137 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $POLYGON_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xDc78DAe441E2d6997Ec177bbe2F6BCa42850dE01'
#FANTOM
forge script --chain 250 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $FANTOM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xDc78DAe441E2d6997Ec177bbe2F6BCa42850dE01'
#BASE
forge script --legacy --gas-estimate-multiplier 130 --chain 8453 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $BASE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xDc78DAe441E2d6997Ec177bbe2F6BCa42850dE01'
#LINEA
forge script --legacy --gas-estimate-multiplier 130 --chain 59144 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $LINEA_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xaA01ED5B276A1B61850799FFD8d42f9bc7fe8CC5'
#MANTLE
forge script --legacy --gas-estimate-multiplier 200 --chain 5000 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $MANTLE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xBa39542aD2A115A2a86e2127a51A7674f8c8E3b9'
#GNOSIS
forge script --chain 100 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $GNOSIS_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xd0AdC46C8Af67382b23AB68b330BDbc3bb6A326a'
#RONIN
#forge script --chain 2020 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $RONIN_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'omnify'
#CELO
forge script --chain 42220 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $CELO_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xDc78DAe441E2d6997Ec177bbe2F6BCa42850dE01'
#SCROLL
forge script --legacy --gas-estimate-multiplier 130 --chain 534352 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $SCROLL_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xd0AdC46C8Af67382b23AB68b330BDbc3bb6A326a'
#BLAST
forge script --legacy --gas-estimate-multiplier 130 --chain 81457 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $BLAST_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x5762D178F6A449BE90C6f98EB94769F792f8e9E2'
#ETHEREUM
#forge script --chain 1 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $ETHEREUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'omnify'

#ZKSYNC
# forge script --use 0.8.24 --legacy --gas-estimate-multiplier 200 --chain 324 script/withdrawer.s.sol:ProfitWithdrawer --zksync --rpc-url https://mainnet.era.zksync.io --broadcast --slow --via-ir -vvvv --sig 'run(address)' '0xDCde411FacD5081fa304542f57bF1B0A731a8B50'

#FUJI
#forge script --chain 43113 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $FUJI_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x0a187D975624dE816e4FbeFbD3e2Ac4Bb686eD20'
#BNBT
#forge script --chain 97 script/withdrawer.s.sol:ProfitWithdrawer --rpc-url $BNB_TESTNET_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x9CEA849181e0E8938791beC142C568b135543E17'