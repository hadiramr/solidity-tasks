// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Election {
    address public owner;
    uint256 public deadline;
    bool public winnerDeclared;

    struct Candidate {
        uint256 id;
        bytes32 name;
    }

    mapping(uint256 => Candidate) public candidates; // candidateId => Candidate
    mapping(uint256 => uint256) public votes;        // candidateId => vote count
    mapping(address => bool) public hasVoted;        // prevent double voting

    uint256 public candidatesCount;

    event Voted(address indexed voter, uint256 indexed candidateId);
    event WinnerDeclared(uint256 indexed candidateId, uint256 voteCount);


    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyBeforeDeadline() {
        require(block.timestamp < deadline, "Voting ended");
        _;
    }

    modifier onlyAfterDeadline() {
        require(block.timestamp >= deadline, "Voting still active");
        _;
    }

    constructor(
        uint256 _durationInSeconds,
        bytes32[] memory _candidateNames
    ) {
        require(_candidateNames.length > 0, "No candidates");

        owner = msg.sender;
        deadline = block.timestamp + _durationInSeconds;

        for (uint256 i = 0; i < _candidateNames.length; i++) {
            candidates[i] = Candidate({
                id: i,
                name: _candidateNames[i]
            });
        }

        candidatesCount = _candidateNames.length;
    }

    function vote(uint256 candidateId) external onlyBeforeDeadline {
        require(!hasVoted[msg.sender], "You already voted");
        require(candidateId < candidatesCount, "Invalid candidate");

        hasVoted[msg.sender] = true;
        votes[candidateId] += 1;

        emit Voted(msg.sender, candidateId);
    }

    function getWinner()
        external
        onlyAfterDeadline
        returns (uint256 winnerId)
    {
        require(!winnerDeclared, "Winner already declared");

        uint256 highestVotes = 0;
        uint256 winnerCandidateId = 0;

        for (uint256 i = 0; i < candidatesCount; i++) {
            if (votes[i] > highestVotes) {
                highestVotes = votes[i];
                winnerCandidateId = i;
            }
        }

        winnerDeclared = true;

        emit WinnerDeclared(winnerCandidateId, highestVotes);

        return winnerCandidateId;
    }

    
    function getCandidate(uint256 id)
        external
        view
        returns (bytes32 name, uint256 voteCount)
    {
        require(id < candidatesCount, "Invalid candidate");
        return (candidates[id].name, votes[id]);
    }

    function timeLeft() external view returns (uint256) {
        if (block.timestamp >= deadline) {
            return 0;
        }
        return deadline - block.timestamp;
    }
}
