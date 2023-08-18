//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract VotingContract
{
  mapping(string=>uint256) public candidateVotes;
  mapping(address=>bool) public hasVotes;

  string[] public candidateList;

  function addCandidates(string[] memory _candidates) public
  {
    require(candidateList.length==0, "Candidates can only be added once.");
    candidateList = _candidates;
  }

  function vote(string memory _candidate) public
  {
    require(bytes(_candidate).length>0, "Candidate name cannot be empty.");
    require(candidateVotes[_candidate]>=0, "Candidate does not exist.");
    require(!hasVoted[msg.sender], "You have already voted.");

    candidateVotes[_candidate]++;
    hasVoted[msg.sender]=true;
  }

  function getTotalVotesForCandidate(string memory _candidate) public view returns(uint256)
  {
    return candidateVotes[_candidate];
  }
}
