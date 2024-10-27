// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
//import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";


contract BridgedOmniToken is ERC20 {
    uint8 public tokenDecimals;
    address public omnifyAddress;
    constructor(
        address _omnifyAddress,
        string memory _tokenName,
        string memory _tokenSymbol,
        uint8 _tokenDecimals
    ) ERC20(_tokenName, _tokenSymbol) {
        omnifyAddress = _omnifyAddress;
        tokenDecimals = _tokenDecimals;
    }

    function changeOmnifyAddress(address newAddress) external{
        require(msg.sender == omnifyAddress);
        require(omnifyAddress != newAddress);
        omnifyAddress = newAddress;
    }

    function decimals() public view override returns (uint8) {
        return tokenDecimals;
    }

    function burnSenderTokens(address _sender, uint _amount) external {
        require(msg.sender == omnifyAddress);
        _burn(_sender, _amount);
    }

    function mint(address _recipient, uint _amount) external {
        require(msg.sender == omnifyAddress);
        _mint(_recipient, _amount);
    }

//    function balanceOf(address account) public view override returns (uint256) {
//        return _balances[account];
//    }
}