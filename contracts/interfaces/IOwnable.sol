
pragma solidity 0.5.2;

/**
 * @title IOwnable
 * @dev IOwnable interface
 **/

 
interface IOwnable {
  function owner() external view returns (address);
  function transferOwnership(address _newOwner) external returns (bool);
  function renounceOwnership() external returns (bool);

  event OwnershipTransferred(address indexed newOwner);
}
