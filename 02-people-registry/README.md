# People Registry

## Objective
Practice using `struct`, `array`, and `mapping`.

## Requirements
- Define a `struct Person` with at least the following fields:
  - `string name`
  - `uint256 age`
- Maintain a **dynamic array** of all registered people.
- Maintain a **mapping** from an Ethereum address to `Person`.
- Provide a function `registerPerson(string memory _name, uint256 _age)` to register a person.
- Prevent duplicate registrations (an address can only register once).
- Provide a function `getPerson(address _addr)` that returns the person’s info.
- Provide a function `getAllPeople()` that returns the array of registered people.
- Emit an event `PersonRegistered(address indexed user, string name, uint256 age)` when someone registers.
