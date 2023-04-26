
## HOW TO CONFIRM INSURER'S CLAIM OF ASSESTS ON EXCHANGES 

lookup the amount of assets  claimed by an insurer that he owned on exchanges when coming to the platform to purchase a cover for all those assets he claimed to own??? as it is very important for us to really confirm that he has and own  those assets he claimed to avoid fraudulent tarnsactions on the platform

### SOLUTION:::

One way to achieve this is to use an external data source or an oracle to verify the insurer's claims about their assets. The oracle can be programmed to fetch data from various exchanges and compare it with the assets claimed by the insurer. The oracle can then return the verified asset data to our platform, which can be used to calculate the premium for the cover.

there are two approach to this:::

### ONE:::


```solidity

    // let's say we use an oracle service such as Chainlink. we'll create a smart contract that interacts with the oracle and pass the insurer's claimed assets as input to the oracle. The oracle would then use its own APIs to retrieve the actual asset balances of the insurer on the exchanges and return them back to our smart contract. The smart contract can then use this data to calculate the appropriate premium to charge the insurer for the cover. as in:::


    import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

    contract Insurance {

        AggregatorV3Interface internal priceFeed;

        function getAssetPrice(string memory _assetSymbol) public view returns (int) {
        // create an instance of the price feed contract for the given asset symbol
        priceFeed = AggregatorV3Interface(getPriceFeedAddress(_assetSymbol));

        // get the latest price from the price feed contract
        (, int price, , , ) = priceFeed.latestRoundData();

        return price;
        }

        function calculatePremium(string[] memory _assets, uint[] memory _amounts) public view returns (uint) {
        uint totalValue = 0;

        // loop through each asset and calculate the total value
        for (uint i = 0; i < _assets.length; i++) {
          int price = getAssetPrice(_assets[i]);
          totalValue += uint(price * _amounts[i]);
        }

        // calculate the premium based on the total value and other risk factors
        uint premium = calculatePremiumLogic(totalValue, otherRiskFactors);

        return premium;
        }

        function getPriceFeedAddress(string memory _assetSymbol) private pure returns (address) {
        // return the address of the price feed contract for the given asset symbol
        // this could be hard-coded or retrieved from a registry
        }

        function calculatePremiumLogic(uint _totalValue, ...) private pure returns (uint) {
        // calculate the premium based on the total value and other risk factors
        }

    }

```

### ...............................................

### TWO:::


```solidity

    // the second solution using code logic, we can use APIs provided by the exchanges where the insurer has claimed to own assets. YWe would need to obtain API keys from the exchanges and use them to make API calls to retrieve the asset balances of the insurer. & then use this data to calculate the appropriate premium to charge the insurer for the cover. for instane :::

 // ========================================================

   <!-- import "https://github.com/provable-things/ethereum-api/blob/master/provableAPI_0.6.sol"; -->


    import "https://github.com/provable-things/ethereum-api/provableAPI.sol";


    ethereum-api/blob/master/provableAPI_0.6.sol

contract Insurance is usingProvable {

  mapping(string => uint) private exchangeAssets;
  
  function __callback(bytes32 _myid, string memory _result) public {
    require(msg.sender == provable_cbAddress());
    exchangeAssets["coinbase"] = parseInt(_result);
  }

  function getExchangeAssetBalance(string memory _exchange, string memory _asset, string memory _account) public payable {
    string memory apiUrl = getExchangeApiUrl(_exchange, _account);
    string memory apiEndpoint = getExchangeApiEndpoint(_exchange, _asset);
    string memory apiQuery = string(abi.encodePacked(apiUrl, apiEndpoint));
    provable_query("URL", apiQuery);
  }

  function calculatePremium(string[] memory _assets, uint[] memory _amounts) public view returns (uint) {
    uint totalValue = 0;
    
    // loop through each asset and calculate the total value
    for (uint i = 0; i < _assets.length
    ...

    //STILL THINKING...
  }
}

// ====================== OR ================================

// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

interface IExchange {
    function balanceOf(address _owner) external view returns (uint256);
}

contract InsurerVerification {
    function verifyAssets(address[] calldata _exchanges, address _insurer, uint256[] calldata _amounts) external view returns (bool) {
        uint256 totalClaimedAssets = 0;
        for (uint i = 0; i < _exchanges.length; i++) {
            uint256 balance = IExchange(_exchanges[i]).balanceOf(_insurer);
            totalClaimedAssets += balance;
            if (balance < _amounts[i]) {
                return false; // Insurer doesn't have enough assets on this exchange
            }
        }
        // Verify that the total claimed assets matches the sum of individual exchange balances
        return totalClaimedAssets == getSum(_amounts);
    }

    function getSum(uint256[] calldata _values) internal pure returns (uint256) {
        uint256 sum = 0;
        for (uint i = 0; i < _values.length; i++) {
            sum += _values[i];
        }
        return sum;
    }
}

```