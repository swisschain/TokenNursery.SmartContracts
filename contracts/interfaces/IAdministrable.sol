pragma solidity 0.5.2;

/**
 * @title IAdministrable
 * @dev IAdministrable interface
 **/
interface IAdministrable {
  function isAdministrator(address _administrator) external view returns (bool);
  function addAdministrator(address _administrator) external;
  function removeAdministrator(address _administrator) external;

  event AdministratorAdded(address indexed administrator);
  event AdministratorRemoved(address indexed administrator);
}
