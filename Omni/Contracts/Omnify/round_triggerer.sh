#!/bin/bash
source .env
# AVALANCHE
forge script --chain 43114 script/roundtriggerer.s.sol:RoundTrigger --rpc-url $AVALANCHE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x67b306745b6679778Dc4bB488be3a56655DFA939'
#OPTIMISM
forge script --legacy --gas-estimate-multiplier 130 --chain 10 script/roundtriggerer.s.sol:RoundTrigger --rpc-url $OPTIMISM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05'
#BSC
forge script --chain 56 script/roundtriggerer.s.sol:RoundTrigger --rpc-url $BNB_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x883bA282D409e0E984Bef70B338f641D0045942F'
#ARBITRUM
forge script --legacy --gas-estimate-multiplier 130 --chain 42161 script/roundtriggerer.s.sol:RoundTrigger --rpc-url $ARBITRUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x883bA282D409e0E984Bef70B338f641D0045942F'
#POLYGON
forge script --legacy --gas-estimate-multiplier 130 --chain 137 script/roundtriggerer.s.sol:RoundTrigger --rpc-url $POLYGON_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x883bA282D409e0E984Bef70B338f641D0045942F'
#FANTOM
forge script --chain 250 script/roundtriggerer.s.sol:RoundTrigger --rpc-url $FANTOM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x883bA282D409e0E984Bef70B338f641D0045942F'
#BASE
forge script --legacy --gas-estimate-multiplier 130 --chain 8453 script/roundtriggerer.s.sol:RoundTrigger --rpc-url $BASE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x883bA282D409e0E984Bef70B338f641D0045942F'
#LINEA
forge script --legacy --gas-estimate-multiplier 130 --chain 59144 script/roundtriggerer.s.sol:RoundTrigger --rpc-url $LINEA_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x0490b255168549725a1cb880A44Dc9B090f88E07'
#MANTLE
forge script --legacy --gas-estimate-multiplier 200 --chain 5000 script/roundtriggerer.s.sol:RoundTrigger --rpc-url $MANTLE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x883bA282D409e0E984Bef70B338f641D0045942F'
#GNOSIS
forge script --chain 100 script/roundtriggerer.s.sol:RoundTrigger --rpc-url $GNOSIS_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x67b306745b6679778Dc4bB488be3a56655DFA939'
#RONIN
#forge script --chain 2020 script/roundtriggerer.s.sol:RoundTrigger --rpc-url $RONIN_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'omnify'
#CELO
forge script --chain 42220 script/roundtriggerer.s.sol:RoundTrigger --rpc-url $CELO_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x883bA282D409e0E984Bef70B338f641D0045942F'
#SCROLL
forge script --legacy --gas-estimate-multiplier 130 --chain 534352 script/roundtriggerer.s.sol:RoundTrigger --rpc-url $SCROLL_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x135d68d97081A7132eb41E107E6b7Ed94202a9A4'
#BLAST
forge script --legacy --gas-estimate-multiplier 130 --chain 81457 script/roundtriggerer.s.sol:RoundTrigger --rpc-url $BLAST_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x883bA282D409e0E984Bef70B338f641D0045942F'
#ETHEREUM
#forge script --chain 1 script/roundtriggerer.s.sol:RoundTrigger --rpc-url $ETHEREUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'omnify'

#ZKSYNC
# forge script --use 0.8.24 --legacy --gas-estimate-multiplier 200 --chain 324 script/roundtriggerer.s.sol:RoundTrigger --zksync --rpc-url https://mainnet.era.zksync.io --broadcast --slow --via-ir -vvvv --sig 'run(address)' '0xf87048C473E7A4952252E63b8531230dcEB4081B'

#FUJI
#forge script --chain 43113 script/roundtriggerer.s.sol:RoundTrigger --rpc-url $FUJI_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x0a187D975624dE816e4FbeFbD3e2Ac4Bb686eD20'
#BNBT
#forge script --chain 97 script/roundtriggerer.s.sol:RoundTrigger --rpc-url $BNB_TESTNET_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' '0x9CEA849181e0E8938791beC142C568b135543E17'