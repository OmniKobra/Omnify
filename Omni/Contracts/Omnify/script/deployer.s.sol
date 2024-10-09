pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
import "../src/govern.sol";
import "../src/coinseller.sol";

//forge script --chain fuji script/deployer.s.sol:DeployScript --rpc-url $FUJI_RPC_URL --broadcast --via-ir -vvvv
//forge script --chain 97 script/deployer.s.sol:DeployScript --rpc-url $BNB_RPC_URL --broadcast --via-ir -vvvv
interface IOmnify8 {
    function setOmniCoinAddress(address _omniCoinAddress) external;

    function setHoldingAndRoundInterval(uint256 _holdingPeriod, uint256 _interval) external;

    function whitelistAddress(address _contract) external;

    function changeOmnifyAddressOnOmnicoin(address newAddress) external;
}

interface IOmniFeature {
    function setOmnifyAddress(address _newaddress) external;
}

interface ICoinseller2 {
    function offerCoins(uint256 amount) external;
    function withdrawLeftovers() external;
    function setUnlockDuration(uint256 newDuration) external;
    function setIcoDuration(uint256 nd) external;
    function buyCoins(uint256 want) external payable;
}

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("EVM_TESTING_PRIVATE_KEYB");
        ICoinseller2 coinseller = ICoinseller2(0x5a3A1b445D359b3d1998aff075C73A2c88c29F1C);
        coinseller.buyCoins{value: 1.2 * (10 ** 18)}(100);
        vm.startBroadcast(deployerPrivateKey);
        // address omnifyAddress = address(0x0a187D975624dE816e4FbeFbD3e2Ac4Bb686eD20);
        // address omnicoinAddress = address(0x7c617746Be398758ba704CAb7c4D8523587fbaEe);
        // IOmnify8 theOmnify = IOmnify8(0x0a187D975624dE816e4FbeFbD3e2Ac4Bb686eD20);
        // uint256 pricePerCoin = 12000000000000000;
        // uint256 unlockDuration = 3 days;
        // uint256 icoDuration = 3 days;
        // address coinsellerAddress = address(new Coinseller(omnifyAddress, omnicoinAddress, pricePerCoin, unlockDuration, icoDuration));
        // theOmnify.whitelistAddress(coinsellerAddress);
        /*
           IOmnify8 oldOmnify = IOmnify8(0x1959794ebB50027959f44D64540a8cB09B1eBC62);

           address omnifyContract = address(new Omnify(18, 30000000000000000));

           oldOmnify.changeOmnifyAddressOnOmnicoin(omnifyContract);

           IOmnify8 omnify = IOmnify8(omnifyContract);
           omnify.setHoldingAndRoundInterval(2 days, 1 days);

           address transfersAddress = address(0x46A536beDe3C736Fa23f6725d4FC16F770A508d1);
           address paymentsAddress = address(0x0728a761eFE78Eb8FEf02f0754A0C4BBCc041BA1);
           address trustAddress = address(0x36acbeEa5c54044c27603d1632657C6A5CBAADff);
           address bridgeAddress = address(0x375875470085bD524BBF05e7931Aa0882886A278);
           address escrowAddress = address(0x548eD112D78528D2EB6d84228751Ab22527e456b);
           address omniCoinAddress = address(0x7c617746Be398758ba704CAb7c4D8523587fbaEe);

           omnify.setOmniCoinAddress(omniCoinAddress);
           omnify.whitelistAddress(transfersAddress);
           omnify.whitelistAddress(paymentsAddress);
           omnify.whitelistAddress(trustAddress);
           omnify.whitelistAddress(bridgeAddress);
           omnify.whitelistAddress(escrowAddress);

           IOmniFeature transfers = IOmniFeature(transfersAddress);
           IOmniFeature payments = IOmniFeature(paymentsAddress);
           IOmniFeature trust = IOmniFeature(trustAddress);
           IOmniFeature bridges = IOmniFeature(bridgeAddress);
           IOmniFeature escrow = IOmniFeature(escrowAddress);

           transfers.setOmnifyAddress(omnifyContract);
           payments.setOmnifyAddress(omnifyContract);
           trust.setOmnifyAddress(omnifyContract);
           bridges.setOmnifyAddress(omnifyContract);
           escrow.setOmnifyAddress(omnifyContract); */

        vm.stopBroadcast();
    }
}
