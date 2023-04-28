// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

<<<<<<< HEAD
contract Insurance {
    uint id;
    uint256 public constant MAXIMUM_POLICY_DURATION = 365 days;
// Policy
    struct Cover{
        // Are we not to be the one to decide the name of the POLICY???
        string PolicyName; //Policy Name 
=======
contract Insurance is AccessControl, ReentrancyGuard, Ownable{
    uint256 id;
    uint256 claimInsurance;
    uint256 DAOFEE;
    uint256 numOfProposals;
    uint256 public constant MAXIMUM_POLICY_DURATION = 365 days;
    uint32 public constant MINIMUM_POLICY_DURATION = 1 weeks;
    bytes32 public constant STAKEHOLDER_ROLE = keccak256("STAKEHOLDER");
    bytes32 public constant MAJOR_ADMIN= keccak256("MAJORADMIN");
    uint32 constant MINIMUM_VOTING_PERIOD = 1 weeks;
    address Owner ;
    
    // Policy
    struct Cover {
        string PolicyName; //Policy Name
>>>>>>> master
        uint PolicyPercent; //Annual Rate
        bool PolicyActive; //to know if the policy is still in pogress
        bytes32 Agreement;
    }

    struct PremiumPurchase {
        uint CoverId;
        uint TotalPeriod;
        uint CoverAmount; //Amount to be insured
        uint Premium; //Amount to be charged
        uint StartTime;
        uint EndTime;
        uint ValidateCounter;
        uint AmountToWithdraw; //Amount of Insured to withdraw
        address PremiumBuyerAddr; //address of the premium purchaser
        bool Paid;
        bool SubmitClaim;
<<<<<<< HEAD
        bool AdminVerified; 
        bool Validate; //to check if the claim is valid
=======
        bool AdminVerified;
        bool Validate; //to check if the claim is valid
        uint ValidateCounter;
        address PremiumBuyerAddr; //address of the premium purchaser
        uint AmountToWithdraw; //Amount of Insured to withdraw
>>>>>>> master
        // mapping(address => bool) Validate; //
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

<<<<<<< HEAD

    // uint id;
    // uint256 public constant MAXIMUM_POLICY_DURATION = 365 days;
    // Policy

    // Why is the key of this mapping not "Address of the customer (msg.sender)"
    mapping(uint => Cover) private cover; 
    Cover[] public _arrayCover; 
    uint[] public saveId; //to save the whole ids
=======
    mapping(uint => Cover) private cover;
    Cover[] public _arrayCover;
    uint[] public saveId; //to save the whole ids
    mapping(uint256 => DAOProposal) private daoProposals; //mapping to hold the dao proposals
    mapping(address => uint256[]) private stakeholderVotes;
>>>>>>> master


    address[] private Admin;
    // mapping (address => PremiumPurchase) public purchaseCoverBought;
    mapping(address => mapping(uint => PremiumPurchase)) public premiumBought;

<<<<<<< HEAD

// Events 
    event PolicyPurchased( address indexed holder, uint256 coverAmount, uint256 premium, uint256 indexed coverid, uint256 indexed expiration );

    event ClaimSubmitted( address indexed holder, uint256 amount, uint256 timestamp );

    // event ClaimValidated( address indexed holder, uint256 amount, uint256 timestamp );
    // uint i = 0;
    // while (i < saveId.length && !isCoverId) {
        // if (saveId[i] == _coverId) {
            // isCoverId = true;
        // }
        // i++;
    // }
    // 
    event ClaimPaidOut( address indexed holder, uint256 indexed amount, uint256 indexed timestamp );

    // event PolicyCancelled( address indexed holder, uint256 refundAmount );

    // event PolicyExpired(address indexed holder, uint256 amount, uint256 expiration);

    // ======================  joinDAO =================================

// ???? WHO DEY BECOME ADMIN ??? ==========================
function becomeAdmin() public payable{
    require(msg.value > 0, "Insuficient Amount");
    Admin.push(msg.sender);

}
    function CreateCover(string calldata _policyName, uint _policyPercent, bool _policyActive, bytes memory _agreement) public {
        bool isAdmin = false;
        id += 1;
        // ==============WHILE LOOP??????????????????????????????????
        for (uint i = 0; i < Admin.length; i++) {
            if (Admin[i] == msg.sender) {
                isAdmin = true;
                break;
            }
=======
    mapping (address => uint256) public stakeHoderToken; //keeping track of stakeholder token

    // Events
    event PolicyPurchased(
        address indexed holder,
        uint256 coverAmount,
        uint256 premium,
        uint256 indexed coverid,
        uint256 indexed expiration
    );

    event ClaimSubmitted(
        address indexed holder,
        uint256 amount,
        uint256 timestamp
    );

    // event ClaimValidated( address indexed holder, uint256 amount, uint256 timestamp );

    event ClaimPaidOut(
        address indexed holder,
        uint256 indexed amount,
        uint256 indexed timestamp
    );

event NewDAOProposal(address indexed proposer, uint256 amount, uint256 idProposal);

    // event PolicyCancelled( address indexed holder, uint256 refundAmount );

    // event PolicyExpired(address indexed holder, uint256 amount, uint256 expiration);

    // setAmount to claim Insurance
    function setClaimAmount(uint _amount) public{
        claimInsurance = _amount;
    }

    function setDAOFee(uint _amount) public{
        DAOFEE = _amount;
    }

    function verifyAccess() internal view{
         if (!hasRole(STAKEHOLDER_ROLE, msg.sender)){
            revert();
>>>>>>> master
        }
    }

    // joinDAO
    function becomeAdmin(uint _daoFee, address _tokenContract) public payable {
        address account = msg.sender;
        if(DAOFEE == 0){
            revert();
        }
        if (_daoFee < DAOFEE){
            revert();
        }
        if(IERC20(_tokenContract).balanceOf(account) < _daoFee){
            revert();
        }
        IERC20(_tokenContract).transferFrom(account, address(this), _daoFee);
        require(msg.value > 0, "Insuficient Amount");
        _setupRole(STAKEHOLDER_ROLE, account);
        Admin.push(msg.sender);
    }

    // to create policy
    function CreateCover(
        string calldata _policyName,
        uint _policyPercent,
        bool _policyActive,
        bytes32 _agreement
    ) public {
        // bool isAdmin = false;
        id += 1;
        // for (uint i = 0; i < Admin.length; i++) {
        //     if (Admin[i] == msg.sender) {
        //         isAdmin = true;
        //         break;
        //     }
        // }
        if (!hasRole(STAKEHOLDER_ROLE, msg.sender)){
            revert();
        }
        // require(isAdmin, "Only Dao member can create policy");

        Cover memory newCover = Cover({
            PolicyName: _policyName,
            PolicyPercent: _policyPercent,
            PolicyActive: _policyActive,
            Agreement: _agreement
        });
        cover[id] = newCover;
        _arrayCover.push(newCover);
        saveId.push(id);
<<<<<<< HEAD

=======
>>>>>>> master
    }

    // buy premium
    function purchasePremium(
        uint _coverId,
        uint _totalPeriod,
        uint _coverAmount,
        uint _endTime,
        uint _amount,
        address _TokenContract
    ) public {
        bool isCoverId = false;
<<<<<<< HEAD
        // ==============WHILE LOOP??????????????????????????????????
        // uint i = 0;
        // while (i < saveId.length && !isCoverId) {
        //         if (saveId[i] == _coverId) {
        //         isCoverId = true;
        //     }
        //     i++;
        // }


        for (uint i = 0; i < saveId.length; i++) {
            if (saveId[i] == _coverId) {    // random trial from anyone
=======
        for (uint i = 0; i < saveId.length; i++) {
            if (saveId[i] == _coverId) {
>>>>>>> master
                isCoverId = true;
                break;
            }
        }
        require(isCoverId, "This Id does not exist");
        uint _startTime = block.timestamp;
        uint expireTime = _startTime + _endTime;
        if(expireTime > MAXIMUM_POLICY_DURATION){
            revert();
        }
        if(expireTime < MINIMUM_POLICY_DURATION){
            revert();
        }
        uint _percent = cover[_coverId].PolicyPercent;
        uint premiumTobePaid = _coverAmount * _percent;
        require(_amount >= premiumTobePaid, "Insufficient Amount");
        require(
            IERC20(_TokenContract).balanceOf(msg.sender) >= _amount,
            "INSUFFICIENT_AMOUNT_IN_BALANCE"
        );

        IERC20(_TokenContract).transferFrom(msg.sender, address(this), _amount);

        PremiumPurchase storage _newPremium = premiumBought[msg.sender][
            _coverId
        ];
        _newPremium.CoverId = _coverId;
        _newPremium.TotalPeriod = _totalPeriod;
        _newPremium.CoverAmount = _coverAmount;
        _newPremium.Premium = _amount;
        _newPremium.StartTime = _startTime;
        _newPremium.EndTime = expireTime;
        _newPremium.PremiumBuyerAddr = msg.sender;
        emit PolicyPurchased(
            msg.sender,
            _coverAmount,
            _amount,
            _coverId,
            expireTime
        );
        // transfer nft logic
    }

    // Submit claim to receive insurance fee
    function submitClaim(
        uint _coverId,
        address _premiumBuyerAddr,
        uint _amountToClaim,
        address _tokenContract,
        uint _tokenClaimFee
    ) public {
        require(IERC20(_tokenContract).balanceOf(msg.sender) >= claimInsurance, "INSUFFICIENT_BALANCE_TO_SUBMIT_CLAIM");
        PremiumPurchase storage _newPremium = premiumBought[_premiumBuyerAddr][
            _coverId
        ];
        require(
            _newPremium.PremiumBuyerAddr == msg.sender,
            "YOU_ARE_NOT_THE_POLICY_HOLDER"
        );

        require(
            block.timestamp < _newPremium.EndTime,
            "POLICY_IS_NO_LONGER_ACTIVE"
        );
        require(
            _amountToClaim <= _newPremium.CoverAmount,
            "YOU_CAN_NOT_W ITHDRAW_MORE_THAN_YOU_HAVE_INSURED"
        );
        IERC20(_tokenContract).transferFrom(msg.sender, address(this), _tokenClaimFee);
        _newPremium.SubmitClaim = true;
        _newPremium.AmountToWithdraw = _amountToClaim;

        emit ClaimSubmitted(_premiumBuyerAddr,_amountToClaim, block.timestamp);
    }

    // to validate reward it determines if the insured amount is to be paid or not
    function validateClaim(
        uint _coverId,
        address _rewardee,
        bool _validate
    ) public {
        // bool isAdmin = false;
        // for(uint i = 0; i < Admin.length; i++){
        //     if(Admin[i] == msg.sender){
        //         isAdmin = true;
        //         break;
        //     }
        // }

         if (!hasRole(STAKEHOLDER_ROLE, msg.sender)){
            revert();
        }
        PremiumPurchase storage _newPremium = premiumBought[_rewardee][
            _coverId
        ];

        _newPremium.Validate = _validate;
        if (_validate == true) {
            _newPremium.ValidateCounter += 1;
        }
    }

    function approveClaim(uint _coverId, address _rewardee) public {
        uint _adminPercent = (Admin.length * 70) / 100;
        require(msg.sender == _rewardee, "YOU_ARE_NOT_THE_OWNER_OF_THE_CLAIM");
        PremiumPurchase storage _newPremium = premiumBought[_rewardee][
            _coverId
        ];
        require(
            _newPremium.ValidateCounter >= _adminPercent,
            "You can't withdraw yet "
        );
        uint AmountLeft = _newPremium.CoverAmount -
            _newPremium.AmountToWithdraw;

        //logic to transfer the token worth

        _newPremium.CoverAmount = AmountLeft;

        emit ClaimPaidOut(
            _rewardee,
            _newPremium.AmountToWithdraw,
            block.timestamp
        );
    }

    function renewPolicy(
        uint _coverId,
        address _rewardee,
        uint _endTime,
        uint _coverAmount,
        uint _amount,
        address _tokenContract
    ) public {
        require(msg.sender == _rewardee, "YOU_ARE_NOT_THE_OWNER_OF_THIS_CLAIM");
        PremiumPurchase storage _newPremium = premiumBought[_rewardee][
            _coverId
        ];

        require(
            block.timestamp <= _newPremium.EndTime,
            "You can no longer renew this policy"
        );
        require(IERC20(_tokenContract).balanceOf(msg.sender) >= _amount, "INSUFFICIENT_FUND");
IERC20(_tokenContract).transferFrom(msg.sender, address(this), _amount);
        _newPremium.EndTime += _endTime;
        _newPremium.CoverAmount = _coverAmount;
        _newPremium.Premium += _amount;
    }

    function premiumActive(
        uint _coverId,
        address _rewardee
    ) public view returns (bool) {
        PremiumPurchase memory _newPremium = premiumBought[_rewardee][_coverId];

        if (
            block.timestamp > _newPremium.EndTime || _newPremium.Paid == false
        ) {
            return false;
        }
        return true;
    }

    // create Proposal

        function createProposal(
        string calldata description,
        uint256 amount
    )
        external
    
    {
        verifyAccess();

        uint256 proposalId = numOfProposals + 1;
        DAOProposal storage proposal = daoProposals[proposalId];
        proposal.id = proposalId;
        proposal.proposer = payable(msg.sender);
        proposal.description = description;
        proposal.amount = amount;
        proposal.livePeriod = block.timestamp + MINIMUM_VOTING_PERIOD;

        emit NewDAOProposal(msg.sender, amount, proposalId);
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

    // release fund
    function checkVote(uint256 proposalId)
        external
    {
        verifyAccess();
        uint _adminPercent = (Admin.length * 70) / 100;

        DAOProposal storage daoProposal = daoProposals[proposalId];
        uint256 totalVotes = daoProposal.votesFor + daoProposal.votesAgainst;
        if(daoProposal.livePeriod < block.timestamp && totalVotes >= _adminPercent){
            revert();
        }

        if (daoProposal.paid)
            revert("Payment has been made to this charity");

        if (daoProposal.votesFor <= daoProposal.votesAgainst)
            revert(
                "The proposal does not have the required amount of votes to pass"
            );

        daoProposal.paid = true;
        daoProposal.paidBy = msg.sender;

        // emit PaymentTransfered(
        //     msg.sender,
        //     charityProposal.charityAddress,
        //     charityProposal.amount
        // );

        // return charityProposal.charityAddress.transfer(charityProposal.amount);
    }

    // release Amount to MainAdmin for the purpose of the agreed purpose
function releasePayment(uint256 proposalId, address _tokenContract) public onlyOwner {
    address account = msg.sender;
   
    DAOProposal storage daoProposal = daoProposals[proposalId];
    if(!daoProposal.paid){
        revert();
    }
    IERC20(_tokenContract).transfer(account, daoProposal.amount);
}

}



