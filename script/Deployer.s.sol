// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Insurance/Policy.sol";
import "../src/Insurance/Pricefeed.sol";
import "../src/CoverERC20.sol";

contract DeployerScript is Script {
    NewCoverage public newCoverage;
    CoverERC20 public DAOToken;
    PriceConsumerV3 public priceConsumerV3;

    function setUp() public {}

    function run() public {
        address deployer = 0xc6d123c51c7122d0b23e8B6ff7eC10839677684d;
        address Admin = 0x49207A3567EF6bdD0bbEc88e94206f1cf53c5AfC;
        address Admin2 = 0x99C9fc46f92E8a1c0deC1b1747d010903E884bE1;
        address Admin3 = 0xC01D06A33b1EDA12B02BbDe35bec6F8d4d6E06e3;
        address user = 0xBd032b770f364605BfE8D16E27ae4D241b9061c8;
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        uint256 eventAdminKey = vm.envUint("PRIVATE_KEY3");
        uint256 userKey = vm.envUint("PRIVATE_KEY4");

        vm.startBroadcast(deployerKey);
        newCoverage = new NewCoverage();
        DAOToken = new CoverERC20("Neon", "Neon");
        priceConsumerV3 = new PriceConsumerV3();
        DAOToken.mint(address(newCoverage), 10_000_000);

        newCoverage.registerAdmin(Admin);
        newCoverage.registerAdmin(Admin2);
        newCoverage.setDAOFee(100_000);
        DAOToken.mint(user, 500_000);
        vm.stopBroadcast();

        vm.startBroadcast(userKey);
        DAOToken.approve(address(newCoverage), 100_000);
        newCoverage.joinDAO(100_000, address(DAOToken));
        vm.stopBroadcast();

    }
}
