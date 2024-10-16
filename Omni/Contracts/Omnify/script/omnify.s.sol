pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
import "../src/govern.sol";
import "../src/omnicoin.sol";
import "../src/transfers.sol";
import "../src/payments.sol";
import "../src/trust.sol";
import "../src/bridges.sol";
import "../src/escrow.sol";
import "../src/coinseller.sol";

interface IOmnify2 {
    function setOmniCoinAddress(address _omniCoinAddress) external;

    function whitelistAddress(address _contract) external;
}

//forge script --chain fuji script/omnify.s.sol:MyScript --rpc-url $FUJI_RPC_URL --broadcast --verify --via-ir --optimize -vvvv
//forge script --chain 97 script/omnify.s.sol:MyScript --rpc-url $BNB_RPC_URL --broadcast --verify --via-ir --optimize -vvvv

contract MyScript is Script {
    /*todo before deployment:
    1. change lzendpoint address variable
    2. change chain id variable
    3. change tiers higher threshold decimal places
    4. change fee values
    5. use deployment private key for non testing
    */

    /* todo deployment pipeline:
    1. Deploy omnify contract and store address
    2. Deploy omnicoin address pass deployed omnify contract address param, store address
    3. Set omnicoin address on omnify contract
    4. Set coinsale address on omnify contract
    5. Run set peer script for all deployed contracts with acquired contract addresses
    6. whitelist coinsale
    7. offer coins coinsale
    */

    /* todo after deployment
    1. get omnify address on deployed chain
    2. get omnicoin address on deployed chain
    3. get transfers address on deployed chain
    4. get payments address on deployed chain
    5. get trust address on deployed chain
    6. get bridge address on deployed chain
    7. get escrow address on deployed chain
    8. get coinseller address on deployed chain
    */

    /*
    avalanche_fuji= 0x6EDCE65403992e310A62460808c4b910D972f10f  id: 40106
    bsc_test= 0x6EDCE65403992e310A62460808c4b910D972f10f  id: 40102
    */

    /*
    endpoints:
    avalanche= 0x1a44076050125825900e736c501f859c50fE728c id: 30106
    optimism= 0x1a44076050125825900e736c501f859c50fE728c  id: 30111
    ethereum= 0x1a44076050125825900e736c501f859c50fE728c  id: 30101
    bsc= 0x1a44076050125825900e736c501f859c50fE728c  id: 30102
    arbitrum= 0x1a44076050125825900e736c501f859c50fE728c  id: 30110
    polygon= 0x1a44076050125825900e736c501f859c50fE728c  id: 30109
    fantom= 0x1a44076050125825900e736c501f859c50fE728c  id: 30112
    tron= 0x0Af59750D5dB5460E5d89E268C474d5F7407c061  id: 30420
    base= 0x1a44076050125825900e736c501f859c50fE728c  id: 30184
    linea= 0x1a44076050125825900e736c501f859c50fE728c  id: 30183
    mantle= 0x1a44076050125825900e736c501f859c50fE728c  id: 30181
    gnosis= 0x1a44076050125825900e736c501f859c50fE728c  id: 30145
    ronin=

    WARNING: ZKSYNC uses different compiler
    zksync= 0xd07C30aF3Ff30D96BDc9c6044958230Eb797DDBF  id: 30165

    celo= 0x1a44076050125825900e736c501f859c50fE728c  id: 30125
    scroll= 0x1a44076050125825900e736c501f859c50fE728c  id: 30214
    blast= 0x1a44076050125825900e736c501f859c50fE728c  id:30243
    */

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("EVM_PRIVATE_KEY");

        address lzEndpoint = address(0x1a44076050125825900e736c501f859c50fE728c);
        uint32 _paramChainId = 30109;

        uint8 _paramNativeDecimals = 18;

        uint256 _paramProposalFee = 22200000000000000000; //$9.99
        uint256 _paramTier2Fee = 22200000000000000000; //$9.99
        uint256 _paramFeePerInstallment = 11000000000000000000; //$4.95
        uint256 _paramContractFee = 11000000000000000000; //$4.95
        uint256 _paramBridgeFee = 11000000000000000000; //$4.95
        uint256 _paramDepositFee = 8770000000000000000; //$3.95
        uint256 _paramBenefFee = 2220000000000000000; // $1
        uint256 _paramTier1Fee = 2220000000000000000; //$1
        uint256 _paramAltcoinFee = 4440000000000000000; //$2
        uint256 _paramTier3Fee = 220000000000000000000; //$99
        uint256 _paramTier4Fee = 366660000000000000000; //$165
        uint256 pricePerCoin = 1000000000000000000;//$0.42
        uint256 _paramFeePerPayment = 1000000000000000000; //$0.42

        uint256 _paramTier1HigherThreshold = 9999_999999999999999999;
        uint256 _paramTier2HigherThreshold = 99999_999999999999999999;
        uint256 _paramTier3HigherThreshold = 999999_999999999999999999;

        vm.startBroadcast(deployerPrivateKey);

        address omnifyAddress = address(new Omnify(
            _paramNativeDecimals,
            _paramProposalFee));
        address transfersAddress = address(new Transfers(
            omnifyAddress,
            _paramNativeDecimals,
            _paramAltcoinFee,
            _paramTier1Fee,
            _paramTier2Fee,
            _paramTier3Fee,
            _paramTier4Fee,
            _paramTier1HigherThreshold,
            _paramTier2HigherThreshold,
            _paramTier3HigherThreshold
        ));
        IOmnify2 omnifyContract = IOmnify2(omnifyAddress);
        omnifyContract.whitelistAddress(transfersAddress);
        address paymentsAddress = address(new Payments(
            omnifyAddress,
            _paramNativeDecimals,
            _paramFeePerInstallment,
            _paramFeePerPayment
        ));
        omnifyContract.whitelistAddress(paymentsAddress);
        address trustAddress = address(new Trust(
            omnifyAddress,
            _paramNativeDecimals,
            _paramDepositFee,
            _paramBenefFee
        ));
        omnifyContract.whitelistAddress(trustAddress);
        address bridgesAddress = address(new Bridges(
            lzEndpoint,
            _paramBridgeFee,
            _paramChainId,
            omnifyAddress
        ));
        omnifyContract.whitelistAddress(bridgesAddress);
        address escrowAddress = address(new Escrow(
            omnifyAddress,
            _paramNativeDecimals,
            _paramContractFee
        ));
        omnifyContract.whitelistAddress(escrowAddress);
        address omnicoin = address(new OmniCoin(omnifyAddress));
        omnifyContract.setOmniCoinAddress(omnicoin);
        uint256 unlockDuration = 1 days;
        uint256 icoDuration = 101 days;
        address coinsellerAddress = address(new Coinseller(omnifyAddress, omnicoin, pricePerCoin, unlockDuration, icoDuration));
        omnifyContract.whitelistAddress(coinsellerAddress);

        vm.stopBroadcast();
    }
}

