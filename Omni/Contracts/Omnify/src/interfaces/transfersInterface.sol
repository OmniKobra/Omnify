interface ITransfers99 {
    struct AssetStat {
        uint256 sent;
        uint256 received;
    }

    struct ParamTransfer {
        address asset;
        uint256 amount;
        address payable recipient;
        string id;
    }

    struct ProfileTransfer {
        string id;
    }

    struct Transfer {
        string id;
        address sender;
        address recipient;
        address assetAddress;
        uint256 amount;
        uint256 date;
        bool exists;
    }

    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);

    event AssetsReceived(
        string _id,
        address _sender,
        address _recipient,
        address _asset,
        uint256 _amount,
        uint256 _blockNumber,
        uint256 _date
    );
    event AssetsSent(
        string _id,
        address _sender,
        address _recipient,
        address _asset,
        uint256 _amount,
        uint256 _blockNumber,
        uint256 _date
    );
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event TransferComplete(
        string _id,
        address _sender,
        address _recipient,
        address _asset,
        uint256 _amount,
        uint256 _blockNumber,
        uint256 _date
    );

//    constructor(
//        address _omnifyAddress,
//        uint8 _paramNativeDecimals,
//        uint256 _paramAltcoinFee,
//        uint256 _paramTier1Fee,
//        uint256 _paramtier2Fee,
//        uint256 _paramTier3Fee,
//        uint256 _paramTier4Fee,
//        uint256 _paramTier1HigherThreshold,
//        uint256 _paramTier2HigherThreshold,
//        uint256 _paramTier3HigherThreshold
//    );

    function altcoinFee() external view returns (uint256);

    function conductTransfers(ParamTransfer[] memory _trz) external payable;

    function feeKeeperAddress() external view returns (address);

    function getMinAmount(uint8 _decimals) external pure returns (uint256);

    function lookupTransfer(string memory _id) external view returns (Transfer memory);

    function lookupTransferAssetFromProfile(address _profile, uint256 _count) external view returns (address);

    function lookupTransferProfileAssetStats(address _profile) external view returns (AssetStat[] memory);

    function lookupTransferProfileReceiveds(address _profile) external view returns (uint256);

    function lookupTransferProfileSents(address _profile) external view returns (uint256);

    function lookupTransferProfileTransfers(address _profile) external view returns (ProfileTransfer[] memory);

    function nativeCoinDecimals() external view returns (uint8);

    function omnifyAddress() external view returns (address);

    function owner() external view returns (address);

    function renounceOwnership() external;

    function setAltcoinFee(uint256 _fee) external;

    function setAltcoinFeeByFeeKeeper(uint256 _fee) external;

    function setFeeKeeperAddress(address _feeKeeper) external;

    function setOmnifyAddress(address _newaddress) external;

    function setTier1(uint256 _lowerThreshold, uint256 _higherThreshold, uint256 _fee) external;

    function setTier1ByFeeKeeper(uint256 _lowerThreshold, uint256 _higherThreshold, uint256 _fee) external;

    function setTier2(uint256 _lowerThreshold, uint256 _higherThreshold, uint256 _fee) external;

    function setTier2ByFeeKeeper(uint256 _lowerThreshold, uint256 _higherThreshold, uint256 _fee) external;

    function setTier3(uint256 _lowerThreshold, uint256 _higherThreshold, uint256 _fee) external;

    function setTier3ByFeeKeeper(uint256 _lowerThreshold, uint256 _higherThreshold, uint256 _fee) external;

    function setTier4(uint256 _lowerThreshold, uint256 _higherThreshold, uint256 _fee) external;

    function setTier4ByFeeKeeper(uint256 _lowerThreshold, uint256 _higherThreshold, uint256 _fee) external;

    function tier1() external view returns (uint256 lowerThreshold, uint256 higherThreshold, uint256 fee);

    function tier2() external view returns (uint256 lowerThreshold, uint256 higherThreshold, uint256 fee);

    function tier3() external view returns (uint256 lowerThreshold, uint256 higherThreshold, uint256 fee);

    function tier4() external view returns (uint256 lowerThreshold, uint256 higherThreshold, uint256 fee);

    function totalAssetsTransferred() external view returns (uint256);

    function totalNumerOfTransfers() external view returns (uint256);

    function totalRecipientsUnique() external view returns (uint256);

    function totalSendersUnique() external view returns (uint256);

    function transferOwnership(address newOwner) external;

    function transferProfiles(address)
    external
    view
    returns (
        uint256 transfersSent,
        uint256 transfersReceived,
        bool exists,
        uint256 transfersCount,
        uint256 assetCount
    );

    function transfers(string memory)
    external
    view
    returns (
        string memory id,
        address sender,
        address recipient,
        address assetAddress,
        uint256 amount,
        uint256 date,
        bool exists
    );
}

