// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ownable.sol";
import "./ierc20metadata.sol";
import "./IOmnify.sol";

contract Trust is Ownable {
    event TrustDeposit(
        string _id, address _initiator, address _asset, uint256 _amount, uint256 _blockNumber, uint256 _date
    );
    event TrustModified(string _id, address _initiator, uint256 _blockNumber, uint256 _date);
    event TrustWithdrawal(
        string _id, address _initiator, address _asset, uint256 _amount, uint256 _blockNumber, uint256 _date
    );
    event TrustRetraction(
        string _id, address _initiator, address _asset, uint256 _amount, uint256 _blockNumber, uint256 _date
    );

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

    struct Deposit {
        string id;
        uint256 initialAmount;
        uint256 remainingAmount;
        address asset;
        //true is modifiable
        bool depositType;
        //true is retractable
        bool liquidity;
        //true is active
        bool isActive;
        uint256 dateCreated;
        bool exists;
        mapping(address => bool) owners;
        mapping(address => bool) beneficiaries;
        mapping(address => Beneficiary) addressToBeneficiary;
        Owner[] ownerList;
        Beneficiary[] beneficiaryList;
    }

    struct TrustAssetProfile {
        address asset;
        uint256 amountWithdrawn;
    }

    struct TrustProfileDeposit {
        string id;
        bool isOwner;
    }

    struct TrustProfile {
        uint256 assetCount;
        uint256 depositCount;
        mapping(address => uint256) assetToCount;
        mapping(uint256 => TrustAssetProfile) amountOfAssetWithdrawn;
        mapping(uint256 => TrustProfileDeposit) depositAndIsOwnerOrBeneficiary;
    }

    constructor(
        address _paramOmnifyAddress,
        uint8 _paramNativeDecimals,
        uint256 _paramDepositFee,
        uint256 _paramBenefFee
    ) Ownable(msg.sender) {
        omnifyAddress = _paramOmnifyAddress;
        nativeCoinDecimals = _paramNativeDecimals;
        depositFee = _paramDepositFee;
        beneficiaryFee = _paramBenefFee;
    }

    uint8 public nativeCoinDecimals;
    uint256 internal MAXUINT = 2 ** 256 - 1;
    uint256 public depositFee;
    uint256 public beneficiaryFee;
    uint256 public numberOwners;
    uint256 public numberBeneficiaries;
    uint256 public numberDeposits;
    uint256 public amountAssetsDeposited;
    uint256 public numberWithdrawals;
    uint256 public amountAssetsWithdrawn;
    address public feeKeeperAddress;
    address public omnifyAddress;

    mapping(string => Deposit) public deposits;
    mapping(address => TrustProfile) public trustProfiles;

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

    function setDepositFee(uint256 _fee) external onlyOwner {
        depositFee = _fee;
    }

    function setDepositFeeByFeeKeeper(uint256 _fee) external onlyFeeKeeper(msg.sender) {
        depositFee = _fee;
    }

    function setBeneficiaryFee(uint256 _fee) external onlyOwner {
        beneficiaryFee = _fee;
    }

    function setBeneficiaryFeeByFeeKeeper(uint256 _fee) external onlyFeeKeeper(msg.sender) {
        beneficiaryFee = _fee;
    }

    function _addNumberDeposits() internal {
        numberDeposits++;
    }

    function _addAssetsDeposited(uint256 _amount) internal {
        amountAssetsDeposited = safeAdd(amountAssetsDeposited, _amount);
    }

    function _addNumberWithdrawals() internal {
        numberWithdrawals++;
    }

    function _addAmountAssetsWithdrawn(uint256 _amount) internal {
        amountAssetsWithdrawn = safeAdd(amountAssetsWithdrawn, _amount);
    }

    function _addNumberOwners(uint256 _number) internal {
        numberOwners = safeAdd(numberOwners, _number);
    }

    function _addNumberBeneficiaries(uint256 _number) internal {
        numberBeneficiaries = safeAdd(numberBeneficiaries, _number);
    }

    function lookupDepositInitialAmount(string memory _id) public view returns (uint256) {
        return deposits[_id].initialAmount;
    }

    function lookupDepositRemainingAmount(string memory _id) public view returns (uint256) {
        return deposits[_id].remainingAmount;
    }

    function lookupDepositAsset(string memory _id) public view returns (address) {
        return deposits[_id].asset;
    }

    function lookupDepositType(string memory _id) public view returns (bool) {
        //true is modifiable
        return deposits[_id].depositType;
    }

    function lookupDepositLiquidity(string memory _id) public view returns (bool) {
        //true is retractable
        return deposits[_id].liquidity;
    }

    function lookupDepositActivity(string memory _id) public view returns (bool) {
        //true is active
        return deposits[_id].isActive;
    }

    function lookupDepositExists(string memory _id) public view returns (bool) {
        return deposits[_id].exists;
    }

    function lookupDepositDateCreated(string memory _id) public view returns (uint256) {
        return deposits[_id].dateCreated;
    }

    function lookupDepositOwners(string memory _id) public view returns (Owner[] memory) {
        return deposits[_id].ownerList;
    }

    function lookupDepositBeneficiaries(string memory _id) public view returns (Beneficiary[] memory) {
        return deposits[_id].beneficiaryList;
    }

    function lookupDepositBenefDateLastWithdrawal(string memory _id, address _b) public view returns (uint256) {
        return deposits[_id].addressToBeneficiary[_b].dateLastWithdrawal;
    }

    function lookupTrustProfileAssets(address _profile) public view returns (TrustAssetProfile[] memory) {
        uint256 profileAssetCount = trustProfiles[_profile].assetCount;
        TrustAssetProfile[] memory profileAssets = new TrustAssetProfile[](profileAssetCount + 1);
        if (profileAssetCount > 0) {
            for (uint256 i = 0; i <= profileAssetCount; i++) {
                profileAssets[i] = trustProfiles[_profile].amountOfAssetWithdrawn[i];
            }
        }
        return profileAssets;
    }

    function lookupTrustProfileDeposits(address _profile) public view returns (TrustProfileDeposit[] memory) {
        uint256 profileDepositCount = trustProfiles[_profile].depositCount;
        TrustProfileDeposit[] memory profileDeposits = new TrustProfileDeposit[](profileDepositCount);
        if (profileDepositCount > 0) {
            for (uint256 i = 0; i < profileDepositCount; i++) {
                profileDeposits[i] = trustProfiles[_profile].depositAndIsOwnerOrBeneficiary[i];
            }
        }
        return profileDeposits;
    }

    function createDeposit(
        string memory _id,
        uint256 _amount,
        address _asset,
        bool _depositType,
        bool _liquidity,
        bool _isActive,
        Owner[] calldata _owners,
        Beneficiary[] calldata _beneficiaries
    ) external payable {
        require(!deposits[_id].exists);
        if (_asset == address(0)) {
            uint256 _minAmount = getMinAmount(nativeCoinDecimals);
            require(_amount >= _minAmount);
            uint256 benefFee = beneficiaryFee * _beneficiaries.length;
            uint256 totalAmount = _amount + depositFee + benefFee;
            require(msg.value == totalAmount);
            IOmnify mainContract = IOmnify(omnifyAddress);
            mainContract.addProfitsFromExternalContract{value: depositFee + benefFee}();
            _addNumberDeposits();
            _addAssetsDeposited(_amount);
            _addNumberOwners(_owners.length);
            _addNumberBeneficiaries(_beneficiaries.length);
            _addToDeposits(_id, _amount, _asset, _depositType, _liquidity, _isActive, _owners, _beneficiaries);
            emit TrustDeposit(_id, msg.sender, _asset, _amount, block.number, block.timestamp);
        } else {
            uint256 benefFee = beneficiaryFee * _beneficiaries.length;
            uint256 totalFees = depositFee + benefFee;
            require(msg.value == totalFees);
            MYIERC20Metadata coin = MYIERC20Metadata(_asset);
            uint8 _decimals = coin.decimals();
            uint256 _minAmount = getMinAmount(_decimals);
            require(_amount >= _minAmount);
            bool success1 = coin.transferFrom(msg.sender, address(this), _amount);
            require(success1);
            IOmnify mainContract = IOmnify(omnifyAddress);
            mainContract.addProfitsFromExternalContract{value: msg.value}();
            _addNumberDeposits();
            _addAssetsDeposited(_amount);
            _addNumberOwners(_owners.length);
            _addNumberBeneficiaries(_beneficiaries.length);
            _addToDeposits(_id, _amount, _asset, _depositType, _liquidity, _isActive, _owners, _beneficiaries);
            emit TrustDeposit(_id, msg.sender, _asset, _amount, block.number, block.timestamp);
        }
    }

    function depositIntoExistingDeposit(string memory _id, address _asset, uint256 _amount) external payable {
        require(deposits[_id].depositType);
        require(_asset == deposits[_id].asset);
        if (_asset == address(0)) {
            uint256 _minAmount = getMinAmount(nativeCoinDecimals);
            require(_amount >= _minAmount);
            uint256 totalAmount = _amount + depositFee;
            require(msg.value == totalAmount);
            deposits[_id].remainingAmount += _amount;
            _addAssetsDeposited(_amount);
            IOmnify mainContract = IOmnify(omnifyAddress);
            mainContract.addProfitsFromExternalContract{value: depositFee}();
            emit TrustDeposit(_id, msg.sender, _asset, _amount, block.number, block.timestamp);
        } else {
            require(msg.value == depositFee);
            MYIERC20Metadata coin = MYIERC20Metadata(_asset);
            uint8 _decimals = coin.decimals();
            uint256 _minAmount = getMinAmount(_decimals);
            require(_amount >= _minAmount);
            bool success1 = coin.transferFrom(msg.sender, address(this), _amount);
            require(success1);
            deposits[_id].remainingAmount += _amount;
            _addAssetsDeposited(_amount);
            IOmnify mainContract = IOmnify(omnifyAddress);
            mainContract.addProfitsFromExternalContract{value: depositFee}();
            emit TrustDeposit(_id, msg.sender, _asset, _amount, block.number, block.timestamp);
        }
    }

    function withdrawFromDeposit(string memory _id, uint256 _amount) external {
        require(_amount <= deposits[_id].remainingAmount);
        bool requesterIsBeneficiary = deposits[_id].beneficiaries[msg.sender] == true;
        require(requesterIsBeneficiary);
        require(deposits[_id].isActive);
        Beneficiary memory current = deposits[_id].addressToBeneficiary[msg.sender];
        if (current.isLimited) {
            require(_amount <= current.allowance);
            require(block.timestamp >= current.dateLastWithdrawal + 1 days);
        }
        address depositAsset = deposits[_id].asset;
        if (depositAsset == address(0)) {
            deposits[_id].remainingAmount -= _amount;
            trustProfiles[msg.sender].assetToCount[depositAsset] = 0;
            uint256 assetCount = trustProfiles[msg.sender].assetToCount[depositAsset];
            trustProfiles[msg.sender].amountOfAssetWithdrawn[assetCount].asset = address(0);
            trustProfiles[msg.sender].amountOfAssetWithdrawn[assetCount].amountWithdrawn =
                safeAdd(trustProfiles[msg.sender].amountOfAssetWithdrawn[assetCount].amountWithdrawn, _amount);
            _addNumberWithdrawals();
            _addAmountAssetsWithdrawn(_amount);
            deposits[_id].addressToBeneficiary[msg.sender].dateLastWithdrawal = block.timestamp;
            address payable sendTo = payable(msg.sender);
            (bool success,) = sendTo.call{value: _amount}("");
            require(success);
            emit TrustWithdrawal(_id, msg.sender, depositAsset, _amount, block.number, block.timestamp);
        } else {
            deposits[_id].remainingAmount -= _amount;
            uint256 assetCount = trustProfiles[msg.sender].assetToCount[depositAsset];
            if (assetCount == 0) {
                trustProfiles[msg.sender].assetCount++;
                trustProfiles[msg.sender].assetToCount[depositAsset] = trustProfiles[msg.sender].assetCount;
                uint256 assetCount2 = trustProfiles[msg.sender].assetToCount[depositAsset];
                trustProfiles[msg.sender].amountOfAssetWithdrawn[assetCount2].asset = depositAsset;
            }
            uint256 assetCount3 = trustProfiles[msg.sender].assetToCount[depositAsset];
            trustProfiles[msg.sender].amountOfAssetWithdrawn[assetCount3].amountWithdrawn =
                safeAdd(trustProfiles[msg.sender].amountOfAssetWithdrawn[assetCount3].amountWithdrawn, _amount);
            _addNumberWithdrawals();
            _addAmountAssetsWithdrawn(_amount);
            deposits[_id].addressToBeneficiary[msg.sender].dateLastWithdrawal = block.timestamp;
            MYIERC20 coin = MYIERC20(depositAsset);
            bool success1 = coin.transfer(msg.sender, _amount);
            require(success1);
            emit TrustWithdrawal(_id, msg.sender, depositAsset, _amount, block.number, block.timestamp);
        }
    }

    function retractDeposit(string memory _id) external {
        require(deposits[_id].remainingAmount > 0);
        require(deposits[_id].owners[msg.sender] == true);
        require(deposits[_id].liquidity);
        address depositAsset = deposits[_id].asset;
        uint256 remaining = deposits[_id].remainingAmount;
        if (depositAsset == address(0)) {
            deposits[_id].remainingAmount = 0;
            deposits[_id].isActive = false;
            address payable sendTo = payable(msg.sender);
            (bool success,) = sendTo.call{value: remaining}("");
            require(success);
            emit TrustRetraction(_id, msg.sender, depositAsset, remaining, block.number, block.timestamp);
        } else {
            deposits[_id].remainingAmount = 0;
            deposits[_id].isActive = false;
            MYIERC20 coin = MYIERC20(depositAsset);
            bool success1 = coin.transfer(msg.sender, remaining);
            require(success1);
            emit TrustRetraction(_id, msg.sender, depositAsset, remaining, block.number, block.timestamp);
        }
    }

    function setDepositActiveVal(string calldata _id, bool _val) external {
        require(deposits[_id].owners[msg.sender] == true);
        if (deposits[_id].isActive != _val) {
            deposits[_id].isActive = _val;
        }
    }

    function modifyDeposit(string memory _id, bool _newIsActive, Beneficiary[] calldata _newBeneficiaries)
        external
        payable
    {
        require(deposits[_id].owners[msg.sender] == true);
        require(deposits[_id].depositType);
        if (deposits[_id].isActive != _newIsActive) {
            deposits[_id].isActive = _newIsActive;
        }
        if (_newBeneficiaries.length > 0) {
            uint256 totalFee = 0;
            IOmnify mainContract = IOmnify(omnifyAddress);
            for (uint256 i = 0; i < _newBeneficiaries.length; i++) {
                Beneficiary memory _c = _newBeneficiaries[i];
                bool isAlreadyABeneficiary = deposits[_id].beneficiaries[_c.benef];
                if (isAlreadyABeneficiary == false) {
                    totalFee += beneficiaryFee;
                }
            }
            require(msg.value == totalFee);
            for (uint256 i = 0; i < deposits[_id].beneficiaryList.length; i++) {
                Beneficiary memory current = deposits[_id].beneficiaryList[i];
                deposits[_id].beneficiaries[current.benef] = false;
            }

            mainContract.addProfitsFromExternalContract{value: msg.value}();
            deposits[_id].beneficiaryList = _newBeneficiaries;
            for (uint256 i = 0; i < _newBeneficiaries.length; i++) {
                Beneficiary memory current = _newBeneficiaries[i];
                deposits[_id].beneficiaries[current.benef] = true;
                deposits[_id].addressToBeneficiary[current.benef].allowance = current.allowance;
                deposits[_id].addressToBeneficiary[current.benef].isLimited = current.isLimited;
                uint256 currentDepositCount = trustProfiles[current.benef].depositCount;
                trustProfiles[current.benef].depositAndIsOwnerOrBeneficiary[currentDepositCount].id = _id;
                trustProfiles[current.benef].depositAndIsOwnerOrBeneficiary[currentDepositCount].isOwner = false;
                trustProfiles[_newBeneficiaries[i].benef].depositCount++;
            }
        } else {
            for (uint256 i = 0; i < deposits[_id].beneficiaryList.length; i++) {
                Beneficiary memory current = deposits[_id].beneficiaryList[i];
                deposits[_id].beneficiaries[current.benef] = false;
            }
            deposits[_id].beneficiaryList = _newBeneficiaries;
        }
        emit TrustModified(_id, msg.sender, block.number, block.timestamp);
    }

    function _addToDeposits(
        string memory _id,
        uint256 _amount,
        address _asset,
        bool _depositType,
        bool _liquidity,
        bool _isActive,
        Owner[] calldata _owners,
        Beneficiary[] calldata _beneficiaries
    ) private {
        deposits[_id].id = _id;
        deposits[_id].initialAmount = _amount;
        deposits[_id].remainingAmount = _amount;
        deposits[_id].asset = _asset;
        deposits[_id].dateCreated = block.timestamp;
        deposits[_id].exists = true;
        deposits[_id].ownerList = _owners;
        deposits[_id].beneficiaryList = _beneficiaries;
        if (_depositType) {
            deposits[_id].depositType = true;
        }
        if (_liquidity) {
            deposits[_id].liquidity = true;
        }
        if (_isActive) {
            deposits[_id].isActive = true;
        }
        for (uint256 i = 0; i < _beneficiaries.length; i++) {
            Beneficiary memory current = _beneficiaries[i];
            deposits[_id].beneficiaries[current.benef] = true;
            deposits[_id].addressToBeneficiary[current.benef].allowance = current.allowance;
            deposits[_id].addressToBeneficiary[current.benef].isLimited = current.isLimited;
            uint256 currentDepositCount = trustProfiles[current.benef].depositCount;
            trustProfiles[current.benef].depositAndIsOwnerOrBeneficiary[currentDepositCount].id = _id;
            trustProfiles[current.benef].depositAndIsOwnerOrBeneficiary[currentDepositCount].isOwner = false;
            trustProfiles[_beneficiaries[i].benef].depositCount++;
        }
        for (uint256 i = 0; i < _owners.length; i++) {
            deposits[_id].owners[_owners[i].owner] = true;
            uint256 currentDepositCount = trustProfiles[_owners[i].owner].depositCount;
            trustProfiles[_owners[i].owner].depositAndIsOwnerOrBeneficiary[currentDepositCount].id = _id;
            trustProfiles[_owners[i].owner].depositAndIsOwnerOrBeneficiary[currentDepositCount].isOwner = true;
            trustProfiles[_owners[i].owner].depositCount++;
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
