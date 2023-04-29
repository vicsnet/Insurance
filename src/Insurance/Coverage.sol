// // // SPDX-License_Identifier: MIT

// pragma solidity ^0.8.13;
// import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
// import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";

// contract Cover is AccessControl, Ownable {
    
    
//     uint256 insureId;
//     uint256 private constant MINIMUM_POLICY_DURATION = 1 weeks; // minimum period in which insurance covers
//     uint256 private constant MAXIMUM_POLICY_DURATION = 365 days; // maximum period in which insurance covers
//     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
//     bytes32 public constant MAJOR_ADMIN = keccak256("MAJOR_ADMIN");
//     // Struct to create Insurance Policy

//     ///////     EVENTS      ///////////


//     struct InsurancePolicy {
//         //uint policyId; //for tracking each policy
//         string PolicyName; //insurance Name
//         bool PolicyActive; //is this Policy still Active
//         bytes Agreement;
//         bytes PolicyOffer; //determine the type of Policy to buy
//         uint MinimumPeriod; // minimum period in which insurance covers in days
//         uint MaximumPeriod; // maximum period in days
//     }

// // struct to track when subscribers apply for claim
//     struct ClaimDetails{
//         uint256 AmountApplied;
//         string Event;
//     }

//     // Struct to purchase Insurance Policy
//     struct PolicyPurchase {
//         uint InsureId;
//         uint PercentageToCover; //percentage of premium to buy which determine deductible
//         uint StartTime; //when deductible start
//         uint EndTime; //when deductible ends in weeks
//         uint deductible; //percentage of deductible
//         uint AmountPaid; //premium to pay or paid
//         uint FamilyNo; //no in family
//         uint age; //
//         uint CoverageAmount; //the amount you want the insurance policy to cover
//         uint[] Ages; //Ages of the people in family
//         string FamilyName; //The Family Name
//         string PolicyCovered; // for health Purpose single, Extended family, Family
//         string[] Gender; //members gender
//         string[] prescription; //on any prescription
//         bytes FamilyHospital;
//         bool FamilyHealthStatus; //the status of health includin allergy
//         bool Claim; //has insurance claim been filed this should be enum
//         bool paid; //Insurance policy paid
//         string policyCovered;
//         bool Smoke;
//     }
//     enum ClaimProcess {
//         item1,
//         item2
//     }

//     mapping(uint => InsurancePolicy) public insurePolicy;
//     mapping(address => mapping(uint => PolicyPurchase)) public policyBought;
//     mapping(address => ClaimDetails) public userClaimDetails;

//     InsurancePolicy[] public arrayPolicy;
//     address[] public admins;

//     // constructor() {
//     //     Admin = msg.sender;
//     // }

//     // Register Admin
//     function registerAdmin(address _newAdmin) external onlyOwner {
//         if (_newAdmin == address(0x0)) revert("ADDRESS_ZERO_REVERTED");
//         _setupRole(ADMIN_ROLE, _newAdmin);
//         admins.push(_newAdmin);
//     }

//     function showAdmins() external view returns (address[] memory) {
//         return admins;
//     }

//     function verifyAdmin(address _admin) internal view returns (bool) {
//         return hasRole(ADMIN_ROLE, _admin);
//     }

//     // create an insurance policy
//     // Only chosen Admin can create Insurance Policy
//     function createInsurancePolicy(
//         string memory _policyName,
//         string[] memory _agreement,
//         string[] memory _policyOffer,
//         uint _minimumPeriod,
//         uint _maximumPeriod
//     ) external onlyRole(ADMIN_ROLE) {
//         if (_minimumPeriod < MAXIMUM_POLICY_DURATION) revert();
//         if (_maximumPeriod > MAXIMUM_POLICY_DURATION) revert();
//         insureId += 1;

//         InsurancePolicy storage createPolicy = insurePolicy[insureId];
//         createPolicy.PolicyName = _policyName;
//         createPolicy.PolicyActive = true;
//         createPolicy.Agreement = abi.encode(_agreement);
//         createPolicy.PolicyOffer = abi.encode(_policyOffer);
//         createPolicy.MinimumPeriod = _minimumPeriod;
//         createPolicy.MaximumPeriod = _maximumPeriod;

//         InsurancePolicy memory newPolicy = InsurancePolicy({
//             PolicyName: _policyName,
//             PolicyActive: true,
//             Agreement: abi.encode(_agreement),
//             PolicyOffer: abi.encode(_policyOffer),
//             MinimumPeriod: _minimumPeriod,
//             MaximumPeriod: _maximumPeriod
//         });
//         arrayPolicy.push(newPolicy);
//     }

//     // buy Automobile policy

