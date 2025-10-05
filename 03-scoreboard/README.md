# Scoreboard

## Objective
Learn `mapping`, and practice working with `memory` vs `calldata`.

## Requirements
- Use a **mapping** from `address` to `uint256` to store scores.
- Provide a function `setScore(uint256 _score)` to allow a user to set/update their score.
- Provide a function `getScore(address _addr)` to retrieve a user’s score.
- Provide a function `bulkUpdateScores(address[] calldata _users, uint256[] memory _scores)` to update multiple users’ scores at once.
- Ensure the arrays `_users` and `_scores` have the same length.
- Provide a function `getTopScore(address[] memory _users)` that checks among a list of users and returns the highest score.
- Emit an event `ScoreUpdated(address indexed user, uint256 score)` whenever a score is updated.
