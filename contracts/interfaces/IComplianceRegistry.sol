pragma solidity 0.5.2;

/**
 * @title IComplianceRegistry
 * @dev IComplianceRegistry interface
 **/
interface IComplianceRegistry {

  event AddressAttached(address indexed trustedIntermediary, uint256 indexed userId, address indexed address_);
  event AddressDetached(address indexed trustedIntermediary, uint256 indexed userId, address indexed address_);

  function userId(address[] calldata _trustedIntermediaries, address _address) 
    external view returns (uint256, address);
  function validUntil(address _trustedIntermediary, uint256 _userId) 
    external view returns (uint256);
  function attribute(address _trustedIntermediary, uint256 _userId, uint256 _key)
    external view returns (uint256);
  function attributes(address _trustedIntermediary, uint256 _userId, uint256[] calldata _keys) 
    external view returns (uint256[] memory);

  function isAddressValid(address[] calldata _trustedIntermediaries, address _address) external view returns (bool);
  function isValid(address _trustedIntermediary, uint256 _userId) external view returns (bool);

  function registerUser(
    address _address, 
    uint256[] calldata _attributeKeys, 
    uint256[] calldata _attributeValues
  ) external;
  function registerUsers(
    address[] calldata _addresses, 
    uint256[] calldata _attributeKeys, 
    uint256[] calldata _attributeValues
  ) external;

  function attachAddress(uint256 _userId, address _address) external;
  function attachAddresses(uint256[] calldata _userIds, address[] calldata _addresses) external;

  function detachAddress(address _address) external;
  function detachAddresses(address[] calldata _addresses) external;

  function updateUserAttributes(
    uint256 _userId, 
    uint256[] calldata _attributeKeys, 
    uint256[] calldata _attributeValues
  ) external;
  function updateUsersAttributes(
    uint256[] calldata _userIds, 
    uint256[] calldata _attributeKeys, 
    uint256[] calldata _attributeValues
  ) external;

  function updateTransfers(
    address _realm, 
    address _from, 
    address _to, 
    uint256 _value
  ) external;
  function monthlyTransfers(
    address _realm, 
    address[] calldata _trustedIntermediaries,
    address _address
  ) external view returns (uint256);
  function yearlyTransfers(
    address _realm, 
    address[] calldata _trustedIntermediaries,
    address _address
  ) external view returns (uint256);
  function monthlyInTransfers(
    address _realm, 
    address[] calldata _trustedIntermediaries,
    address _address
  ) external view returns (uint256);
  function yearlyInTransfers(
    address _realm, 
    address[] calldata _trustedIntermediaries,
    address _address
  ) external view returns (uint256);
  function monthlyOutTransfers(
    address _realm, 
    address[] calldata _trustedIntermediaries,
    address _address
  ) external view returns (uint256);
  function yearlyOutTransfers(
    address _realm, 
    address[] calldata _trustedIntermediaries,
    address _address
  ) external view returns (uint256);

  function addOnHoldTransfer(
    address trustedIntermediary,
    address token,
    address from, 
    address to, 
    uint256 amount
  ) external;

  function getOnHoldTransfers(address trustedIntermediary)
    external view returns (
      uint256 length, 
      uint256[] memory id,
      address[] memory token, 
      address[] memory from, 
      address[] memory to, 
      uint256[] memory amount
    );

  function processOnHoldTransfers(uint256[] calldata transfers, uint8[] calldata transferDecisions, bool skipMinBoundaryUpdate) external;
  function updateOnHoldMinBoundary(uint256 maxIterations) external;

  event TransferOnHold(
    address indexed trustedIntermediary,
    address indexed token, 
    address indexed from, 
    address to, 
    uint256 amount
  );
  event TransferApproved(
    address indexed trustedIntermediary,
    address indexed token, 
    address indexed from, 
    address to, 
    uint256 amount
  );
  event TransferRejected(
    address indexed trustedIntermediary,
    address indexed token, 
    address indexed from, 
    address to, 
    uint256 amount
  );
  event TransferCancelled(
    address indexed trustedIntermediary,
    address indexed token, 
    address indexed from, 
    address to, 
    uint256 amount
  );
}
