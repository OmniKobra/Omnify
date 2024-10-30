// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ownable.sol";
import "./ierc20metadata.sol";
import "./IOmnify.sol";

contract Transfers is Ownable {
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
    event TransferComplete(
        string _id,
        address _sender,
        address _recipient,
        address _asset,
        uint256 _amount,
        uint256 _blockNumber,
        uint256 _date
    );

    struct TransferFee {
        uint256 lowerThreshold;
        uint256 higherThreshold;
        uint256 fee;
    }

    struct ParamTransfer {
        address asset;
        uint256 amount;
        address payable recipient;
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

    struct ProfileTransfer {
        string id;
    }

    struct AssetStat {
        uint256 sent;
        uint256 received;
    }

    struct TransferProfile {
        uint256 transfersSent;
        uint256 transfersReceived;
        bool exists;
        uint256 transfersCount;
        uint256 assetCount;
        mapping(uint256 => ProfileTransfer) transfers;
        mapping(uint256 => address) countToAsset;
        mapping(address => uint256) assetToCount;
        mapping(uint256 => AssetStat) assetsStats;
    }

    constructor(
        address _omnifyAddress,
        uint8 _paramNativeDecimals,
        uint256 _paramAltcoinFee,
        uint256 _paramTier1Fee,
        uint256 _paramtier2Fee,
        uint256 _paramTier3Fee,
        uint256 _paramTier4Fee,
        uint256 _paramTier1HigherThreshold,
        uint256 _paramTier2HigherThreshold,
        uint256 _paramTier3HigherThreshold
    ) Ownable(msg.sender) {
        omnifyAddress = _omnifyAddress;
        nativeCoinDecimals = _paramNativeDecimals;
        altcoinFee = _paramAltcoinFee;
        tier1.fee = _paramTier1Fee;
        tier2.fee = _paramtier2Fee;
        tier3.fee = _paramTier3Fee;
        tier4.fee = _paramTier4Fee;
        tier1.lowerThreshold = getMinAmount(_paramNativeDecimals);
        tier1.higherThreshold = _paramTier1HigherThreshold;
        tier2.lowerThreshold = 10_000 * (10 ** _paramNativeDecimals);
        tier2.higherThreshold = _paramTier2HigherThreshold;
        tier3.lowerThreshold = 100_000 * (10 ** _paramNativeDecimals);
        tier3.higherThreshold = _paramTier3HigherThreshold;
        tier4.lowerThreshold = 1_000_000 * (10 ** _paramNativeDecimals);
    }

    uint256 internal MAXUINT = 2 ** 256 - 1;
    TransferFee public tier1;
    TransferFee public tier2;
    TransferFee public tier3;
    TransferFee public tier4;
    uint8 public nativeCoinDecimals;
    address public feeKeeperAddress;
    address public omnifyAddress;
    uint256 public altcoinFee;
    uint256 public totalNumerOfTransfers;
    uint256 public totalAssetsTransferred;
    uint256 public totalSendersUnique;
    uint256 public totalRecipientsUnique;
    mapping(string => Transfer) public transfers;
    mapping(address => TransferProfile) public transferProfiles;

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

    function setTier1(uint256 _lowerThreshold, uint256 _higherThreshold, uint256 _fee) external onlyOwner {
        tier1.lowerThreshold = _lowerThreshold;
        tier1.higherThreshold = _higherThreshold;
        tier1.fee = _fee;
    }

    function setTier1ByFeeKeeper(uint256 _lowerThreshold, uint256 _higherThreshold, uint256 _fee)
        external
        onlyFeeKeeper(msg.sender)
    {
        tier1.lowerThreshold = _lowerThreshold;
        tier1.higherThreshold = _higherThreshold;
        tier1.fee = _fee;
    }

    function setTier2(uint256 _lowerThreshold, uint256 _higherThreshold, uint256 _fee) external onlyOwner {
        tier2.lowerThreshold = _lowerThreshold;
        tier2.higherThreshold = _higherThreshold;
        tier2.fee = _fee;
    }

    function setTier2ByFeeKeeper(uint256 _lowerThreshold, uint256 _higherThreshold, uint256 _fee)
        external
        onlyFeeKeeper(msg.sender)
    {
        tier2.lowerThreshold = _lowerThreshold;
        tier2.higherThreshold = _higherThreshold;
        tier2.fee = _fee;
    }

    function setTier3(uint256 _lowerThreshold, uint256 _higherThreshold, uint256 _fee) external onlyOwner {
        tier3.lowerThreshold = _lowerThreshold;
        tier3.higherThreshold = _higherThreshold;
        tier3.fee = _fee;
    }

    function setTier3ByFeeKeeper(uint256 _lowerThreshold, uint256 _higherThreshold, uint256 _fee)
        external
        onlyFeeKeeper(msg.sender)
    {
        tier3.lowerThreshold = _lowerThreshold;
        tier3.higherThreshold = _higherThreshold;
        tier3.fee = _fee;
    }

    function setTier4(uint256 _lowerThreshold, uint256 _higherThreshold, uint256 _fee) external onlyOwner {
        tier4.lowerThreshold = _lowerThreshold;
        tier4.higherThreshold = _higherThreshold;
        tier4.fee = _fee;
    }

    function setTier4ByFeeKeeper(uint256 _lowerThreshold, uint256 _higherThreshold, uint256 _fee)
        external
        onlyFeeKeeper(msg.sender)
    {
        tier4.lowerThreshold = _lowerThreshold;
        tier4.higherThreshold = _higherThreshold;
        tier4.fee = _fee;
    }

    function setAltcoinFee(uint256 _fee) external onlyOwner {
        altcoinFee = _fee;
    }

    function setAltcoinFeeByFeeKeeper(uint256 _fee) external onlyFeeKeeper(msg.sender) {
        altcoinFee = _fee;
    }

    function _addTotalTransfers() internal {
        totalNumerOfTransfers++;
    }

    function _addTotalAssetsTransferred(uint256 _amount) internal {
        totalAssetsTransferred = safeAdd(totalAssetsTransferred, _amount);
    }

    function _addTotalSendersUnique(address _sender) internal {
        if (!transferProfiles[_sender].exists) {
            totalSendersUnique++;
            transferProfiles[_sender].exists = true;
        }
    }

    function _addTotalRecipients(address _recipient) internal {
        if (!transferProfiles[_recipient].exists) {
            totalRecipientsUnique++;
            transferProfiles[_recipient].exists = true;
        }
    }

    function lookupTransfer(string memory _id) public view returns (Transfer memory) {
        return transfers[_id];
    }

    function lookupTransferProfileSents(address _profile) public view returns (uint256) {
        return transferProfiles[_profile].transfersSent;
    }

    function lookupTransferProfileReceiveds(address _profile) public view returns (uint256) {
        return transferProfiles[_profile].transfersReceived;
    }

    function lookupTransferProfileTransfers(address _profile) public view returns (ProfileTransfer[] memory) {
        uint256 transferCount = transferProfiles[_profile].transfersCount;
        ProfileTransfer[] memory profileTransfers = new ProfileTransfer[](transferCount);
        if (transferCount > 0) {
            for (uint256 i = 0; i < transferCount; i++) {
                profileTransfers[i] = transferProfiles[_profile].transfers[i];
            }
        }
        return profileTransfers;
    }

    function lookupTransferProfileAssetStats(address _profile) public view returns (AssetStat[] memory) {
        uint256 assetCount = transferProfiles[_profile].assetCount;
        AssetStat[] memory profileAssets = new AssetStat[](assetCount);
        if (assetCount > 0) {
            for (uint256 i = 0; i < assetCount; i++) {
                profileAssets[i] = transferProfiles[_profile].assetsStats[i + 1];
            }
        }
        return profileAssets;
    }

    function lookupTransferAssetFromProfile(address _profile, uint256 _count) public view returns (address) {
        return transferProfiles[_profile].countToAsset[_count];
    }

    function conductTransfers(ParamTransfer[] calldata _trz) external payable {
        require(_trz.length > 0);
        uint256 _feesAmount = 0;
        uint256 _nonFeeAmount = 0;
        for (uint256 i = 0; i < _trz.length; i++) {
            ParamTransfer memory _t = _trz[i];
            address _asset = _t.asset;
            uint256 _amount = _t.amount;
            address payable _recipient = _t.recipient;
            string memory _id = _t.id;
            require(transfers[_id].exists == false);
            if (_asset == address(0)) {
                uint256 _minAmount = getMinAmount(nativeCoinDecimals);
                require(_amount >= _minAmount);
                TransferFee memory matchedTier = _matchFeeTier(_amount);
                uint256 calculatedFee = _calculateFeeFromTier(matchedTier);
                _feesAmount += calculatedFee;
                _nonFeeAmount += _amount;
                emit AssetsReceived(_id, msg.sender, _recipient, _asset, _amount, block.number, block.timestamp);
                (bool success,) = _recipient.call{value: _amount}("");
                require(success);
                emit AssetsSent(_id, msg.sender, _recipient, _asset, _amount, block.number, block.timestamp);
            } else {
                _feesAmount += altcoinFee;
                MYIERC20Metadata coin = MYIERC20Metadata(_asset);
                uint8 _decimals = coin.decimals();
                uint256 _minAmount = getMinAmount(_decimals);
                require(_amount >= _minAmount);
                bool success1 = coin.transferFrom(msg.sender, address(this), _amount);
                require(success1);
                emit AssetsReceived(_id, msg.sender, _recipient, _asset, _amount, block.number, block.timestamp);
                bool success2 = coin.transfer(_recipient, _amount);
                require(success2);
                emit AssetsSent(_id, msg.sender, _recipient, _asset, _amount, block.number, block.timestamp);
            }

            transferProfiles[msg.sender].transfersSent++;
            uint256 senderProfileTransferCount = transferProfiles[msg.sender].transfersCount;
            transferProfiles[msg.sender].transfers[senderProfileTransferCount].id = _id;
            transferProfiles[msg.sender].transfersCount++;
            if (transferProfiles[msg.sender].assetCount == 0) {
                transferProfiles[msg.sender].assetCount++;
            }
            uint256 thisAssetsCount = transferProfiles[msg.sender].assetToCount[_asset];
            bool assetExists = thisAssetsCount != 0;
            if (assetExists) {
                transferProfiles[msg.sender].assetsStats[thisAssetsCount].sent =
                    safeAdd(transferProfiles[msg.sender].assetsStats[thisAssetsCount].sent, _amount);
            } else {
                uint256 senderProfileAssetCount = transferProfiles[msg.sender].assetCount;
                transferProfiles[msg.sender].assetsStats[senderProfileAssetCount].sent =
                    safeAdd(transferProfiles[msg.sender].assetsStats[senderProfileAssetCount].sent, _amount);
                transferProfiles[msg.sender].countToAsset[senderProfileAssetCount] = _asset;
                transferProfiles[msg.sender].assetToCount[_asset] = senderProfileAssetCount;
                transferProfiles[msg.sender].assetCount++;
            }

            transferProfiles[_recipient].transfersReceived++;
            uint256 recipientProfileTransferCount = transferProfiles[_recipient].transfersCount;
            transferProfiles[_recipient].transfers[recipientProfileTransferCount].id = _id;
            transferProfiles[_recipient].transfersCount++;
            if (transferProfiles[_recipient].assetCount == 0) {
                transferProfiles[_recipient].assetCount++;
            }
            uint256 thisAssetsCountRecipient = transferProfiles[_recipient].assetToCount[_asset];
            bool recipientAssetExists = thisAssetsCountRecipient != 0;
            if (recipientAssetExists) {
                transferProfiles[_recipient].assetsStats[thisAssetsCountRecipient].received =
                    safeAdd(transferProfiles[_recipient].assetsStats[thisAssetsCountRecipient].received, _amount);
            } else {
                uint256 recipientProfileAssetCount = transferProfiles[_recipient].assetCount;
                transferProfiles[_recipient].assetsStats[recipientProfileAssetCount].received =
                    safeAdd(transferProfiles[_recipient].assetsStats[recipientProfileAssetCount].received, _amount);
                transferProfiles[_recipient].countToAsset[recipientProfileAssetCount] = _asset;
                transferProfiles[_recipient].assetToCount[_asset] = recipientProfileAssetCount;
                transferProfiles[_recipient].assetCount++;
            }

            _addTotalTransfers();
            _addTotalSendersUnique(msg.sender);
            _addTotalRecipients(_recipient);
            _addTotalAssetsTransferred(_amount);
            _addToTransfers(_id, _recipient, _asset, _amount);
            emit TransferComplete(_id, msg.sender, _recipient, _asset, _amount, block.number, block.timestamp);
        }
        require(msg.value == _feesAmount + _nonFeeAmount);
        require(msg.value - _nonFeeAmount == _feesAmount);
        require(msg.value - _feesAmount == _nonFeeAmount);
        IOmnify mainContract = IOmnify(omnifyAddress);
        mainContract.addProfitsFromExternalContract{value: _feesAmount}();
    }

    function _addToTransfers(string memory _id, address payable _recipient, address _asset, uint256 _amount) private {
        transfers[_id].id = _id;
        transfers[_id].sender = msg.sender;
        transfers[_id].recipient = _recipient;
        transfers[_id].assetAddress = _asset;
        transfers[_id].amount = _amount;
        transfers[_id].exists = true;
        transfers[_id].date = block.timestamp;
    }

    function _matchFeeTier(uint256 _amount) private view returns (TransferFee memory) {
        if (_amount >= tier1.lowerThreshold && _amount <= tier1.higherThreshold) {
            return tier1;
        }
        if (_amount >= tier2.lowerThreshold && _amount <= tier2.higherThreshold) {
            return tier2;
        }
        if (_amount >= tier3.lowerThreshold && _amount <= tier3.higherThreshold) {
            return tier3;
        }
        if (_amount >= tier4.lowerThreshold) {
            return tier4;
        }
        return tier1;
    }

    function _calculateFeeFromTier(TransferFee memory _tier) private pure returns (uint256) {
        return _tier.fee;
    }

    function safeAdd(uint256 _currentAmount, uint256 _amountToBeAdded) internal view returns (uint256) {
        uint256 _allowedAmount = MAXUINT - _currentAmount;
        if (_amountToBeAdded <= _allowedAmount) {
            return _currentAmount + _amountToBeAdded;
        }
        return _currentAmount;
    }
}
