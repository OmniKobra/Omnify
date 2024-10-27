// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ownable.sol";
import "./IOmnify.sol";
import "./ierc20metadata.sol";
import "./ierc20.sol";

contract Escrow is Ownable {
    event NewContract(string _id, address _owner, uint256 _blockNumber, uint256 _date);
    event ContractDeleted(string _id, address _owner, uint256 _blockNumber, uint256 _date);
    event BidAccepted(string _id, address _owner, uint256 _blockNumber, uint256 _date);
    event NewBid(string _id, address _owner, uint256 _blockNumber, uint256 _date);

    struct Bid {
        address bidder;
        address asset;
        uint256 amount;
        uint256 dateBid;
        bool isAccepted;
        bool isCancelled;
        bool exists;
    }

    struct EscrowContract {
        string id;
        address asset;
        uint256 assetAmount;
        bool isComplete;
        bool isDeleted;
        bool exists;
        uint256 bidCount;
        mapping(uint256 => Bid) bids;
        mapping(address => uint256) addressToBidCount;
        address owner;
        uint256 dateCreated;
        uint256 dateDeleted;
    }

    struct EscrowProfile {
        uint256 numOfCompleteContracts;
        uint256 numOfDeletedContracts;
        uint256 numOfBidsMade;
        uint256 numOfBidsReceived;
        uint256 contractCount;
        mapping(uint256 => string) profileContracts;
    }

    constructor(address _paramOmnifyAddress, uint8 _paramNativeDecimals, uint256 _paramContractFee)
        Ownable(msg.sender)
    {
        omnifyAddress = _paramOmnifyAddress;
        nativeCoinDecimals = _paramNativeDecimals;
        contractFee = _paramContractFee;
    }

    uint8 public nativeCoinDecimals;
    uint256 internal MAXUINT = 2 ** 256 - 1;
    uint256 public contractFee;
    uint256 public numberContracts;
    uint256 public amountAssetsInContracts;
    uint256 public numberBids;
    uint256 public amountAssetsInBids;
    uint256 public numberCompletedContracts;
    address public feeKeeperAddress;
    address public omnifyAddress;
    mapping(string => EscrowContract) public contracts;
    mapping(address => EscrowProfile) public escrowProfiles;

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

    function setOmnifyAddress(address _newaddress) external onlyOwner {
        omnifyAddress = _newaddress;
    }

    function setFeeKeeperAddress(address _feeKeeper) external onlyOwner {
        feeKeeperAddress = _feeKeeper;
    }

    function setContractFee(uint256 _fee) external onlyOwner {
        contractFee = _fee;
    }

    function setContractFeeByFeeKeeper(uint256 _fee) external onlyFeeKeeper(msg.sender) {
        contractFee = _fee;
    }

    function _addNumberContracts() internal {
        numberContracts++;
    }

    function _addAmountAssetsInContracts(uint256 _amount) internal {
        amountAssetsInContracts = safeAdd(amountAssetsInContracts, _amount);
    }

    function _addNumberBids() internal {
        numberBids++;
    }

    function _addAmountAssetsInBids(uint256 _amount) internal {
        amountAssetsInBids = safeAdd(amountAssetsInBids, _amount);
    }

    function _addCompletedContracts() internal {
        numberCompletedContracts++;
    }

    function lookupEscrowProfileContractCount(address _profile) public view returns (uint256) {
        return escrowProfiles[_profile].contractCount;
    }

    function lookupEscrowProfileCompleteContracts(address _profile) public view returns (uint256) {
        return escrowProfiles[_profile].numOfCompleteContracts;
    }

    function lookupEscrowProfileDeletedContracts(address _profile) public view returns (uint256) {
        return escrowProfiles[_profile].numOfDeletedContracts;
    }

    function lookupEscrowProfileBidsMade(address _profile) public view returns (uint256) {
        return escrowProfiles[_profile].numOfBidsMade;
    }

    function lookupEscrowProfileBidsReceived(address _profile) public view returns (uint256) {
        return escrowProfiles[_profile].numOfBidsReceived;
    }

    function lookupContractBids(string memory _id) public view returns (Bid[] memory) {
        uint256 contractBidCount = contracts[_id].bidCount;
        Bid[] memory bids = new Bid[](contractBidCount);
        if (contractBidCount > 0) {
            for (uint256 i = 0; i < contractBidCount; i++) {
                bids[i] = contracts[_id].bids[i + 1];
            }
        }
        return bids;
    }

    function lookupEscrowProfileContracts(address _profile) public view returns (string[] memory) {
        uint256 profileContractCount = escrowProfiles[_profile].contractCount;
        string[] memory profileContracts = new string[](profileContractCount);
        if (profileContractCount > 0) {
            for (uint256 i = 0; i < profileContractCount; i++) {
                profileContracts[i] = escrowProfiles[_profile].profileContracts[i + 1];
            }
        }
        return profileContracts;
    }

    function lookupContractAsset(string memory _id) public view returns (address) {
        return contracts[_id].asset;
    }

    function lookupContractAssetAmount(string memory _id) public view returns (uint256) {
        return contracts[_id].assetAmount;
    }

    function lookupContractIsComplete(string memory _id) public view returns (bool) {
        return contracts[_id].isComplete;
    }

    function lookupContractIsDeleted(string memory _id) public view returns (bool) {
        return contracts[_id].isDeleted;
    }

    function lookupContractExists(string memory _id) public view returns (bool) {
        return contracts[_id].exists;
    }

    function lookupCountractBidCount(string memory _id) public view returns (uint256) {
        return contracts[_id].bidCount;
    }

    function lookupContractOwner(string memory _id) public view returns (address) {
        return contracts[_id].owner;
    }

    function lookupContractDateCreated(string memory _id) public view returns (uint256) {
        return contracts[_id].dateCreated;
    }

    function lookupContractDateDeleted(string memory _id) public view returns (uint256) {
        return contracts[_id].dateDeleted;
    }

    function newContract(string memory _id, address _asset, uint256 _amount) external payable {
        require(!contracts[_id].exists);
        if (_asset == address(0)) {
            uint256 _minAmount = getMinAmount(nativeCoinDecimals);
            require(_amount >= _minAmount);
            uint256 totalAmount = _amount + contractFee;
            require(msg.value == totalAmount);
            escrowProfiles[msg.sender].contractCount++;
            uint256 profileCount = escrowProfiles[msg.sender].contractCount;
            escrowProfiles[msg.sender].profileContracts[profileCount] = _id;
            _addNumberContracts();
            _addAmountAssetsInContracts(_amount);
            _addToContracts(_id, _asset, _amount);
            IOmnify mainContract = IOmnify(omnifyAddress);
            mainContract.addProfitsFromExternalContract{value: contractFee}();
            emit NewContract(_id, msg.sender, block.number, block.timestamp);
        } else {
            require(msg.value == contractFee);
            MYIERC20Metadata coin = MYIERC20Metadata(_asset);
            uint8 _decimals = coin.decimals();
            uint256 _minAmount = getMinAmount(_decimals);
            require(_amount >= _minAmount);
            bool success1 = coin.transferFrom(msg.sender, address(this), _amount);
            require(success1);
            escrowProfiles[msg.sender].contractCount++;
            uint256 profileCount = escrowProfiles[msg.sender].contractCount;
            escrowProfiles[msg.sender].profileContracts[profileCount] = _id;
            _addNumberContracts();
            _addAmountAssetsInContracts(_amount);
            _addToContracts(_id, _asset, _amount);
            IOmnify mainContract = IOmnify(omnifyAddress);
            mainContract.addProfitsFromExternalContract{value: contractFee}();
            emit NewContract(_id, msg.sender, block.number, block.timestamp);
        }
    }

    function newBid(string memory _contractId, address _asset, uint256 _amount) external payable {
        require(contracts[_contractId].exists);
        require(!contracts[_contractId].isDeleted);
        require(!contracts[_contractId].isComplete);
        require(contracts[_contractId].addressToBidCount[msg.sender] == 0);
        require(msg.sender != contracts[_contractId].owner);
        if (_asset == address(0)) {
            uint256 _minAmount = getMinAmount(nativeCoinDecimals);
            require(_amount >= _minAmount);
            require(msg.value >= _minAmount);
            require(msg.value == _amount);
            contracts[_contractId].bidCount++;
            address contractOwner = contracts[_contractId].owner;
            uint256 currentBidCount = contracts[_contractId].bidCount;
            contracts[_contractId].bids[currentBidCount].bidder = msg.sender;
            contracts[_contractId].bids[currentBidCount].amount = _amount;
            contracts[_contractId].bids[currentBidCount].asset = _asset;
            contracts[_contractId].bids[currentBidCount].dateBid = block.timestamp;
            contracts[_contractId].bids[currentBidCount].exists = true;
            contracts[_contractId].addressToBidCount[msg.sender] = currentBidCount;
            escrowProfiles[contractOwner].numOfBidsReceived++;
            escrowProfiles[msg.sender].numOfBidsMade++;
            escrowProfiles[msg.sender].contractCount++;
            escrowProfiles[msg.sender].profileContracts[escrowProfiles[msg.sender].contractCount] = _contractId;
            _addNumberBids();
            _addAmountAssetsInBids(_amount);
            emit NewBid(_contractId, msg.sender, block.number, block.timestamp);
        } else {
            MYIERC20Metadata coin = MYIERC20Metadata(_asset);
            uint8 _decimals = coin.decimals();
            uint256 _minAmount = getMinAmount(_decimals);
            require(_amount >= _minAmount);
            bool success1 = coin.transferFrom(msg.sender, address(this), _amount);
            require(success1);
            contracts[_contractId].bidCount++;
            address contractOwner = contracts[_contractId].owner;
            uint256 currentBidCount = contracts[_contractId].bidCount;
            contracts[_contractId].bids[currentBidCount].bidder = msg.sender;
            contracts[_contractId].bids[currentBidCount].amount = _amount;
            contracts[_contractId].bids[currentBidCount].asset = _asset;
            contracts[_contractId].bids[currentBidCount].dateBid = block.timestamp;
            contracts[_contractId].bids[currentBidCount].exists = true;
            contracts[_contractId].addressToBidCount[msg.sender] = currentBidCount;
            escrowProfiles[contractOwner].numOfBidsReceived++;
            escrowProfiles[msg.sender].numOfBidsMade++;
            escrowProfiles[msg.sender].contractCount++;
            escrowProfiles[msg.sender].profileContracts[escrowProfiles[msg.sender].contractCount] = _contractId;
            _addNumberBids();
            _addAmountAssetsInBids(_amount);
            emit NewBid(_contractId, msg.sender, block.number, block.timestamp);
        }
    }

    function acceptBid(string memory _contractId, uint256 _acceptedBidCount) external {
        require(contracts[_contractId].exists);
        require(!contracts[_contractId].isDeleted);
        require(!contracts[_contractId].isComplete);
        require(!contracts[_contractId].bids[_acceptedBidCount].isAccepted);
        require(!contracts[_contractId].bids[_acceptedBidCount].isCancelled);
        require(contracts[_contractId].bids[_acceptedBidCount].exists);
        require(msg.sender == contracts[_contractId].owner);
        Bid memory theBid = contracts[_contractId].bids[_acceptedBidCount];
        address contractAsset = contracts[_contractId].asset;
        address bidAsset = theBid.asset;
        address payable owner = payable(contracts[_contractId].owner);
        address payable bidder = payable(theBid.bidder);
        contracts[_contractId].isComplete = true;
        contracts[_contractId].bids[_acceptedBidCount].isAccepted = true;
        escrowProfiles[contracts[_contractId].owner].numOfCompleteContracts++;
        _addCompletedContracts();
        if (bidAsset == address(0)) {
            (bool success,) = owner.call{value: theBid.amount}("");
            require(success);
        } else {
            MYIERC20 bidCoin = MYIERC20(bidAsset);
            bool success = bidCoin.transfer(contracts[_contractId].owner, theBid.amount);
            require(success);
        }
        if (contractAsset == address(0)) {
            (bool success,) = bidder.call{value: contracts[_contractId].assetAmount}("");
            require(success);
        } else {
            MYIERC20 contractCoin = MYIERC20(contractAsset);
            bool success = contractCoin.transfer(theBid.bidder, contracts[_contractId].assetAmount);
            require(success);
        }
        emit BidAccepted(_contractId, msg.sender, block.number, block.timestamp);
    }

    function cancelBid(string memory _contractId, uint256 _bidCount) external {
        require(contracts[_contractId].exists);
        require(!contracts[_contractId].bids[_bidCount].isCancelled);
        require(!contracts[_contractId].bids[_bidCount].isAccepted);
        require(msg.sender == contracts[_contractId].bids[_bidCount].bidder);
        require(contracts[_contractId].bids[_bidCount].exists);
        address bidAsset = contracts[_contractId].bids[_bidCount].asset;
        address bidder = contracts[_contractId].bids[_bidCount].bidder;
        uint256 bidAmount = contracts[_contractId].bids[_bidCount].amount;
        contracts[_contractId].bids[_bidCount].isCancelled = true;
        address payable payBidder = payable(bidder);
        if (bidAsset == address(0)) {
            (bool success,) = payBidder.call{value: bidAmount}("");
            require(success);
        } else {
            MYIERC20 bidCoin = MYIERC20(bidAsset);
            bool success = bidCoin.transfer(bidder, bidAmount);
            require(success);
        }
    }

    function deleteContract(string memory _contractId) external {
        require(contracts[_contractId].exists);
        require(!contracts[_contractId].isDeleted);
        require(!contracts[_contractId].isComplete);
        require(msg.sender == contracts[_contractId].owner);
        address payable owner = payable(contracts[_contractId].owner);
        address contractAsset = contracts[_contractId].asset;
        contracts[_contractId].isDeleted = true;
        contracts[_contractId].dateDeleted = block.timestamp;
        escrowProfiles[msg.sender].numOfDeletedContracts++;
        if (contractAsset == address(0)) {
            (bool success,) = owner.call{value: contracts[_contractId].assetAmount}("");
            require(success);
        } else {
            MYIERC20 contractCoin = MYIERC20(contractAsset);
            bool success = contractCoin.transfer(contracts[_contractId].owner, contracts[_contractId].assetAmount);
            require(success);
        }
        emit ContractDeleted(_contractId, msg.sender, block.number, block.timestamp);
    }

    function _addToContracts(string memory _id, address _asset, uint256 _amount) private {
        contracts[_id].id = _id;
        contracts[_id].asset = _asset;
        contracts[_id].assetAmount = _amount;
        contracts[_id].dateCreated = block.timestamp;
        contracts[_id].owner = msg.sender;
        contracts[_id].exists = true;
    }

    function safeAdd(uint256 _currentAmount, uint256 _amountToBeAdded) internal view returns (uint256) {
        uint256 _allowedAmount = MAXUINT - _currentAmount;
        if (_amountToBeAdded <= _allowedAmount) {
            return _currentAmount + _amountToBeAdded;
        }
        return _currentAmount;
    }
}
