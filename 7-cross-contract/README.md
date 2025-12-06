# Cross-Contract Interaction 

This project demonstrates how two smart contracts interact securely using:
- Interfaces
- Low-level `call`
- `delegatecall`
- Access control modifiers


## Contracts
- **ContractA**: Controller contract that calls ContractB.
- **ContractB**: Storage & logic contract protected from unauthorized access.


## Features
- Deposit & withdraw through ContractA.
- ContractB rejects direct external calls.
- Interaction using:
  - Interface
  - `call`
  - `delegatecall`


## Security
- ContractB uses `onlyAuthorized` modifier.
- Prevents malicious direct access.
- Follows checks-effects-interactions.


## How to Test 
1. Deploy ContractB.
2. Deploy ContractA with ContractB address.
3. Call deposit/withdraw from ContractA.
4. Try calling ContractB directly → should revert.

