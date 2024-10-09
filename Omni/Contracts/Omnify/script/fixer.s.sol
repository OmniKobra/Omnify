pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";

interface IFixGov {
    function setOmniCoinAddress(address _omniCoinAddress) external;

    function whitelistAddress(address _contract) external;
}

interface IFixTransfers {
    function setOmnifyAddress(address _newaddress) external;
}

interface IFixPayments {
    function setOmnifyAddress(address _newaddress) external;
}

interface IFixTrust {
    function setOmnifyAddress(address _newaddress) external;
}

interface IFixEscrow {
    function setOmnifyAddress(address _newaddress) external;
}

interface IFixBridge {
    function setOmnifyAddress(address _newaddress) external;

    function endpoint() external returns (address);

    function thisChainEid() external returns (uint32);

    function publicSetPeer(uint32 _eid, address _peer) external;
}

interface IFixCoinseller {
    function omnifyAddress() external returns (address);

    function setOmnifyAddress(address _newaddress) external;
}

contract MyScript is Script {

    function setter(uint32 _eid, address _peer) private {
        IFixBridge target = IFixBridge(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);
        target.publicSetPeer(_eid, _peer);
    }


    function run() external {
        uint256 deployerPrivateKey = vm.envUint("EVM_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        IFixGov gov = IFixGov(0x883bA282D409e0E984Bef70B338f641D0045942F);

        IFixTransfers transfers = IFixTransfers(0x06d7307E9678816d256036354866Ab9490355a05);
        transfers.setOmnifyAddress(address(0x883bA282D409e0E984Bef70B338f641D0045942F));
        gov.whitelistAddress(address(0x06d7307E9678816d256036354866Ab9490355a05));

        IFixPayments payments = IFixPayments(0xcEeC51f724d25Ce6BA0E4aA2DFc55eEa336ee8BE);
        payments.setOmnifyAddress(address(0x883bA282D409e0E984Bef70B338f641D0045942F));
        gov.whitelistAddress(address(0xcEeC51f724d25Ce6BA0E4aA2DFc55eEa336ee8BE));

        IFixTrust trust = IFixTrust(0x8D19256c92DCfad71aDCC7573de4817D31F18B14);
        trust.setOmnifyAddress(address(0x883bA282D409e0E984Bef70B338f641D0045942F));
        gov.whitelistAddress(address(0x8D19256c92DCfad71aDCC7573de4817D31F18B14));

        IFixBridge bridge = IFixBridge(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136);
        bridge.setOmnifyAddress(address(0x883bA282D409e0E984Bef70B338f641D0045942F));
        gov.whitelistAddress(address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136));

        setter(30106, address(0x6e819151184D165686D2DC46B77d6271A4b70270)); // avalanche mainnet
        setter(30111, address(0xCC404532787c9E1D478F6aa14DF1C4219939145E)); //optimism
        setter(30102, address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136)); //bsc mainnet
        setter(30110, address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136)); // arbitrum
        setter(30109, address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136)); //polygon
        setter(30112, address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136)); //fantom
        setter(30184, address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136)); //base
        setter(30183, address(0x6445CE5e7F342eA217bf08781dBd53876F3BF383)); //linea
        setter(30145, address(0x6e819151184D165686D2DC46B77d6271A4b70270)); //gnosis
        setter(30165, address(0x8363091e979B1cfdc9f08b45A46d175781ceD884)); //zksync
        setter(30125, address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136)); //celo
        setter(30214, address(0xB0A50b25949dC9ac16524ac97a48565c08F7C643)); //scroll
        setter(30243, address(0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136));//blast

        uint32 chainId = bridge.thisChainEid();
        address endpoint = bridge.endpoint();
        console.logUint(chainId);
        console.logAddress(endpoint);

        IFixEscrow escrow = IFixEscrow(0x6e819151184D165686D2DC46B77d6271A4b70270);
        escrow.setOmnifyAddress(address(0x883bA282D409e0E984Bef70B338f641D0045942F));
        gov.whitelistAddress(address(0x6e819151184D165686D2DC46B77d6271A4b70270));

        IFixCoinseller coinseller = IFixCoinseller(0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05);
//        coinseller.setOmnifyAddress(address(0x883bA282D409e0E984Bef70B338f641D0045942F));
        gov.whitelistAddress(address(0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05));
        address ofyAddressOnCoinseller = coinseller.omnifyAddress();
        console.logAddress(ofyAddressOnCoinseller);
        vm.stopBroadcast();
    }
}

//omnifyAddress: '0x883bA282D409e0E984Bef70B338f641D0045942F',
//transfersAddress: '0x06d7307E9678816d256036354866Ab9490355a05',
//paymentsAddress: '0xcEeC51f724d25Ce6BA0E4aA2DFc55eEa336ee8BE',
//trustAddress: '0x8D19256c92DCfad71aDCC7573de4817D31F18B14',
//bridgeAddress: '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136',
//escrowAddress: '0x6e819151184D165686D2DC46B77d6271A4b70270',
//omnicoinAddress: '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9',
//coinSellerAddress: "0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05",