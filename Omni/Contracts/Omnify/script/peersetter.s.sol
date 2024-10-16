pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";

interface IOmnify11 {
    function publicSetPeer(uint32 _eid, address _peer) external;
}

contract PeerSetter is Script {
    function setter(uint32 _eid, address _currentTarget, address _peer) private {
            IOmnify11 target = IOmnify11(_currentTarget);
            target.publicSetPeer(_eid, _peer);
    }

    function run(address targetAddress) external {
        uint256 deployerPrivateKey = vm.envUint("EVM_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address avalancheContractAddress = address(0x27Efe83C0629D5c3B1C3554EaB3E2B3645d2465e);
        address OptimismContractAddress = address(0x7E6630282a88AE7318fa00658Ba4a8665303C455);
        //        address EthereumContractAddress = address(0);
        address BSCContractAddress = address(0x855b3389f56Ed63A00684AF8522fadba4A14984b);
        address ArbitrumContractAddress = address(0xA1A9698513201768357C6d05e939cc684e6Daf4B);
        address PolygonContractAddress = address(0xB75Df341363E58C0B3684B263af629fe6cc73610);
        address FantomContractAddress = address(0xB75Df341363E58C0B3684B263af629fe6cc73610);
//        address TronContractAddress = address(0);
        address BaseContractAddress = address(0xB75Df341363E58C0B3684B263af629fe6cc73610);
        address LineaContractAddress = address(0x787dA54f5C1b003969B9639B71e104A433431266);
        address MantleContractAddress = address(0xA79E2c0F5F5c3Ec5399855e5129e468034161E00);
        address GnosisContractAddress = address(0x3Da72342e70440Fa3fd2C5105FB778a4E511040f);
        address ZksyncContractAddress = address(0x57835D82CBfd964Fa18CB7E488dB3e7c39B003F0);
        address CeloContractAddress = address(0xB75Df341363E58C0B3684B263af629fe6cc73610);
        address ScrollContractAddress = address(0x3Da72342e70440Fa3fd2C5105FB778a4E511040f);
        address blastContractAddress = address(0xBdc066F91b9DB3b854e3Ec15b6816944896974CD);

        setter(30106, targetAddress, avalancheContractAddress); // avalanche mainnet
        setter(30111, targetAddress, OptimismContractAddress); //optimism
        //        setter(30101, EthereumContractAddress); //ethereum
        setter(30102, targetAddress, BSCContractAddress); //bsc mainnet
        setter(30110, targetAddress, ArbitrumContractAddress); // arbitrum
        setter(30109, targetAddress, PolygonContractAddress); //polygon
        setter(30112, targetAddress, FantomContractAddress); //fantom
//        setter(30420, targetAddress, TronContractAddress); //tron
        setter(30184, targetAddress, BaseContractAddress); //base
        setter(30183, targetAddress, LineaContractAddress); //linea
        setter(30181, targetAddress, MantleContractAddress); //mantle
        setter(30145, targetAddress, GnosisContractAddress); //gnosis
        setter(30165, targetAddress, ZksyncContractAddress); //zksync
        setter(30125, targetAddress, CeloContractAddress); //celo
        setter(30214, targetAddress, ScrollContractAddress); //scroll
        setter(30243, targetAddress, blastContractAddress); //blast

        vm.stopBroadcast();
    }
}

contract TronPeerSetter is Script {
    function setter(uint32 _eid, address _currentTarget, address _peer) private {
            IOmnify11 target = IOmnify11(_currentTarget);
            target.publicSetPeer(_eid, _peer);
    }

    function run(address targetAddress) external {
        uint256 deployerPrivateKey = vm.envUint("TRON_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address avalancheContractAddress = address(0x27Efe83C0629D5c3B1C3554EaB3E2B3645d2465e);
        address OptimismContractAddress = address(0x7E6630282a88AE7318fa00658Ba4a8665303C455);
        //        address EthereumContractAddress = address(0);
        address BSCContractAddress = address(0x855b3389f56Ed63A00684AF8522fadba4A14984b);
        address ArbitrumContractAddress = address(0xA1A9698513201768357C6d05e939cc684e6Daf4B);
        address PolygonContractAddress = address(0xB75Df341363E58C0B3684B263af629fe6cc73610);
        address FantomContractAddress = address(0xB75Df341363E58C0B3684B263af629fe6cc73610);
        address BaseContractAddress = address(0xB75Df341363E58C0B3684B263af629fe6cc73610);
        address LineaContractAddress = address(0x787dA54f5C1b003969B9639B71e104A433431266);
        address MantleContractAddress = address(0xA79E2c0F5F5c3Ec5399855e5129e468034161E00);
        address GnosisContractAddress = address(0x3Da72342e70440Fa3fd2C5105FB778a4E511040f);
        address ZksyncContractAddress = address(0x57835D82CBfd964Fa18CB7E488dB3e7c39B003F0);
        address CeloContractAddress = address(0xB75Df341363E58C0B3684B263af629fe6cc73610);
        address ScrollContractAddress = address(0x3Da72342e70440Fa3fd2C5105FB778a4E511040f);
        address blastContractAddress = address(0xBdc066F91b9DB3b854e3Ec15b6816944896974CD);

        setter(30106, targetAddress, avalancheContractAddress); // avalanche mainnet
        setter(30111, targetAddress, OptimismContractAddress); //optimism
        //        setter(30101, EthereumContractAddress); //ethereum
        setter(30102, targetAddress, BSCContractAddress); //bsc mainnet
        setter(30110, targetAddress, ArbitrumContractAddress); // arbitrum
        setter(30109, targetAddress, PolygonContractAddress); //polygon
        setter(30112, targetAddress, FantomContractAddress); //fantom
        setter(30184, targetAddress, BaseContractAddress); //base
        setter(30183, targetAddress, LineaContractAddress); //linea
        setter(30181, targetAddress, MantleContractAddress); //mantle
        setter(30145, targetAddress, GnosisContractAddress); //gnosis
        setter(30165, targetAddress, ZksyncContractAddress); //zksync
        setter(30125, targetAddress, CeloContractAddress); //celo
        setter(30214, targetAddress, ScrollContractAddress); //scroll
        setter(30243, targetAddress, blastContractAddress); //blast

        vm.stopBroadcast();
    }
}
