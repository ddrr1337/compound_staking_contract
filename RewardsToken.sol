// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardsToken is ERC20,Ownable {

    address public allowedMinter;

    modifier onlyAllowedMinter() {
        require(msg.sender == allowedMinter, "Only alowed minter can call this function");
        _; 
    }

    constructor() ERC20("RewardsToken", "RTK") {
        // Starting some initial supply
        _mint(msg.sender, 1000000 * 10 ** uint(decimals()));
    }

    function setAllowedMinter(address _allowedMinter) external onlyOwner {
        require(allowedMinter == address(0),'allowedMinter is already setted');

        allowedMinter = _allowedMinter;
    }

    function mint(address to, uint256 amount) external onlyAllowedMinter {
        _mint(to,amount);
    }

}
