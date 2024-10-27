// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ownable.sol";
import "./ierc20.sol";

interface IOmnicoin {
    function remintBurntCoins(address _recipient) external;

    function changeOmnifyAddress(address newAddress) external;
}

contract Omnify is Ownable {
    uint256 internal MAXUINT = 2 ** 256 - 1;

    constructor(uint8 _paramNativeDecimals, uint256 _paramProposalFee) Ownable(msg.sender) {
        nativeCoinDecimals = _paramNativeDecimals;
        proposalFee = _paramProposalFee;
        distributionRoundInterval = 3 days;
        coinHoldingPeriod = 4 days;
        proposalVotingPeriod = 3 days;
    }

    event NewMilestoneEvent(uint256 _count, string _title, string _description, uint256 _date);
    event NewProposalEvent(uint256 _count, string _title, string _description, address _proposer, uint256 _date);

    struct Proposal {
        address proposer;
        string title;
        string description;
        uint256 date;
        uint24 yesVotes;
        uint24 noVotes;
        mapping(address => bool) votes;
        mapping(address => bool) yesVoteAddresses;
        mapping(address => bool) noVoteAddresses;
    }

    struct Milestone {
        string title;
        string description;
        uint256 date;
    }

    struct DistributionRound {
        uint256 feesCollected;
        uint256 roundNumber;
        uint256 profitPerShare;
        uint256 amountWithdrawn;
        uint256 amountRemaining;
        mapping(address => bool) hasWithdrawn;
        uint256 date;
        bool roundOpen;
    }

    mapping(address => uint256) public dateCoinsReceived;
    mapping(address => uint256) public addressProfits;
    uint256 public proposalCount = 1;
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => Milestone) public milestones;
    mapping(uint256 => DistributionRound) public distributionRounds;
    mapping(address => bool) public whitelistedExternalContracts;
    uint256 public proposalFee;
    uint256 public totalProfitsDistributed;
    uint256 public currentProfitsCollected;
    uint256 public totalProfitsCollected;
    address public omniCoinAddress;
    uint256 public milestoneCount = 1;
    uint256 public currentRoundNumber = 0;
    uint256 public coinHoldingPeriod;
    uint256 public proposalVotingPeriod;
    uint256 public distributionRoundInterval;
    uint8 public nativeCoinDecimals;
    address public keeperAddress;
    address public feeKeeperAddress;
    address public coinsaleAddress;

    modifier onlyOmniCoin(address _sender) {
        require(_sender == omniCoinAddress);
        _;
    }

    modifier onlyKeeper(address _sender) {
        require(_sender == keeperAddress);
        _;
    }

    modifier onlyFeeKeeper(address _sender) {
        require(_sender == feeKeeperAddress);
        _;
    }

    function setOmniCoinAddress(address _omniCoinAddress) external onlyOwner {
        omniCoinAddress = _omniCoinAddress;
    }

    function setCoinsaleAddress(address _coinsale) external onlyOwner {
        coinsaleAddress = _coinsale;
    }

    function setKeeperAddress(address _keeper) external onlyOwner {
        keeperAddress = _keeper;
    }

    function setFeeKeeperAddress(address _feeKeeper) external onlyOwner {
        feeKeeperAddress = _feeKeeper;
    }

    function whitelistAddress(address _contract) external onlyOwner {
        whitelistedExternalContracts[_contract] = true;
    }

    function removeAddressWhitelist(address _contract) external onlyOwner {
        whitelistedExternalContracts[_contract] = false;
    }

    function addProfitsFromExternalContract() external payable {
        require(whitelistedExternalContracts[msg.sender] == true);
        currentProfitsCollected = safeAdd(currentProfitsCollected, msg.value);
    }

    function checkIfContractWhiteListed(address _contract) external view returns (bool) {
        return whitelistedExternalContracts[_contract];
    }

    function setProposalFee(uint256 _fee) public onlyOwner {
        proposalFee = _fee;
    }

    function setProposalFeeByFeeKeeper(uint256 _fee) public onlyFeeKeeper(msg.sender) {
        proposalFee = _fee;
    }

    function _setCoinHoldingPeriod(uint256 _period) internal onlyOwner {
        require(_period > 0);
        require(_period >= distributionRoundInterval + 1 days);
        require(_period != coinHoldingPeriod);
        coinHoldingPeriod = _period;
    }

    function _setDistributionRoundInterval(uint256 _interval) internal onlyOwner {
        require(_interval >= 1 days);
        require(distributionRoundInterval != _interval);
        distributionRoundInterval = _interval;
    }

    function setHoldingAndRoundInterval(uint256 _holdingPeriod, uint256 _interval) external onlyOwner {
        _setDistributionRoundInterval(_interval);
        _setCoinHoldingPeriod(_holdingPeriod);
    }

    function setCoinsReceivedDate(address _recipient) external onlyOmniCoin(msg.sender) {
        dateCoinsReceived[_recipient] = block.timestamp;
    }

    function lookupAddressProfits(address _address) public view returns (uint256) {
        return addressProfits[_address];
    }

    function lookupHasWithdrawnFromRound(uint256 _roundNumber, address _address) public view returns (bool) {
        return distributionRounds[_roundNumber].hasWithdrawn[_address];
    }

    function lookupMilestone(uint256 _count) public view returns (Milestone memory) {
        return milestones[_count];
    }

    function lookupMilestones() public view returns (Milestone[] memory) {
        Milestone[] memory _milestones = new Milestone[](milestoneCount);
        if (milestoneCount > 1) {
            for (uint256 i = 1; i < milestoneCount; i++) {
                _milestones[i] = milestones[i];
            }
        }
        return _milestones;
    }

    function lookupProposalProposer(uint256 _id) public view returns (address) {
        return proposals[_id].proposer;
    }

    function lookupProposalTitle(uint256 _id) public view returns (string memory) {
        return proposals[_id].title;
    }

    function lookupProposalDescription(uint256 _id) public view returns (string memory) {
        return proposals[_id].description;
    }

    function lookupProposalDate(uint256 _id) public view returns (uint256) {
        return proposals[_id].date;
    }

    function lookupProposalYesses(uint256 _id) public view returns (uint256) {
        return proposals[_id].yesVotes;
    }

    function lookupProposalNos(uint256 _id) public view returns (uint256) {
        return proposals[_id].noVotes;
    }

    function checkHasVoted(uint256 _id, address _voter) public view returns (bool) {
        return proposals[_id].votes[_voter];
    }

    function checkIfVotedYes(uint256 _id, address _voter) public view returns (bool) {
        return proposals[_id].yesVoteAddresses[_voter];
    }

    function checkIfVotedNo(uint256 _id, address _voter) public view returns (bool) {
        return proposals[_id].noVoteAddresses[_voter];
    }

    function lookupRoundFeesCollected(uint256 _roundNum) public view returns (uint256) {
        return distributionRounds[_roundNum].feesCollected;
    }

    function lookupRoundProfitPerShare(uint256 _roundNum) public view returns (uint256) {
        return distributionRounds[_roundNum].profitPerShare;
    }

    function lookupAmountWithdrawn(uint256 _roundNum) public view returns (uint256) {
        return distributionRounds[_roundNum].amountWithdrawn;
    }

    function lookupAmountRemaining(uint256 _roundNum) public view returns (uint256) {
        return distributionRounds[_roundNum].amountRemaining;
    }

    function lookUpRoundOpen(uint256 _roundNum) public view returns (bool) {
        return distributionRounds[_roundNum].roundOpen;
    }

    function lookupRoundDate(uint256 _roundNum) public view returns (uint256) {
        return distributionRounds[_roundNum].date;
    }

    function submitProposal(string calldata _title, string calldata _description) external payable {
        require(proposals[proposalCount].date == 0);
        require(msg.value == proposalFee);
        MYIERC20 omniCoin = MYIERC20(omniCoinAddress);
        uint256 balanceOfProposer = omniCoin.balanceOf(msg.sender);
        require(balanceOfProposer >= 1);
        proposals[proposalCount].proposer = msg.sender;
        proposals[proposalCount].title = _title;
        proposals[proposalCount].description = _description;
        proposals[proposalCount].date = block.timestamp;
        emit NewProposalEvent(proposalCount, _title, _description, msg.sender, block.timestamp);
        proposalCount++;
        addProfits(msg.value);
    }

    function voteYes(uint256 _proposalId) external {
        require(proposals[_proposalId].date != 0);
        require(proposals[_proposalId].date + proposalVotingPeriod > block.timestamp);
        uint256 dateVoterCoinsReceived = dateCoinsReceived[msg.sender];
        uint256 dateAllowedToVote = dateVoterCoinsReceived + proposalVotingPeriod + 1 days;
        require(dateAllowedToVote <= block.timestamp);
        bool hasVoted = proposals[_proposalId].votes[msg.sender];
        require(hasVoted == false);
        MYIERC20 omniCoin = MYIERC20(omniCoinAddress);
        uint24 balanceOfVoter = uint24(omniCoin.balanceOf(msg.sender));
        require(balanceOfVoter >= 1);
        proposals[_proposalId].yesVotes += balanceOfVoter;
        proposals[_proposalId].votes[msg.sender] = true;
        proposals[_proposalId].yesVoteAddresses[msg.sender] = true;
    }

    function voteNo(uint256 _proposalId) external {
        require(proposals[_proposalId].date != 0);
        require(proposals[_proposalId].date + proposalVotingPeriod > block.timestamp);
        uint256 dateVoterCoinsReceived = dateCoinsReceived[msg.sender];
        uint256 dateAllowedToVote = dateVoterCoinsReceived + proposalVotingPeriod + 1 days;
        require(dateAllowedToVote <= block.timestamp);
        bool hasVoted = proposals[_proposalId].votes[msg.sender];
        require(hasVoted == false);
        MYIERC20 omniCoin = MYIERC20(omniCoinAddress);
        uint24 balanceOfVoter = uint24(omniCoin.balanceOf(msg.sender));
        require(balanceOfVoter >= 1);
        proposals[_proposalId].noVotes += balanceOfVoter;
        proposals[_proposalId].votes[msg.sender] = true;
        proposals[_proposalId].noVoteAddresses[msg.sender] = true;
    }

    function newMilestone(string calldata _title, string calldata _description) external onlyOwner {
        require(milestones[milestoneCount].date == 0);
        milestones[milestoneCount].title = _title;
        milestones[milestoneCount].description = _description;
        milestones[milestoneCount].date = block.timestamp;
        emit NewMilestoneEvent(milestoneCount, _title, _description, block.timestamp);
        milestoneCount++;
    }

    function triggerRound() private {
        require(distributionRounds[currentRoundNumber].date + distributionRoundInterval <= block.timestamp);
        uint256 oneCoin = 1 * (10 ** nativeCoinDecimals);
        require(currentProfitsCollected >= oneCoin);
        distributionRounds[currentRoundNumber].roundOpen = false;
        uint256 bufferRemainder;
        if (currentRoundNumber > 0) {
            bufferRemainder = address(this).balance - currentProfitsCollected;
        }
        currentRoundNumber++;
        totalProfitsCollected = safeAdd(totalProfitsCollected, currentProfitsCollected);
        distributionRounds[currentRoundNumber].feesCollected = currentProfitsCollected;
        distributionRounds[currentRoundNumber].feesCollected += bufferRemainder;
        distributionRounds[currentRoundNumber].amountRemaining = distributionRounds[currentRoundNumber].feesCollected;
        distributionRounds[currentRoundNumber].date = block.timestamp;
        uint256 profitPerShare = distributionRounds[currentRoundNumber].feesCollected / 250_000;
        distributionRounds[currentRoundNumber].profitPerShare = profitPerShare;
        distributionRounds[currentRoundNumber].roundOpen = true;
        currentProfitsCollected = 0;
    }

    function triggerNewDistributionRoundByKeeper() external onlyKeeper(msg.sender) {
        triggerRound();
    }

    function triggerNewDistributionRoundByOwner() external onlyOwner {
        triggerRound();
    }

    function endDistributionRoundByKeeper() external onlyKeeper(msg.sender) {
        require(distributionRounds[currentRoundNumber].date + distributionRoundInterval <= block.timestamp);
        distributionRounds[currentRoundNumber].roundOpen = false;
    }

    function endDistributionRoundByOwner() external onlyOwner {
        require(distributionRounds[currentRoundNumber].date + distributionRoundInterval <= block.timestamp);
        distributionRounds[currentRoundNumber].roundOpen = false;
    }

    function withdrawProfits() external {
        require(distributionRounds[currentRoundNumber].roundOpen);
        require(distributionRounds[currentRoundNumber].hasWithdrawn[msg.sender] == false);
        require(distributionRounds[currentRoundNumber].date + distributionRoundInterval > block.timestamp);
        MYIERC20 omniCoin = MYIERC20(omniCoinAddress);
        uint256 balanceOfPerson = omniCoin.balanceOf(msg.sender);
        require(balanceOfPerson >= 1);
        uint256 amountPerShare = distributionRounds[currentRoundNumber].profitPerShare;
        uint256 amountProfit = amountPerShare * balanceOfPerson;
        require(distributionRounds[currentRoundNumber].amountRemaining >= amountProfit);
        uint256 dateRequesterCoinsReceived = dateCoinsReceived[msg.sender];
        uint256 dateAllowedToWithdraw = dateRequesterCoinsReceived + coinHoldingPeriod;
        require(dateAllowedToWithdraw <= block.timestamp);
        distributionRounds[currentRoundNumber].amountWithdrawn += amountProfit;
        distributionRounds[currentRoundNumber].amountRemaining -= amountProfit;
        distributionRounds[currentRoundNumber].hasWithdrawn[msg.sender] = true;
        totalProfitsDistributed = safeAdd(totalProfitsDistributed, amountProfit);
        addressProfits[msg.sender] = safeAdd(addressProfits[msg.sender], amountProfit);
        address payable sendTo = payable(msg.sender);
        (bool success,) = sendTo.call{value: amountProfit}("");
        require(success);
    }

    function addProfits(uint256 _amount) internal {
        currentProfitsCollected = safeAdd(currentProfitsCollected, _amount);
    }

    function safeAdd(uint256 _currentAmount, uint256 _amountToBeAdded) internal view returns (uint256) {
        uint256 _allowedAmount = MAXUINT - _currentAmount;
        if (_amountToBeAdded <= _allowedAmount) {
            return _currentAmount + _amountToBeAdded;
        }
        return _currentAmount;
    }

    function remintBurnt() external onlyOwner {
        IOmnicoin omniCoin = IOmnicoin(omniCoinAddress);
        omniCoin.remintBurntCoins(owner());
    }

    function changeOmnifyAddressOnOmnicoin(address newAddress) external onlyOwner {
        IOmnicoin omniCoin = IOmnicoin(omniCoinAddress);
        omniCoin.changeOmnifyAddress(newAddress);
    }
}
