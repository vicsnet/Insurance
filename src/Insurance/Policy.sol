// SPDX-License_Identifier: MIT

pragma solidity ^0.8.13;
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";

contract NewCoverage is AccessControl, Ownable {
    uint256 insureId;
    uint256 DAOFEE;
    uint256 numOfProposals;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MAJOR_ADMIN = keccak256("MAJOR_ADMIN");
    uint32 constant MINIMUM_VOTING_PERIOD = 1 weeks;
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
        address Insurer; //
        string FamilyName;
        ClaimStatus Claim;
        bool paid; //Insurance premium is paid

        HealthDetail detailsOfhealth;
        ClaimDetail detailsToclaim;
    }
    enum ClaimStatus {
        Pending,
        Approved,
        Rejected
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
    struct ClaimDetail {
        bool Report;
        uint AmountToClaim;
        uint ValidateFor; //admin validate claim
        uint Validateagainst; //admin validate against
    }

        struct DAOProposal {
        uint256 id;
        uint256 amount;
        uint256 livePeriod;
        uint256 votesFor;
        uint256 votesAgainst;
        string description;
        bool votingPassed;
        bool paid;
        address proposer;
        address paidBy;
        address AdminPaidTo;

    }
    mapping(uint => InsurancePolicy) public insurePolicy;
    mapping(address => mapping(uint => PolicyPurchase)) public policyBought;
    //to display all policy for a particular address
    mapping(address =>PolicyPurchase[]) public ArrayPolicyPurchase;
    
    // to display for Admins 
    PolicyPurchase[] private  AdminArrayPolicyPurchase; 
    mapping(address => mapping(uint256 => bool)) private hasValidateClaim;

    // dao
    mapping(uint256 => DAOProposal) private daoProposals; //mapping to hold the dao proposals
    DAOProposal[] private arrayDaoProposals;
    mapping(address => uint256[]) private stakeholderVotes; //to validate vote


    InsurancePolicy[] public arrayPolicy;
    address[] public admins;

    function registerAdmin(address _newAdmin) external onlyOwner {
        if (_newAdmin == address(0x0)) revert("ADDRESS_ZERO_REVERTED");
        _setupRole(ADMIN_ROLE, _newAdmin);
        admins.push(_newAdmin);
    }

  function setDAOFee(uint _amount) public onlyOwner{
        DAOFEE = _amount;
    }
    
  // joinDAO
    // function becomeAdmin(uint _daoFee, address _tokenContract) public payable {
    //     address account = msg.sender;
    //     if(DAOFEE == 0){
    //         revert();
    //     }
    //     if (_daoFee < DAOFEE){
    //         revert();
    //     }
    //     if(IERC20(_tokenContract).balanceOf(account) < _daoFee){
    //         revert();
    //     }
    //     IERC20(_tokenContract).transferFrom(account, address(this), _daoFee);
    //     require(msg.value > 0, "Insuficient Amount");
    //     _setupRole(STAKEHOLDER_ROLE, account);
    //     admins.push(msg.sender);
    // }
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
        newPolicy.Insurer = msg.sender;
          ArrayPolicyPurchase[msg.sender].push(newPolicy);
          AdminArrayPolicyPurchase.push(newPolicy);
    }

    // generate health policy price
    function generateHealthPolicy(
        uint _insureId,
        uint _startTime,
        uint _endTime,
        uint _amountToInsure // uint _periodOfCoverage
    ) public {
        // uint id = _insureId;
        PolicyPurchase storage newPolicy = policyBought[msg.sender][_insureId];
        if (msg.sender != newPolicy.Insurer) {
            revert();
        }
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
    }

    function payInsurance(uint _amount, uint _insureId) public {
        PolicyPurchase storage newPolicy = policyBought[msg.sender][_insureId];
        if (msg.sender != newPolicy.Insurer) {
            revert();
        }
        if (newPolicy.CoverageAmount > _amount) {
            revert();
        }
        if (newPolicy.PercentageToCover == 0) {
            revert();
        }
        if (newPolicy.paid == true) {
            revert();
        }
        newPolicy.paid = true;
    }

    //to claim health insuraance
    function claimHealthPolicy(
        bool _report,
        uint256 _amount,
        uint _insureId
    ) public {
        PolicyPurchase storage newPolicy = policyBought[msg.sender][_insureId];
        if(block.timestamp > newPolicy.EndTime) revert();
        if (newPolicy.paid == false) {
            revert();
        }
        if(_amount >newPolicy.CoverageAmount) revert();
        if (msg.sender != newPolicy.Insurer) {
            revert();
        }
        if (_report == false) {
            revert();
        }

        newPolicy.detailsToclaim.Report = _report;
        newPolicy.detailsToclaim.AmountToClaim = _amount;
        newPolicy.Claim = ClaimStatus.Pending;
    }

