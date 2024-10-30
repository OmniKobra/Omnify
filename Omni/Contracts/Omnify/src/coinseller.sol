// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ownable.sol";
import "./ierc20.sol";
import "./IOmnify.sol";

contract Coinseller is Ownable {
    constructor(
        address _omnifyAddress,
        address _omnicoinAddress,
        uint256 _pricePerCoin,
        uint256 _unlockDuration,
        uint256 _icoDuration
    ) Ownable(msg.sender) {
        omnifyAddress = _omnifyAddress;
        omnicoinAddress = _omnicoinAddress;
        pricePerCoin = _pricePerCoin;
        unlockDuration = _unlockDuration;
        icoDuration = _icoDuration;
    }

    address public omnifyAddress;
    address public omnicoinAddress;
    uint256 public availableCoins;
    uint256 public soldCoins;
    uint256 public pricePerCoin;
    uint256 public dateOffered;
    uint256 public unlockDuration;
    uint256 public icoDuration;
    uint256 public endDate;

    function setUnlockDuration(uint256 newDuration) external onlyOwner {
        unlockDuration = newDuration;
    }

    function setIcoDuration(uint256 nd) external onlyOwner {
        icoDuration = nd;
    }

    function setOmnicoinAddress(address _omniAddress) external onlyOwner {
        omnicoinAddress = _omniAddress;
    }

    function offerCoins(uint256 amount) external onlyOwner {
        MYIERC20 omnicoin = MYIERC20(omnicoinAddress);
        bool success = omnicoin.transferFrom(owner(), address(this), amount);
        require(success);
        availableCoins += amount;
        dateOffered = block.timestamp;
        uint256 unlockDate = dateOffered + unlockDuration;
        endDate = unlockDate + icoDuration;
    }

    function buyCoins(uint256 want) external payable {
        require(dateOffered + unlockDuration <= block.timestamp);
        require(endDate > block.timestamp);
        require(want > 0);
        require(availableCoins >= want);
        uint256 cost = want * pricePerCoin;
        require(msg.value == cost);
        MYIERC20 omnicoin = MYIERC20(omnicoinAddress);
        bool success = omnicoin.transfer(msg.sender, want);
        require(success);
        IOmnify omnify = IOmnify(omnifyAddress);
        omnify.addProfitsFromExternalContract{value: cost}();
        soldCoins += want;
        availableCoins -= want;
    }

    function withdrawLeftovers() external onlyOwner {
        require(availableCoins > 0);
        MYIERC20 omnicoin = MYIERC20(omnicoinAddress);
        bool success = omnicoin.transfer(owner(), availableCoins);
        require(success);
        availableCoins = 0;
    }
}
