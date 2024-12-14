interface IPayments99 {
    struct Payment {
        string id;
        uint256 amount;
        address customer;
        address vendor;
        bool isPaid;
        bool isRefunded;
        bool isInstallments;
        uint256 fullAmount;
        uint256 amountPerInstallment;
        uint8 installmentPeriod;
        uint8 paidInstallments;
        uint8 remainingInstallments;
        uint256 datePaid;
        uint256 dateLastInstallmentPaid;
    }

    struct PaymentProfileInstallmentPlan {
        string id;
    }

    struct PaymentProfileReceipt {
        string id;
    }

    struct PaymentProfileWithdrawal {
        uint256 amount;
        uint256 date;
    }

    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event PaymentInstallmentPaid(
        string _id, address _customer, address _vendor, uint256 _amount, uint256 _blockNumber, uint256 _date
    );
    event PaymentMade(
        string _id, address _customer, address _vendor, uint256 _amount, uint256 _blockNumber, uint256 _date
    );
    event PaymentRefundIssued(
        string _id, address _customer, address _vendor, uint256 _amount, uint256 _blockNumber, uint256 _date
    );
    event PaymentWithdrawalMade(address _vendor, uint256 _amount, uint256 _blockNumber, uint256 _date);

//    constructor(
//        address _paramOmnifyAddress,
//        uint8 _paramNativeDecimals,
//        uint256 _paramFeePerInstallment,
//        uint256 _paramFeePerPayment
//    );

    function amountWithdrawn() external view returns (uint256);
    function assetsPaid() external view returns (uint256);
    function feeKeeperAddress() external view returns (address);
    function feePerInstallment() external view returns (uint256);
    function feePerPayment() external view returns (uint256);
    function getMinAmount(uint8 _decimals) external pure returns (uint256);
    function installmentAssetsPaid() external view returns (uint256);
    function installmentsCreated() external view returns (uint256);
    function installmentsPaid() external view returns (uint256);
    function issueRefund(string memory _id) external;
    function lookupPayment(string memory _id) external view returns (Payment memory);
    function lookupPaymentProfileBalance(address _profile) external view returns (uint256);
    function lookupPaymentProfileInstallmentPlans(address _profile)
        external
        view
        returns (PaymentProfileInstallmentPlan[] memory);
    function lookupPaymentProfileNumberPaymentsMade(address _profile) external view returns (uint256);
    function lookupPaymentProfileNumberPaymentsReceived(address _profile) external view returns (uint256);
    function lookupPaymentProfileNumberRefunds(address _profile) external view returns (uint256);
    function lookupPaymentProfileNumberWithdrawals(address _profile) external view returns (uint256);
    function lookupPaymentProfileReceipts(address _profile) external view returns (PaymentProfileReceipt[] memory);
    function lookupPaymentProfileRefundAmount(address _profile) external view returns (uint256);
    function lookupPaymentProfileRevenue(address _profile) external view returns (uint256);
    function lookupPaymentProfileSpending(address _profile) external view returns (uint256);
    function lookupPaymentProfileWithdrawals(address _profile)
        external
        view
        returns (PaymentProfileWithdrawal[] memory);
    function lookupPaymentProfileWithdrawnAmount(address _profile) external view returns (uint256);
    function makePayment(
        string memory _id,
        uint256 _amount,
        address _vendor,
        bool _isInstallments,
        uint256 _fullAmount,
        uint8 _installmentPeriod
    ) external payable;
    function maxInstallmentPeriod() external view returns (uint8);
    function nativeCoinDecimals() external view returns (uint8);
    function omnifyAddress() external view returns (address);
    function owner() external view returns (address);
    function payInstallment(string memory _id) external payable;
    function paymentProfiles(address)
        external
        view
        returns (
            uint256 currentBalance,
            uint256 totalRevenue,
            uint256 numberPaymentsReceived,
            uint256 numberPaymentsMade,
            uint256 totalSpending,
            uint256 numberWithdrawals,
            uint256 amountWithdrawals,
            uint256 amountRefunds,
            uint256 numberRefunds,
            bool exists,
            uint256 planCount,
            uint256 receiptCount,
            uint256 withdrawalCount
        );
    function payments(string memory)
        external
        view
        returns (
            string memory id,
            uint256 amount,
            address customer,
            address vendor,
            bool isPaid,
            bool isRefunded,
            bool isInstallments,
            uint256 fullAmount,
            uint256 amountPerInstallment,
            uint8 installmentPeriod,
            uint8 paidInstallments,
            uint8 remainingInstallments,
            uint256 datePaid,
            uint256 dateLastInstallmentPaid
        );
    function paymentsMade() external view returns (uint256);
    function refundsAmount() external view returns (uint256);
    function refundsIssued() external view returns (uint256);
    function renounceOwnership() external;
    function setFeeKeeperAddress(address _feeKeeper) external;
    function setFeePerInstallment(uint256 _fee) external;
    function setFeePerInstallmentByFeeKeeper(uint256 _fee) external;
    function setFeePerPayment(uint256 _fee) external;
    function setFeePerPaymentByKeeper(uint256 _fee) external;
    function setMaxInstallmentPeriod(uint8 _period) external;
    function setOmnifyAddress(address _newaddress) external;
    function transferOwnership(address newOwner) external;
    function uniqueCustomers() external view returns (uint256);
    function uniqueVendors() external view returns (uint256);
    function withdrawBalance(uint256 _amount) external;
    function withdrawalsMade() external view returns (uint256);
}

