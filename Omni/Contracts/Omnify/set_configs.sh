#!/bin/bash
source .env
# AVALANCHE                                                                                                                //run(oapp,dvn,executor,sendconfirmations)
forge script --chain 43114 script/setConfig.s.sol:SetConfig --rpc-url $AVALANCHE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address,address,uint64)' '0x27Efe83C0629D5c3B1C3554EaB3E2B3645d2465e' '0x962f502a63f5fbeb44dc9ab932122648e8352959' '0x90E595783E43eb89fF07f63d27B8430e6B44bD9c' '20'
#OPTIMISM
forge script --legacy --gas-estimate-multiplier 130 --chain 10 script/setConfig.s.sol:SetConfig --rpc-url $OPTIMISM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address,address,uint64)' '0x7E6630282a88AE7318fa00658Ba4a8665303C455' '0x6a02d83e8d433304bba74ef1c427913958187142' '0x2D2ea0697bdbede3F01553D2Ae4B8d0c486B666e' '75'
#BSC
forge script --chain 56 script/setConfig.s.sol:SetConfig --rpc-url $BNB_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address,address,uint64)' '0x855b3389f56Ed63A00684AF8522fadba4A14984b' '0xfd6865c841c2d64565562fcc7e05e619a30615f0' '0x3ebD570ed38B1b3b4BC886999fcF507e9D584859' '60'
#ARBITRUM
forge script --legacy --gas-estimate-multiplier 200 --chain 42161 script/setConfig.s.sol:SetConfig --rpc-url $ARBITRUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address,address,uint64)' '0xA1A9698513201768357C6d05e939cc684e6Daf4B' '0x2f55c492897526677c5b68fb199ea31e2c126416' '0x31CAe3B7fB82d847621859fb1585353c5720660D' '300'
#APE
forge script --legacy --gas-estimate-multiplier 200 --chain 33139 script/setConfig.s.sol:SetConfig --rpc-url $APE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address,address,uint64)' '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136' '0x6788f52439aca6bff597d3eec2dc9a44b8fee842' '0xcCE466a522984415bC91338c232d98869193D46e' '300'
#POLYGON
forge script --legacy --gas-estimate-multiplier 130 --chain 137 script/setConfig.s.sol:SetConfig --rpc-url $POLYGON_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address,address,uint64)' '0xB75Df341363E58C0B3684B263af629fe6cc73610' '0x23de2fe932d9043291f870324b74f820e11dc81a' '0xCd3F213AD101472e1713C72B1697E727C803885b' '250'
#FANTOM
forge script --chain 250 script/setConfig.s.sol:SetConfig --rpc-url $FANTOM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address,address,uint64)' '0xB75Df341363E58C0B3684B263af629fe6cc73610' '0xe60a3959ca23a92bf5aaf992ef837ca7f828628a' '0x2957eBc0D2931270d4a539696514b047756b3056' '30'
#BASE
forge script --legacy --gas-estimate-multiplier 130 --chain 8453 script/setConfig.s.sol:SetConfig --rpc-url $BASE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address,address,uint64)' '0xB75Df341363E58C0B3684B263af629fe6cc73610' '0x9e059a54699a285714207b43b055483e78faac25' '0x2CCA08ae69E0C44b18a57Ab2A87644234dAebaE4' '75'
#LINEA
forge script --legacy --gas-estimate-multiplier 130 --chain 59144 script/setConfig.s.sol:SetConfig --rpc-url $LINEA_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address,address,uint64)' '0x787dA54f5C1b003969B9639B71e104A433431266' '0x129ee430cb2ff2708ccaddbdb408a88fe4ffd480' '0x0408804C5dcD9796F22558464E6fE5bDdF16A7c7' '40'
#MANTLE
forge script --skip-simulation --chain 5000 script/setConfig.s.sol:SetConfig --rpc-url $MANTLE_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address,address,uint64)' '0xA79E2c0F5F5c3Ec5399855e5129e468034161E00' '0x28b6140ead70cb2fb669705b3598ffb4beaa060b' '0x4Fc3f4A38Acd6E4cC0ccBc04B3Dd1CCAeFd7F3Cd' '70'
#GNOSIS
forge script --chain 100 script/setConfig.s.sol:SetConfig --rpc-url $GNOSIS_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address,address,uint64)' '0x3Da72342e70440Fa3fd2C5105FB778a4E511040f' '0x11bb2991882a86dc3e38858d922559a385d506ba' '0x38340337f9ADF5D76029Ab3A667d34E5a032F7BA' '350'
#RONIN
#forge script --chain 2020 script/setConfig.s.sol:SetConfig --rpc-url $RONIN_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'BRIDGE' 'dvn' 'executor' 'sendconfirms'
#CELO
forge script --legacy --gas-estimate-multiplier 130 --chain 42220 script/setConfig.s.sol:SetConfig --rpc-url $CELO_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address,address,uint64)' '0xB75Df341363E58C0B3684B263af629fe6cc73610' '0x75b073994560a5c03cd970414d9170be0c6e5c36' '0x1dDbaF8b75F2291A97C22428afEf411b7bB19e28' '20'
#SCROLL
forge script --legacy --gas-estimate-multiplier 130 --chain 534352 script/setConfig.s.sol:SetConfig --rpc-url $SCROLL_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address,address,uint64)' '0x3Da72342e70440Fa3fd2C5105FB778a4E511040f' '0xbe0d08a85eebfcc6eda0a843521f7cbb1180d2e2' '0x581b26F362AD383f7B51eF8A165Efa13DDe398a4' '150'
#BLAST
forge script --legacy --gas-estimate-multiplier 130 --chain 81457 script/setConfig.s.sol:SetConfig --rpc-url $BLAST_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address,address,address,uint64)' '0xBdc066F91b9DB3b854e3Ec15b6816944896974CD' '0xc097ab8CD7b053326DFe9fB3E3a31a0CCe3B526f' '0x4208D6E27538189bB48E603D6123A94b8Abe0A0b' '150'
#ETHEREUM
#forge script --chain 1 script/setConfig.s.sol:SetConfig --rpc-url $ETHEREUM_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'BRIDGE'

#ZKSYNC
# forge script --use 0.8.24 --legacy --gas-estimate-multiplier 200 --chain 324 script/setConfig.s.sol:SetConfig --zksync --rpc-url https://mainnet.era.zksync.io --broadcast --slow --via-ir -vvvv --sig 'run(address,address,address,uint64)' '0x57835D82CBfd964Fa18CB7E488dB3e7c39B003F0' '0x620a9df73d2f1015ea75aea1067227f9013f5c51' '0x664e390e672A811c12091db8426cBb7d68D5D8A6' '1200'

#FUJI
#forge script --chain 43113 script/setConfig.s.sol:SetConfig --rpc-url $FUJI_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'BRIDGE'
#BNBT
#forge script --chain 97 script/setConfig.s.sol:SetConfig --rpc-url $BNB_TESTNET_RPC_URL --broadcast --via-ir -vvvv --sig 'run(address)' 'BRIDGE'