// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ownable.sol";
import "./IOmnify.sol";

contract Payments is Ownable {
    event PaymentRefundIssued(
        string _id, address _customer, address _vendor, uint256 _amount, uint256 _blockNumber, uint256 _date
    );
    event PaymentMade(
        string _id, address _customer, address _vendor, uint256 _amount, uint256 _blockNumber, uint256 _date
    );
    event PaymentInstallmentPaid(
        string _id, address _customer, address _vendor, uint256 _amount, uint256 _blockNumber, uint256 _date
    );
    event PaymentWithdrawalMade(address _vendor, uint256 _amount, uint256 _blockNumber, uint256 _date);

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

    struct PaymentProfileReceipt {
        string id;
    }

    struct PaymentProfileInstallmentPlan {
        string id;
    }

    struct PaymentProfileWithdrawal {
        uint256 amount;
        uint256 date;
    }

    struct PaymentProfile {
        uint256 currentBalance;
        uint256 totalRevenue;
        uint256 numberPaymentsReceived;
        uint256 numberPaymentsMade;
        uint256 totalSpending;
        uint256 numberWithdrawals;
        uint256 amountWithdrawals;
        uint256 amountRefunds;
        uint256 numberRefunds;
        bool exists;
        uint256 planCount;
        uint256 receiptCount;
        uint256 withdrawalCount;
        mapping(uint256 => PaymentProfileInstallmentPlan) installmentPlans;
        mapping(uint256 => PaymentProfileReceipt) receipts;
        mapping(uint256 => PaymentProfileWithdrawal) withdrawals;
    }

    constructor(
        address _paramOmnifyAddress,
        uint8 _paramNativeDecimals,
        uint256 _paramFeePerInstallment,
        uint256 _paramFeePerPayment
    ) Ownable(msg.sender) {
        nativeCoinDecimals = _paramNativeDecimals;
        omnifyAddress = _paramOmnifyAddress;
        feePerInstallment = _paramFeePerInstallment;
        feePerPayment = _paramFeePerPayment;
        maxInstallmentPeriod = 120;
    }

    uint8 public nativeCoinDecimals;
    uint256 internal MAXUINT = 2 ** 256 - 1;
    uint256 public feePerPayment;
    uint256 public feePerInstallment;
    uint8 public maxInstallmentPeriod;
    uint256 public paymentsMade;
    uint256 public assetsPaid;
    uint256 public installmentsCreated;
    uint256 public installmentsPaid;
    uint256 public installmentAssetsPaid;
    uint256 public withdrawalsMade;
    uint256 public amountWithdrawn;
    uint256 public uniqueCustomers;
    uint256 public uniqueVendors;
    uint256 public refundsIssued;
    uint256 public refundsAmount;
    address public feeKeeperAddress;
    address public omnifyAddress;
    mapping(string => Payment) public payments;
    mapping(address => PaymentProfile) public paymentProfiles;

    modifier onlyFeeKeeper(address _sender) {
        require(_sender == feeKeeperAddress);
        _;
    }

    function setFeeKeeperAddress(address _feeKeeper) external onlyOwner {
        feeKeeperAddress = _feeKeeper;
    }

    function setOmnifyAddress(address _newaddress) external onlyOwner {
        omnifyAddress = _newaddress;
    }

    function _addUniqueCustomers(address _customer) internal {
        if (!paymentProfiles[_customer].exists) {
            uniqueCustomers++;
            paymentProfiles[_customer].exists = true;
        }
    }

    function _addUniqueVendors(address _vendor) internal {
        if (!paymentProfiles[_vendor].exists) {
            uniqueVendors++;
            paymentProfiles[_vendor].exists = true;
        }
    }

    function _addPaymentsMade() internal {
        paymentsMade++;
    }

    function _addAssetsPaid(uint256 _amount) internal {
        assetsPaid = safeAdd(assetsPaid, _amount);
    }

    function _addInstallmentsCreated(uint256 _installments) internal {
        installmentsCreated = safeAdd(installmentsCreated, _installments);
    }

    function _addInstallmentsPaid() internal {
        installmentsPaid++;
    }

    function _addInstallmentAssetsPaid(uint256 _amount) internal {
        installmentAssetsPaid = safeAdd(installmentAssetsPaid, _amount);
    }

    function _addWithdrawalsMade() internal {
        withdrawalsMade++;
    }

    function _addAmountWithdrawn(uint256 _amount) internal {
        amountWithdrawn = safeAdd(amountWithdrawn, _amount);
    }

    function _addRefundsIssued() internal {
        refundsIssued++;
    }

    function _addRefundsAmount(uint256 _amount) internal {
        refundsAmount = safeAdd(refundsAmount, _amount);
    }

    function setFeePerPayment(uint256 _fee) external onlyOwner {
        feePerPayment = _fee;
    }

    function setFeePerPaymentByKeeper(uint256 _fee) external onlyFeeKeeper(msg.sender) {
        feePerPayment = _fee;
    }

    function setFeePerInstallment(uint256 _fee) external onlyOwner {
        feePerInstallment = _fee;
    }

    function setFeePerInstallmentByFeeKeeper(uint256 _fee) external onlyFeeKeeper(msg.sender) {
        feePerInstallment = _fee;
    }

    function setMaxInstallmentPeriod(uint8 _period) external onlyOwner {
        maxInstallmentPeriod = _period;
    }

    function lookupPayment(string memory _id) public view returns (Payment memory) {
        return payments[_id];
    }

    function lookupPaymentProfileBalance(address _profile) public view returns (uint256) {
        return paymentProfiles[_profile].currentBalance;
    }

    function lookupPaymentProfileRevenue(address _profile) public view returns (uint256) {
        return paymentProfiles[_profile].totalRevenue;
    }

    function lookupPaymentProfileSpending(address _profile) public view returns (uint256) {
        return paymentProfiles[_profile].totalSpending;
    }

    function lookupPaymentProfileRefundAmount(address _profile) public view returns (uint256) {
        return paymentProfiles[_profile].amountRefunds;
    }

    function lookupPaymentProfileWithdrawnAmount(address _profile) public view returns (uint256) {
        return paymentProfiles[_profile].amountWithdrawals;
    }

    function lookupPaymentProfileNumberPaymentsMade(address _profile) public view returns (uint256) {
        return paymentProfiles[_profile].numberPaymentsMade;
    }

    function lookupPaymentProfileNumberPaymentsReceived(address _profile) public view returns (uint256) {
        return paymentProfiles[_profile].numberPaymentsReceived;
    }

    function lookupPaymentProfileNumberWithdrawals(address _profile) public view returns (uint256) {
        return paymentProfiles[_profile].numberWithdrawals;
    }

    function lookupPaymentProfileNumberRefunds(address _profile) public view returns (uint256) {
        return paymentProfiles[_profile].numberRefunds;
    }

    function lookupPaymentProfileInstallmentPlans(address _profile)
        public
        view
        returns (PaymentProfileInstallmentPlan[] memory)
    {
        uint256 profilePlanCount = paymentProfiles[_profile].planCount;
        PaymentProfileInstallmentPlan[] memory plans = new PaymentProfileInstallmentPlan[](profilePlanCount);
        if (profilePlanCount > 0) {
            for (uint256 i = 0; i < profilePlanCount; i++) {
                plans[i] = paymentProfiles[_profile].installmentPlans[i];
            }
        }
        return plans;
    }

    function lookupPaymentProfileReceipts(address _profile) public view returns (PaymentProfileReceipt[] memory) {
        uint256 profileReceiptCount = paymentProfiles[_profile].receiptCount;
        PaymentProfileReceipt[] memory receipts = new PaymentProfileReceipt[](profileReceiptCount);
        if (profileReceiptCount > 0) {
            for (uint256 i = 0; i < profileReceiptCount; i++) {
                receipts[i] = paymentProfiles[_profile].receipts[i];
            }
        }
        return receipts;
    }

    function lookupPaymentProfileWithdrawals(address _profile)
        public
        view
        returns (PaymentProfileWithdrawal[] memory)
    {
        uint256 profileWithdrawalCount = paymentProfiles[_profile].withdrawalCount;
        PaymentProfileWithdrawal[] memory withdrawals = new PaymentProfileWithdrawal[](profileWithdrawalCount);
        if (profileWithdrawalCount > 0) {
            for (uint256 i = 0; i < profileWithdrawalCount; i++) {
                withdrawals[i] = paymentProfiles[_profile].withdrawals[i];
            }
        }

        return withdrawals;
    }

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

    function makePayment(
        string memory _id,
        uint256 _amount,
        address _vendor,
        bool _isInstallments,
        uint256 _fullAmount,
        uint8 _installmentPeriod
    ) external payable {
        require(payments[_id].isPaid == false);
        uint256 _minAmount = getMinAmount(nativeCoinDecimals);
        require(_amount >= _minAmount);
        uint256 totalAmount = _amount + feePerPayment;
        require(totalAmount == msg.value);
        if (_isInstallments) {
            require(_installmentPeriod >= 1);
            require(_installmentPeriod <= maxInstallmentPeriod);
            require(_fullAmount > _amount);
            uint256 remainingAmount = _fullAmount - _amount;
            require(remainingAmount >= _minAmount);
            uint256 vendorPlanCount = paymentProfiles[_vendor].planCount;
            uint256 customerPlanCount = paymentProfiles[msg.sender].planCount;
            paymentProfiles[_vendor].installmentPlans[vendorPlanCount].id = _id;
            paymentProfiles[msg.sender].installmentPlans[customerPlanCount].id = _id;
            paymentProfiles[_vendor].planCount++;
            paymentProfiles[msg.sender].planCount++;
            _addInstallmentsCreated(_installmentPeriod);
        }
        paymentProfiles[_vendor].currentBalance += _amount;
        paymentProfiles[_vendor].totalRevenue = safeAdd(paymentProfiles[_vendor].totalRevenue, _amount);
        paymentProfiles[_vendor].numberPaymentsReceived++;
        uint256 vendorReceiptCount = paymentProfiles[_vendor].receiptCount;
        paymentProfiles[_vendor].receipts[vendorReceiptCount].id = _id;
        paymentProfiles[_vendor].receiptCount++;
        paymentProfiles[msg.sender].totalSpending = safeAdd(paymentProfiles[msg.sender].totalSpending, _amount);
        paymentProfiles[msg.sender].numberPaymentsMade++;
        uint256 customerReceiptCount = paymentProfiles[msg.sender].receiptCount;
        paymentProfiles[msg.sender].receipts[customerReceiptCount].id = _id;
        paymentProfiles[msg.sender].receiptCount++;
        _addUniqueVendors(_vendor);
        _addUniqueCustomers(msg.sender);
        _addPaymentsMade();
        _addAssetsPaid(_amount);
        _addToPayments(_id, _amount, _vendor, _isInstallments, _fullAmount, _installmentPeriod);
        IOmnify mainContract = IOmnify(omnifyAddress);
        mainContract.addProfitsFromExternalContract{value: feePerPayment}();
        emit PaymentMade(_id, msg.sender, _vendor, _amount, block.number, block.timestamp);
    }

    function payInstallment(string memory _id) external payable {
        require(payments[_id].isInstallments);
        require(payments[_id].remainingInstallments > 0);
        //        uint256 dueDate = payments[_id].dateLastInstallmentPaid + 30 days;
        //        require(block.timestamp >= dueDate);
        uint256 amountPerInstallment = payments[_id].amountPerInstallment;
        address vendor = payments[_id].vendor;
        address customer = payments[_id].customer;
        if (payments[_id].remainingInstallments == 1) {
            uint256 amountPaid = payments[_id].paidInstallments * amountPerInstallment;
            amountPaid += payments[_id].amount;
            uint256 remainingAmount = payments[_id].fullAmount - amountPaid;
            uint256 totalAmount = remainingAmount + feePerInstallment;
            require(msg.value == totalAmount);
            paymentProfiles[vendor].currentBalance += remainingAmount;
            paymentProfiles[vendor].totalRevenue = safeAdd(paymentProfiles[vendor].totalRevenue, remainingAmount);
            paymentProfiles[customer].totalSpending = safeAdd(paymentProfiles[customer].totalSpending, remainingAmount);
            _addInstallmentAssetsPaid(remainingAmount);
        } else {
            uint256 totalAmount = amountPerInstallment + feePerInstallment;
            require(msg.value == totalAmount);
            paymentProfiles[vendor].currentBalance += amountPerInstallment;
            paymentProfiles[vendor].totalRevenue = safeAdd(paymentProfiles[vendor].totalRevenue, amountPerInstallment);
            paymentProfiles[customer].totalSpending =
                safeAdd(paymentProfiles[customer].totalSpending, amountPerInstallment);
            _addInstallmentAssetsPaid(amountPerInstallment);
        }
        paymentProfiles[vendor].numberPaymentsReceived++;
        paymentProfiles[customer].numberPaymentsMade++;
        payments[_id].paidInstallments++;
        payments[_id].remainingInstallments--;
        payments[_id].dateLastInstallmentPaid = block.timestamp;
        _addInstallmentsPaid();
        IOmnify mainContract = IOmnify(omnifyAddress);
        mainContract.addProfitsFromExternalContract{value: feePerInstallment}();
        emit PaymentInstallmentPaid(_id, customer, vendor, amountPerInstallment, block.number, block.timestamp);
    }

    function withdrawBalance(uint256 _amount) external {
        require(paymentProfiles[msg.sender].currentBalance >= _amount);
        paymentProfiles[msg.sender].currentBalance -= _amount;
        paymentProfiles[msg.sender].amountWithdrawals = safeAdd(paymentProfiles[msg.sender].amountWithdrawals, _amount);
        paymentProfiles[msg.sender].numberWithdrawals++;
        uint256 profileWithdrawalCount = paymentProfiles[msg.sender].withdrawalCount;
        paymentProfiles[msg.sender].withdrawals[profileWithdrawalCount].amount = _amount;
        paymentProfiles[msg.sender].withdrawals[profileWithdrawalCount].date = block.timestamp;
        paymentProfiles[msg.sender].withdrawalCount++;
        _addWithdrawalsMade();
        _addAmountWithdrawn(_amount);
        address payable payTo = payable(msg.sender);
        (bool success,) = payTo.call{value: _amount}("");
        require(success);
        emit PaymentWithdrawalMade(msg.sender, _amount, block.number, block.timestamp);
    }

    function issueRefund(string memory _id) external {
        require(!payments[_id].isRefunded);
        address paymentVendor = payments[_id].vendor;
        require(msg.sender == paymentVendor);
        uint256 paymentAmount = payments[_id].amount;
        require(paymentProfiles[paymentVendor].currentBalance >= paymentAmount);
        payments[_id].isRefunded = true;
        paymentProfiles[paymentVendor].currentBalance -= paymentAmount;
        paymentProfiles[paymentVendor].amountRefunds =
            safeAdd(paymentProfiles[paymentVendor].amountRefunds, paymentAmount);
        paymentProfiles[paymentVendor].numberRefunds++;
        _addRefundsIssued();
        _addRefundsAmount(paymentAmount);
        address payable customer = payable(payments[_id].customer);
        (bool success,) = customer.call{value: paymentAmount}("");
        require(success);
        emit PaymentRefundIssued(_id, customer, paymentVendor, paymentAmount, block.number, block.timestamp);
    }

    function _addToPayments(
        string memory _id,
        uint256 _amount,
        address _vendor,
        bool _isInstallments,
        uint256 _fullAmount,
        uint8 _installmentPeriod
    ) private {
        payments[_id].id = _id;
        payments[_id].amount = _amount;
        payments[_id].vendor = _vendor;
        payments[_id].customer = msg.sender;
        payments[_id].isInstallments = _isInstallments;
        payments[_id].datePaid = block.timestamp;
        payments[_id].isPaid = true;
        if (_isInstallments) {
            uint256 remainingAmount = _fullAmount - _amount;
            uint256 _amountPerInstallment = remainingAmount / _installmentPeriod;
            payments[_id].installmentPeriod = _installmentPeriod;
            payments[_id].amountPerInstallment = _amountPerInstallment;
            payments[_id].remainingInstallments = _installmentPeriod;
            payments[_id].dateLastInstallmentPaid = block.timestamp;
            payments[_id].fullAmount = _fullAmount;
        }
    }

    function safeAdd(uint256 _currentAmount, uint256 _amountToBeAdded) internal view returns (uint256) {
        uint256 _allowedAmount = MAXUINT - _currentAmount;
        if (_amountToBeAdded <= _allowedAmount) {
            return _currentAmount + _amountToBeAdded;
        }
        return _currentAmount;
    }
}
