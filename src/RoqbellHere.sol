// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";

contract AutoInsurance is AccessControl, Ownable {
    
    struct Policy {
        address policyHolder;
        uint premiumAmount;
        uint coverageAmount;
        uint durationInDays;
        uint startTime;
        uint endTime;
        bool isActive;
    }
    
    mapping(address => Policy) policies;
    
    uint public maxCoverageAmount = 100 ether;
    uint public maxDurationInDays = 365;
    
    event PolicyCreated(address indexed policyHolder, uint premiumAmount, uint coverageAmount, uint durationInDays);
    event PolicyCanceled(address indexed policyHolder);
    event PolicyPayout(address indexed policyHolder, uint amount);
    
    function createPolicy(uint _coverageAmount, uint _durationInDays) public payable {
        require(msg.value > 0, "Premium amount must be greater than 0");
        require(_coverageAmount > 0 && _coverageAmount <= maxCoverageAmount, "Coverage amount must be between 0 and maxCoverageAmount");
        require(_durationInDays > 0 && _durationInDays <= maxDurationInDays, "Duration must be between 0 and maxDurationInDays");
        
        Policy storage policy = policies[msg.sender];
        require(!policy.isActive, "Policy already active");
        
        policy.policyHolder = msg.sender;
        policy.premiumAmount = msg.value;
        policy.coverageAmount = _coverageAmount;
        policy.durationInDays = _durationInDays;
        policy.startTime = block.timestamp;
        policy.endTime = block.timestamp + (_durationInDays * 1 days);
        policy.isActive = true;
        
        emit PolicyCreated(msg.sender, msg.value, _coverageAmount, _durationInDays);
    }
    
    function cancelPolicy() public {
        Policy storage policy = policies[msg.sender];
        require(policy.isActive, "Policy not active");
        
        payable(msg.sender).transfer(policy.premiumAmount);
        
        policy.isActive = false;
        
        emit PolicyCanceled(msg.sender);
    }
    
    function getPolicy(address _policyHolder) public view returns (uint premiumAmount, uint coverageAmount, uint durationInDays, uint startTime, uint endTime, bool isActive) {
        Policy storage policy = policies[_policyHolder];
        return (policy.premiumAmount, policy.coverageAmount, policy.durationInDays, policy.startTime, policy.endTime, policy.isActive);
    }
    
    function payout() public {
        Policy storage policy = policies[msg.sender];
        require(policy.isActive, "Policy not active");
        require(block.timestamp > policy.endTime, "Policy not expired");
        
        uint payoutAmount = policy.premiumAmount + (policy.coverageAmount * 2);
        payable(msg.sender).transfer(payoutAmount);
        
        policy.isActive = false;
        
        emit PolicyPayout(msg.sender, payoutAmount);
    }
    
    function setMaxCoverageAmount(uint _maxCoverageAmount) public {
        maxCoverageAmount = _maxCoverageAmount;
    }
    
    function setMaxDurationInDays(uint _maxDurationInDays) public {
        maxDurationInDays = _maxDurationInDays;
    }
    
}
