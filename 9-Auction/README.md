# Smart Auction Contract  

A simple **Solidity-based Auction Contract** that allows users to bid with Ether (ETH).  
The highest bidder wins when the auction ends, and all other participants can withdraw their pending bids.

## Overview

This contract implements a **decentralized auction system** where:
- An auction owner starts the auction with a specific duration.
- Participants can place bids that are higher than the previous highest bid.
- Once the auction ends, the owner receives the highest bid amount.
- All non-winning bidders can withdraw their funds safely.


## Features

Create an auction with a time limit  
Accept bids in ETH  
Track the **highest bidder** and **highest bid amount**  
Allow safe withdrawal of previous bids  
Emit events when bids are updated or the auction ends  

