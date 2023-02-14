// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract vote {

    struct Candidate {
        string name;
        uint256 upVote;
    }

    bool live;
    address owner;
    Candidate[] public candidateList;

    mapping(address => bool) Voted;

    event AddCandidate(string name);
    event UpVote(string candidate, uint256 upVote);
    event FinishVote(bool live);
    event Voting(address owner);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    modifier chkLive {  // 추가
        require(live == true);
        _;
    }

    constructor() {  // 수정
        owner = msg.sender;
        live = true;

        emit Voting(owner);
    }

    // candidate
    function addCandidate(string calldata _name) public chkLive onlyOwner { // 수정
        require(candidateList.length < 5);

        candidateList.push(Candidate(_name, 0));

        emit AddCandidate(_name);
    }

    //upVote
    function upVote(uint256 _indexOfCandidate) public chkLive {
        require(_indexOfCandidate < candidateList.length);
        require(Voted[msg.sender] == false);

        candidateList[_indexOfCandidate].upVote++;

        Voted[msg.sender] = true;

        emit UpVote(candidateList[_indexOfCandidate].name, candidateList[_indexOfCandidate].upVote);
    } 

    // finish vote
    function finishVote() public chkLive onlyOwner {
        live = false;

        emit FinishVote(live);
    }
}
