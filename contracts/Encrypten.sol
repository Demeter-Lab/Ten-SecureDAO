// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Encrypten {
    address private _admin;
    uint256 private proposalCount;

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

    /// @notice A Struct to track proposal voters
    /// @dev Struct tracks each member's Data
    struct Member {
        uint256 proposalsCreated;
        uint256 proposalsParticipatedIn;
        bool voted;
    }

    mapping(uint256 => Proposal) private _proposals;
    mapping(address => Member) private _members;
    mapping(uint256 => mapping(address => bool)) private _hasVoted;

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
        address indexed member,
        bool support
    );

    modifier onlyAdmin() {
        require(msg.sender == _admin, "Not authorized");
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
    //     require(!_hasVoted[_proposalId][msg.sender], "Already Voted!");
    //     _;
    // }

    constructor() {
        _admin = msg.sender;
    }

    /// SHOULD WE MAKE THIS FUNCTION AVAILABLE TO ALL?
    function createProposal(
        string memory _description,
        uint256 _durationInMinutes
    ) external onlyAdmin {
        proposalCount++;
        uint256 startTime = block.timestamp;
        uint256 endTime = startTime + (_durationInMinutes * 1 minutes);

        // create new proposal
        _proposals[proposalCount] = Proposal({
            id: proposalCount,
            description: _description,
            forVotes: 0,
            againstVotes: 0,
            startTime: startTime,
            endTime: endTime,
            status: ProposalStatus.Pending
        });

        // update members data
        _members[msg.sender].proposalsCreated++;

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
        require(!_hasVoted[_proposalId][msg.sender], "Already Voted!");

        if (_support) {
            proposal.forVotes++;
        } else {
            proposal.againstVotes++;
        }

        // internally check if a member has already voted
        _hasVoted[_proposalId][msg.sender] = true;
        // update member's data
        _members[msg.sender].proposalsParticipatedIn++;

        emit Voted(_proposalId, msg.sender, _support);
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////// GETTER FUNCTIONS ////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    function revealAdmin() public view returns (address) {
        return _admin;
    }

    function getTotalNoOfProposals() public view returns (uint256) {
        return proposalCount;
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

    /// @dev checks if a member has voted on a specified proposal
    /// @notice only the member can access this data
    function checkHasVoted(
        uint256 _proposalId,
        address _memberAddress
    ) public view validProposal(_proposalId) returns (bool) {
        require(
            msg.sender == _memberAddress,
            "Unauthorized: Can't access this data!"
        );
        return _hasVoted[_proposalId][_memberAddress];
    }

    /// @notice only the member can access this data
    function checkMemberInfo(
        address _memberAddress
    )
        public
        view
        returns (uint256 proposalsCreated, uint256 proposalsParticipatedIn)
    {
        require(
            msg.sender == _memberAddress,
            "Unauthorized: Can't access this data!"
        );
        Member storage member = _members[msg.sender];
        return (member.proposalsCreated, member.proposalsParticipatedIn);
    }
}
