# CurrencyBank – Mini ERC-20 Demo

A simple Solidity smart contract that demonstrates the core logic behind ERC-20 tokens — minting, sending tokens, handling errors, and emitting transfer events.

## Overview

**CurrencyBank** is a beginner-friendly Solidity contract that simulates how digital currencies work inside a blockchain.  
It shows how to:
- Create new tokens (minting) by a specific address (`miner`).
- Store balances for each account using a mapping.
- Transfer tokens between users.
- Handle insufficient balance errors using custom Solidity errors.
- Emit events to track successful transactions.


## Features

- **Minting:** Only the contract creator (miner) can create new currency.
- **Send Money:** Users can transfer funds if they have enough balance.
- **Error Handling:** Uses `error insufficentValue(...)` for clear failure messages.
- **Events:** Emits `successfulTX` after every valid transfer.
