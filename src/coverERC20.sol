// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract coverERC20 is ERC20 {
    address Admin;
    uint256 decimal = 1e18;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) {
        Admin = msg.sender;
    }

    function mint(address to, uint256 _amount) public {
        uint256 amount = _amount * decimal;
        _mint(to, amount);
    }
}
