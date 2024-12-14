interface IEscrow99 {
    struct Bid {
        address bidder;
        address asset;
        uint256 amount;
        uint256 dateBid;
        bool isAccepted;
        bool isCancelled;
        bool exists;
    }

    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);

    event BidAccepted(string _id, address _owner, uint256 _blockNumber, uint256 _date);
    event ContractDeleted(string _id, address _owner, uint256 _blockNumber, uint256 _date);
    event NewBid(string _id, address _owner, uint256 _blockNumber, uint256 _date);
    event NewContract(string _id, address _owner, uint256 _blockNumber, uint256 _date);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

//    constructor(address _paramOmnifyAddress, uint8 _paramNativeDecimals, uint256 _paramContractFee);

    function acceptBid(string memory _contractId, uint256 _acceptedBidCount) external;

    function amountAssetsInBids() external view returns (uint256);

    function amountAssetsInContracts() external view returns (uint256);

    function cancelBid(string memory _contractId, uint256 _bidCount) external;

    function contractFee() external view returns (uint256);

    function contracts(string memory)
    external
    view
    returns (
        string memory id,
        address asset,
        uint256 assetAmount,
        bool isComplete,
        bool isDeleted,
        bool exists,
        uint256 bidCount,
        address owner,
        uint256 dateCreated,
        uint256 dateDeleted
    );

    function deleteContract(string memory _contractId) external;

    function escrowProfiles(address)
    external
    view
    returns (
        uint256 numOfCompleteContracts,
        uint256 numOfDeletedContracts,
        uint256 numOfBidsMade,
        uint256 numOfBidsReceived,
        uint256 contractCount
    );

    function feeKeeperAddress() external view returns (address);

    function getMinAmount(uint8 _decimals) external pure returns (uint256);

    function lookupContractAsset(string memory _id) external view returns (address);

    function lookupContractAssetAmount(string memory _id) external view returns (uint256);

    function lookupContractBids(string memory _id) external view returns (Bid[] memory);

    function lookupContractDateCreated(string memory _id) external view returns (uint256);

    function lookupContractDateDeleted(string memory _id) external view returns (uint256);

    function lookupContractExists(string memory _id) external view returns (bool);

    function lookupContractIsComplete(string memory _id) external view returns (bool);

    function lookupContractIsDeleted(string memory _id) external view returns (bool);

    function lookupContractOwner(string memory _id) external view returns (address);

    function lookupCountractBidCount(string memory _id) external view returns (uint256);

    function lookupEscrowProfileBidsMade(address _profile) external view returns (uint256);

    function lookupEscrowProfileBidsReceived(address _profile) external view returns (uint256);

    function lookupEscrowProfileCompleteContracts(address _profile) external view returns (uint256);

    function lookupEscrowProfileContractCount(address _profile) external view returns (uint256);

    function lookupEscrowProfileContracts(address _profile) external view returns (string[] memory);

    function lookupEscrowProfileDeletedContracts(address _profile) external view returns (uint256);

    function nativeCoinDecimals() external view returns (uint8);

    function newBid(string memory _contractId, address _asset, uint256 _amount) external payable;

    function newContract(string memory _id, address _asset, uint256 _amount) external payable;

    function numberBids() external view returns (uint256);

    function numberCompletedContracts() external view returns (uint256);

    function numberContracts() external view returns (uint256);

    function omnifyAddress() external view returns (address);

    function owner() external view returns (address);

    function renounceOwnership() external;

    function setContractFee(uint256 _fee) external;

    function setContractFeeByFeeKeeper(uint256 _fee) external;

    function setFeeKeeperAddress(address _feeKeeper) external;

    function setOmnifyAddress(address _newaddress) external;

    function transferOwnership(address newOwner) external;
}

