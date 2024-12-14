interface IBridges99 {
    struct BridgeTransaction {
        address asset;
        uint256 amount;
        uint32 sourceChain;
        uint32 destinationChain;
        address sourceAddress;
        address destinationAddress;
        uint256 date;
    }

    struct Origin {
        uint32 srcEid;
        bytes32 sender;
        uint64 nonce;
    }

    struct ProfileMigratedAsset {
        address asset;
        uint256 amountMigrated;
    }

    struct ProfileReceivedAsset {
        address asset;
        uint256 amountReceived;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error InvalidDelegate();
    error InvalidEndpointCall();
    error InvalidOptionType(uint16 optionType);
    error LzTokenUnavailable();
    error NoPeer(uint32 eid);
    error NotEnoughNative(uint256 msgValue);
    error OnlyEndpoint(address addr);
    error OnlyPeer(uint32 eid, bytes32 sender);
    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);
    error SafeCastOverflowedUintDowncast(uint8 bits, uint256 value);
    error SafeERC20FailedOperation(address token);
    error StringsInsufficientHexLength(uint256 value, uint256 length);

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
    event NewBridgedTokenCreated(
        uint32 _sourceChainId,
        uint32 _thisChainId,
        address _creator,
        address _bridgedAssetAddress,
        string _bridgedAssetName,
        string _bridgedAssetSymbol,
        address _sourceAssetAddress,
        string _sourceAssetName,
        string _sourceAssetSymbol
    );
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event PeerSet(uint32 eid, bytes32 peer);

//    constructor(address _endpoint, uint256 _paramBridgeFee, uint32 _paramChainId, address _paramOmnifyAddress);

    function GAS_LIMIT() external view returns (uint128);

    function allowInitializePath(Origin memory origin) external view returns (bool);

    function amountMigratedAssets() external view returns (uint256);

    function amountReceivedAssets() external view returns (uint256);

    function bridgeFee() external view returns (uint256);

    function bridgeProfiles(address)
    external
    view
    returns (address person, uint256 transactionCount, uint256 migratedAssetCount, uint256 receivedAssetCount);

    function bridgeTransactions(uint256)
    external
    view
    returns (
        address asset,
        uint256 amount,
        uint32 sourceChain,
        uint32 destinationChain,
        address sourceAddress,
        address destinationAddress,
        uint256 date
    );

    function bridgedTokenForeignEquivalent(address, uint32) external view returns (address);

    function changeOmnifyAddressOnBridgedCoin(address _bridgedCoinAddress, address _newAddress) external;

    function compare(string memory str1, string memory str2) external pure returns (bool);

    function composeMsgSender() external view returns (address sender);

    function createLzReceiveOption(uint128 _gas, uint128 _value) external pure returns (bytes memory);

    function endpoint() external view returns (address);

    function feeKeeperAddress() external view returns (address);

    function foreignTokenBridgedEquivalent(uint32, address) external view returns (address);

    function getMinAmount(uint8 _decimals) external pure returns (uint256);

    function lookupBridgeProfileMigratedAssets(address _profile)
    external
    view
    returns (ProfileMigratedAsset[] memory);

    function lookupBridgeProfileReceivedAssets(address _profile)
    external
    view
    returns (ProfileReceivedAsset[] memory);

    function lookupBridgeProfileTransactions(address _profile) external view returns (uint256[] memory);

    function lookupBridgeTransaction(uint256 _id) external view returns (BridgeTransaction memory);

    function lookupBridgedTokenForeignEquivalent(address _asset, uint32 _sourceChain) external view returns (address);

    function lookupForeignTokenBridgedEquivalent(address _asset, uint32 _sourceChain) external view returns (address);

    function lzReceive(
        Origin memory _origin,
        bytes32 _guid,
        bytes memory _message,
        address _executor,
        bytes memory _extraData
    ) external payable;

    function migrateAssets(address _sourceAsset, uint256 _amount, uint32 _destinationChain, address _recipient)
    external
    payable;

    function nextNonce(uint32, bytes32) external view returns (uint64 nonce);

    function numberMigrationTransactions() external view returns (uint256);

    function numberReceivedTransactions() external view returns (uint256);

    function oAppVersion() external pure returns (uint64 senderVersion, uint64 receiverVersion);

    function omnifyAddress() external view returns (address);

    function owner() external view returns (address);

    function peers(uint32 eid) external view returns (bytes32 peer);

    function publicSetDelegate(address _delegate) external;

    function publicSetPeer(uint32 _eid, address _peer) external;

    function quote(uint32 _dstEid, string memory _message, bytes memory _options, bool _payInLzToken)
    external
    view
    returns (uint256 nativeFee, uint256 lzTokenFee);

    function renounceOwnership() external;

    function setBridgeFee(uint256 _fee) external;

    function setBridgeFeeByFeeKeeper(uint256 _fee) external;

    function setFeeKeeperAddress(address _feeKeeper) external;

    function setGasLimit(uint128 _limit) external;

    function setGasLimitByFeeKeeper(uint128 _limit) external;

    function setOmnifyAddress(address _newaddress) external;

    function stringToAddress(string memory _address) external pure returns (address);

    function thisChainEid() external view returns (uint32);

    function transactionCount() external view returns (uint256);

    function transferOwnership(address newOwner) external;
}

