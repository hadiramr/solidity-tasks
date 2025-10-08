# Donation Smart Contract  

A simple **Solidity-based Donation Contract** that allows users to donate Ether securely and registers each unique funder only once — even if they donate multiple times.


## Overview

This project demonstrates a basic **funding/donation system** built with Solidity.  
It allows anyone to send ETH to the contract, automatically recording their address as a funder.  
The contract inherits from `paymentMethhod.sol` to handle the payment logic and ensures that each funder is recorded once.


## Features

- Register each funder only once (no duplicates).  
- Accept ETH donations.  
- Modifier to check that an account has sufficient balance.  
- Retrieve funder by index.  
- Can be extended to include withdrawal, events, or minimum donation limits.