//function to get all the policy bought by a user
function getPolicyPurchases() public view returns (PolicyPurchase[] memory) {
    return ArrayPolicyPurchase[msg.sender];
}

    // get all insurance  policy
    function getAllPurchase() public view returns (PolicyPurchase[] memory) {
    return AdminArrayPolicyPurchase;
}


    // to validate reward it determines if the insured amount is to be paid or not
    function validateClaim(
        uint _insureId,
        address _rewardee,
        bool _validate
    ) public {
      

         if (!hasRole(ADMIN_ROLE, msg.sender)){
            revert();
        }
       if ( hasValidateClaim[msg.sender][_insureId] == true) revert();
        PolicyPurchase storage newPolicy= policyBought[_rewardee][
            _insureId
        ];
        if(_validate = true){
            newPolicy.detailsToclaim.ValidateFor +=1;
        }
        if(_validate = false){
            newPolicy.detailsToclaim.Validateagainst +=1;
        }
    hasValidateClaim[msg.sender][_insureId] = true;

    }

//Validate claim
function  ValidateClaimStatus(uint _insureId, address _rewardee) public{
     uint _adminPercent = (admins.length * 70) / 100;
 PolicyPurchase storage newPolicy = policyBought[_rewardee][_insureId];
      if(newPolicy.detailsToclaim.ValidateFor < _adminPercent){
            revert("YOU_CANT_ACCESS_NOW");
        }

    if(msg.sender != _rewardee){
        revert();
    }
  if(newPolicy.detailsToclaim.ValidateFor > newPolicy.detailsToclaim.Validateagainst){

     newPolicy.Claim = ClaimStatus.Approved;
  }
  else{
    newPolicy.Claim= ClaimStatus.Rejected;
  }
}

//function to collect claim
    function ClaimReward(uint _insureId, address _rewardee) public {
        uint _adminPercent = (admins.length * 70) / 100;

    if(msg.sender != _rewardee){
        revert();
    }

        PolicyPurchase storage _newPolicy = policyBought[_rewardee][
            _insureId
        ];
        if(_newPolicy.detailsToclaim.ValidateFor < _adminPercent){
            revert("YOU_CANT_WITHDRAW_CLAIM_NOT_ACCEPTED");
        }
        if( _newPolicy.Claim != ClaimStatus.Approved){
            revert("CLAIM_REJECTED");
        }


        uint AmountLeft = _newPolicy.CoverageAmount -
            _newPolicy.detailsToclaim.AmountToClaim;
            _newPolicy.CoverageAmount = AmountLeft;

        //logic to transfer the token worth



    }


        // create Proposal

        function createProposal(
        string calldata description,
        uint256 amount
    )
        external
    
    {
        if (!hasRole(ADMIN_ROLE, msg.sender)){
            revert();
        }

        uint256 proposalId = numOfProposals + 1;
        DAOProposal storage proposal = daoProposals[proposalId];
        proposal.id = proposalId;
        proposal.proposer = payable(msg.sender);
        proposal.description = description;
        proposal.amount = amount;
        proposal.livePeriod = block.timestamp + MINIMUM_VOTING_PERIOD;
arrayDaoProposals.push(proposal);
    
    }

        // to vote for a proposal
        function vote(uint256 proposalId, bool supportProposal)
        external

    {
        DAOProposal storage daoProposal = daoProposals[proposalId];

        votable(daoProposal);

        if (supportProposal){

         daoProposal.votesFor++;
        }
        else{

         daoProposal.votesAgainst++;
        }

        stakeholderVotes[msg.sender].push(daoProposal.id);
    }

    function votable(DAOProposal storage daoProposal) internal {
        if (
            daoProposal.votingPassed ||
            daoProposal.livePeriod <= block.timestamp
        ) {
            daoProposal.votingPassed = true;
            revert("Voting period has passed on this proposal");
        }

        uint256[] memory tempVotes = stakeholderVotes[msg.sender];
        for (uint256 votes = 0; votes < tempVotes.length; votes++) {
            if (daoProposal.id == tempVotes[votes])
                revert("This stakeholder already voted on this proposal");
        }
    }



}
