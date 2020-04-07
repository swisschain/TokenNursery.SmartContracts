
pragma solidity 0.5.2;

/**
 * @title IRulable
 * @dev IRulable interface
 **/


interface IRulable {
  function rule(uint256 ruleId) external view returns (uint256, uint256);
  function rules() external view returns (uint256[] memory, uint256[] memory);

  function canTransfer(address _from, address _to, uint256 _amount) external view returns (bool, uint256, uint256);

  function setRules(
    uint256[] calldata _rules, 
    uint256[] calldata _rulesParams
  ) external;
  event RulesChanged(uint256[] newRules, uint256[] newRulesParams);
}
