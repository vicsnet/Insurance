// SPDX-License_Identifier: MIT

pragma solidity ^0.8.13;
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";

contract NewCoverage is AccessControl, Ownable {
    
    uint256 insureId;
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MAJOR_ADMIN = keccak256("MAJOR_ADMIN");
    
    struct InsurancePolicy {
        string PolicyName; //insurance Name
        bool PolicyActive; //is this Policy still Active
        bytes Agreement;
        bytes PolicyOffer; //determine the type of Policy to buy
        uint MinimumPeriod; // minimum period in which insurance covers in days
        uint MaximumPeriod; // maximum period in days
    }

    struct PolicyPurchase {
        uint256 InsureId;
        uint256 PercentageToCover;
        uint256 StartTime;
        uint256 EndTime;
        uint256 deductible;
        uint256 AmountPaid; //amount to be paid
        uint256 CoverageAmount; //amount to insure
        string FamilyName;
        bool Claim;
        bool paid;
        HealthDetail detailsOfhealth;
    }

    struct HealthDetail {
        bool Smoke;
        bool FamilyHealthStatus;
        string[] Gender;
        string[] prescription;
        uint[] age;
        bytes FamilyHospital;
        string PolicyCoverd;
        uint FamilyNo;
    }
    mapping(uint => InsurancePolicy) public insurePolicy;
    mapping(address => mapping(uint => PolicyPurchase)) public policyBought;

    InsurancePolicy[] public arrayPolicy;
    address[] public admins;

    function registerAdmin(address _newAdmin) external onlyOwner {
        if (_newAdmin == address(0x0)) revert("ADDRESS_ZERO_REVERTED");
        _setupRole(ADMIN_ROLE, _newAdmin);
        admins.push(_newAdmin);
    }

    function showAdmins() external view returns (address[] memory) {
        return admins;
    }

    function verifyAdmin(address _admin) internal view returns (bool) {
        return hasRole(ADMIN_ROLE, _admin);
    }

    function createInsurancePolicy(
        string memory _policyName,
        string[] memory _agreement,
        string[] memory _policyOffer,
        uint _minimumPeriod,
        uint _maximumPeriod
    ) external onlyRole(ADMIN_ROLE) {
        // if (_minimumPeriod < MAXIMUM_POLICY_DURATION) revert();
        // if (_maximumPeriod > MAXIMUM_POLICY_DURATION) revert();
        insureId += 1;

        InsurancePolicy storage createPolicy = insurePolicy[insureId];
        createPolicy.PolicyName = _policyName;
        createPolicy.PolicyActive = true;
        createPolicy.Agreement = abi.encode(_agreement);
        createPolicy.PolicyOffer = abi.encode(_policyOffer);
        createPolicy.MinimumPeriod = _minimumPeriod;
        createPolicy.MaximumPeriod = _maximumPeriod;

        // InsurancePolicy memory newPolicy = InsurancePolicy({
        //     PolicyName: _policyName,
        //     PolicyActive: true,
        //     Agreement: abi.encode(_agreement),
        //     PolicyOffer: abi.encode(_policyOffer),
        //     MinimumPeriod: _minimumPeriod,
        //     MaximumPeriod: _maximumPeriod
        // });  I DONT THINK WE NEED TO ASSIGN VALUES TO THE STRUCT TWICE

        arrayPolicy.push(newPolicy);
    }

    // register for the health policy
    function registerPolicy(
        uint _insureId,
        uint _percentageToCover,
        uint _familyNo,
        uint[] memory _age,

        bool _familyHealthStatus,
        bool _smoke,

        string memory _familyName
    ) public {
        PolicyPurchase storage newPolicy = policyBought[msg.sender][_insureId];
        newPolicy.InsureId = _insureId;
        newPolicy.PercentageToCover = _percentageToCover;
        newPolicy.detailsOfhealth.FamilyNo = _familyNo;
        newPolicy.detailsOfhealth.age = _age;
        newPolicy.detailsOfhealth.FamilyHealthStatus = _familyHealthStatus;
        newPolicy.detailsOfhealth.Smoke = _smoke;
        newPolicy.FamilyName = _familyName;
    }

    // generate health policy price
    function generateHealthPolicy(
        uint _insureId,
        uint _startTime,
        uint _endTime,
        uint _amountToInsure
    ) public // uint _periodOfCoverage
    {
        // uint id = _insureId;
        PolicyPurchase storage newPolicy = policyBought[msg.sender][_insureId];
        // uint policyD = newPolicy;
        uint timeToStart_ = block.timestamp + _startTime;
        uint timeToEnd_ = timeToStart_ + _endTime;
        uint[] memory _age = newPolicy.detailsOfhealth.age;
        bool _smoke = newPolicy.detailsOfhealth.Smoke;
        bool _familyHealthStatus = newPolicy.detailsOfhealth.FamilyHealthStatus;
        //determine deductible to be paid
        uint coverToPay = (newPolicy.CoverageAmount * 1) / 100;
        uint _amountInsureCover = _amountToInsure;
        uint256 determineAmount = _amountInsureCover * coverToPay;
        newPolicy.deductible = determineAmount;
        uint256 ageSum;
        // uint ageFactor = uint256(40 * 1) / 100;
        // uint genderFactor = uint256(10 * 1) / 100;
        // uint BMIFactor = uint256(20 * 1) / 100;
        uint smokingFactor;
        uint familyHealthFactor;
        for (uint i = 0; i < _age.length; i++) {
            ageSum += _age[i];
        }
        if (_smoke == true) {
            uint smoke_factor = uint256(1 * 20) / 100;
            smokingFactor = smoke_factor;
        }
        if (_smoke == false) {
            uint smoke_factor = uint256(0 * 20) / 100;
            smokingFactor = smoke_factor;
        }
        if (_familyHealthStatus == true) {
            uint _healthFactor = uint256(1 * 10) / 100;
            familyHealthFactor = _healthFactor;
        }
        if (_familyHealthStatus == false) {
            uint _healthFactor = uint256(1 * 10) / 100;
            familyHealthFactor = _healthFactor;
        }

        uint256 riskFactor = ((ageSum) * (uint256(40 * 1) / 100)) +
            (uint256(10 * 1) / 100) +
            (uint256(20 * 1) / 100) +
            smokingFactor +
            familyHealthFactor;

        // uint timeFactor = (timeToEnd_ / 365 days) * 1;

        uint _premium = (_amountInsureCover * riskFactor) +
            determineAmount +
            (((timeToEnd_ / 365 days) * 1) * _amountInsureCover);

        // return _premium;
        newPolicy.AmountPaid = _premium;
        newPolicy.StartTime = timeToStart_;
        newPolicy.EndTime = timeToEnd_;
        newPolicy.CoverageAmount = _amountInsureCover;
//         uint id_ = newPolicy.InsureId;
// saveDetails(_premium, id_);
    }
    function saveDetails (uint _premium, uint _insureId) internal{
        PolicyPurchase storage newPolicy = policyBought[msg.sender][_insureId];
        newPolicy.AmountPaid = _premium;
    }
}
