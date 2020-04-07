
pragma solidity 0.5.2;

/**
 * @title IVotable
 * @dev IVotable interface
 **/
interface IVotable {
  function votingSession() external view returns (address);
  function setVotingSession(address _votingSession) external;

  /**
  * Purpose:
  * This event is emitted when the voting session address is changed
  *
  * @param votingSession - new voting session address
  */
  event VotingSessionSet(address votingSession);
}
