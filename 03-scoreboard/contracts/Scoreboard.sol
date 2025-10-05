// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ScoreBoard {
    
    // The address of the contract deployer (owner)
    address private owner;
    
    // Mapping to store each user's score
    mapping(address => uint256) public score;

    // Event to log whenever a user's score is updated
    event ScoreUpdated(address indexed user, uint256 score);

    // Constructor: sets the deployer as the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Function to allow a user to set or update their own score
    function setScore(uint256 _score) public {
        // Update the score for the sender
        score[msg.sender] = _score;

        // Emit an event to record that the score was updated
        emit ScoreUpdated(msg.sender, _score);
    }

    // Function to get a user's score by their address
    function getScore(address _addr) public view returns (uint256) {
        return score[_addr];
    }

    // Function to update multiple users' scores in one transaction
    function bulkUpdateScores(address[] calldata _users, uint256[] memory _scores) public {
        // Ensure both arrays have the same length
        require(_users.length == _scores.length, "Array length mismatch");

        // Loop through each user and update their score
        for (uint256 i = 0; i < _users.length; i++) {
            score[_users[i]] = _scores[i];

            // Emit event for each score update
            emit ScoreUpdated(_users[i], _scores[i]);
        }
    }

    // Function to find and return the highest score among a list of users
    function getTopScore(address[] memory _users) public view returns (uint256) {
        uint256 topScore = 0;

        // Loop through users to find the highest score
        for (uint256 i = 0; i < _users.length; i++) {
            uint256 currentScore = score[_users[i]];
            if (currentScore > topScore) {
                topScore = currentScore;
            }
        }

        // Return the highest score found
        return topScore;
    }
}
