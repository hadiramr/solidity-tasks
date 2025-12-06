// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBankB {
    function deposit(address user) external payable;
    function withdraw(address user, uint256 amount) external;
    function balances(address user) external view returns (uint256);
}

contract A {
   address public owner;
   address public contractB;

    // used for delegatecall demo
    mapping(address => uint256) public balances;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function setContractB(address _contractB) external onlyOwner {
        contractB = _contractB;
    }

    // 1. Interaction using Interface
    function depositViaInterface() external payable {
        IBankB(contractB).deposit{value: msg.value}(msg.sender);
    }

    function withdrawViaInterface(uint256 amount) external {
        IBankB(contractB).withdraw(msg.sender, amount);
    }

    // 2. Interaction using Low-Level call
    function depositViaCall() external payable {
        (bool success, ) = contractB.call{value: msg.value}(
            abi.encodeWithSignature("deposit(address)", msg.sender)
        );
        require(success, "Call failed");
    }

    function withdrawViaCall(uint256 amount) external {
        (bool success, ) = contractB.call(
            abi.encodeWithSignature("withdraw(address,uint256)", msg.sender, amount)
        );
        require(success, "Call failed");
    }

    // 3. Interaction using delegatecall (dangerous on purpose for learning)
    function depositViaDelegateCall() external payable {
        (bool success, ) = contractB.delegatecall(
            abi.encodeWithSignature("deposit(address)", msg.sender)
        );
        require(success, "Delegatecall failed");
    }

    // local balance affected when using delegatecall
    function myBalance() external view returns (uint) {
        return balances[msg.sender];
    }

    receive() external payable {}
}
