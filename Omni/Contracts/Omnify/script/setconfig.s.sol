pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
import {ILayerZeroEndpointV2} from "../lib/LayerZero-v2/packages/layerzero-v2/evm/protocol/contracts/interfaces/ILayerZeroEndpointV2.sol";
import "../lib/LayerZero-v2/packages/layerzero-v2/evm/protocol/contracts/interfaces/IMessageLibManager.sol";
import {UlnConfig} from "../lib/LayerZero-v2/packages/layerzero-v2/evm/messagelib/contracts/uln/UlnBase.sol";
import {ExecutorConfig} from "../lib/LayerZero-v2/packages/layerzero-v2/evm/messagelib/contracts/SendLibBase.sol";

interface ISendLib {
    function getConfig(uint32 _eid, address _oapp, uint32 _configType) external view returns (bytes memory);

    function getExecutorConfig(address _oapp, uint32 _remoteEid) external view returns (ExecutorConfig memory rtnConfig);

    function getUlnConfig(address _oapp, uint32 _remoteEid) external view returns (UlnConfig memory rtnConfig);
}

interface IReceiveLib {
    function getConfig(uint32 _eid, address _oapp, uint32 _configType) external view returns (bytes memory);

    function getUlnConfig(address _oapp, uint32 _remoteEid) external view returns (UlnConfig memory rtnConfig);
}

interface IMyOApp {
    function endpoint() external returns (address);
}

