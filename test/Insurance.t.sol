// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Insurance/Policy.sol";

contract InsuranceTest is Test {
    NewCoverage public newCoverage;

    function setUp() public {
        newCoverage = new NewCoverage();
    }

    
}
