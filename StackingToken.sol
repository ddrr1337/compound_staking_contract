// SPDX-License-Identifier: MIT

// this is just a basic implementation of any ERC20 for testing.
// If you want to reward users for providing liquidity, you need to use as stackingToken
// the token LP you recibe to provide liquidity in a Uniswap V2 contract.

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";



contract StackingToken is ERC20 {
    constructor() ERC20("StackingToken", "STK") {
        _mint(msg.sender, 1000000 * 10 ** uint(decimals()));
    }
}
