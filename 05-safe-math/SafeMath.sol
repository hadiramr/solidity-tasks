// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24; 

/*
overflow
Happens when result > max uint256
beyond uint256 limit
*/ 

/*
underflow
Happens when result < 0 (for unsigned integers)
*/

library safeMath{
    // custom errors use less gas 
    error Overflow();
    error Underflow();
    error DivideByZero(); // Happens when dividing by zero

    function add(uint256 a, uint256 b) internal pure returns (uint256){
        uint256 addingResualt = a + b;
        // If result < a or < b, that means the number wrapped around (overflow)
        if((addingResualt < a )|| (addingResualt < b)) revert Overflow();
        return addingResualt;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256){
        if (b > a) revert Underflow();
        uint256 subtractingResualt = a - b;
        return subtractingResualt;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256){
        //Division by zero is undefined and must revert
        if ((a == 0)||(b == 0)) return 0;
        uint256 multiplyingResult = a * b;
        //If result / a != b → means result wrapped around and became smaller.
        if (multiplyingResult / a != b) revert Overflow();
        return multiplyingResult;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256){
        if (b==0) revert DivideByZero();
        uint256 divisionResult = a * b;
        return divisionResult;

    }
}
contract BankAccount{

    using safeMath for uint256;
    //accounts and values 
    mapping (address => uint256) private balances;

    //deposit ETH into your balance
    function deposit()external payable {
        balances[msg.sender] = balances[msg.sender].add(msg.value);
    }

    //safely withdraw funds
    function withdraw(uint256 amount) external{
        balances[msg.sender] = balances[msg.sender].sub(amount);
        payable(msg.sender).transfer(amount);

    }

    //transfer funds to another address
    function transfer(address to, uint256 amount) external{
    balances[msg.sender] = balances[msg.sender].sub(amount);
    balances[to] = balances[to].add(amount);
    }

    function getBalance(address user) external view returns (uint256) {
                return balances[user];

    }

}
