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
//        IGov gov = IGov(0x883bA282D409e0E984Bef70B338f641D0045942F);
//        gov.setOmniCoinAddress(address(0xe6C211a8b4F32D0EA16389D282A199D29A1366D9));
//        address ad = gov.omniCoinAddress();
//        console.logAddress(ad);
        MYIERC20 omnicoin = MYIERC20(omnicoinAddress);
        omnicoin.approve(coinsellerAddress, 218750);
        ICoinseller coinseller = ICoinseller(coinsellerAddress);
        uint256 icoDuration = 101 days;
        coinseller.setIcoDuration(icoDuration);
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
