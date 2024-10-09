// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

interface IOmnify1 {
    function setCoinsReceivedDate(address _recipient) external;
}

contract OmniCoin is ERC20 {
    address public omnifyAddress;

    constructor(address _omnifyAddress) ERC20("Omnify Coin", "OFY") {
        omnifyAddress = _omnifyAddress;
        _mint(msg.sender, 250000);
        IOmnify1 omnifyContract = IOmnify1(_omnifyAddress);
    }

    function decimals() public view override returns (uint8) {
        return 0;
    }

    function changeOmnifyAddress(address newAddress) external {
        require(msg.sender == omnifyAddress);
        require(omnifyAddress != newAddress);
        omnifyAddress = newAddress;
    }

    function remintBurntCoins(address _recipient) external {
        require(msg.sender == omnifyAddress);
        uint supply = totalSupply();
        uint difference = 250000 - supply;
        require(difference > 0);
        _mint(_recipient, difference);
    }

    function transfer(
        address to,
        uint256 value
    ) public override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        IOmnify1 omnifyContract = IOmnify1(omnifyAddress);
        omnifyContract.setCoinsReceivedDate(to);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        IOmnify1 omnifyContract = IOmnify1(omnifyAddress);
        omnifyContract.setCoinsReceivedDate(to);
        return true;
    }
}