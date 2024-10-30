pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
import "../src/ierc20.sol";

interface ICoinseller {
    function offerCoins(uint256 amount) external;

    function withdrawLeftovers() external;

    function setUnlockDuration(uint256 newDuration) external;

    function setIcoDuration(uint256 nd) external;
}

interface IGov {
    function omniCoinAddress() external returns (address);
    function setOmniCoinAddress(address _omniCoinAddress) external;
}

contract OfferCoins is Script {
    function run(address coinsellerAddress, address omnicoinAddress) external {
        uint256 deployerPrivateKey = vm.envUint("EVM_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
    //    IGov gov = IGov(0xBa39542aD2A115A2a86e2127a51A7674f8c8E3b9);
    //    gov.setOmniCoinAddress(address(0x1540Fdeb5A7D7759Bec11D4557921D9046F22605));
    //    address ad = gov.omniCoinAddress();
    //    console.logAddress(ad);
        MYIERC20 omnicoin = MYIERC20(omnicoinAddress);
        omnicoin.approve(coinsellerAddress, 218750);
        ICoinseller coinseller = ICoinseller(coinsellerAddress);
        coinseller.offerCoins(218750);
        vm.stopBroadcast();
    }
}

contract WithdrawLeftovers is Script {
    function run(address coinsellerAddress) external {
        uint256 deployerPrivateKey = vm.envUint("EVM_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        ICoinseller coinseller = ICoinseller(coinsellerAddress);
        coinseller.withdrawLeftovers();
        vm.stopBroadcast();
    }
}

contract TronOfferCoins is Script {
    function run(address coinsellerAddress, address omnicoinAddress) external {
        uint256 deployerPrivateKey = vm.envUint("TRON_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        MYIERC20 omnicoin = MYIERC20(omnicoinAddress);
        omnicoin.approve(coinsellerAddress, 218750);
        ICoinseller coinseller = ICoinseller(coinsellerAddress);
        coinseller.offerCoins(218750);
        vm.stopBroadcast();
    }
}

contract TronWithdrawLeftovers is Script {
    function run(address coinsellerAddress) external {
        uint256 deployerPrivateKey = vm.envUint("TRON_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        ICoinseller coinseller = ICoinseller(coinsellerAddress);
        coinseller.withdrawLeftovers();
        vm.stopBroadcast();
    }
}
