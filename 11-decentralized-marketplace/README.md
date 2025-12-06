# Decentralized Marketplace

A simple on-chain marketplace where sellers list items and buyers purchase them with ETH. The marketplace owner takes a commission.

## Features
- Sellers list items (name, price, stock).
- Buyers purchase items using ETH.
- Tracks sales per item and per seller.
- Sellers withdraw their earnings.
- Marketplace owner takes a commission fee.
- Extra ETH is refunded automatically.

## Contract
- `Marketplace.sol`

## Main Functions
- `listItem(string name, uint price, uint stock)`
- `buy(uint itemId, uint quantity)`
- `withdrawEarnings()` — for sellers
- `withdrawOwner()` — for marketplace owner

## How to Test
1. Deploy `Marketplace` with a commission rate.
2. List items from different seller accounts.
3. Buy items from buyer accounts.
4. Withdraw earnings as sellers.
5. Withdraw commission as owner.

## Security
- Uses checks-effects-interactions in withdrawals.
- Validates stock, price, and payment.
