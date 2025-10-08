// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24; 
import "./paymentMethhod.sol";
//DONATION 
contract donation is paymentMethhod{
    //id for each
    uint public funderID;

    mapping(uint=>address)private funders;
    mapping(address=>bool)private fundersRegistered;
    
    // check that the account has sufficient value  USE REQUIRE OR MODIFIER 
    modifier accountHasBalance(){
        require((msg.sender.balance)>0,"recharge you have insufficent value");
        _;
    }


    function addFund() override external accountHasBalance payable{

        address funderAddress = msg.sender;
        //address add once even donation more than one time so we must check
        if(!fundersRegistered[funderAddress]){
            funderID++;
            funders[funderID]= funderAddress;
            fundersRegistered[funderAddress] = true;
        }
    }
    function getFunderAtIndex (uint _index) external view returns (address){
        return funders[_index];
    }


}
