// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Insurance {
    uint id;
    struct Cover {
        string PolicyName; //Policy Name
        uint PolicyPercent; //Annual Rate
        bool PolicyActive; //to know if the policy is still in pogress
        bytes Agreement;
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
        // mapping(address => bool) Validate; //
    }
    address[] private Admin;
    // mapping (address => PremiumPurchase) public purchaseCoverBought;
    mapping(address => mapping(uint => PremiumPurchase)) public premiumBought;

    // joinDAO
    function becomeAdmin() public payable {
        require(msg.value > 0, "Insuficient Amount");
        Admin.push(msg.sender);
    }

    function CreateCover(
        string calldata _policyName,
        uint _policyPercent,
        bool _policyActive,
        bytes memory _agreement
    ) public {
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

        PremiumPurchase storage _newPremium = premiumBought[msg.sender][
            _coverId
        ];

        _newPremium.CoverId = _coverId;
        _newPremium.TotalPeriod = _totalPeriod;
        _newPremium.CoverAmount = _coverAmount;
        _newPremium.Premium = _amount;
        _newPremium.StartTime = block.timestamp;
        _newPremium.EndTime = block.timestamp + _endTime;
    }

    // Submit claim to receive insurance fee
    function submitClaim(uint _coverId) public {
        require(
            block.timestamp < premiumBought[msg.sender][_coverId].EndTime,
            "You can no longer claim reward"
        );
        premiumBought[msg.sender][_coverId].SubmitClaim = true;
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

    function approveClaim(uint _coverId, address _rewardee) public view {
        uint _adminPercent = (Admin.length * 70) / 100;
        PremiumPurchase storage _newPremium = premiumBought[_rewardee][
            _coverId
        ];
        require(
            _newPremium.ValidateCounter >= _adminPercent,
            "You can't withdraw yet "
        );
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

    function premiumActive() public {}
}
