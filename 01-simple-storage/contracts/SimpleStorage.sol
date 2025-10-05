// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
contract SimpleStorage is Ownable {
    constructor() Ownable(msg.sender) {
    }
    uint256 storedValue;
    event ValueUpdated(uint256 oldValue, uint256 newValue);
    function setValue(uint256 _NewstoredValue) public onlyOwner {
    uint256 oldValue = storedValue; 
    storedValue = _NewstoredValue;   
    emit ValueUpdated(oldValue, _NewstoredValue); 
}
    function getValue() public view returns(uint256){
        return storedValue;
    }

}