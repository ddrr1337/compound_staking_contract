// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardsToken is ERC20,Ownable {

    address public allowedMinter;

    modifier onlyAllowedMinter() {
        require(msg.sender == allowedMinter, "Only alowed minter can call this function");
        _; // Esto indica al compilador que continúe con la ejecución de la función una vez que se haya verificado el modificador
    }

    constructor() ERC20("Tester", "TST") {
        // Inicializa el contrato con un total de 1 millón de tokens
        _mint(msg.sender, 1000000 * 10 ** uint(decimals()));
    }

    function setAllowedMinter() external onlyOwner {
        require(allowedMinter == address(0),'allowedMinter is already setted');
    }

    function mint(address to, uint256 amount) external onlyAllowedMinter {
        _mint(to,amount);
    }

}