contract SetConfig is Script {
    uint32 public constant EXECUTOR_CONFIG_TYPE = 1;
    uint32 public constant ULN_CONFIG_TYPE = 2;
    uint32 public constant RECEIVE_CONFIG_TYPE = 2;

    function printExecutorConfig(address myOapp, uint32 target, ILayerZeroEndpointV2 _endpoint) private view {
        address sendLib = _endpoint.getSendLibrary(myOapp, target);
        ISendLib sendLibInterface = ISendLib(sendLib);
        ExecutorConfig memory executorConfig = sendLibInterface.getExecutorConfig(myOapp, target);
//        console.logUint(executorConfig.maxMessageSize);
//        console.logAddress(executorConfig.executor);
    }

    function printUlnConfig(address myOapp, uint32 target, ILayerZeroEndpointV2 _endpoint) private view {
        address sendLib = _endpoint.getSendLibrary(myOapp, target);
        ISendLib sendLibInterface = ISendLib(sendLib);
        UlnConfig memory ulnConfig = sendLibInterface.getUlnConfig(myOapp, target);
        console.logString("---------------------------------------------------------------------------------");
        console.logUint(ulnConfig.confirmations);
//        console.logUint(ulnConfig.requiredDVNCount);
        for (uint256 i = 0; i < ulnConfig.requiredDVNCount; i++) {
//            console.logAddress(ulnConfig.requiredDVNs[i]);
        }
//        console.logUint(ulnConfig.optionalDVNCount);
        for (uint256 i = 0; i < ulnConfig.optionalDVNCount; i++) {
//            console.logAddress(ulnConfig.optionalDVNs[i]);
        }
//        console.logUint(ulnConfig.optionalDVNThreshold);
    }

    function printReceiveUlnConfig(address myOapp, uint32 target, ILayerZeroEndpointV2 _endpoint) private view {
        (address sendLib,) = _endpoint.getReceiveLibrary(myOapp, target);
        IReceiveLib sendLibInterface = IReceiveLib(sendLib);
        UlnConfig memory ulnConfig = sendLibInterface.getUlnConfig(myOapp, target);
        console.logUint(ulnConfig.confirmations);
//        console.logUint(ulnConfig.requiredDVNCount);
        for (uint256 i = 0; i < ulnConfig.requiredDVNCount; i++) {
//            console.logAddress(ulnConfig.requiredDVNs[i]);
        }
//        console.logUint(ulnConfig.optionalDVNCount);
        for (uint256 i = 0; i < ulnConfig.optionalDVNCount; i++) {
//            console.logAddress(ulnConfig.optionalDVNs[i]);
        }
//        console.logUint(ulnConfig.optionalDVNThreshold);
        console.logString("---------------------------------------------------------------------------------");
    }

    function setSendConfig(address myOapp, uint32 target, ILayerZeroEndpointV2 _endpoint, address executor, address dvn1, uint64 confirmations) private {
        address sendLib = _endpoint.getSendLibrary(myOapp, target);
        ExecutorConfig memory executorConfig = ExecutorConfig({
            maxMessageSize: 2 ** 32 - 1,
            executor: executor
        });
        address[] memory requiredDvns = new address[](1);
        address[] memory optionalDvns = new address[](0);
        requiredDvns[0] = dvn1;
        UlnConfig memory ulnConfig = UlnConfig({
            confirmations: confirmations,
            requiredDVNCount: 1,
            requiredDVNs: requiredDvns,
            optionalDVNCount: 0,
            optionalDVNThreshold: 0,
            optionalDVNs: optionalDvns
        });
        SetConfigParam[] memory setConfigParams = new SetConfigParam[](2);
        setConfigParams[0] = SetConfigParam({
            eid: target,
            configType: EXECUTOR_CONFIG_TYPE,
            config: abi.encode(executorConfig)
        });
        setConfigParams[1] = SetConfigParam({
            eid: target,
            configType: ULN_CONFIG_TYPE,
            config: abi.encode(ulnConfig)
        });
        _endpoint.setConfig(myOapp, sendLib, setConfigParams);
    }

    function setReceiveConfig(address myOapp, uint32 target, ILayerZeroEndpointV2 _endpoint, address dvn1, uint64 confirmations) private {
        (address receiveLib,) = _endpoint.getReceiveLibrary(myOapp, target);
        address[] memory requiredDvns = new address[](1);
        address[] memory optionalDvns = new address[](0);
        requiredDvns[0] = dvn1;
        UlnConfig memory ulnConfig = UlnConfig({
            confirmations: confirmations,
            requiredDVNCount: 1,
            requiredDVNs: requiredDvns,
            optionalDVNCount: 0,
            optionalDVNThreshold: 0,
            optionalDVNs: optionalDvns
        });
        SetConfigParam[] memory setConfigParams = new SetConfigParam[](1);
        setConfigParams[0] = SetConfigParam({
            eid: target,
            configType: RECEIVE_CONFIG_TYPE,
            config: abi.encode(ulnConfig)
        });
        _endpoint.setConfig(myOapp, receiveLib, setConfigParams);
    }

    function run(address bridgeAddress, address dvn, address executor, uint64 sendConfirmations) external {
        uint256 deployerPrivateKey = vm.envUint("EVM_PRIVATE_KEY");
        IMyOApp _bridge = IMyOApp(bridgeAddress);
        address lzEndpoint = _bridge.endpoint();
        ILayerZeroEndpointV2 endpoint = ILayerZeroEndpointV2(lzEndpoint);

        vm.startBroadcast(deployerPrivateKey);
//        setSendConfig(bridgeAddress, 30106, endpoint, executor, dvn, sendConfirmations); // avalanche mainnet
//        setReceiveConfig(bridgeAddress, 30106, endpoint, dvn, 20); // avalanche mainnet
//
//        setSendConfig(bridgeAddress, 30111, endpoint, executor, dvn, sendConfirmations); //optimism
//        setReceiveConfig(bridgeAddress, 30111, endpoint, dvn, 75); //optimism
//
////        setSendConfig(bridgeAddress, 30101, endpoint); //ethereum
////        setReceiveConfig(bridgeAddress, 30101, endpoint); //ethereum
//
//        setSendConfig(bridgeAddress, 30102, endpoint, executor, dvn, sendConfirmations); //bsc mainnet
//        setReceiveConfig(bridgeAddress, 30102, endpoint, dvn, 60); //bsc mainnet
//
//        setSendConfig(bridgeAddress, 30110, endpoint, executor, dvn, sendConfirmations); // arbitrum
//        setReceiveConfig(bridgeAddress, 30110, endpoint, dvn, 300); // arbitrum
//
//        setSendConfig(bridgeAddress, 30109, endpoint, executor, dvn, sendConfirmations); //polygon
//        setReceiveConfig(bridgeAddress, 30109, endpoint, dvn, 250); //polygon
//
//        setSendConfig(bridgeAddress, 30112, endpoint, executor, dvn, sendConfirmations); //fantom
//        setReceiveConfig(bridgeAddress, 30112, endpoint, dvn, 30); //fantom
//
////       setSendConfig(bridgeAddress, 30420, endpoint); //tron
////        setReceiveConfig(bridgeAddress, 30420, endpoint); //tron
//
//        setSendConfig(bridgeAddress, 30184, endpoint, executor, dvn, sendConfirmations); //base
//        setReceiveConfig(bridgeAddress, 30184, endpoint, dvn, 75); //base
//
//        setSendConfig(bridgeAddress, 30183, endpoint, executor, dvn, sendConfirmations); //linea
//        setReceiveConfig(bridgeAddress, 30183, endpoint, dvn, 40); //linea
//
//        setSendConfig(bridgeAddress, 30181, endpoint, executor, dvn, sendConfirmations); //mantle
//        setReceiveConfig(bridgeAddress, 30181, endpoint, dvn, 70); //mantle
//
//        setSendConfig(bridgeAddress, 30145, endpoint, executor, dvn, sendConfirmations); //gnosis
//        setReceiveConfig(bridgeAddress, 30145, endpoint, dvn, 350); //gnosis
//
//        setSendConfig(bridgeAddress, 30165, endpoint, executor, dvn, sendConfirmations); //zksync
//        setReceiveConfig(bridgeAddress, 30165, endpoint, dvn, 1200); //zksync
//
//        setSendConfig(bridgeAddress, 30125, endpoint, executor, dvn, sendConfirmations); //celo
//        setReceiveConfig(bridgeAddress, 30125, endpoint, dvn, 20); //celo
//
//        setSendConfig(bridgeAddress, 30214, endpoint, executor, dvn, sendConfirmations); //scroll
//        setReceiveConfig(bridgeAddress, 30214, endpoint, dvn, 150); //scroll
//
//        setSendConfig(bridgeAddress, 30243, endpoint, executor, dvn, sendConfirmations); //blast
//        setReceiveConfig(bridgeAddress, 30243, endpoint, dvn, 150); //blast

        printExecutorConfig(bridgeAddress, 30106, endpoint);
        printUlnConfig(bridgeAddress, 30106, endpoint);
        printReceiveUlnConfig(bridgeAddress, 30106, endpoint);

        printExecutorConfig(bridgeAddress, 30111, endpoint);
        printUlnConfig(bridgeAddress, 30111, endpoint);
        printReceiveUlnConfig(bridgeAddress, 30111, endpoint);

        printExecutorConfig(bridgeAddress, 30102, endpoint);
        printUlnConfig(bridgeAddress, 30102, endpoint);
        printReceiveUlnConfig(bridgeAddress, 30102, endpoint);

        printExecutorConfig(bridgeAddress, 30110, endpoint);
        printUlnConfig(bridgeAddress, 30110, endpoint);
        printReceiveUlnConfig(bridgeAddress, 30110, endpoint);

        printExecutorConfig(bridgeAddress, 30109, endpoint);
        printUlnConfig(bridgeAddress, 30109, endpoint);
        printReceiveUlnConfig(bridgeAddress, 30109, endpoint);

        printExecutorConfig(bridgeAddress, 30112, endpoint);
        printUlnConfig(bridgeAddress, 30112, endpoint);
        printReceiveUlnConfig(bridgeAddress, 30112, endpoint);

        printExecutorConfig(bridgeAddress, 30184, endpoint);
        printUlnConfig(bridgeAddress, 30184, endpoint);
        printReceiveUlnConfig(bridgeAddress, 30184, endpoint);

        printExecutorConfig(bridgeAddress, 30183, endpoint);
        printUlnConfig(bridgeAddress, 30183, endpoint);
        printReceiveUlnConfig(bridgeAddress, 30183, endpoint);

        printExecutorConfig(bridgeAddress, 30181, endpoint);
        printUlnConfig(bridgeAddress, 30181, endpoint);
        printReceiveUlnConfig(bridgeAddress, 30181, endpoint);

        printExecutorConfig(bridgeAddress, 30145, endpoint);
        printUlnConfig(bridgeAddress, 30145, endpoint);
        printReceiveUlnConfig(bridgeAddress, 30145, endpoint);

        printExecutorConfig(bridgeAddress, 30165, endpoint);
        printUlnConfig(bridgeAddress, 30165, endpoint);
        printReceiveUlnConfig(bridgeAddress, 30165, endpoint);

        printExecutorConfig(bridgeAddress, 30125, endpoint);
        printUlnConfig(bridgeAddress, 30125, endpoint);
        printReceiveUlnConfig(bridgeAddress, 30125, endpoint);

        printExecutorConfig(bridgeAddress, 30214, endpoint);
        printUlnConfig(bridgeAddress, 30214, endpoint);
        printReceiveUlnConfig(bridgeAddress, 30214, endpoint);

        printExecutorConfig(bridgeAddress, 30243, endpoint);
        printUlnConfig(bridgeAddress, 30243, endpoint);
        printReceiveUlnConfig(bridgeAddress, 30243, endpoint);

        vm.stopBroadcast();
    }
}

