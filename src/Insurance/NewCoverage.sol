// // SPDX-License_Identifier: MIT

// pragma solidity ^0.8.13;
// import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
// import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";

// contract NewCoverage is AccessControl, Ownable {
//     uint256 insureId;
//     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
//     bytes32 public constant MAJOR_ADMIN = keccak256("MAJOR_ADMIN");
//     struct InsurancePolicy {
//         string PolicyName; //insurance Name
//         bool PolicyActive; //is this Policy still Active
//         bytes Agreement;
//         bytes PolicyOffer; //determine the type of Policy to buy
//         uint MinimumPeriod; // minimum period in which insurance covers in days
//         uint MaximumPeriod; // maximum period in days
//     }

//     struct PolicyPurchase {
//         uint InsureId;
//         uint PercentageToCover; 
//         uint StartTime; 
//         uint EndTime; 
//         uint deductible; 
//         uint AmountPaid; 
//         uint CoverageAmount; 
//         string FamilyName; 
      
//         bool Claim; 
//         bool paid;
//         HealthDetail detailsOfhealth;
//     }
 

//     struct HealthDetail {
//         bool Smoke;
//         string[] Gender;
//         string[] prescription;
//         bytes FamilyHospital;
//         bool FamilyHealthStatus;
//         string PolicyCoverd;
//         uint FamilyNo;
//     }
//         mapping(uint => InsurancePolicy) public insurePolicy;
//     mapping(address => mapping(uint => PolicyPurchase)) public policyBought;

//     InsurancePolicy[] public arrayPolicy;
//     address[] public admins;

//         function registerAdmin(address _newAdmin) external onlyOwner {
//         if (_newAdmin == address(0x0)) revert("ADDRESS_ZERO_REVERTED");
//         _setupRole(ADMIN_ROLE, _newAdmin);
//         admins.push(_newAdmin);
//     }
//         function showAdmins() external view returns (address[] memory) {
//         return admins;
//     }

//     function verifyAdmin(address _admin) internal view returns (bool) {
//         return hasRole(ADMIN_ROLE, _admin);
//     }

//     function createInsurancePolicy(
//         string memory _policyName,
//         string[] memory _agreement,
//         string[] memory _policyOffer,
//         uint _minimumPeriod,
//         uint _maximumPeriod
//     ) external onlyRole(ADMIN_ROLE) {
//         // if (_minimumPeriod < MAXIMUM_POLICY_DURATION) revert();
//         // if (_maximumPeriod > MAXIMUM_POLICY_DURATION) revert();
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

// function registerInsurance(uint _insureId, uint _percentageToCover, uint _familyName, string[] memory _gender, bool _familyHealthStatus) public{

// PolicyPurchase storage newPolicy = policyBought[msg.sender][_insureId];

// }
//     function InsureHealth(uint _insureId, uint _startTime, uint _endTime, uint _coverage, uint[] memory _age, uint _coverageAmount, bool _familyHealthStatus, bool _smoke) public {

// uint id = _insureId;
// uint time = _startTime;
// uint cover =_coverageAmount;
// uint end = _endTime;
// if((block.timestamp + _endTime > insurePolicy[id].MaximumPeriod)) revert();
//  uint deductible = cover * uint(_coverage * 1/ 100);
 
//         uint256 ageSum = 0;
//         for (uint i = 0; i < _age.length; i++) {
//             ageSum += _age[i];
//         }
//         uint ageFactor = uint256(40 * 1) / 100;
//         uint genderFactor = uint256(10 * 1) / 100;
//         uint BMIFactor = uint256(20 * 1) / 100;
//         uint smokingFactor;
//         uint familyHealthFactor;
//              if (_smoke == true) {
//             uint smoke_factor = uint256(1 * 20) / 100;
//             smokingFactor = smoke_factor;
//         }
//         if (_smoke == false) {
//             uint smoke_factor = uint256(0 * 20) / 100;
//             smokingFactor = smoke_factor;
//         }

//         if (_familyHealthStatus == true) {
//             uint _healthFactor = uint256(1 * 10) / 100;
//             familyHealthFactor = _healthFactor;
//         }
//         if (_familyHealthStatus == false) {
//             uint _healthFactor = uint256(1 * 10) / 100;
//             familyHealthFactor = _healthFactor;
//         }
// uint presentTime = block.timestamp + time + end;
//          uint256 riskFactor = ((ageSum) * ageFactor) +
//             genderFactor +
//             BMIFactor +
//             smokingFactor +
//             familyHealthFactor;
//         uint timeFactor = (presentTime / 365 days) * 1;

// uint premium = calculatePremium(cover, riskFactor, deductible, timeFactor);
//   saveToInsurance(id,  _coverage, time,  presentTime, premium);

//     }

//     function calculatePremium(uint _coverageAmount, uint _riskFactor, uint _deductible, uint _timeFactor) internal pure returns(uint){ 
//          uint _premium = (_coverageAmount * _riskFactor) +
//            _deductible +
//             (_timeFactor * _coverageAmount);
//     //          PolicyPurchase storage newPolicy = policyBought[msg.sender][_insureId];
//     // newPolicy.InsureId = _insureId;
//     // newPolicy.PercentageToCover = _coverage;
//     // newPolicy.StartTime = block.timestamp + _startTime;
//     // newPolicy.EndTime = presentTime;
//     // newPolicy.AmountPaid = _premium;
  
//             return _premium;
//     }
//     function saveToInsurance(uint _insureId, uint _coverage, uint _startTime, uint presentTime, uint premium) internal{
//          PolicyPurchase storage newPolicy = policyBought[msg.sender][_insureId];
//     newPolicy.InsureId = _insureId;
//     newPolicy.PercentageToCover = _coverage;
//     newPolicy.StartTime = block.timestamp + _startTime;
//     newPolicy.EndTime = presentTime;
//     newPolicy.AmountPaid = premium;

//          newPolicy.PercentageToCover =_coverage;
        
//     }

//     function saveToInsurance(uint _insureId, uint _startTime, uint _endTime, uint _coverage, uint[] memory _age, uint _coverageAmount, bool _familyHealthStatus, bool _smoke) public {
//         InsureHealth(_insureId, _startTime,  _endTime,  _coverage,  _age,  _coverageAmount,  _familyHealthStatus,  _smoke);
//         PolicyPurchase storage newPolicy = policyBought[msg.sender][_insureId];
//         // newPolicy
//     }
// }
