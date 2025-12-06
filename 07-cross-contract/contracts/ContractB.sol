// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ContractB {
    mapping(address => uint256) public balances;
    address public authorizedCaller;

    constructor(address _authorizedCaller) {
        authorizedCaller = _authorizedCaller;
    }

    modifier onlyAuthorized() {
        require(msg.sender == authorizedCaller, "Not authorized");
        _;
    }

    // deposit on behalf of a user
    function deposit(address user) external payable onlyAuthorized {
        balances[user] += msg.value;
    }

    // withdraw for a user
    function withdraw(address user, uint256 amount) external onlyAuthorized {
        require(balances[user] >= amount, "Insufficient balance");

        // Checks → Effects → Interactions
        balances[user] -= amount;

        (bool success, ) = payable(user).call{value: amount}("");
        require(success, "Transfer failed");
    }

    // for testing balance of this contract
    function contractBalance() external view returns (uint) {
        return address(this).balance;
    }

    receive() external payable {}
}
