// SPDX-License_Identifier: MIT

pragma solidity ^0.8.13;
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "./Pricefeed.sol";

contract NewCoverage is AccessControl, Ownable, PriceConsumerV3 {
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
        bool paid; //Insurance premium is paid
        ClaimStatus Claim;
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
        bytes description;
        bool votingPassed;
        bool paid;
        address proposer;
        address paidBy;
        address AdminPaidTo;
    }

    mapping(uint => InsurancePolicy) public insurePolicy;
    mapping(address => mapping(uint => PolicyPurchase)) public policyBought;
    //to display all policy for a particular address
    mapping(address => PolicyPurchase[]) public ArrayPolicyPurchase;

    // to display for Admins
    PolicyPurchase[] private AdminArrayPolicyPurchase;
    mapping(address => mapping(uint256 => bool)) private hasValidateClaim;

    // dao
    mapping(uint256 => DAOProposal) private daoProposals; //mapping to hold the dao proposals
    DAOProposal[] private arrayDaoProposals;
    mapping(address => uint256[]) private stakeholderVotes; //to validate vote

    InsurancePolicy[] public arrayPolicy;
    address[] public admins;

    event PaidInsurance(address insured, uint _amount);

    // event GeneratedHealthPolicy(address insured, uint startTime, uint premium);
    // event ClaimedHealthPolicy(address insured, uint amount);

    function registerAdmin(address _newAdmin) external onlyOwner {
        if (_newAdmin == address(0x0)) revert("ADDRESS_ZERO_REVERTED");
        _setupRole(ADMIN_ROLE, _newAdmin);
        admins.push(_newAdmin);
    }

    function setDAOFee(uint _amount) external onlyOwner {
        DAOFEE = _amount;
    }

    //buy protocol token
    function buyToken(uint _amount, address _tokenDao) external payable {
        if (msg.value < _amount) revert("Enter correct amount");

        (bool success, ) = address(this).call{value: _amount}("");
        require(success, "Ether payment failed...!");

        int EthPrice = getLatestPrice();
        uint rate = uint(EthPrice) * 1000;
        uint amountReceived = rate * _amount;

        IERC20(_tokenDao).transfer(msg.sender, amountReceived);
    }

    // joinDAO
    function joinDAO(uint _daoFee, address _tokenContract) external {
        if (DAOFEE == 0) {
            revert("OPs error, contact admin");
        }
        if (_daoFee < DAOFEE) {
            revert("Amount less than DAO fee");
        }
        if (IERC20(_tokenContract).balanceOf(msg.sender) < _daoFee) {
            revert("Insufficient balance");
        }
        IERC20(_tokenContract).transferFrom(msg.sender, address(this), _daoFee);

        _setupRole(ADMIN_ROLE, msg.sender);
        admins.push(msg.sender);
    }

    function showAdmins() external view returns (address[] memory) {
        return admins;
    }

    function verifyAdmin(address _admin) external view returns (bool) {
        return hasRole(ADMIN_ROLE, _admin);
    }

    function createInsurancePolicy(
        string memory _policyName,
        string[] memory _policyOffer,
        string[] memory _agreement,
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
    ) external returns (uint256) {
        if (_startTime < block.timestamp) revert("Invalid time [_startTime]");
        if (_endTime < _startTime) revert("Invalid time [_endTime]");
        if (_amountToInsure <= 0) revert("Invalid value [_amountToInsure]");

        PolicyPurchase storage newPolicy = policyBought[msg.sender][_insureId];
        if (msg.sender != newPolicy.Insurer) {
            revert("Insurer record not found");
        }

        uint timeToStart_ = block.timestamp + _startTime;
        uint timeToEnd_ = timeToStart_ + _endTime;
        uint[] memory _age = newPolicy.detailsOfhealth.age;
        bool _smoke = newPolicy.detailsOfhealth.Smoke;
        bool _familyHealthStatus = newPolicy.detailsOfhealth.FamilyHealthStatus;
        //determine deductible to be paid
        // uint coverToPay = (newPolicy.PercentageToCover * _amountToInsure) / 100;
        // uint256 determineAmount = coverToPay;
        // newPolicy.deductible = determineAmount;
        uint _amountInsureCover = _amountToInsure;
        uint256 ageSum;
        uint smokingFactor;
        uint familyHealthFactor;
        for (uint i = 0; i < _age.length; i++) {
            ageSum = ageSum + _age[i];
        }
        if (_smoke == true) {
            smokingFactor = 2;
        }
        if (_smoke == false) {
            smokingFactor = 0;
        }
        if (_familyHealthStatus == true) {
            familyHealthFactor = 1;
        }
        if (_familyHealthStatus == false) {
            familyHealthFactor = 0;
        }

        uint256 riskFactor = ((ageSum * uint256(40 * 1)) / 100) +
            1 +
            2 +
            smokingFactor +
            familyHealthFactor;

        uint _premium = (((_amountInsureCover * riskFactor) / 100)) +
            ((((timeToEnd_ / 365 days) * 1) * _amountInsureCover) / 100);

        newPolicy.AmountPaid = _premium;
        newPolicy.StartTime = timeToStart_;
        newPolicy.EndTime = timeToEnd_;
        newPolicy.CoverageAmount = _amountInsureCover;

        return _amountInsureCover;
        // emit GeneratedHealthPolicy(msg.sender, _startTime, _premium);
    }

    function payInsurance(
        uint _amount,
        uint _insureId,
        address _tokenDAO
    ) external {
        PolicyPurchase storage newPolicy = policyBought[msg.sender][_insureId];
        if (msg.sender != newPolicy.Insurer) {
            revert("Insurer record not found");
        }
        if ( _amount < newPolicy.CoverageAmount) {
            revert("Amount less than user coverage");
        }
        if (newPolicy.PercentageToCover == 0) {
            revert("User registration not found");
        }
        if (newPolicy.paid == true) {
            revert("User already has payment record");
        }

        IERC20(_tokenDAO).transferFrom(msg.sender, address(this), _amount);
        newPolicy.paid = true;
        newPolicy.AmountPaid = _amount;

        emit PaidInsurance(msg.sender, _amount);
    }

    //to claim health insuraance
    function claimHealthPolicy(
        bool _report,
        uint256 _amount,
        uint _insureId
    ) public {
        PolicyPurchase storage newPolicy = policyBought[msg.sender][_insureId];
        if (block.timestamp > newPolicy.EndTime)
            revert("Insurance coverage expired");
        if (newPolicy.paid == false) {
            revert("No record of insurance subscription found");
        }
        if (_amount > newPolicy.CoverageAmount)
            revert("Amount exceeds coverage");
        if (msg.sender != newPolicy.Insurer) {
            revert("Record not found");
        }
        if (_report == false) {
            revert("No evidence submitted");
        }

        newPolicy.detailsToclaim.Report = _report;
        newPolicy.detailsToclaim.AmountToClaim = _amount;
        newPolicy.Claim = ClaimStatus.Pending;

        // emit ClaimedHealthPolicy(msg.sender, _amount);
    }


    //function to get all the policy bought by a user
    function getPolicyPurchases()
        external
        view
        returns (PolicyPurchase[] memory)
    {
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
    ) external {
        PolicyPurchase storage newPolicy = policyBought[_rewardee][_insureId];

        if (newPolicy.Insurer != _rewardee) revert("Rewardee not a subscriber");

        if (!hasRole(ADMIN_ROLE, msg.sender)) {
            revert("Unauthorized operation [validateClaim]");
        }
        if (hasValidateClaim[msg.sender][_insureId] == true)
            revert("Can't validate twice");

        if (_validate == true) {
            newPolicy.detailsToclaim.ValidateFor += 1;
        }
        if (_validate == false) {
            newPolicy.detailsToclaim.Validateagainst += 1;
        }

        hasValidateClaim[msg.sender][_insureId] = true;
    }

    //Validate claim
    function ValidateClaimStatus(uint _insureId) internal returns (bool) {
        PolicyPurchase storage newPolicy = policyBought[msg.sender][_insureId];

        uint adminPercent = (admins.length * 70) / 100;
        // uint totalVotes_ = newPolicy.detailsToclaim.ValidateFor + newPolicy.detailsToclaim.Validateagainst;
        // uint votesPercent = (totalVotes_ * 60) / 100;

        if (msg.sender != newPolicy.Insurer) {
            revert("User record not found");
        }

        // if(newPolicy.detailsToclaim.ValidateFor >= votesPercent ) {
        //     newPolicy.Claim = ClaimStatus.Approved;
        //     return true;
        // } else if(newPolicy.detailsToclaim.Validateagainst >= votesPercent) {
        //     newPolicy.Claim = ClaimStatus.Rejected;
        //     return false;
        // } else {
        //     newPolicy.Claim = ClaimStatus.Pending;
        // }
        if (newPolicy.detailsToclaim.ValidateFor < adminPercent) {
            // revert("Claim not approved");
            return false;
        }

        if (
            newPolicy.detailsToclaim.ValidateFor >
            newPolicy.detailsToclaim.Validateagainst
        ) {
            newPolicy.Claim = ClaimStatus.Approved;
            return true;
        } else {
            newPolicy.Claim = ClaimStatus.Rejected;
            return false;
        }
    }

    //function to collect claim
    function ClaimReward(uint _insureId, address _tokenDao) external returns(uint) {
        PolicyPurchase storage _newPolicy = policyBought[msg.sender][_insureId];

        bool voteOutcome = ValidateClaimStatus(_insureId);

        if (msg.sender != _newPolicy.Insurer) {
            revert("User record not found");
        }

        if(voteOutcome == false) revert("claim not approved");

        uint AmountLeft = _newPolicy.CoverageAmount - _newPolicy.detailsToclaim.AmountToClaim;
        _newPolicy.CoverageAmount = AmountLeft;

        uint deductible = (_newPolicy.detailsToclaim.AmountToClaim * _newPolicy.PercentageToCover) / 100;

        // if(_newPolicy.detailsToclaim.AmountToClaim > _newPolicy.deductible) {
        //     uint reward = _newPolicy.detailsToclaim.AmountToClaim - deductible;
        //     IERC20(_tokenDao).transfer(msg.sender, reward);
        // } else {
        //     uint reward = _newPolicy.deductible - _newPolicy.detailsToclaim.AmountToClaim;
        //     IERC20(_tokenDao).transfer(msg.sender, reward);
        // }

        uint reward = _newPolicy.detailsToclaim.AmountToClaim - deductible;
        IERC20(_tokenDao).transfer(msg.sender, reward);

        _newPolicy.deductible = deductible;

        return reward;

        //logic to transfer the token worth
    }

    // create Proposal

    function createProposal(
        string calldata description,
        uint256 amount
    ) external onlyRole(ADMIN_ROLE) {
        bytes memory descHash = abi.encode(description);
        uint256 vetPeriod = block.timestamp + MINIMUM_VOTING_PERIOD;
        uint256 proposalId = numOfProposals + 1;
        DAOProposal storage proposal = daoProposals[proposalId];
        proposal.id = proposalId;
        proposal.proposer = payable(msg.sender);
        proposal.description = descHash;
        proposal.amount = amount;
        proposal.livePeriod = vetPeriod;
        arrayDaoProposals.push(proposal);
    }

    function returnProposals() external view returns (DAOProposal[] memory) {
        return arrayDaoProposals;
    }

    // to vote for a proposal
    function vote(
        uint256 proposalId,
        bool supportProposal
    ) external onlyRole(ADMIN_ROLE) {
        DAOProposal storage daoProposal = daoProposals[proposalId];

        votable(daoProposal);

        if (supportProposal) {
            daoProposal.votesFor = daoProposal.votesFor + 1;
        } else {
            daoProposal.votesAgainst = daoProposal.votesAgainst + 1;
        }

        stakeholderVotes[msg.sender].push(daoProposal.id);
    }

    function votable(DAOProposal storage daoProposal) internal {
        if (
            daoProposal.votingPassed || daoProposal.livePeriod < block.timestamp
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

    function showVoteRecords(uint proposalId) external view returns (uint, uint) {
        DAOProposal memory _daoProposal = daoProposals[proposalId];
        return (_daoProposal.votesFor, _daoProposal.votesAgainst);
    }

    function withdrawEther(uint _amount, address _to) external onlyOwner {
        if(_amount == 0) revert('Amount cannot be zero');
        if(_to == address(0x0)) revert('Address zero detected');

        (bool success, ) = _to.call{value: _amount}('');
        require(success, 'Ether withdrawal failed');
    }

    function withdrawToken(uint _amount,address _daoToken, address _to) external onlyOwner {
        if(_amount == 0) revert('Amount cannot be zero');
        if(_to == address(0x0)) revert('Address zero detected');

        IERC20(_daoToken).transfer(_to, _amount);
    }

    // receive() external payable virtual;
}
    //claim Automobile insurance

    // Register for auto insurance
    // function regAutoInsurance(
    //     uint _insureId,
    //     uint _age,
    //     uint _drivingYears,
    //     bool _eyeDefect,
    //     string calldata _name,
    //     string calldata _gender,
    //     string calldata _policyCovered
    // ) external returns (uint deductible) {
    //     PolicyPurchase storage policy = policyBought[msg.sender][_insureId];

    //     bytes32 zerohash = keccak256("");
    //     if (keccak256(abi.encode(_name)) == zerohash) revert("Name cannot be blank");
    //     if (keccak256(abi.encode(_policyCovered)) == zerohash)
    //         revert("Policy covered cannot be blank");
    //     if(keccak256(abi.encode(_gender)) == zerohash) revert("Gender cannot be blank");
    //     if(_drivingYears <= 0) revert("Invalid age");
    //     if(_age < 18) revert("Age is 18 years minimum");

    //     // payment

    //     policy.FamilyName = _name;
    //     policy.autoDetails.gender = _gender;
    //     policy.autoDetails.age = _age;
    //     policy.autoDetails.drivingYears = _drivingYears;
    //     policy.autoDetails.eyeDefect = _eyeDefect;
    //     policy.autoDetails.policyCovered = _policyCovered;

    //     // emit some event
    // }

    // function getAutoInsurance(
    //     uint _insureId,
    //     uint _startTime,
    //     uint _endTime,
    //     uint _amountToInsure
    // ) external {
    //     if (_startTime < block.timestamp) revert("Invalid time [_startTime]");
    //     if (_endTime < _startTime) revert("Invalid time [_endTime]");
    //     if (_amountToInsure <= 0) revert("Invalid value [_amountToInsure]");

    //     PolicyPurchase storage newPolicy = policyBought[msg.sender][_insureId];
    //     if (msg.sender != newPolicy.Insurer) {
    //         revert("Insurer record not found");
    //     }

    //     uint timeToStart_ = block.timestamp + _startTime;
    //     uint timeToEnd_ = timeToStart_ + _endTime;
    // }

    // claim Health Insurance
    // if claim is once rejected you have to pay to resubmit claim
    // function claimAutoInsurance(uint _insureId, uint256 _amount, string calldata _event ) external {
    //     policyBought storage policy = policyBought[msg.sender][_insureId];

    //     if(policy.deductible <= 0) revert("Deductible payment not on record");

    //     uint256 totalSub = policy.CoverageAmount;
    //     userClaimDetails[msg.sender].AmountApplied = _amount;
    //     userClaimDetails[msg.sender].Event = _event;
    // }
