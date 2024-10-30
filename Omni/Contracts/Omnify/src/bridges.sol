// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "./bridgedToken.sol";
import "./ierc20metadata.sol";
import {OApp, Origin, MessagingFee} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OApp.sol";
import "../lib/LayerZero-v2/packages/layerzero-v2/evm/oapp/contracts/oapp/OApp.sol";
import "../lib/LayerZero-v2/packages/layerzero-v2/evm/protocol/contracts/interfaces/ILayerZeroEndpointV2.sol";
import {OptionsBuilder} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/libs/OptionsBuilder.sol";
import "../lib/LayerZero-v2/packages/layerzero-v2/evm/oapp/contracts/oapp/libs/OptionsBuilder.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import "../lib/solidity-stringutils/strings.sol";
import './IOmnify.sol';
import './ownable.sol';

interface IBridgedOmniToken {
    function mint(address _recipient, uint256 _amount) external;

    function burnSenderTokens(address _sender, uint256 _amount) external;

    function decimals() external view returns (uint8);

    function balanceOf(address account) external view returns (uint256);

    function changeOmnifyAddress(address newAddress) external;
}

contract Bridges is OApp, Ownable {
    using OptionsBuilder for bytes;
    using strings for *;
    event NewBridgedTokenCreated(
        uint32 _sourceChainId,
        uint32 _thisChainId,
        address _creator,
        address _bridgedAssetAddress,
        string _bridgedAssetName,
        string _bridgedAssetSymbol,
        address _sourceAssetAddress,
        string _sourceAssetName,
        string _sourceAssetSymbol);
    event AssetsMigrated(
        uint256 _id,
        address _asset,
        uint256 _amount,
        uint32 _sourceChain,
        address _sourceAddress,
        uint32 _destinationChain,
        address _destinationAddress,
        uint256 _blockNumber,
        uint256 _date
    );
    event AssetsReceived(
        uint256 _id,
        address _asset,
        uint256 _amount,
        uint32 _sourceChain,
        address _sourceAddress,
        uint32 _destinationChain,
        address _destinationAddress,
        uint256 _blockNumber,
        uint256 _date
    );

    struct BridgeProfile {
        address person;
        uint256 transactionCount;
        mapping(uint256 => uint256) transactions;
        uint256 migratedAssetCount;
        mapping(uint256 => ProfileMigratedAsset) assetAmountMigrated;
        mapping(address => uint256) migratedAssetToCount;
        uint256 receivedAssetCount;
        mapping(uint256 => ProfileReceivedAsset) assetAmountReceived;
        mapping(address => uint256) receivedAssetToCount;
    }

    struct ProfileMigratedAsset {
        address asset;
        uint256 amountMigrated;
    }

    struct ProfileReceivedAsset {
        address asset;
        uint256 amountReceived;
    }

    struct BridgeTransaction {
        address asset;
        uint256 amount;
        uint32 sourceChain;
        uint32 destinationChain;
        address sourceAddress;
        address destinationAddress;
        uint256 date;
    }
    constructor(
        address _endpoint,
        uint256 _paramBridgeFee,
        uint32 _paramChainId,
        address _paramOmnifyAddress
    )OApp(_endpoint, msg.sender) Ownable(msg.sender){
        bridgeFee = _paramBridgeFee;
        thisChainEid = _paramChainId;
        GAS_LIMIT = 2000000;
        omnifyAddress = _paramOmnifyAddress;
    }


    mapping(address => mapping(uint32 => address)) public bridgedTokenForeignEquivalent;
    mapping(uint32 => mapping(address => address)) public foreignTokenBridgedEquivalent;

    uint256 internal MAXUINT = 2 ** 256 - 1;
    uint256 public bridgeFee;
    uint256 public numberReceivedTransactions;
    uint256 public numberMigrationTransactions;
    uint256 public amountReceivedAssets;
    uint256 public amountMigratedAssets;
    uint256 public transactionCount;
    uint32 public thisChainEid;
    uint128 public GAS_LIMIT;
    address public feeKeeperAddress;
    address public omnifyAddress;

    mapping(address => BridgeProfile) public bridgeProfiles;
    mapping(uint256 => BridgeTransaction) public bridgeTransactions;

    function getMinAmount(uint8 _decimals) public pure returns (uint256) {
        if (_decimals == 0) {
            return 1;
        }
        if (_decimals == 1) {
            return 0.1 * (10 ** 1);
        }
        if (_decimals == 2) {
            return 0.01 * (10 ** 2);
        }
        if (_decimals >= 3) {
            uint8 powa = _decimals - 3;
//0.001
            return 1 * (10 ** powa);
        }
        return 1;
    }
    modifier onlyFeeKeeper(address _sender){
        require(_sender == feeKeeperAddress);
        _;
    }

    function setOmnifyAddress(address _newaddress) external onlyOwner {
        omnifyAddress = _newaddress;
    }

    function setBridgeFee(uint256 _fee) external onlyOwner {
        bridgeFee = _fee;
    }

    function setFeeKeeperAddress(address _feeKeeper) external onlyOwner {
        feeKeeperAddress = _feeKeeper;
    }

    function setBridgeFeeByFeeKeeper(uint256 _fee) external onlyFeeKeeper(msg.sender) {
        bridgeFee = _fee;
    }

    function setGasLimit(uint128 _limit) external onlyOwner {
        GAS_LIMIT = _limit;
    }

    function setGasLimitByFeeKeeper(uint128 _limit) external onlyFeeKeeper(msg.sender) {
        GAS_LIMIT = _limit;
    }

    function createLzReceiveOption(uint128 _gas, uint128 _value) public pure returns (bytes memory) {
        return OptionsBuilder.newOptions().addExecutorLzReceiveOption(_gas, _value);
    }

    function lookupBridgeTransaction(uint256 _id) public view returns (BridgeTransaction memory) {
        return bridgeTransactions[_id];
    }

    function publicSetPeer(uint32 _eid, address _peer) public onlyOwner {
        bytes32 _addressBytes = bytes32(uint256(uint160(_peer)));
        setPeer(_eid, _addressBytes);
    }

    function publicSetDelegate(address _delegate) public onlyOwner {
        setDelegate(_delegate);
    }

    function lookupBridgeProfileTransactions(address _profile) public view returns (uint256[] memory) {
        uint256 count = bridgeProfiles[_profile].transactionCount;
        uint256[] memory trans = new uint256[](count);
        if (count > 0) {
            for (uint256 i = 0; i < count; i++) {
                trans[i] = bridgeProfiles[_profile].transactions[i + 1];
            }
        }
        return trans;
    }

    function lookupBridgeProfileMigratedAssets(address _profile) public view returns (ProfileMigratedAsset[] memory) {
        uint256 count = bridgeProfiles[_profile].migratedAssetCount;
        ProfileMigratedAsset[] memory migs = new ProfileMigratedAsset[](count);
        if (count > 0) {
            for (uint256 i = 0; i < count; i++) {
                migs[i] = bridgeProfiles[_profile].assetAmountMigrated[i + 1];
            }
        }
        return migs;
    }

    function lookupBridgeProfileReceivedAssets(address _profile) public view returns (ProfileReceivedAsset[] memory) {
        uint256 count = bridgeProfiles[_profile].receivedAssetCount;
        ProfileReceivedAsset[] memory recs = new ProfileReceivedAsset[](count);
        if (count > 0) {
            for (uint256 i = 0; i < count; i++) {
                recs[i] = bridgeProfiles[_profile].assetAmountReceived[i + 1];
            }
        }
        return recs;
    }


    function compare(string memory str1, string memory str2) public pure returns (bool) {
        if (bytes(str1).length != bytes(str2).length) {
            return false;
        }
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }

    function quote(
        uint32 _dstEid, // Destination chain's endpoint ID.
        string memory _message, // The message to send.
        bytes memory _options, // Message execution options
        bool _payInLzToken // boolean for which token to return fee in
    ) public view returns (uint256 nativeFee, uint256 lzTokenFee) {
        bytes memory _payload = abi.encode(_message);
        MessagingFee memory fee = _quote(_dstEid, _payload, _options, _payInLzToken);
        return (fee.nativeFee, fee.lzTokenFee);
    }

    function dotter(string memory val) private pure returns (string memory){
        return string.concat(val, ".");
    }

    function convertBoolToString(bool input) private pure returns (string memory) {
        if (input) {
            return "true";
        } else {
            return "false";
        }
    }

    function convertStringToBool(string memory input) private pure returns (bool){
        if (compare("true", input)) {
            return true;
        } else {
            return false;
        }
    }

//    function lookupAllBridgedTokensFromChain(uint32 _chain) public view returns (mapping(address => address) memory){
//        return foreignTokenBridgedEquivalent[_chain];
//    }


    function migrateAssets(address _sourceAsset, uint256 _amount, uint32 _destinationChain, address _recipient)
    external
    payable
    {
        require(_destinationChain != thisChainEid);
        MYIERC20Metadata _theCoin = MYIERC20Metadata(_sourceAsset);
        require(_sourceAsset != address(0));
        address _foreignEquivalent = lookupBridgedTokenForeignEquivalent(_sourceAsset, _destinationChain);
        address _bridgedEquivalent = lookupForeignTokenBridgedEquivalent(_foreignEquivalent, _destinationChain);
        bool isReturningBridgedAsset = (_bridgedEquivalent != address(0)) && (_bridgedEquivalent == _sourceAsset);
        string memory sourceAssetString = Strings.toHexString(uint256(uint160(_sourceAsset)), 20);
        string memory dottedSourceAssetString = dotter(sourceAssetString);
        string memory thisChainEidString = Strings.toString(uint256(thisChainEid));
        string memory dottedThisChainIdString = dotter(thisChainEidString);
        string memory senderAddressString = Strings.toHexString(uint256(uint160(msg.sender)), 20);
        string memory dottedSenderAddressString = dotter(senderAddressString);
        string memory recipientAddressString = Strings.toHexString(uint256(uint160(_recipient)), 20);
        string memory dottedRecipientAddressString = dotter(recipientAddressString);
        string memory amountString = Strings.toString(_amount);
        string memory dottedAmountString = dotter(amountString);
        string memory assetName = _theCoin.name();
        string memory dottedAssetName = dotter(assetName);
        string memory assetSymbol = _theCoin.symbol();
        string memory dottedAssetSymbol = dotter(assetSymbol);
        uint8 decimals = _theCoin.decimals();
        string memory decimalsString = Strings.toString(uint256(decimals));
        string memory dottedDecimalsString = dotter(decimalsString);
        string memory isReturningBridgedAssetString = convertBoolToString(isReturningBridgedAsset);
        string memory dottedIsReturningBridgedAsset = dotter(isReturningBridgedAssetString);
        string memory foreignEquivalentAddressString = Strings.toHexString(uint256(uint160(_foreignEquivalent)), 20);
        string memory _message = string.concat(dottedSourceAssetString, dottedThisChainIdString, dottedSenderAddressString, dottedRecipientAddressString, dottedAmountString, dottedAssetName, dottedAssetSymbol, dottedDecimalsString, dottedIsReturningBridgedAsset, foreignEquivalentAddressString);
// message: sourceAssetAddress.thisChainEid.msgsenderaddress.recipientAddress.amount.assetName.assetSymbol.decimals.isReturningBridgedAsset.foreignEquivalentAddress
        bytes memory _payload = abi.encode(_message);
        bytes memory _options = createLzReceiveOption(GAS_LIMIT, 0);
        (uint256 nativeGas,) = quote(_destinationChain,
            _message,
            _options,
            false);
        require(msg.value == bridgeFee + nativeGas);
        if (isReturningBridgedAsset) {
            IBridgedOmniToken _theToken = IBridgedOmniToken(_sourceAsset);
            uint8 _decimals = _theToken.decimals();
            uint256 _minAmount = getMinAmount(_decimals);
            require(_amount >= _minAmount);
            uint256 balanceOfCaller = _theToken.balanceOf(msg.sender);
            require(balanceOfCaller >= _amount);
            _theToken.burnSenderTokens(msg.sender, _amount);
        } else {
            uint8 _decimals = _theCoin.decimals();
            uint256 _minAmount = getMinAmount(_decimals);
            require(_amount >= _minAmount);
            bool success = _theCoin.transferFrom(msg.sender, address(this), _amount);
            require(success);
        }
        IOmnify mainContract = IOmnify(omnifyAddress);
        mainContract.addProfitsFromExternalContract{value: bridgeFee}();
        numberMigrationTransactions++;
        amountMigratedAssets = safeAdd(amountMigratedAssets, _amount);
        transactionCount++;
        bridgeTransactions[transactionCount].asset = _sourceAsset;
        bridgeTransactions[transactionCount].amount = _amount;
        bridgeTransactions[transactionCount].sourceChain = thisChainEid;
        bridgeTransactions[transactionCount].destinationChain = _destinationChain;
        bridgeTransactions[transactionCount].sourceAddress = msg.sender;
        bridgeTransactions[transactionCount].destinationAddress = _recipient;
        bridgeTransactions[transactionCount].date = block.timestamp;
        uint256 thisAssetProfileCount = bridgeProfiles[msg.sender].migratedAssetToCount[_sourceAsset];
        bridgeProfiles[msg.sender].transactionCount++;
        bridgeProfiles[msg.sender].transactions[bridgeProfiles[msg.sender].transactionCount] = transactionCount;
        if (thisAssetProfileCount > 0) {
            bridgeProfiles[msg.sender].assetAmountMigrated[thisAssetProfileCount].amountMigrated = safeAdd(bridgeProfiles[msg.sender].assetAmountMigrated[thisAssetProfileCount].amountMigrated, _amount);
        } else {
            bridgeProfiles[msg.sender].migratedAssetCount++;
            bridgeProfiles[msg.sender].migratedAssetToCount[_sourceAsset] =
                                bridgeProfiles[msg.sender].migratedAssetCount;
            bridgeProfiles[msg.sender].assetAmountMigrated[bridgeProfiles[msg.sender].migratedAssetCount].asset =
                        _sourceAsset;
            bridgeProfiles[msg.sender].assetAmountMigrated[bridgeProfiles[msg.sender].migratedAssetCount].amountMigrated
            = safeAdd(bridgeProfiles[msg.sender].assetAmountMigrated[bridgeProfiles[msg.sender].migratedAssetCount].amountMigrated, _amount);
        }
        _lzSend(_destinationChain,
            _payload,
            _options,
            MessagingFee(nativeGas, 0),
            payable(msg.sender));
        emit AssetsMigrated(
            transactionCount,
            _sourceAsset,
            _amount,
            thisChainEid,
            msg.sender,
            _destinationChain,
            _recipient,
            block.number,
            block.timestamp
        );
    }

    function decodeMessage(bytes calldata data) private pure returns (string memory){
        return abi.decode(data, (string));
    }

    function stringToUint(string memory s) private pure returns (uint result) {
        bytes memory b = bytes(s);
        uint i;
        result = 0;
        for (i = 0; i < b.length; i++) {
            uint c = uint256(uint8(b[i]));
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }
    }

    function stringToAddress(string memory _address) public pure returns (address) {
        string memory cleanAddress = remove0xPrefix(_address);
        bytes20 _addressBytes = parseHexStringToBytes20(cleanAddress);
        return address(_addressBytes);
    }

    function remove0xPrefix(string memory _hexString) internal pure returns (string memory) {
        if (bytes(_hexString).length >= 2 && bytes(_hexString)[0] == '0' && (bytes(_hexString)[1] == 'x' || bytes(_hexString)[1] == 'X')) {
            return substring(_hexString, 2, bytes(_hexString).length);
        }
        return _hexString;
    }

    function substring(string memory _str, uint256 _start, uint256 _end) internal pure returns (string memory) {
        bytes memory _strBytes = bytes(_str);
        bytes memory _result = new bytes(_end - _start);
        for (uint256 i = _start; i < _end; i++) {
            _result[i - _start] = _strBytes[i];
        }
        return string(_result);
    }

    function parseHexStringToBytes20(string memory _hexString) internal pure returns (bytes20) {
        bytes memory _bytesString = bytes(_hexString);
        uint160 _parsedBytes = 0;
        for (uint256 i = 0; i < _bytesString.length; i += 2) {
            _parsedBytes *= 256;
            uint8 _byteValue = parseByteToUint8(_bytesString[i]);
            _byteValue *= 16;
            _byteValue += parseByteToUint8(_bytesString[i + 1]);
            _parsedBytes += _byteValue;
        }
        return bytes20(_parsedBytes);
    }

    function parseByteToUint8(bytes1 _byte) internal pure returns (uint8) {
        if (uint8(_byte) >= 48 && uint8(_byte) <= 57) {
            return uint8(_byte) - 48;
        } else if (uint8(_byte) >= 65 && uint8(_byte) <= 70) {
            return uint8(_byte) - 55;
        } else if (uint8(_byte) >= 97 && uint8(_byte) <= 102) {
            return uint8(_byte) - 87;
        } else {
            revert(string(abi.encodePacked("Invalid byte value: ", _byte)));
        }
    }

    function _lzReceive(Origin calldata _origin,
        bytes32 _guid,
        bytes calldata _message,
        address _executor,
        bytes calldata _extraData) internal override {
//message: sourceAssetAddress.thisChainEid.msgsenderaddress.recipientAddress.amount.assetName.assetSymbol.decimals.isReturningBridgedAsset.foreignEquivalentAddress
        string memory _decodedMessage = decodeMessage(_message);
        strings.slice  memory s = _decodedMessage.toSlice();
        strings.slice memory delim = ".".toSlice();
        string memory sourceAssetAddressString = s.split(delim).toString();
        address sourceAssetAddress = stringToAddress(sourceAssetAddressString);
        string memory chainEidString = s.split(delim).toString();
        uint chainEid = stringToUint(chainEidString);
        string memory senderAddressString = s.split(delim).toString();
        address senderAddress = stringToAddress(senderAddressString);
        string memory recipientAddressString = s.split(delim).toString();
        address recipientAddress = stringToAddress(recipientAddressString);
        string memory amountString = s.split(delim).toString();
        uint amount = stringToUint(amountString);
        string memory assetName = s.split(delim).toString();
        string memory assetSymbol = s.split(delim).toString();
        string memory decimalsString = s.split(delim).toString();
        uint decimals = stringToUint(decimalsString);
        string memory isReturningString = s.split(delim).toString();
        bool isReturning = convertStringToBool(isReturningString);
        string memory foreignEquivAddressString = s.toString();
        address foreingEquivAddress = stringToAddress(foreignEquivAddressString);
        receiveAssets(
            sourceAssetAddress,
            uint32(chainEid),
            senderAddress,
            recipientAddress,
            amount,
            assetName,
            assetSymbol,
            uint8(decimals),
            isReturning,
            foreingEquivAddress
        );
    }

    function receiveAssets(
        address _foreignAsset,
        uint32 _sourceChain,
        address _sourceAddress,
        address _recipientAddress,
        uint256 _amount,
        string memory _foreignAssetName,
        string memory _foreignAssetSymbol,
        uint8 _foreignAssetDecimals,
        bool _isReturningBridgedAsset,
        address _bridgedAssetAddressOnSource
    ) private {
        require(_sourceChain != thisChainEid);
        require(msg.sender != address(0));
        address _theAssetWeAreWorkingOn;
        address _localEquivalent = lookupForeignTokenBridgedEquivalent(_foreignAsset, _sourceChain);
        if (_localEquivalent == address(0)) {
            if (_isReturningBridgedAsset) {
                MYIERC20Metadata _theCoin = MYIERC20Metadata(_bridgedAssetAddressOnSource);
                uint8 _decimals = _theCoin.decimals();
                uint256 _minAmount = getMinAmount(_decimals);
                require(_amount >= _minAmount);
                bool success = _theCoin.transfer(_recipientAddress, _amount);
                require(success);
                transactionCount++;
                bridgeTransactions[transactionCount].asset = _bridgedAssetAddressOnSource;
                _theAssetWeAreWorkingOn = _bridgedAssetAddressOnSource;
            } else {
                address _newBridgedToken = _createNewLocalAssetForForeignAsset(
                    _foreignAsset, _sourceChain, _foreignAssetName, _foreignAssetSymbol, _sourceAddress, _foreignAssetDecimals
                );
                require(_newBridgedToken != address(0));
                IBridgedOmniToken _theToken = IBridgedOmniToken(_newBridgedToken);
                _theToken.mint(_recipientAddress, _amount);
                transactionCount++;
                bridgeTransactions[transactionCount].asset = _newBridgedToken;
                _theAssetWeAreWorkingOn = _newBridgedToken;
            }
            amountReceivedAssets = safeAdd(amountReceivedAssets, _amount);
            numberReceivedTransactions++;
        } else {
            IBridgedOmniToken _theToken = IBridgedOmniToken(_localEquivalent);
            _theToken.mint(_recipientAddress, _amount);
            amountReceivedAssets = safeAdd(amountReceivedAssets, _amount);
            numberReceivedTransactions++;
            transactionCount++;
            bridgeTransactions[transactionCount].asset = _localEquivalent;
            _theAssetWeAreWorkingOn = _localEquivalent;
        }
        bridgeTransactions[transactionCount].amount = _amount;
        bridgeTransactions[transactionCount].sourceChain = _sourceChain;
        bridgeTransactions[transactionCount].destinationChain = thisChainEid;
        bridgeTransactions[transactionCount].sourceAddress = _sourceAddress;
        bridgeTransactions[transactionCount].destinationAddress = _recipientAddress;
        bridgeTransactions[transactionCount].date = block.timestamp;
        bridgeProfiles[_recipientAddress].transactionCount++;
        bridgeProfiles[_recipientAddress].transactions[bridgeProfiles[_recipientAddress].transactionCount] =
                    transactionCount;
        uint256 thisAssetProfileCount = bridgeProfiles[_recipientAddress].receivedAssetToCount[_theAssetWeAreWorkingOn];
        if (thisAssetProfileCount > 0) {
            bridgeProfiles[_recipientAddress].assetAmountReceived[thisAssetProfileCount].amountReceived = safeAdd(bridgeProfiles[_recipientAddress].assetAmountReceived[thisAssetProfileCount].amountReceived, _amount);
        } else {
            bridgeProfiles[_recipientAddress].receivedAssetCount++;
            uint256 receivedCount = bridgeProfiles[_recipientAddress].receivedAssetCount;
            bridgeProfiles[_recipientAddress].receivedAssetToCount[_theAssetWeAreWorkingOn] = receivedCount;
            bridgeProfiles[_recipientAddress].assetAmountReceived[receivedCount].asset = _theAssetWeAreWorkingOn;
            bridgeProfiles[_recipientAddress].assetAmountReceived[receivedCount].amountReceived = safeAdd(bridgeProfiles[_recipientAddress].assetAmountReceived[receivedCount].amountReceived, _amount);
        }
        emit AssetsReceived(
            transactionCount,
            _theAssetWeAreWorkingOn,
            _amount,
            _sourceChain,
            _sourceAddress,
            thisChainEid,
            _recipientAddress,
            block.number,
            block.timestamp
        );
    }

    function lookupForeignTokenBridgedEquivalent(address _asset, uint32 _sourceChain)
    public
    view
    returns (address)
    {
        return foreignTokenBridgedEquivalent[_sourceChain][_asset];
    }

    function lookupBridgedTokenForeignEquivalent(address _asset, uint32 _sourceChain)
    public
    view
    returns (address)
    {
        return bridgedTokenForeignEquivalent[_asset][_sourceChain];
    }

    function _createNewLocalAssetForForeignAsset(
        address _foreignAsset,
        uint32 _sourceChain,
        string memory _foreignAssetName,
        string memory _foreignAssetSymbol,
        address _sourceAddress,
        uint8 _foreignAssetDecimals
    ) internal returns (address) {
        require(foreignTokenBridgedEquivalent[_sourceChain][_foreignAsset] == address(0));
        address _omnifyAddress = address(this);
        string memory concatenatedName = string.concat("Omnify ", _foreignAssetName);
        string memory concatenatedSymbol = string.concat("OFY", _foreignAssetSymbol);
        address _newBridgedToken =
                        address(new BridgedOmniToken(_omnifyAddress, concatenatedName, concatenatedSymbol, _foreignAssetDecimals));
        foreignTokenBridgedEquivalent[_sourceChain][_foreignAsset] = _newBridgedToken;
        bridgedTokenForeignEquivalent[_newBridgedToken][_sourceChain] = _foreignAsset;
        emit NewBridgedTokenCreated(_sourceChain, thisChainEid, _sourceAddress, _newBridgedToken, concatenatedName, concatenatedSymbol, _foreignAsset, _foreignAssetName, _foreignAssetSymbol);
        return _newBridgedToken;
    }

    function changeOmnifyAddressOnBridgedCoin(address _bridgedCoinAddress, address _newAddress) external onlyOwner {
        IBridgedOmniToken _theBridgedToken = IBridgedOmniToken(_bridgedCoinAddress);
        _theBridgedToken.changeOmnifyAddress(_newAddress);
    }

    function safeAdd(uint256 _currentAmount, uint256 _amountToBeAdded) internal view returns (uint256){
        uint256 _allowedAmount = MAXUINT - _currentAmount;
        if (_amountToBeAdded <= _allowedAmount) {
            return _currentAmount + _amountToBeAdded;
        }
        return _currentAmount;
    }
}