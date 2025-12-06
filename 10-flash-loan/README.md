# Flash Loan & Reentrancy Practice

This project demonstrates a vulnerable lending pool that can be exploited using a reentrancy attack, and a fixed secure version.

## Contracts
- `VulnerableLendingPool.sol`  
  - Users deposit ETH.
  - Users withdraw ETH (contains reentrancy vulnerability).
  - Provides a simple flash loan with a small fee.
- `Attacker.sol`  
  - Exploits the vulnerable withdraw logic to drain funds.
- `FixedLendingPool.sol`  
  - Secure version using checks-effects-interactions or reentrancy guard.

## Learning Goals
- Understand reentrancy attacks.
- Learn how flash loans work.
- Apply security fixes (CEI pattern, reentrancy guard).

## How to Test (Remix)
1. Deploy `VulnerableLendingPool`.
2. Deposit ETH from multiple accounts.
3. Deploy `Attacker` with pool address.
4. Call `attack()` and observe drained balance.
5. Deploy `FixedLendingPool` and repeat to confirm the attack fails.

## Security Note
This project is for educational purposes only. Never deploy vulnerable contracts to mainnet.

