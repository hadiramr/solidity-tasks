// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract SecureCrowdfunding {
    
    address public owner;
    uint256 public fundingGoal;
    uint256 public deadline;
    uint256 public totalFundsRaised;
    bool public fundingGoalReached;
    bool public crowdfundingClosed;
    
    mapping(address => uint256) public contributions;
    
    address[] public contributors;
    mapping(address => bool) private isContributor;
    
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;
    uint256 private reentrancyStatus;
    
    event FundReceived(address contributor, uint256 amount);
    event FundWithdrawn(address owner, uint256 amount);
    event RefundIssued(address contributor, uint256 amount);
    event GoalReached(uint256 totalAmount);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier nonReentrant() {
        require(reentrancyStatus != ENTERED, "ReentrancyGuard: reentrant call");
        reentrancyStatus = ENTERED;
        _;
        reentrancyStatus = NOT_ENTERED;
    }
    
    modifier afterDeadline() {
        require(block.timestamp >= deadline, "Deadline has not passed yet");
        _;
    }
    
    modifier beforeDeadline() {
        require(block.timestamp < deadline, "Deadline has already passed");
        _;
    }
    
    constructor(uint256 _fundingGoal, uint256 _durationInMinutes) {
        require(_fundingGoal > 0, "Funding goal must be greater than 0");
        require(_durationInMinutes > 0, "Duration must be greater than 0");
        
        owner = msg.sender;
        fundingGoal = _fundingGoal;
        deadline = block.timestamp + (_durationInMinutes * 1 minutes);
        fundingGoalReached = false;
        crowdfundingClosed = false;
        reentrancyStatus = NOT_ENTERED;
    }
    

    function deposit() public payable beforeDeadline {
        require(msg.value > 0, "Must send some ETH");
        require(!crowdfundingClosed, "Crowdfunding is closed");
        
        if (!isContributor[msg.sender]) {
            contributors.push(msg.sender);
            isContributor[msg.sender] = true;
        }
        
        contributions[msg.sender] += msg.value;
        totalFundsRaised += msg.value;
        
        emit FundReceived(msg.sender, msg.value);
        
        if (totalFundsRaised >= fundingGoal && !fundingGoalReached) {
            fundingGoalReached = true;
            emit GoalReached(totalFundsRaised);
        }
    }
    

    function withdraw() public onlyOwner afterDeadline {
        require(fundingGoalReached, "Funding goal was not reached");
        require(address(this).balance > 0, "No funds to withdraw");
        require(!crowdfundingClosed, "Funds already withdrawn");
        
        uint256 amount = address(this).balance;
        crowdfundingClosed = true;
        
        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "Transfer failed");
        
        emit FundWithdrawn(owner, amount);
    }
    
    
    function refund() public afterDeadline nonReentrant {
        require(!fundingGoalReached, "Funding goal was reached, no refunds");
        require(contributions[msg.sender] > 0, "No contribution to refund");
        
        uint256 amount = contributions[msg.sender];
        
        contributions[msg.sender] = 0;
        totalFundsRaised -= amount;
        
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
        
        emit RefundIssued(msg.sender, amount);
    }
    
    function getTopContributorsPaginated(
        uint256 _startIndex, 
        uint256 _count
    ) public view returns (address[] memory addresses, uint256[] memory amounts) {
        require(_count > 0, "Count must be greater than 0");
        require(_count <= 50, "Maximum 50 items per page");
        require(_startIndex < contributors.length, "Start index out of bounds");
        
        uint256 remaining = contributors.length - _startIndex;
        uint256 itemsToReturn = remaining < _count ? remaining : _count;
        
        addresses = new address[](itemsToReturn);
        amounts = new uint256[](itemsToReturn);
        
        for (uint256 i = 0; i < itemsToReturn; i++) {
            addresses[i] = contributors[_startIndex + i];
            amounts[i] = contributions[addresses[i]];
        }
        
        return (addresses, amounts);
    }
    
    function getTopContributors(uint256 _count) public view returns (
        address[] memory topAddresses, 
        uint256[] memory topAmounts
    ) {
        require(_count > 0, "Count must be greater than 0");
        require(_count <= 20, "Maximum 20 top contributors");
        
        uint256 contributorCount = contributors.length;
        uint256 resultCount = contributorCount < _count ? contributorCount : _count;
        
        topAddresses = new address[](resultCount);
        topAmounts = new uint256[](resultCount);
        

        uint256 maxIterations = contributorCount > 1000 ? 1000 : contributorCount;
        
        for (uint256 i = 0; i < maxIterations; i++) {
            address contributor = contributors[i];
            uint256 amount = contributions[contributor];
            
            for (uint256 j = 0; j < resultCount; j++) {
                if (amount > topAmounts[j]) {
                    for (uint256 k = resultCount - 1; k > j; k--) {
                        if (k > 0) {
                            topAddresses[k] = topAddresses[k - 1];
                            topAmounts[k] = topAmounts[k - 1];
                        }
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
    

    function getContributorsPaginated(
        uint256 _startIndex, 
        uint256 _count
    ) public view returns (address[] memory) {
        require(_count > 0, "Count must be greater than 0");
        require(_count <= 100, "Maximum 100 items per page");
        require(_startIndex < contributors.length, "Start index out of bounds");
        
        uint256 remaining = contributors.length - _startIndex;
        uint256 itemsToReturn = remaining < _count ? remaining : _count;
        
        address[] memory result = new address[](itemsToReturn);
        
        for (uint256 i = 0; i < itemsToReturn; i++) {
            result[i] = contributors[_startIndex + i];
        }
        
        return result;
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
    
    function checkIsContributor(address _address) public view returns (bool) {
        return isContributor[_address];
    }
    

    function emergencyWithdraw() public onlyOwner {
        require(crowdfundingClosed || block.timestamp > deadline + 30 days, 
                "Can only emergency withdraw after 30 days past deadline");
        
        uint256 amount = address(this).balance;
        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "Emergency withdrawal failed");
    }
}
