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

        address avalancheContractAddress = address(0x6e819151184D165686D2DC46B77d6271A4b70270);
        address OptimismContractAddress = address(0xCC404532787c9E1D478F6aa14DF1C4219939145E);
        //        address EthereumContractAddress = address(0);
        address BSCContractAddress = address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);
        address ArbitrumContractAddress = address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);
        address PolygonContractAddress = address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);
        address FantomContractAddress = address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);
//        address TronContractAddress = address(0);
        address BaseContractAddress = address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);
        address LineaContractAddress = address(0x6445CE5e7F342eA217bf08781dBd53876F3BF383);
        address MantleContractAddress = address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);
        address GnosisContractAddress = address(0x6e819151184D165686D2DC46B77d6271A4b70270);
        address ZksyncContractAddress = address(0x8363091e979B1cfdc9f08b45A46d175781ceD884);
        address CeloContractAddress = address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);
        address ScrollContractAddress = address(0xB0A50b25949dC9ac16524ac97a48565c08F7C643);
        address blastContractAddress = address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);

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
        if (_currentTarget != _peer) {
            IOmnify11 target = IOmnify11(_currentTarget);
            target.publicSetPeer(_eid, _peer);
        }
    }

    function run(address targetAddress) external {
        uint256 deployerPrivateKey = vm.envUint("TRON_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address avalancheContractAddress = address(0x6e819151184D165686D2DC46B77d6271A4b70270);
        address OptimismContractAddress = address(0xCC404532787c9E1D478F6aa14DF1C4219939145E);
        //        address EthereumContractAddress = address(0);
        address BSCContractAddress = address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);
        address ArbitrumContractAddress = address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);
        address PolygonContractAddress = address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);
        address FantomContractAddress = address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);
        address BaseContractAddress = address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);
        address LineaContractAddress = address(0x6445CE5e7F342eA217bf08781dBd53876F3BF383);
        address MantleContractAddress = address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);
        address GnosisContractAddress = address(0x6e819151184D165686D2DC46B77d6271A4b70270);
        address ZksyncContractAddress = address(0x8363091e979B1cfdc9f08b45A46d175781ceD884);
        address CeloContractAddress = address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);
        address ScrollContractAddress = address(0xB0A50b25949dC9ac16524ac97a48565c08F7C643);
        address blastContractAddress = address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);

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
