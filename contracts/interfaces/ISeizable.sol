
pragma solidity 0.5.2;

/**
 * @title ISeizable
 * @dev ISeizable interface
 **/


interface ISeizable {
  function isSeizer(address _seizer) external view returns (bool);
  function addSeizer(address _seizer) external;
  function removeSeizer(address _seizer) external;

  event SeizerAdded(address indexed seizer);
  event SeizerRemoved(address indexed seizer);

  function seize(address _account, uint256 _value) external;
  event Seize(address account, uint256 amount);
}
