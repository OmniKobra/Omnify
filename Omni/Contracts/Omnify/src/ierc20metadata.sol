// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ierc20.sol";

interface MYIERC20Metadata is MYIERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}