/*
LAYERZERO LABS DVNS
Avalanche: 0x962f502a63f5fbeb44dc9ab932122648e8352959
Optimism: 0x6a02d83e8d433304bba74ef1c427913958187142
Ethereum: 0x589dedbd617e0cbcb916a9223f4d1300c294236b
BNB: 0xfd6865c841c2d64565562fcc7e05e619a30615f0
Arbitrum: 0x2f55c492897526677c5b68fb199ea31e2c126416
Polygon: 0x23de2fe932d9043291f870324b74f820e11dc81a
Fantom: 0xe60a3959ca23a92bf5aaf992ef837ca7f828628a
Tron: 0x8bc1d368036ee5e726d230beb685294be191a24e
Base: 0x9e059a54699a285714207b43b055483e78faac25
Linea: 0x129ee430cb2ff2708ccaddbdb408a88fe4ffd480
Mantle: 0x28b6140ead70cb2fb669705b3598ffb4beaa060b
Gnosis: 0x11bb2991882a86dc3e38858d922559a385d506ba
Zksync: 0x620a9df73d2f1015ea75aea1067227f9013f5c51
Celo: 0x75b073994560a5c03cd970414d9170be0c6e5c36
Scroll: 0xbe0d08a85eebfcc6eda0a843521f7cbb1180d2e2
Blast: 0xc097ab8CD7b053326DFe9fB3E3a31a0CCe3B526f
*/

