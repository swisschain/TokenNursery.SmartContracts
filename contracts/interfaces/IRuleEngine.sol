
pragma solidity 0.5.2;


import "./IRule.sol";

/**
 * @title IRuleEngine
 * @dev IRuleEngine interface
 **/


interface IRuleEngine {

  function setRules(IRule[] calldata rules) external;
  function ruleLength() external view returns (uint256);
  function rule(uint256 ruleId) external view returns (IRule);
  function rules(uint256[] calldata _ruleIds) external view returns(IRule[] memory);

  function validateTransferWithRules(
    uint256[] calldata _tokenRules, 
    uint256[] calldata _tokenRulesParam, 
    address _token,
    address _from, 
    address _to, 
    uint256 _amount)
    external view returns (bool, uint256, uint256);
}