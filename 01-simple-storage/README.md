# Simple Storage Contract

## Objective
Learn how state variables work and practice basic access control.

## Requirements
- The contract should have a **single state variable** (e.g., `uint256 storedValue`) that stores a number.
- Provide a function `setValue(uint256 _value)` to update the stored number.
- Provide a function `getValue()` that returns the stored number.
- Implement **access control** so only the contract deployer (owner) can update the value.
- Events should be emitted whenever the value changes (e.g., `ValueUpdated(oldValue, newValue)`).
