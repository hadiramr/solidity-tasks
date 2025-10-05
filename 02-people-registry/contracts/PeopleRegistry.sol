// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract PeopleRegistry {
    struct Person {
        string name;
        uint256 age;
    }
    address private owner;

    constructor() {
        owner = msg.sender;
    }
    
    Person[] public RegistratedPeople;
    mapping(address => Person) public addressToPerson;
    event PersonRegistered(address indexed user, string name, uint256 age);
    

    function registerPerson (string memory _name , uint256 _age) public {

        //Prevent duplicate registrations (an address can only register once)
        require(
             bytes(addressToPerson[msg.sender].name).length == 0,
            "address already registered"
        );

        Person memory newPerson = Person(_name, _age);
        addressToPerson[msg.sender] = newPerson;
        RegistratedPeople.push(newPerson);
        emit PersonRegistered(msg.sender, _name, _age);

    }
    function getPerson(address _addr) public view returns (string memory,uint256) {
        require(
            bytes(addressToPerson[_addr].name).length > 0,
            "Address not registered"
        );
        return (
            addressToPerson[_addr].name, 
            addressToPerson[_addr].age
            );
    }
    function getAllPeople() public view returns (Person[] memory) {
        return RegistratedPeople;
    }
}
