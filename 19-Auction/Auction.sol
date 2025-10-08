// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24; 

contract Auction{
    //المزاد 
    bool isEnded;
    uint public endTime;
        //صاحب المزاد
    address payable public auctionOwner;

    uint public highestBid;
    address public highestBidder;
    mapping (address=>uint) pendingContributers;
    event highestBitInc(address bidder, uint value);
    event auctionWinner(address winner, uint amount);

    constructor(uint _timeInSecond, address payable _auctionOwner){
        endTime = block.timestamp + _timeInSecond;
        auctionOwner = _auctionOwner;

    }
    function bid() payable public {
     // المزاد لسه شغال ؟   
    if (block.timestamp > endTime) revert ("The Auction Ended");
    if (msg.value<=highestBid) revert ("you need to increase the amount");

    pendingContributers[highestBidder] += highestBid;

    highestBid = msg.value;
    highestBidder = msg.sender;

    emit highestBitInc (msg.sender, msg.value);

    }
    //الفلوس بتتحفظ في العقد
    function withDrawal() public payable returns (bool){
        uint amount = pendingContributers[msg.sender];

        if(amount > 0){
            pendingContributers[msg.sender] = 0;
        }
        if(! payable (msg.sender).send(amount)){
            pendingContributers[msg.sender] = amount;
        }
        return true;
    }
    // ننهي المزاد
    function endAuction () public {
    
        if (block.timestamp < endTime) revert ("The Auction Not Ended Yet");
        if (isEnded) revert("The Auction Ended");
        isEnded = true;
        auctionOwner.transfer(highestBid);
        emit auctionWinner(highestBidder, highestBid);
    }

    
}


