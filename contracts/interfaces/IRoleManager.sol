pragma solidity 0.5.2;

interface IRoleManager {
  function isAdministrator(address _administrator) external view returns (bool);
}