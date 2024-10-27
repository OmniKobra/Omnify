pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";

//forge script --chain fuji script/governancetester.s.sol:GovernanceScript --rpc-url $FUJI_RPC_URL --broadcast --via-ir -vvvv
interface IOmnify5 {
    function newMilestone(
        string calldata _title,
        string calldata _description
    ) external;

    function triggerNewDistributionRoundByOwner() external;
}

contract RoundTrigger is Script {
    function run(address omnifyAddress) external {
        uint256 deployerPrivateKey = vm.envUint("EVM_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        IOmnify5 omnify = IOmnify5(omnifyAddress);
        omnify.triggerNewDistributionRoundByOwner();
        vm.stopBroadcast();
    }
}

contract Milestoner is Script {
    function run(address omnifyAddress) external {
        uint256 deployerPrivateKey = vm.envUint("EVM_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        IOmnify5 omnify = IOmnify5(omnifyAddress);
        omnify.newMilestone("Milestone Title", "Milestone Description");
        vm.stopBroadcast();
    }
}

contract TronRoundTrigger is Script {
    function run(address omnifyAddress) external {
        uint256 deployerPrivateKey = vm.envUint("TRON_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        IOmnify5 omnify = IOmnify5(omnifyAddress);
        omnify.triggerNewDistributionRoundByOwner();
        vm.stopBroadcast();
    }
}

contract TronMilestoner is Script {
    function run(address omnifyAddress) external {
        uint256 deployerPrivateKey = vm.envUint("TRON_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        IOmnify5 omnify = IOmnify5(omnifyAddress);
        omnify.newMilestone("Milestone Title", "Milestone Description");
        vm.stopBroadcast();
    }
}
