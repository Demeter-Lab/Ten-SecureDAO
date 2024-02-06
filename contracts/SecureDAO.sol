// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DAOVoting {
    address public admin;
    uint256 public proposalCount;

    enum ProposalStatus {
        Pending,
        Approved,
        Rejected
    }

    struct Proposal {
        uint256 id;
        string description;
        uint256 forVotes;
        uint256 againstVotes;
        uint256 startTime;
        uint256 endTime;
        ProposalStatus status;
    }

    mapping(uint256 => mapping(address => bool)) private _voters;
    mapping(uint256 => Proposal) private _proposals;

    // Public event
    event ProposalCreated(
        uint256 indexed id,
        string description,
        uint256 startTime,
        uint256 endTime
    );
    // Private event
    event Voted(
        uint256 indexed proposalId,
        address indexed voter,
        bool support
    );

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    modifier validProposal(uint256 _proposalId) {
        require(
            _proposalId > 0 && _proposalId <= proposalCount,
            "Invalid proposal ID"
        );
        _;
    }

    // modifier notVoted(uint256 _proposalId) {
    //     // require(!_proposals[_proposalId].hasVoted[msg.sender], "Already voted");
    //     _;
    // }

    constructor() {
        admin = msg.sender;
    }

    function createProposal(
        string memory _description,
        uint256 _durationInMinutes
    ) external onlyAdmin {
        proposalCount++;
        uint256 startTime = block.timestamp;
        uint256 endTime = startTime + (_durationInMinutes * 1 minutes);

        _proposals[proposalCount] = Proposal({
            id: proposalCount,
            description: _description,
            forVotes: 0,
            againstVotes: 0,
            startTime: startTime,
            endTime: endTime,
            status: ProposalStatus.Pending
        });

        emit ProposalCreated(proposalCount, _description, startTime, endTime);
    }

    function vote(
        uint256 _proposalId,
        bool _support
    ) external validProposal(_proposalId) {
        //notVoted(_proposalId)
        Proposal storage proposal = _proposals[_proposalId];
        require(
            block.timestamp >= proposal.startTime &&
                block.timestamp <= proposal.endTime,
            "Voting is closed!"
        );

        if (_support) {
            proposal.forVotes++;
        } else {
            proposal.againstVotes++;
        }

        // proposal.hasVoted[msg.sender] = true;

        emit Voted(_proposalId, msg.sender, _support);
    }

    function getProposalDetails(
        uint256 _proposalId
    )
        external
        view
        validProposal(_proposalId)
        returns (
            string memory description,
            uint256 forVotes,
            uint256 againstVotes,
            uint256 startTime,
            uint256 endTime,
            ProposalStatus status
        )
    {
        Proposal storage proposal = _proposals[_proposalId];
        return (
            proposal.description,
            proposal.forVotes,
            proposal.againstVotes,
            proposal.startTime,
            proposal.endTime,
            proposal.status
        );
    }
}
