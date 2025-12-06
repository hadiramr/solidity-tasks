# Decentralized Voting System (Election)

A simple Ethereum-based voting system where users can vote once for a candidate within a fixed time window.

## Features
- Owner creates candidates at deployment.
- Users can vote only once.
- Voting ends after a deadline.
- Winner is calculated after voting ends.
- Events emitted for voting and winner declaration.
- Gas optimized using mappings.

## Contract
- `Election.sol`

## Main Functions
- `vote(uint candidateId)` — vote for a candidate.
- `getWinner()` — returns the winning candidate after deadline.
- `getCandidate(uint id)` — view candidate data.

## How to Test
1. Deploy `Election` with:
   - Voting duration.
   - Candidate names.
2. Vote using different accounts.
3. Wait for deadline.
4. Call `getWinner()` to get the result.

## Security
- Modifier prevents voting after deadline.
- Prevents double voting using mapping.

