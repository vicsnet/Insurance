// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Insurance {
    uint id;
    uint256 public constant MAXIMUM_POLICY_DURATION = 365 days;
// Policy
    struct Cover{
        string PolicyName; //Policy Name
        uint PolicyPercent; //Annual Rate
        bool PolicyActive; //to know if the policy is still in pogress
        bytes32 Agreement;
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
    event PolicyPurchased( address indexed holder, uint256 coverAmount, uint256 premium, uint256 indexed coverid, uint256 indexed expiration );

    event ClaimSubmitted( address indexed holder, uint256 amount, uint256 timestamp );

    // event ClaimValidated( address indexed holder, uint256 amount, uint256 timestamp );

    event ClaimPaidOut( address indexed holder, uint256 indexed amount, uint256 indexed timestamp );

    // event PolicyCancelled( address indexed holder, uint256 refundAmount );

    // event PolicyExpired(address indexed holder, uint256 amount, uint256 expiration);

// joinDAO
function becomeAdmin() public payable{
    require(msg.value > 0, "Insuficient Amount");
    Admin.push(msg.sender);

}

// to create policy
    function CreateCover(string calldata _policyName, uint _policyPercent, bool _policyActive, bytes32 _agreement) public {
        bool isAdmin = false;
        id += 1;
        for (uint i = 0; i < Admin.length; i++) {
            if (Admin[i] == msg.sender) {
                isAdmin = true;
                break;
            }
        }
        require(isAdmin, "Only Dao member can create policy");

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
        uint _amount
    ) public {
        bool isCoverId = false;
        for (uint i = 0; i < saveId.length; i++) {
            if (saveId[i] == _coverId) {
                isCoverId = true;
                break;
            }
        }
        require(isCoverId, "This Id does not exist");
        uint _percent = cover[_coverId].PolicyPercent;
        uint premiumTobePaid = _coverAmount * _percent;
        require(_amount >= premiumTobePaid, "Insufficient Amount");

        // PremiumPurchase memory newPremiumPurchase = PremiumPurchase({CoverId: _coverId, TotalPeriod:_totalPeriod, CoverAmount: _coverAmount, Premium:_amount, StartTime: _startTime, EndTime: _endTime, Paid:false, SubmitClaim: false,AdminVerified: false, Validate:false });
        // premiumBought[msg.sender][_coverId] =newPremiumPurchase;

uint _startTime = block.timestamp;
uint expireTime = _startTime + _endTime;
         PremiumPurchase storage _newPremium = premiumBought[msg.sender][_coverId];
         _newPremium.CoverId = _coverId;
         _newPremium.TotalPeriod = _totalPeriod;
         _newPremium.CoverAmount = _coverAmount;
         _newPremium.Premium = _amount;
         _newPremium.StartTime = _startTime;
         _newPremium.EndTime = expireTime;
         _newPremium.PremiumBuyerAddr = msg.sender;
         emit PolicyPurchased(msg.sender, _coverAmount, _amount, _coverId, expireTime);



    }

// Submit claim to receive insurance fee
    function submitClaim(uint _coverId, address _premiumBuyerAddr, uint _amount) public {
        PremiumPurchase storage _newPremium = premiumBought[_premiumBuyerAddr][_coverId];
        require(_newPremium.PremiumBuyerAddr == msg.sender, "YOU_ARE_NOT_THE_POLICY_HOLDER");

        require(block.timestamp < _newPremium.EndTime, "POLICY_IS_NO_LONGER_ACTIVE");
        require(_amount <= _newPremium.CoverAmount, "YOU_CAN_NOT_WITHDRAW_MORE_THAN_YOU_HAVE_INSURED");
        _newPremium.SubmitClaim = true;
        _newPremium.AmountToWithdraw = _amount; 

        emit ClaimSubmitted(_premiumBuyerAddr, _amount, block.timestamp);
    }

    // to validate reward it determines if the inured amount is to be paid or not
    function validateClaim(
        uint _coverId,
        address _rewardee,
        bool _validate
    ) public {
        PremiumPurchase storage _newPremium = premiumBought[_rewardee][
            _coverId
        ];

        _newPremium.Validate = _validate;
        if (_validate == true) {
            _newPremium.ValidateCounter += 1;
        }
    }


    function approveClaim(uint _coverId, address _rewardee) public {
        uint _adminPercent = (Admin.length * 70)/100;
         PremiumPurchase storage _newPremium = premiumBought[_rewardee][_coverId];
        require(_newPremium.ValidateCounter >= _adminPercent, "You can't withdraw yet ");
       uint AmountLeft =   _newPremium.CoverAmount - _newPremium.AmountToWithdraw; 

       //logic to transfer the token worth

       _newPremium.CoverAmount = AmountLeft;
       
       emit ClaimPaidOut(_rewardee, _newPremium.AmountToWithdraw, block.timestamp);



    }

    function renewPolicy(
        uint _coverId,
        address _rewardee,
        uint _endTime,
        uint _coverAmount,
        uint _amount
    ) public {
        PremiumPurchase storage _newPremium = premiumBought[_rewardee][
            _coverId
        ];

        require(
            block.timestamp <= _newPremium.EndTime,
            "You can no longer renew this policy"
        );

        _newPremium.EndTime += _endTime;
        _newPremium.CoverAmount = _coverAmount;
        _newPremium.Premium += _amount;
    }


    function premiumActive(uint _coverId, address _rewardee) public view returns(bool){
                 PremiumPurchase memory _newPremium = premiumBought[_rewardee][_coverId];
     
        if(block.timestamp > _newPremium.EndTime || _newPremium.Paid == false){
            return false;
        }
        return true;

    }
}
