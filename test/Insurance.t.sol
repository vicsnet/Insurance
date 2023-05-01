// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Insurance/Policy.sol";
import "../src/CoverERC20.sol";
// import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";


contract InsuranceTest is Test {
    NewCoverage public newCoverage;
    CoverERC20 public DAOToken;
    address Owner = 0x661Be0562b31E9E8DdC2A7c93803005A1C71D749;
    address Admin = 0x23eBA962AC256e4BDfEb926c438AD33f96a68042;
    address user = 0x64b6eBE0A55244f09dFb1e46Fe59b74Ab94F8BE1;
    address Admin2 = 0x99C9fc46f92E8a1c0deC1b1747d010903E884bE1;
    address Admin3 = 0xC01D06A33b1EDA12B02BbDe35bec6F8d4d6E06e3;
    address Admin4 = 0xc6d123c51c7122d0b23e8B6ff7eC10839677684d;
    string[] agreement = ["30% deductible", "Abc"];
    string[] policyOffer = ["Single", "Family"];

    function setUp() public {
        newCoverage = new NewCoverage();
        DAOToken = new CoverERC20('Neon', 'Neon');
        DAOToken.mint(address(newCoverage), 10_000_000);
    }

    // function test_registerAdmin() public {
    //     newCoverage.registerAdmin(Admin);
    //     newCoverage.registerAdmin(Admin2);
    //     newCoverage.registerAdmin(Admin3);
    //     newCoverage.registerAdmin(Admin4);
    //     newCoverage.registerAdmin(Owner);
    //     newCoverage.setDAOFee(0.5 ether);
    // }

    // function test_Misc() public {
    //     test_registerAdmin();

    //     newCoverage.showAdmins();
    //     newCoverage.verifyAdmin(Admin);
    // }

    uint[] age = [45];

    // function test_Misc2() public {
    //     test_registerAdmin();
    //     test_Misc();

    //     vm.prank(Admin);
    //     newCoverage.createInsurancePolicy(
    //         "Evergreen Insure",
    //         policyOffer,
    //         agreement,
    //         1 weeks,
    //         8 weeks
    //     );

    //     vm.prank(user);
    //     newCoverage.registerPolicy(
    //         40,
    //         20,
    //         1,
    //         age,
    //         true,
    //         true,
    //         "Adeyemi Samuel"
    //     );
    // }

    // function test_Misc3() public {
    //     test_registerAdmin();
    //     test_Misc();
    //     test_Misc2();

    //     vm.prank(user);
    //     uint premium = newCoverage.generateHealthPolicy(
    //         40,
    //         1 weeks,
    //         52 weeks,
    //         150000
    //     );
    //     // console.log(premium);

    //     vm.prank(user);
    //     newCoverage.claimHealthPolicy(true, 15000, 40);
    // }

    function test_Misc4() public {
        // test_registerAdmin();
        // test_Misc();
        // test_Misc2();
        // test_Misc3();
        newCoverage.registerAdmin(Admin);
        newCoverage.registerAdmin(Admin2);
        newCoverage.registerAdmin(Admin3);
        newCoverage.registerAdmin(Admin4);
        newCoverage.registerAdmin(Owner);
        newCoverage.setDAOFee(100_000);

        // vm.deal(user, 20 ether);
        // vm.prank(user);
        // newCoverage.buyToken{value:10 ether}(100_000, NEON);

        DAOToken.mint(user, 500_000);

        vm.startPrank(user);
        DAOToken.approve(address(newCoverage), 100_000);
        newCoverage.joinDAO(100_000, address(DAOToken));
        newCoverage.showAdmins();

        vm.stopPrank();

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

        vm.prank(user);
        uint premium = newCoverage.generateHealthPolicy(
            40,
            1 weeks,
            52 weeks,
            15000000
        );
        // console.log(premium);
        
        vm.startPrank(user);
        DAOToken.approve(address(newCoverage), 150_000_00);
        newCoverage.payInsurance(15000000, 40, address(DAOToken));
        vm.stopPrank();

        vm.prank(user);
        newCoverage.claimHealthPolicy(true, 5000000, 40);

        vm.prank(user);
        newCoverage.getPolicyPurchases();
        newCoverage.getAllPurchase();

        vm.prank(Admin);
        newCoverage.validateClaim(40, user, true);
        vm.prank(Admin2);
        newCoverage.validateClaim(40, user, true);
        vm.prank(Admin3);
        newCoverage.validateClaim(40, user, false);
        vm.prank(Admin4);
        newCoverage.validateClaim(40, user, true);
        vm.prank(Owner);
        newCoverage.validateClaim(40, user, true);

        vm.prank(user);
        uint dedux = newCoverage.ClaimReward(40, address(DAOToken));
        console.log(dedux);

        // newCoverage.validateClaim(40, msg.sender, false);
        // newCoverage.validateClaim(40, msg.sender, false);
        // newCoverage.validateClaim(40, msg.sender, true);
        // newCoverage.validateClaim(40, msg.sender, false);
        // newCoverage.validateClaim(40, msg.sender, false);
        // vm.prank(user);
        // bool votesPerc = newCoverage.ValidateClaimStatus(40);

        vm.prank(Admin);
        newCoverage.createProposal(
            "To ban Femi from eating semo",
            20
        );

        vm.prank(Admin);
        newCoverage.vote(1, false);
        vm.startPrank(Admin2);
        // vm.warp(4 weeks);
        newCoverage.vote( 1, true);
        vm.stopPrank();
        vm.prank(Admin3);
        newCoverage.vote( 1, false);
        vm.prank(Admin4);
        newCoverage.vote( 1, false);
        vm.prank(Owner);
        newCoverage.vote( 1, true);

        newCoverage.showVoteRecords(1);
       
    }
}
