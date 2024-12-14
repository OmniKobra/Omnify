interface IOmnify99 {
    struct Milestone {
        string title;
        string description;
        uint256 date;
    }

    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);

    event NewMilestoneEvent(uint256 _count, string _title, string _description, uint256 _date);
    event NewProposalEvent(uint256 _count, string _title, string _description, address _proposer, uint256 _date);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

//    constructor(uint8 _paramNativeDecimals, uint256 _paramProposalFee);

    function addProfitsFromExternalContract() external payable;
    function addressProfits(address) external view returns (uint256);
    function changeOmnifyAddressOnOmnicoin(address newAddress) external;
    function checkHasVoted(uint256 _id, address _voter) external view returns (bool);
    function checkIfContractWhiteListed(address _contract) external view returns (bool);
    function checkIfVotedNo(uint256 _id, address _voter) external view returns (bool);
    function checkIfVotedYes(uint256 _id, address _voter) external view returns (bool);
    function coinHoldingPeriod() external view returns (uint256);
    function coinsaleAddress() external view returns (address);
    function currentProfitsCollected() external view returns (uint256);
    function currentRoundNumber() external view returns (uint256);
    function dateCoinsReceived(address) external view returns (uint256);
    function distributionRoundInterval() external view returns (uint256);
    function distributionRounds(uint256)
        external
        view
        returns (
            uint256 feesCollected,
            uint256 roundNumber,
            uint256 profitPerShare,
            uint256 amountWithdrawn,
            uint256 amountRemaining,
            uint256 date,
            bool roundOpen
        );
    function endDistributionRoundByKeeper() external;
    function endDistributionRoundByOwner() external;
    function feeKeeperAddress() external view returns (address);
    function keeperAddress() external view returns (address);
    function lookUpRoundOpen(uint256 _roundNum) external view returns (bool);
    function lookupAddressProfits(address _address) external view returns (uint256);
    function lookupAmountRemaining(uint256 _roundNum) external view returns (uint256);
    function lookupAmountWithdrawn(uint256 _roundNum) external view returns (uint256);
    function lookupHasWithdrawnFromRound(uint256 _roundNumber, address _address) external view returns (bool);
    function lookupMilestone(uint256 _count) external view returns (Milestone memory);
    function lookupMilestones() external view returns (Milestone[] memory);
    function lookupProposalDate(uint256 _id) external view returns (uint256);
    function lookupProposalDescription(uint256 _id) external view returns (string memory);
    function lookupProposalNos(uint256 _id) external view returns (uint256);
    function lookupProposalProposer(uint256 _id) external view returns (address);
    function lookupProposalTitle(uint256 _id) external view returns (string memory);
    function lookupProposalYesses(uint256 _id) external view returns (uint256);
    function lookupRoundDate(uint256 _roundNum) external view returns (uint256);
    function lookupRoundFeesCollected(uint256 _roundNum) external view returns (uint256);
    function lookupRoundProfitPerShare(uint256 _roundNum) external view returns (uint256);
    function milestoneCount() external view returns (uint256);
    function milestones(uint256) external view returns (string memory title, string memory description, uint256 date);
    function nativeCoinDecimals() external view returns (uint8);
    function newMilestone(string memory _title, string memory _description) external;
    function omniCoinAddress() external view returns (address);
    function owner() external view returns (address);
    function proposalCount() external view returns (uint256);
    function proposalFee() external view returns (uint256);
    function proposalVotingPeriod() external view returns (uint256);
    function proposals(uint256)
        external
        view
        returns (
            address proposer,
            string memory title,
            string memory description,
            uint256 date,
            uint24 yesVotes,
            uint24 noVotes
        );
    function remintBurnt() external;
    function removeAddressWhitelist(address _contract) external;
    function renounceOwnership() external;
    function setCoinsReceivedDate(address _recipient) external;
    function setCoinsaleAddress(address _coinsale) external;
    function setFeeKeeperAddress(address _feeKeeper) external;
    function setHoldingAndRoundInterval(uint256 _holdingPeriod, uint256 _interval) external;
    function setKeeperAddress(address _keeper) external;
    function setOmniCoinAddress(address _omniCoinAddress) external;
    function setProposalFee(uint256 _fee) external;
    function setProposalFeeByFeeKeeper(uint256 _fee) external;
    function submitProposal(string memory _title, string memory _description) external payable;
    function totalProfitsCollected() external view returns (uint256);
    function totalProfitsDistributed() external view returns (uint256);
    function transferOwnership(address newOwner) external;
    function triggerNewDistributionRoundByKeeper() external;
    function triggerNewDistributionRoundByOwner() external;
    function voteNo(uint256 _proposalId) external;
    function voteYes(uint256 _proposalId) external;
    function whitelistAddress(address _contract) external;
    function whitelistedExternalContracts(address) external view returns (bool);
    function withdrawProfits() external;
}

