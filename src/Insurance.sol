// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";

contract Insurance is AccessControl {
    uint256 id;
    uint256 public constant MAXIMUM_POLICY_DURATION = 365 days;
    uint256 claimInsurance;
    uint256 DAOFEE;
    uint32 public constant MINIMUM_POLICY_DURATION = 1 weeks;
    bytes32 public constant STAKEHOLDER_ROLE = keccak256("STAKEHOLDER");
    // Policy
    struct Cover {
        string PolicyName; //Policy Name
        uint PolicyPercent; //Annual Rate
        bool PolicyActive; //to know if the policy is still in pogress
        bytes32 Agreement;
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
        address payable charityAddress;
        address proposer;
        address paidBy;
    }

    mapping(uint => Cover) private cover;
    Cover[] public _arrayCover;
    uint[] public saveId; //to save the whole ids

    struct PremiumPurchase {
        uint CoverId;
        uint TotalPeriod;
        uint CoverAmount; //Amount to be insured
        uint Premium; //Amount to be charged
        uint StartTime;
        uint EndTime;
        bool Paid;
        bool SubmitClaim;
        bool AdminVerified;
        bool Validate; //to check if the claim is valid
        uint ValidateCounter;
        address PremiumBuyerAddr; //address of the premium purchaser
        uint AmountToWithdraw; //Amount of Insured to withdraw
        // mapping(address => bool) Validate; //
    }
    address[] private Admin;
    // mapping (address => PremiumPurchase) public purchaseCoverBought;
    mapping(address => mapping(uint => PremiumPurchase)) public premiumBought;

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

    // event PolicyCancelled( address indexed holder, uint256 refundAmount );

    // event PolicyExpired(address indexed holder, uint256 amount, uint256 expiration);

    // setAmount to claim Insurance
    function setClaimAmount(uint _amount) public{
        claimInsurance = _amount;
    }

    function setDAOFee(uint _amount) public{
        DAOFEE = _amount;
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
        for (uint i = 0; i < saveId.length; i++) {
            if (saveId[i] == _coverId) {
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
}
