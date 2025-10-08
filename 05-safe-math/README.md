# Safe Math + Custom Errors

### Objective
Practice creating **safe mathematical operations** in Solidity to prevent integer overflow and underflow.  
I also used **custom errors** instead of regular `require` messages for better gas efficiency.


### Task Description
I  built a small **SafeMath Library** and used it in a contract called **BankAccount**.

### Requirements

#### 1. Create a Library `SafeMath`
- The library should include:
  - `function add(uint256 a, uint256 b) internal pure returns (uint256)`
  - `function sub(uint256 a, uint256 b) internal pure returns (uint256)`
  - `function mul(uint256 a, uint256 b) internal pure returns (uint256)`
  - `function div(uint256 a, uint256 b) internal pure returns (uint256)`
- Each function should:
  - Check for overflow/underflow.
  - Use **custom errors** instead of `require`.

#### 2. Create Custom Errors
`error Overflow();`
`error Underflow();`
`error DivideByZero();`


