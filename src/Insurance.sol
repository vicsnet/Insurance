// SPDX-License-Indentifier: MIT

pragma solidity ^0.8.13;

contract Insurance {
    uint id;
    uint256 public constant MAXIMUM_POLICY_DURATION = 365 days;
// Policy
    struct Cover{
        // Are we not to be the one to decide the name of the POLICY???
        string PolicyName; //Policy Name 
        uint PolicyPercent; //Annual Rate
        bool PolicyActive; //to know if the policy is still in pogress
        bytes Agreement;
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
        bool AdminVerified; 
        bool Validate; //to check if the claim is valid
        // mapping(address => bool) Validate; //

    }


    uint id;
    uint256 public constant MAXIMUM_POLICY_DURATION = 365 days;
    // Policy

    // Why is the key of this mapping not "Address of the customer (msg.sender)"
    mapping(uint => Cover) private cover; 
    Cover[] public _arrayCover; 
    uint[] public saveId; //to save the whole ids


    address[] private Admin;
// mapping (address => PremiumPurchase) public purchaseCoverBought;
    mapping(address => mapping(uint => PremiumPurchase)) public premiumBought;


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
        }
        require(isAdmin, "Only Dao member can create policy");

        Cover memory newCover = Cover({
            PolicyName : _policyName,
            PolicyPercent: _policyPercent,
            PolicyActive: _policyActive,
            Agreement: _agreement
        });
        cover[id] = newCover;
        _arrayCover.push(newCover);
        saveId.push(id);

    }

// buy premium
    function purchasePremium(uint _coverId, uint _totalPeriod, uint _coverAmount, uint _endTime, uint _amount) public {
        bool isCoverId = false;
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

         PremiumPurchase storage _newPremium = premiumBought[msg.sender][_coverId];

         _newPremium.CoverId = _coverId;
         _newPremium.TotalPeriod = _totalPeriod;
         _newPremium.CoverAmount = _coverAmount;
         _newPremium.Premium = _amount;
         _newPremium.StartTime = block.timestamp;
         _newPremium.EndTime = block.timestamp + _endTime;


    }

// Submit claim to receive insurance fee
    function submitClaim(uint _coverId) public {
        require(block.timestamp < premiumBought[msg.sender][_coverId].EndTime, "You can no longer claim reward");
        premiumBought[msg.sender][_coverId].SubmitClaim= true;
    }

// to validate reward it determines if the inured amount is to be paid or not
    function validateClaim(uint _coverId, address _rewardee, bool _validate) public{

         PremiumPurchase storage _newPremium = premiumBought[_rewardee][_coverId];

         _newPremium.Validate = _validate;
         if(_validate == true){
            _newPremium.ValidateCounter +=1;
         }
    }


    function approveClaim(uint _coverId, address _rewardee) public view{
        uint _adminPercent = (Admin.length * 70)/100;
         PremiumPurchase storage _newPremium = premiumBought[_rewardee][_coverId];
        require(_newPremium.ValidateCounter >= _adminPercent, "You can't withdraw yet ");

    }

    function renewPolicy(uint _coverId, address _rewardee, uint _endTime, uint _coverAmount, uint _amount) public{
         PremiumPurchase storage _newPremium = premiumBought[_rewardee][_coverId];

         require(block.timestamp <= _newPremium.EndTime, "You can no longer renew this policy");

         _newPremium.EndTime += _endTime; 
         _newPremium.CoverAmount = _coverAmount;
        _newPremium.Premium +=_amount;
    }


    function premiumActive() public{
        
    }
}
