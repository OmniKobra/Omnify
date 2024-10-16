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

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("EVM_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        IFixGov gov = IFixGov(0xBa39542aD2A115A2a86e2127a51A7674f8c8E3b9);

        IFixTransfers transfers = IFixTransfers(0x0f2E150ab8321d54C5216F89C2116B44206BD511);
        transfers.setOmnifyAddress(address(0xBa39542aD2A115A2a86e2127a51A7674f8c8E3b9));
        gov.whitelistAddress(address(0x0f2E150ab8321d54C5216F89C2116B44206BD511));

        IFixPayments payments = IFixPayments(0x16044fC5CD74a90f3187f9988925A3D74F17049A);
        payments.setOmnifyAddress(address(0xBa39542aD2A115A2a86e2127a51A7674f8c8E3b9));
        gov.whitelistAddress(address(0x16044fC5CD74a90f3187f9988925A3D74F17049A));

        IFixTrust trust = IFixTrust(0x4c01E342261B6eA5a63f63C458A3D0b7c4715235);
        trust.setOmnifyAddress(address(0xBa39542aD2A115A2a86e2127a51A7674f8c8E3b9));
        gov.whitelistAddress(address(0x4c01E342261B6eA5a63f63C458A3D0b7c4715235));

        IFixBridge bridge = IFixBridge(0xA79E2c0F5F5c3Ec5399855e5129e468034161E00);
        bridge.setOmnifyAddress(address(0xBa39542aD2A115A2a86e2127a51A7674f8c8E3b9));
        gov.whitelistAddress(address(0xA79E2c0F5F5c3Ec5399855e5129e468034161E00));

        uint32 chainId = bridge.thisChainEid();
        address endpoint = bridge.endpoint();
        console.logUint(chainId);
        console.logAddress(endpoint);

        IFixEscrow escrow = IFixEscrow(0x4C279c15e9595E44Be496841350fc90CFf5C2e5b);
        escrow.setOmnifyAddress(address(0xBa39542aD2A115A2a86e2127a51A7674f8c8E3b9));
        gov.whitelistAddress(address(0x4C279c15e9595E44Be496841350fc90CFf5C2e5b));

        IFixCoinseller coinseller = IFixCoinseller(0xadAAA1F6b6e729B341C95D654eBb4d1c65B441eC);
//        coinseller.setOmnifyAddress(address(0xBa39542aD2A115A2a86e2127a51A7674f8c8E3b9));
        gov.whitelistAddress(address(0xadAAA1F6b6e729B341C95D654eBb4d1c65B441eC));
        address ofyAddressOnCoinseller = coinseller.omnifyAddress();
        console.logAddress(ofyAddressOnCoinseller);
        vm.stopBroadcast();
    }
}

//omnifyAddress: '0xBa39542aD2A115A2a86e2127a51A7674f8c8E3b9',
//transfersAddress: '0x0f2E150ab8321d54C5216F89C2116B44206BD511',
//paymentsAddress: '0x16044fC5CD74a90f3187f9988925A3D74F17049A',
//trustAddress: '0x4c01E342261B6eA5a63f63C458A3D0b7c4715235',
//bridgeAddress: '0xA79E2c0F5F5c3Ec5399855e5129e468034161E00',
//escrowAddress: '0x4C279c15e9595E44Be496841350fc90CFf5C2e5b',
//omnicoinAddress: '0x1540Fdeb5A7D7759Bec11D4557921D9046F22605',
//coinSellerAddress: "0xadAAA1F6b6e729B341C95D654eBb4d1c65B441eC",