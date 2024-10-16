pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";

interface IOmnify12 {
    function withdrawProfits() external;
}

contract ProfitWithdrawer is Script {
    function run(address omnifyAddress) external {
        uint256 deployerPrivateKey = vm.envUint("EVM_STASH_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        IOmnify12 omnify = IOmnify12(omnifyAddress);
        omnify.withdrawProfits();
        vm.stopBroadcast();
    }
}

contract TronProfitWithdrawer is Script {
    function run(address omnifyAddress) external {
        uint256 deployerPrivateKey = vm.envUint("TRON_STASH_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        IOmnify12 omnify = IOmnify12(omnifyAddress);
        omnify.withdrawProfits();
        vm.stopBroadcast();
    }
}
