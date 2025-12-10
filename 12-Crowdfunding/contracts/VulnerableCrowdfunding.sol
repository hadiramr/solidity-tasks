// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableCrowdfunding {
    
    address public owner;
    uint256 public fundingGoal;
    uint256 public deadline;
    uint256 public totalFundsRaised;
    bool public fundingGoalReached;
    bool public crowdfundingClosed;
    
    mapping(address => uint256) public contributions;
    
    address[] public contributors;
    
    event FundReceived(address contributor, uint256 amount);
    event FundWithdrawn(address owner, uint256 amount);
    event RefundIssued(address contributor, uint256 amount);
    event GoalReached(uint256 totalAmount);

    constructor(uint256 _fundingGoal, uint256 _durationInMinutes) {
        owner = msg.sender;
        fundingGoal = _fundingGoal;
        deadline = block.timestamp + (_durationInMinutes * 1 minutes);
        fundingGoalReached = false;
        crowdfundingClosed = false;
    }
    
    
    modifier afterDeadline() {
        require(block.timestamp >= deadline, "Deadline has not passed yet");
        _;
    }
    
    
    modifier beforeDeadline() {
        require(block.timestamp < deadline, "Deadline has already passed");
        _;
    }
   

    function deposit() public payable beforeDeadline {
        require(msg.value > 0, "Must send some ETH");
        require(!crowdfundingClosed, "Crowdfunding is closed");
        
        if (contributions[msg.sender] == 0) {
            contributors.push(msg.sender);
        }
        
        contributions[msg.sender] += msg.value;
        totalFundsRaised += msg.value;
        
        emit FundReceived(msg.sender, msg.value);
        
        if (totalFundsRaised >= fundingGoal) {
            fundingGoalReached = true;
            emit GoalReached(totalFundsRaised);
        }
    }
    
   
    function withdraw() public afterDeadline {
        require(fundingGoalReached, "Funding goal was not reached");
        require(address(this).balance > 0, "No funds to withdraw");
        
        uint256 amount = address(this).balance;
        crowdfundingClosed = true;
        
        payable(msg.sender).transfer(amount);
        emit FundWithdrawn(msg.sender, amount);
    }
    
    
    function refund() public afterDeadline {
        require(!fundingGoalReached, "Funding goal was reached, no refunds");
        require(contributions[msg.sender] > 0, "No contribution to refund");
        
        uint256 amount = contributions[msg.sender];
        
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        
        contributions[msg.sender] = 0;
        totalFundsRaised -= amount;
        
        emit RefundIssued(msg.sender, amount);
    }
    

    function getTopContributors(uint256 _count) public view returns (address[] memory, uint256[] memory) {
        require(_count > 0 && _count <= contributors.length, "Invalid count");
        
        address[] memory topAddresses = new address[](_count);
        uint256[] memory topAmounts = new uint256[](_count);
        

        for (uint256 i = 0; i < contributors.length; i++) {
            address contributor = contributors[i];
            uint256 amount = contributions[contributor];
            
            for (uint256 j = 0; j < _count; j++) {
                if (amount > topAmounts[j]) {
                    // Shift elements down
                    for (uint256 k = _count - 1; k > j; k--) {
                        topAddresses[k] = topAddresses[k - 1];
                        topAmounts[k] = topAmounts[k - 1];
                    }
                    topAddresses[j] = contributor;
                    topAmounts[j] = amount;
                    break;
                }
            }
        }
        
        return (topAddresses, topAmounts);
    }
    

    function getContributorCount() public view returns (uint256) {
        return contributors.length;
    }
    

    function getAllContributors() public view returns (address[] memory) {
        return contributors;
    }
    
    function checkDeadline() public view returns (bool) {
        return block.timestamp >= deadline;
    }
    
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
 
    function getRemainingTime() public view returns (uint256) {
        if (block.timestamp >= deadline) {
            return 0;
        }
        return deadline - block.timestamp;
    }
    
    function getContribution(address _contributor) public view returns (uint256) {
        return contributions[_contributor];
    }
}
