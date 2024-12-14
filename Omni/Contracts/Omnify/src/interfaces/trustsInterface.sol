interface ITrust99 {
    struct Beneficiary {
        address benef;
        uint256 allowance;
        bool isLimited;
        uint256 dateLastWithdrawal;
    }

    struct Owner {
        address owner;
        bool isOwner;
    }

    struct TrustAssetProfile {
        address asset;
        uint256 amountWithdrawn;
    }

    struct TrustProfileDeposit {
        string id;
        bool isOwner;
    }

    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event TrustDeposit(
        string _id, address _initiator, address _asset, uint256 _amount, uint256 _blockNumber, uint256 _date
    );
    event TrustModified(string _id, address _initiator, uint256 _blockNumber, uint256 _date);
    event TrustRetraction(
        string _id, address _initiator, address _asset, uint256 _amount, uint256 _blockNumber, uint256 _date
    );
    event TrustWithdrawal(
        string _id, address _initiator, address _asset, uint256 _amount, uint256 _blockNumber, uint256 _date
    );

//    constructor(
//        address _paramOmnifyAddress,
//        uint8 _paramNativeDecimals,
//        uint256 _paramDepositFee,
//        uint256 _paramBenefFee
//    );

    function amountAssetsDeposited() external view returns (uint256);
    function amountAssetsWithdrawn() external view returns (uint256);
    function beneficiaryFee() external view returns (uint256);
    function createDeposit(
        string memory _id,
        uint256 _amount,
        address _asset,
        bool _depositType,
        bool _liquidity,
        bool _isActive,
        Owner[] memory _owners,
        Beneficiary[] memory _beneficiaries
    ) external payable;
    function depositFee() external view returns (uint256);
    function depositIntoExistingDeposit(string memory _id, address _asset, uint256 _amount) external payable;
    function deposits(string memory)
        external
        view
        returns (
            string memory id,
            uint256 initialAmount,
            uint256 remainingAmount,
            address asset,
            bool depositType,
            bool liquidity,
            bool isActive,
            uint256 dateCreated,
            bool exists
        );
    function feeKeeperAddress() external view returns (address);
    function getMinAmount(uint8 _decimals) external pure returns (uint256);
    function lookupDepositActivity(string memory _id) external view returns (bool);
    function lookupDepositAsset(string memory _id) external view returns (address);
    function lookupDepositBenefDateLastWithdrawal(string memory _id, address _b) external view returns (uint256);
    function lookupDepositBeneficiaries(string memory _id) external view returns (Beneficiary[] memory);
    function lookupDepositDateCreated(string memory _id) external view returns (uint256);
    function lookupDepositExists(string memory _id) external view returns (bool);
    function lookupDepositInitialAmount(string memory _id) external view returns (uint256);
    function lookupDepositLiquidity(string memory _id) external view returns (bool);
    function lookupDepositOwners(string memory _id) external view returns (Owner[] memory);
    function lookupDepositRemainingAmount(string memory _id) external view returns (uint256);
    function lookupDepositType(string memory _id) external view returns (bool);
    function lookupTrustProfileAssets(address _profile) external view returns (TrustAssetProfile[] memory);
    function lookupTrustProfileDeposits(address _profile) external view returns (TrustProfileDeposit[] memory);
    function modifyDeposit(string memory _id, bool _newIsActive, Beneficiary[] memory _newBeneficiaries)
        external
        payable;
    function nativeCoinDecimals() external view returns (uint8);
    function numberBeneficiaries() external view returns (uint256);
    function numberDeposits() external view returns (uint256);
    function numberOwners() external view returns (uint256);
    function numberWithdrawals() external view returns (uint256);
    function omnifyAddress() external view returns (address);
    function owner() external view returns (address);
    function renounceOwnership() external;
    function retractDeposit(string memory _id) external;
    function setBeneficiaryFee(uint256 _fee) external;
    function setBeneficiaryFeeByFeeKeeper(uint256 _fee) external;
    function setDepositActiveVal(string memory _id, bool _val) external;
    function setDepositFee(uint256 _fee) external;
    function setDepositFeeByFeeKeeper(uint256 _fee) external;
    function setFeeKeeperAddress(address _feeKeeper) external;
    function setOmnifyAddress(address _newaddress) external;
    function transferOwnership(address newOwner) external;
    function trustProfiles(address) external view returns (uint256 assetCount, uint256 depositCount);
    function withdrawFromDeposit(string memory _id, uint256 _amount) external;
}

