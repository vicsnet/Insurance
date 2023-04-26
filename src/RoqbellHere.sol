// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract StablecoinInsurance {
    IERC20 public stablecoin;
    uint public depegThreshold;
    uint256 public constant MAXIMUM_POLICY_DURATION = 365 days;
    
    struct Policy {
        address holder;
        uint amount;
        uint premium;
        // uint256 startTime;
        uint expiration;
        bool active;
    }
    
    Policy[] public policies;
    mapping(address => uint[]) policyIds;
    mapping(uint => uint) public payouts;

    event PolicyCreated( address indexed holder, uint256 amount, uint256 premium, uint256 expiration );

    event ClaimSubmitted( address indexed holder, uint256 amount, uint256 timestamp );

    event ClaimValidated( address indexed holder, uint256 amount, uint256 timestamp );

    event ClaimPaidOut( address indexed holder, uint256 amount, uint256 timestamp );

    event PolicyCancelled( address indexed holder, uint256 refundAmount );

    event PolicyExpired(address indexed holder, uint256 amount, uint256 expiration);
    
    constructor(address _stablecoin, uint _depegThreshold) {
        stablecoin = IERC20(_stablecoin);
        depegThreshold = _depegThreshold;
    }
    
    function createPolicy(uint _amount, uint _duration, uint _premium) external {
        require(_amount > 0, "Insured amount must be greater than zero");
        require(_duration > 0, "Policy duration must be greater than zero");
        require(_duration <= MAXIMUM_POLICY_DURATION, "Duration exceeds maximum allowed");
        require(_premium > 0, "Premium must be greater than zero");
        
        // // Calculate premium based on amount and duration
        // uint256 premium = _amount * _duration * 1e15; // premium is 0.1% of insured amount per day
        // require(msg.value >= premium, "Insufficient premium");
        stablecoin.transferFrom(msg.sender, address(this), _premium);
        uint expiration = block.timestamp + _duration;
        uint id = policies.length;
        policies.push(Policy(msg.sender, _amount, _premium, expiration, true));
        policyIds[msg.sender].push(id);

        emit PolicyCreated( msg.sender, _amount, _premium, expiration );
    }
    
    function lookupThreshold() external view returns (uint) {
        return depegThreshold;
    }
    
    function submitClaim(uint _policyId) external {
        Policy storage policy = policies[_policyId];
        require(policy.holder == msg.sender, "You are not the policy holder");
        require(policy.active, "Policy is not active");
        require(block.timestamp <= policy.expiration, "Policy has expired");
        require(stablecoin.balanceOf(address(this)) >= policy.amount, "Insufficient funds for claim");
        
        uint value = stablecoin.balanceOf(address(this)) / policy.amount;
        require(value < depegThreshold, "Stablecoin is not depegged");
        
        payouts[_policyId] = policy.amount;
        policy.active = false;

        emit ClaimSubmitted(msg.sender, policy.amount, block.timestamp);
    }
    
    function validateClaim(uint _policyId) external view returns (bool) {
        Policy storage policy = policies[_policyId];
        require(policy.holder == msg.sender, "You are not the policy holder");
        require(policy.active == false, "Policy is still active");
        return payouts[_policyId] > 0;

        emit ClaimValidated( msg.sender, policy.amount, block.timestamp );
    }
    
    function claimPayout(uint _policyId) external {
        uint payout = payouts[_policyId];
        require(payout > 0, "No payout available");
        
        payouts[_policyId] = 0;
        stablecoin.transfer(msg.sender, payout);

        emit ClaimPaidOut( msg.sender, payout.amount, block.timestamp );
    }
    
    function cancelPolicy(uint _policyId) external {
        Policy storage policy = policies[_policyId];
        require(policy.holder == msg.sender, "You are not the policy holder");
        require(policy.active, "Policy is not active");
        require(block.timestamp < policy.expiration, "Policy has expired");
        
        uint refund = policy.premium * (policy.expiration - block.timestamp) / (policy.expiration - (block.timestamp - 1));
        policy.active = false;
        stablecoin.transfer(msg.sender, refund);
        emit PolicyCancelled(msg.sender, refund);

    }

    function expirePolicy(uint _policyId) external {
        Policy storage policy = policies[_policyId];
        require(policy.holder == msg.sender, "You are not the policy holder");
        require(policy.expiration < block.timestamp, "Policy has not expired");
        require(policy.active, "Policy  is still active");

        policy.active = false;

        emit PolicyExpired(msg.sender, policy.amount, policy.expiration);
    }

}