//     // Age: 40%
//     // Gender: 10%
//     // BMI: 20%
//     // Smoking status: 20%
//     // Family history: 10%
//     //buy Health Policy
//     function buyHealth(
//         string calldata _familyName,
//         uint _amount,
//         uint _insureId,
//         uint _endTime,
//         uint _coverage,
//         string memory _policyCovered,
//         uint[] calldata _age,
//         string[] calldata _gender,
//         uint _familyNo,
//         bool _familyHealthStatus,
//         string[] memory _prescription,
//         string memory _familyHospitalName,
//         uint _coverageAmount,
//         bool _smoke
//     ) external returns (uint deductible) {
//         uint presentTime = block.timestamp;
//         uint maxTime = insurePolicy[_insureId].MaximumPeriod;
//         uint _coveragePeriod = presentTime + _endTime;

//         if ((presentTime + _endTime) > maxTime) revert();

//         // for gender everyone has 10%
//         // for BMI everyone has 20%
//         // for smoking status 20%
//         // for Age 40%

//         uint riskFactor;
//         uint timeFactor = (_coveragePeriod / maxTime) * 1;
//         uint _premium;
//         deductible;

//         bytes memory _hospitalName = abi.encode(_familyHospitalName);
//         PolicyPurchase storage newPolicy = policyBought[msg.sender][_insureId];
//         newPolicy.InsureId = _insureId;
//         newPolicy.PercentageToCover = _coverage;
//         newPolicy.StartTime = presentTime;
//         newPolicy.EndTime = presentTime + _endTime;
//         newPolicy.AmountPaid = _amount;
//         newPolicy.FamilyNo = _familyNo;
//         newPolicy.Ages = _age;
//         newPolicy.FamilyName = _familyName;
//         newPolicy.PolicyCoverd = _policyCovered;
//         newPolicy.FamilyHealthStatus = _familyHealthStatus;
//         newPolicy.prescription = _prescription;
//         newPolicy.FamilyHospital = _hospitalName;
//         newPolicy.Gender = _gender;
//         newPolicy.CoverageAmount = _coverageAmount;
//         newPolicy.Smoke = _smoke;
//     }

//     //claim Automobile insurance
//     function buyAutoInsurance(
//         string calldata _name,
//         uint _insureId,
//         uint _startTime,
//         uint _endTime,
//         uint _coverage,
//         uint _coverageAmount,
//         uint calldata _age,
//         string calldata _policyCovered
//     ) external returns (uint deductible) {
//         policyBought storage policy = policyBought[msg.sender][_insureId];

//         bytes32 zerohash = keccak256("");
//         uint presentTime = block.timestamp;
//         uint maxTime = insurePolicy[_insureId].MaximumPeriod;
//         if ((presentTime + _endTime) > maxTime)
//             revert("Time exceeds max coverage period for policy");
//         if (keccak256(_name) == zerohash) revert("Name cannot be blank");
//         if (keccak256(_policyCovered) == zerohash)
//             revert("Policy covered cannot be blank");
//         if(_startTime < presentTime) revert("Time already past");
//         if(_coverage <= 0) revert("Invalid coverage amount");
//         if(_coverageAmount <= 0) revert("Invalid coverage amount");
//         if(_age < 18 years) revert("Age is 18 years minimum");

//         // payment

//         policy.FamilyName = _name;
//         policy.policy.startTime = _startTime;
//         policy.EndTime = _endTime;
//         policy.CoverageAmount = _coverageAmount;
//         policy.PercentageToCover = _coverage;
//         policy.age = _age;
//         policy.policyCovered = _policyCovered;

// //         uint256 riskFactor = ((ageSum) * ageFactor) +
// //             genderFactor +
// //             BMIFactor +
// //             smokingFactor +
// //             familyHealthFactor;
// //         uint timeFactor = (_coveragPeriod / maxTime) * 1;
// //         uint _premium = (_coverageAmount * riskFactor) +
// //             determineAmount +
// //             (timeFactor * _coverageAmount);

//     }

//     // claim Health Insurance
//     // if claim is once rejected you have to pay to resubmit claim
//     function claimAutoInsurance(uint _insureId, uint256 _amount, string calldata _event ) external {
//         policyBought storage policy = policyBought[msg.sender][_insureId];

//         if(policy.deductible <= 0) revert("Deductible payment not on record");
        
//         uint256 totalSub = policy.CoverageAmount;
//         userClaimDetails[msg.sender].AmountApplied = _amount;
//         userClaimDetails[msg.sender].Event = _event;
//     }

//     // vote for a claim

//     // Check if claim is Succesful or rejected
//     function checkClaimResult() external view returns(bool){

//     }

//     //edit Insurance Policy

// //cancel insurance Policy


//     // Become an Investor

//     // create Proposal

//     // vote for a proposal

//     // Distribute Investors money according to investment
// }
