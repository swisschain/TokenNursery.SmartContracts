
pragma solidity 0.5.2;

/**
 * @title ISuppliable
 * @dev ISuppliable interface
 **/


interface ISuppliable {
  function isSupplier(address _supplier) external view returns (bool);
  function addSupplier(address _supplier) external;
  function removeSupplier(address _supplier) external;

  event SupplierAdded(address indexed supplier);
  event SupplierRemoved(address indexed supplier);
}
