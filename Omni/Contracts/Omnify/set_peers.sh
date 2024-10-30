#!/bin/bash
source .env
# AVALANCHE
forge script --chain 43114 script/peersetter.s.sol:PeerSetter --rpc-url $AVALANCHE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x27Efe83C0629D5c3B1C3554EaB3E2B3645d2465e'
#OPTIMISM
forge script --legacy --gas-estimate-multiplier 130 --chain 10 script/peersetter.s.sol:PeerSetter --rpc-url $OPTIMISM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x7E6630282a88AE7318fa00658Ba4a8665303C455'
#BSC
forge script --chain 56 script/peersetter.s.sol:PeerSetter --rpc-url $BNB_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x855b3389f56Ed63A00684AF8522fadba4A14984b'
#ARBITRUM
forge script --legacy --gas-estimate-multiplier 130 --chain 42161 script/peersetter.s.sol:PeerSetter --rpc-url $ARBITRUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xA1A9698513201768357C6d05e939cc684e6Daf4B'
#APE
forge script --legacy --gas-estimate-multiplier 130 --chain 33139 script/peersetter.s.sol:PeerSetter --rpc-url $APE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136'
#POLYGON
forge script --legacy --gas-estimate-multiplier 130 --chain 137 script/peersetter.s.sol:PeerSetter --rpc-url $POLYGON_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xB75Df341363E58C0B3684B263af629fe6cc73610'
#FANTOM
forge script --chain 250 script/peersetter.s.sol:PeerSetter --rpc-url $FANTOM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xB75Df341363E58C0B3684B263af629fe6cc73610'
#BASE
forge script --legacy --gas-estimate-multiplier 130 --chain 8453 script/peersetter.s.sol:PeerSetter --rpc-url $BASE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xB75Df341363E58C0B3684B263af629fe6cc73610'
#LINEA
forge script --legacy --gas-estimate-multiplier 130 --chain 59144 script/peersetter.s.sol:PeerSetter --rpc-url $LINEA_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x787dA54f5C1b003969B9639B71e104A433431266'
#MANTLE
forge script --skip-simulation --chain 5000 script/peersetter.s.sol:PeerSetter --rpc-url $MANTLE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xA79E2c0F5F5c3Ec5399855e5129e468034161E00'
#GNOSIS
forge script --chain 100 script/peersetter.s.sol:PeerSetter --rpc-url $GNOSIS_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x3Da72342e70440Fa3fd2C5105FB778a4E511040f'
#RONIN
#forge script --chain 2020 script/peersetter.s.sol:PeerSetter --rpc-url $RONIN_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'BRIDGE'
#CELO
forge script --legacy --gas-estimate-multiplier 130 --chain 42220 script/peersetter.s.sol:PeerSetter --rpc-url $CELO_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xB75Df341363E58C0B3684B263af629fe6cc73610'
#SCROLL
forge script --legacy --gas-estimate-multiplier 130 --chain 534352 script/peersetter.s.sol:PeerSetter --rpc-url $SCROLL_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x3Da72342e70440Fa3fd2C5105FB778a4E511040f'
#BLAST
forge script --legacy --gas-estimate-multiplier 130 --chain 81457 script/peersetter.s.sol:PeerSetter --rpc-url $BLAST_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0xBdc066F91b9DB3b854e3Ec15b6816944896974CD'
#ETHEREUM
#forge script --chain 1 script/peersetter.s.sol:PeerSetter --rpc-url $ETHEREUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'BRIDGE'

#ZKSYNC
# forge script --use 0.8.24 --legacy --gas-estimate-multiplier 200 --chain 324 script/peersetter.s.sol:PeerSetter --zksync --rpc-url https://mainnet.era.zksync.io --broadcast --via-ir -vvvv --sig 'run(address)' '0x57835D82CBfd964Fa18CB7E488dB3e7c39B003F0'

#FUJI
#forge script --chain 43113 script/peersetter.s.sol:PeerSetter --rpc-url $FUJI_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'BRIDGE'
#BNBT
#forge script --chain 97 script/peersetter.s.sol:PeerSetter --rpc-url $BNB_TESTNET_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'BRIDGE'