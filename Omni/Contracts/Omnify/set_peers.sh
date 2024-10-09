#!/bin/bash
source .env
# AVALANCHE
forge script --chain 43114 script/peersetter.s.sol:PeerSetter --rpc-url $AVALANCHE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x6e819151184D165686D2DC46B77d6271A4b70270'
#OPTIMISM
forge script --legacy --gas-estimate-multiplier 130 --chain 10 script/peersetter.s.sol:PeerSetter --rpc-url $OPTIMISM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xCC404532787c9E1D478F6aa14DF1C4219939145E'
#BSC
forge script --chain 56 script/peersetter.s.sol:PeerSetter --rpc-url $BNB_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136'
#ARBITRUM
forge script --legacy --gas-estimate-multiplier 130 --chain 42161 script/peersetter.s.sol:PeerSetter --rpc-url $ARBITRUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136'
#POLYGON
forge script --legacy --gas-estimate-multiplier 130 --chain 137 script/peersetter.s.sol:PeerSetter --rpc-url $POLYGON_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136'
#FANTOM
forge script --chain 250 script/peersetter.s.sol:PeerSetter --rpc-url $FANTOM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136'
#BASE
forge script --legacy --gas-estimate-multiplier 130 --chain 8453 script/peersetter.s.sol:PeerSetter --rpc-url $BASE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136'
#LINEA
forge script --legacy --gas-estimate-multiplier 130 --chain 59144 script/peersetter.s.sol:PeerSetter --rpc-url $LINEA_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x6445CE5e7F342eA217bf08781dBd53876F3BF383'
#MANTLE
forge script --skip-simulation --chain 5000 script/peersetter.s.sol:PeerSetter --rpc-url $MANTLE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136'
#GNOSIS
forge script --chain 100 script/peersetter.s.sol:PeerSetter --rpc-url $GNOSIS_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x6e819151184D165686D2DC46B77d6271A4b70270'
#RONIN
#forge script --chain 2020 script/peersetter.s.sol:PeerSetter --rpc-url $RONIN_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'BRIDGE'
#CELO
forge script --legacy --gas-estimate-multiplier 130 --chain 42220 script/peersetter.s.sol:PeerSetter --rpc-url $CELO_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136'
#SCROLL
forge script --legacy --gas-estimate-multiplier 130 --chain 534352 script/peersetter.s.sol:PeerSetter --rpc-url $SCROLL_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xB0A50b25949dC9ac16524ac97a48565c08F7C643'
#BLAST
forge script --legacy --gas-estimate-multiplier 130 --chain 81457 script/peersetter.s.sol:PeerSetter --rpc-url $BLAST_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136'
#ETHEREUM
#forge script --chain 1 script/peersetter.s.sol:PeerSetter --rpc-url $ETHEREUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'BRIDGE'

#ZKSYNC
# forge script --use 0.8.24 --legacy --gas-estimate-multiplier 200 --chain 324 script/peersetter.s.sol:PeerSetter --zksync --rpc-url https://mainnet.era.zksync.io --broadcast --via-ir -vvvv --sig 'run(address)' '0x8363091e979B1cfdc9f08b45A46d175781ceD884'

#FUJI
#forge script --chain 43113 script/peersetter.s.sol:PeerSetter --rpc-url $FUJI_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'BRIDGE'
#BNBT
#forge script --chain 97 script/peersetter.s.sol:PeerSetter --rpc-url $BNB_TESTNET_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'BRIDGE'