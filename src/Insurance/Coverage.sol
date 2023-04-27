// SPDX-License_Identifier: MIT

pragma solidity ^0.8.13;
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";


contract Cover{
uint256 insureId;
uint256 private constant MINIMUM_POLICY_DURATION = 1 weeks; // minimum period in which insurance covers
uint256 private constant MAXIMUM_POLICY_DURATION = 365 days; // maximum period in which insurance covers

// Struct to create Insurance Policy

    struct InsurancePolicy{
        string PolicyName; //insurance Name
        bool PolicyActive; //is this Policy still Active
        bytes Agreement;
        bytes PolicyOffer; //determine the type of Policy to buy 
        uint MinimumPeriod; // minimum period in which insurance covers
        uint MaximumPeriod; // maximum period
    }

    // Struct to purchase Insurance Policy
    struct PolicyPurchase{
        uint InsureId;
        uint PercentageToCover; //percentage of premium to buy which determine deductible
        uint startTime; //when deductible start
        uint EndTime;  //when deductible ends in weeks
        bool claim;
    }

    mapping(uint => InsurancePolicy) public insurePolicy;
    InsurancePolicy[] public arrayPolicy;
    mapping (address => mapping( uint => PolicyPurchase)) public  policyBought;



// Register Admin

// create an insurance policy
// Only chosen Admin can create Insurance Policy
function createInsurancePolicy(string memory _policyName, string [] memory _agreement, string[] memory _policyOffer, uint _minimumPeriod, uint _maximumPeriod) external{
        insureId +=1;

InsurancePolicy storage createPolicy = insurePolicy[insureId];
createPolicy.PolicyName = _policyName;
createPolicy.PolicyActive = true;
createPolicy.Agreement = abi.encode(_agreement);
createPolicy.PolicyOffer = abi.encode(_policyOffer);
createPolicy.MinimumPeriod = _minimumPeriod;
createPolicy.MaximumPeriod = _maximumPeriod;

    }


// buy Automobile policy

//buy Health Policy

//claim Automobile insurance

// claim Health Insurance
// if claim is once rejected you have to pay to resubmit claim

// vote for a claim

// Check if claim is Succesful or rejected



//edit Insurance Policy

//cancel insurance Policy


// Become an Investor

// create Proposal


// vote for a proposal


// Distribute Investors money according to investment 




}