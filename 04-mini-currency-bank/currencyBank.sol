// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24; 
contract currencyBank {
    //ERC-20 Standered mini Demo 
    address public miner ;
    mapping (address=> uint)public accountBalances ;// كل حساب عنده قد ايه فلوس 
    constructor() {
        miner = msg.sender;
    }
    //create money for the first time وجدت العملة
    //عملة بدون اسم 
    // miner only not for normal users 
    function mine(address receiver , uint amount)  public {
        require(msg.sender == miner);
        accountBalances[receiver] += amount; // زود الفلوس على فلوسه
    }
    //error 
    error insufficentValue(uint amountRequested, uint avalibleAmount);
    event successfulTX (address from, address to, uint valueSent);

    // sending money 
    // هل الفلوس اللي حيبعتها القيمه في حسابه تكفيها اصلا ؟
    function sendMoney(address receiver, uint amount)public {

        //require(condition); CAN BE USED 
        //revert رد ارجع -> بتاخد اوبجيكت 
        if(amount > accountBalances[msg.sender])
            //سبب الرفض 
            revert insufficentValue({
                amountRequested: amount , 
                avalibleAmount: accountBalances[msg.sender]
            });

            // طيب لو الفلوس تكفي ؟
            accountBalances[msg.sender] -= amount;
            accountBalances[receiver] += amount;
            //كله تمام ابعت بقى بلغني 
            emit successfulTX(msg.sender,receiver,amount);
        
    }
}
