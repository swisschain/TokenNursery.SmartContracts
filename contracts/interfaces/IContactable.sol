
pragma solidity 0.5.2;

/**
 * @title IContactable
 * @dev IContactable interface
 **/
interface IContactable {
  function contact() external view returns (string memory);
  function setContact(string calldata _contact) external;

  /**
  * Purpose:
  * This event is emitted when the contact information is changed
  *
  * @param contact - new contact information
  */
  event ContactSet(string contact);
}
