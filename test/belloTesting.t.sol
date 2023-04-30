// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/Insurance/Policy.sol";

contract PolicyTest is Test {
    NewCoverage public policy;
    address owner = 0x154421b5abFd5FC12b16715E91d564AA47c8DDee;
    address admin = 0x1CCFe3B61eE85a40dB552A2B0c6BDcF4aE9B4278;
    address anotherAdmin = 0x362923F694243E2d8d2BE4c70b6d2b463B2f6836;
    address yetAnotherAdmin =0x362923F694243E2d8d2BE4c70b6d2b463B2f6836;
    address buyer = 0xA6C6D11907D116308cF81C5d8d41A52E8BD7fE20;
    address buyer1 = 0xAFD91fbf0a7297577e90e56dC17bbe452587350B;
    string[] agreement = ["100percent deductible", "I love the policy"];
    string[] policyOffer = ["Collision", "PIP", "Comprehensive"];
    uint[] age = [21, 43, 52];

    function setUp() public {
        policy = new NewCoverage();
    }

    
    function testRegisterAdmin() public {
        policy.registerAdmin(owner);
        policy.registerAdmin(anotherAdmin);
        policy.registerAdmin(yetAnotherAdmin);
        policy.setDAOFee(0.5 ether);
        policy.showAdmins();

        vm.prank(owner);

        policy.createInsurancePolicy("Collision Cover", agreement, policyOffer, 2 days, 7 days);
        policy.registerPolicy(1, 10, 3, age, false, false, "Agbabiaka");
        policy.generateHealthPolicy(1, 1day, 3day, 7 ETH);
    }


//    function makeAddr(string memory name) internal returns(address addr);



    /*
        function setUp() public {
            ticketFactory = new TicketFactory(Controller);
        }

        function test_CreateID() public {
            vm.prank(Controller);
            ticketFactory.createID(300,eventAdmin);
            vm.prank(Controller);
            ticketFactory.createID(500,eventAdmin);
        }

        function test_createEvent() public {
            test_CreateID();
            vm.startPrank(eventAdmin);
            // address event1 = ticketFactory.createEvent(
            //     200,
            //     0,
            //     60,
            //     "https://ipfs.io/ipfs/QmX84bZL51sJ4g4M8XoWQnBWQJ4Fh1TbT8TgfW2yyfNft",
            //     "Musika",
            //     "MSKA",
            //     "MusikaFlex",
            //     "mFlex"
            // );

            (address newPoap, address newEvent) = ticketFactory.createEvent(
                300,
                2 ether,
                50,
                "https://ipfs.io/ipfs/QmX84bZL51sJ4g4M8XoWQnBWQJ4Fh1TbT8TgfW2yyfNft",
                "Musika",
                "MSKA",
                "MusikaFlex",
                "mFlex"
            );

            vm.stopPrank();

            ticketFactory.checkEventId(newEvent);
            ticketFactory.showTotalEventAddresses();
            // ticketFactory.returnTotalNoOfEvents();
        }
            address[] attenders = [0x5D319012daEA8Fa10BbE8eBe79E4572988ecf0Ab,0x6ED60d1b94b0bB67DcA1c3e69b4Ee2F2eF10136F];

        function test_ticketContract() public {
            test_CreateID();
            vm.startPrank(eventAdmin);
                (address newPoap, address newEvent) = ticketFactory.createEvent(
                500,
                2 ether,
                50,
                "https://ipfs.io/ipfs/QmX84bZL51sJ4g4M8XoWQnBWQJ4Fh1TbT8TgfW2yyfNft",
                "Musika",
                "MSKA",
                "MusikaFlex",
                "mFlex"
            );

            ITicketing(newEvent).startRegistration(1 minutes, 5 minutes);

            vm.stopPrank();
    
            address user = 0x5D319012daEA8Fa10BbE8eBe79E4572988ecf0Ab;
            address user2 = 0x6ED60d1b94b0bB67DcA1c3e69b4Ee2F2eF10136F;
            address whisperer = 0xFA5f9EAa65FFb2A75de092eB7f3fc84FC86B5b18;
            vm.deal(user, 10 ether);
            vm.deal(user2, 50 ether);
            vm.deal(whisperer, 5 ether);

            vm.prank(user);
            ITicketing(newEvent).register{value: 2 ether}();

            vm.prank(user2);
            ITicketing(newEvent).register{value: 2 ether}();

            vm.startPrank(eventAdmin);
            ITicketing(newEvent).endRegistration();
            ITicketing(newEvent).setAttenders(attenders);
            ITicketing(newEvent).setPoapUri_Addr("https://ipfs.io/ipfs/QmX84bZL51sJ4g4M8XoWQnBWQJ4Fh1TbT8TgfW2yyfNft", address(newPoap));

            ITicketing(newEvent).withdrawEthEventAdmin(1.9 ether);
            vm.stopPrank();

            // vm.prank(Controller);
            // ITicketing(newEvent).withdraw(0.1 ether, user);

            vm.prank(user);
            ITicketing(newEvent).claimAttendanceToken();
            vm.prank(user2);
            ITicketing(newEvent).claimAttendanceToken();
            ITicketing(newEvent).EthBalanceOfOrganizer();
            // ticketFactory.showPoaps();

        }
    }
    
    */

}