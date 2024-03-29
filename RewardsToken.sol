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
        // this will be the initial supply needed to make all calculations in compound interest (initial capital)
    
        _mint(msg.sender, 1000000 * 10 ** uint(decimals()));
    }

    // Link ERC20 with stacking contract passing address of stacking contract deployment
    // This is needed to give permission to stacking contract to jmint tokens
    // Notice you can only call this function once.
    function setAllowedMinter(address _allowedMinter) external onlyOwner {
        require(allowedMinter == address(0),'allowedMinter is already setted');

        allowedMinter = _allowedMinter;
    }

    // you MUST have this function in your ERC20 implementation, otherwhise stacking contract
    // will fail to compile due mint function not found in this contract.
    function mint(address to, uint256 amount) external onlyAllowedMinter {
        _mint(to,amount);
    }

}
