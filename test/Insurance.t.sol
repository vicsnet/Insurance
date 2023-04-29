// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Insurance/Policy.sol";

contract InsuranceTest is Test {
    NewCoverage public newCoverage;
    address Owner = 0x661Be0562b31E9E8DdC2A7c93803005A1C71D749;
    address Admin = 0x23eBA962AC256e4BDfEb926c438AD33f96a68042;
    address user = 0x64b6eBE0A55244f09dFb1e46Fe59b74Ab94F8BE1;
    address user2 = 0x99C9fc46f92E8a1c0deC1b1747d010903E884bE1;
    string[] agreement = ["30% deductible", "Abc"];

    function setUp() public {
        newCoverage = new NewCoverage();
    }

    function test_registerAdmin() public {
        newCoverage.registerAdmin(Admin);
        newCoverage.setDAOFee(0.5 ether);
    }

    function test_Misc() public {
        test_registerAdmin();

        newCoverage.showAdmins();
        newCoverage.verifyAdmin(Admin);
    }

    uint[] age = [45, 50, 64];

    function test_Misc2() public {
        test_registerAdmin();
        test_Misc();

        // agreement.push("30% deductible");
        string memory policyOffer = "Single";
        vm.prank(Admin);
        newCoverage.createInsurancePolicy(
            "Evergreen Insure",
            policyOffer,
            agreement,
            1 weeks,
            8 weeks
        );

        vm.prank(user);
        newCoverage.registerPolicy(
            40,
            20,
            1,
            age,
            true,
            true,
            "Adeyemi Samuel"
        );
    }

    function test_Misc3() public {
        test_registerAdmin();
        test_Misc();
        test_Misc2();

        vm.prank(user);
        uint premium = newCoverage.generateHealthPolicy(
            40,
            1 weeks,
            32 weeks,
            20000
        );
        console.log(premium);
    }
}
