const { ethers } = require("hardhat");
const {
  abi: EncryptenAbi,
} = require("../artifacts/contracts/Encrypten.sol/Encrypten.json");

/** LIST OF FUNCTIONS
 * create proposal function
 * vote
 * revealAdmin
 * getTotalNoOfProposals
 * getProposalDetails
 * checkHasVoted
 * checkMemberInfo
 */

const encryptenAddress = "";
const signer = ethers.getSigners();
const EncryptenContract = new ethers.Contract(
  encryptenAddress,
  EncryptenAbi,
  signer
);

/////////////////// [WRITABLE FUNCTIONS] ///////////////////
// create proposal function
async function createProposal(description, duration) {
  try {
    console.log("Calling createProposal...");
    const createProposal = await EncryptenContract.createProposal(
      description,
      duration
    );
    await createProposal.wait(1);
    console.log("Proposal created successfully...");

    return true;
  } catch (err) {
    console.log(err);
    return false;
  }
}

/**
 *
 * @param {number} proposalId
 * @param {boolean} voteDecision true - for a vote in support or false - for a vote against
 */
async function vote(proposalId, voteDecision) {
  try {
    console.log("Calling vote...");
    const vote = await EncryptenContract.vote(proposalId, voteDecision);
    vote.wait(1);

    console.log("Vote successful");
    return true;
  } catch (err) {
    console.log(err);
    return false;
  }
}

//////////////////////// [VIEW FUNCTIONS] ////////////////////////
/**
 * reveal admin function
 * @returns {address}
 */
async function revealAdmin() {
  try {
    console.log("Calling revealAdmin...");
    const revealAdmin = await EncryptenContract.revealAdmin();

    console.log(revealAdmin);
    return revealAdmin;
  } catch (err) {
    console.log(err);
  }
}

/**
 * getTotalNoOfProposals function
 * @returns {number}
 */
async function getTotalNoOfProposals() {
  try {
    console.log("Calling revealAdmin...");
    const proposalCount = await EncryptenContract.getTotalNoOfProposals();

    console.log(proposalCount);
    return proposalCount;
  } catch (err) {
    console.log(err);
  }
}

/**
 * getProposalDetails function
 * @param {numer}
 * @returns {number}
 */
async function getProposalDetails(proposalId) {
  try {
    console.log("Calling getProposalDetails...");
    const proposalDetails = await EncryptenContract.getProposalDetails(
      proposalId
    );

    console.log(proposalDetails);
    return proposalDetails;
  } catch (err) {
    console.log(err);
  }
}

/**
 * checkHasVoted function
 * @returns {number}
 */
async function checkHasVoted(proposalId, memberAddress) {
  try {
    console.log("Calling checkHasVoted...");
    const voteStatus = await EncryptenContract.checkHasVoted(
      proposalId,
      memberAddress
    );

    console.log(voteStatus);
    return voteStatus;
  } catch (err) {
    console.log(err);
  }
}

/**
 * checkMemberInfo function
 * @returns {*}
 */
async function checkMemberInfo(memberAddress) {
  try {
    console.log("Calling checkMemberInfo...");
    const memberInfo = await EncryptenContract.checkMemberInfo(memberAddress);

    console.log(memberInfo);
    return memberInfo;
  } catch (err) {
    console.log(err);
  }
}