/*
LAYERZERO EXECUTORS
Avalanche: 0x90E595783E43eb89fF07f63d27B8430e6B44bD9c
Optimism: 0x2D2ea0697bdbede3F01553D2Ae4B8d0c486B666e
Ethereum: 0x173272739Bd7Aa6e4e214714048a9fE699453059
BNB: 0x3ebD570ed38B1b3b4BC886999fcF507e9D584859
Arbitrum: 0x31CAe3B7fB82d847621859fb1585353c5720660D
Polygon: 0xCd3F213AD101472e1713C72B1697E727C803885b
Fantom: 0x2957eBc0D2931270d4a539696514b047756b3056
Tron: 0x67DE40af19C0C0a6D0278d96911889fAF4EBc1Bc
Base: 0x2CCA08ae69E0C44b18a57Ab2A87644234dAebaE4
Linea: 0x0408804C5dcD9796F22558464E6fE5bDdF16A7c7
Mantle: 0x4Fc3f4A38Acd6E4cC0ccBc04B3Dd1CCAeFd7F3Cd
Gnosis: 0x38340337f9ADF5D76029Ab3A667d34E5a032F7BA
Zksync: 0x664e390e672A811c12091db8426cBb7d68D5D8A6
Celo: 0x1dDbaF8b75F2291A97C22428afEf411b7bB19e28
Scroll: 0x581b26F362AD383f7B51eF8A165Efa13DDe398a4
Blast: 0x4208D6E27538189bB48E603D6123A94b8Abe0A0b
*/

//        printExecutorConfig(bridgeAddress, 30106, endpoint);
//        printUlnConfig(bridgeAddress, 30106, endpoint);
//        printReceiveUlnConfig(bridgeAddress, 30106, endpoint);