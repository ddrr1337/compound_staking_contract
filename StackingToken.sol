// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StackingToken is ERC20 {
    constructor() ERC20("Tester", "TST") {
        // Inicializa el contrato con un total de 1 millón de tokens
        _mint(msg.sender, 1000000 * 10 ** uint(decimals()));
    }
}
