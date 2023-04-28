// SPDX-License_Identifier: MIT

pragma solidity ^0.8.13;
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";

contract Cover is AccessControl, Ownable {
    uint256 insureId;
    uint256 private constant MINIMUM_POLICY_DURATION = 1 weeks; // minimum period in which insurance covers
    uint256 private constant MAXIMUM_POLICY_DURATION = 365 days; // maximum period in which insurance covers
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MAJOR_ADMIN = keccak256("MAJOR_ADMIN");
    // Struct to create Insurance Policy

    struct InsurancePolicy {
        //uint policyId; //for tracking each policy
        string PolicyName; //insurance Name
        bool PolicyActive; //is this Policy still Active
        bytes Agreement;
        bytes PolicyOffer; //determine the type of Policy to buy
        uint MinimumPeriod; // minimum period in which insurance covers
        uint MaximumPeriod; // maximum period
    }

    // Struct to purchase Insurance Policy
    struct PolicyPurchase {
        uint InsureId;
        uint PercentageToCover; //percentage of premium to buy which determine deductible
        uint startTime; //when deductible start
        uint EndTime; //when deductible ends in weeks
        bool Claim; //has insurance claim been filed this should be enum
        string FamilyName;
        string[] FamilyHealthStatus;
        bytes FamilyHospital;
        string[] prescription;
        uint[] Gender;
        uint[] Ages;
        uint deductible; //percentage of deductible
        bool paid; //Insurance policy paid
        string policyCoverd;
    }

    mapping(uint => InsurancePolicy) public insurePolicy;
    mapping(address => mapping(uint => PolicyPurchase)) public policyBought;

    InsurancePolicy[] public arrayPolicy;
    address[] public admins;

    constructor() {
        Admin = msg.sender;
    }

    // Register Admin
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

    // create an insurance policy
    // Only chosen Admin can create Insurance Policy
    function createInsurancePolicy(
        string memory _policyName,
        string[] memory _agreement,
        string[] memory _policyOffer,
        uint _minimumPeriod,
        uint _maximumPeriod
    ) external onlyRole(ADMIN_ROLE) {
        if (_minimumPeriod < MAXIMUM_POLICY_DURATION) revert();
        if (_maximumPeriod > MAXIMUM_POLICY_DURATION) revert();
        insureId += 1;

        InsurancePolicy storage createPolicy = insurePolicy[insureId];
        createPolicy.PolicyName = _policyName;
        createPolicy.PolicyActive = true;
        createPolicy.Agreement = abi.encode(_agreement);
        createPolicy.PolicyOffer = abi.encode(_policyOffer);
        createPolicy.MinimumPeriod = _minimumPeriod;
        createPolicy.MaximumPeriod = _maximumPeriod;

        InsurancePolicy memory newPolicy = InsurancePolicy({
            PolicyName: _policyName,
            PolicyActive: true,
            Agreement: abi.encode(_agreement),
            PolicyOffer: abi.encode(_policyOffer),
            MinimumPeriod: _minimumPeriod,
            MaximumPeriod: _maximumPeriod
        });
        arrayPolicy.push(newPolicy);
    }

    // buy Automobile policy

    //buy Health Policy
    function buyHealth(
        string calldata _familyName,
        uint _amount,
        uint _insureId,
        uint _startTime,
        uint _endTime,
        uint _coverage,
        uint _plan,
        string memory _policyCovered,
        uint[] calldata _age
    ) external returns (uint deductible) {
        uint presentTime = block.timestamp;
        uint maxTime = insurePolicy[_insureId].MaximumPeriod;
        if ((presentTime + _endTime) > maxTime) revert("Time exceeds max coverage period for policy");
    }

    //claim Automobile insurance
    function buyAutoInsurance(
        string calldata _name,
        uint _premium,
        uint _insureId,
        uint _startTime,
        uint _endTime,
        uint _coverage,
        uint _plan,
        uint calldata _age,
        string calldata _driversLicense_ID,
        string calldata _policyCovered

    ) external returns(uint deductible) {
        policyBought storage policy = policyBought[msg.sender][_insureId];
        
        bytes32 zerohash = keccak256("");
        uint presentTime = block.timestamp;
        uint maxTime = insurePolicy[_insureId].MaximumPeriod;
        if ((presentTime + _endTime) > maxTime) revert('Time exceeds max coverage period for policy');
        if(keccak256(_name) == zerohash) revert("Name cannot be blank");
        if(keccak256(_policyCovered) == zerohash) revert("Policy covered cannot be blank");
        if(keccak256(_driversLicense_ID) == zerohash) revert("Driver's license ID cannot be blank");

        policy.FamilyName = _name;
        policy.
    }

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
