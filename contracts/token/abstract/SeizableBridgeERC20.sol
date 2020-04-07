
pragma solidity 0.5.2;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/access/Roles.sol";
import "./BridgeERC20.sol";
import "../../interfaces/ISeizable.sol";
import "../../interfaces/IProcessor.sol";

/**
 * @title SeizableBridgeERC20
 * @dev SeizableBridgeERC20 contract
 *
 * Error messages
 * SE02: Caller is not seizer
**/


contract SeizableBridgeERC20 is Initializable, ISeizable, BridgeERC20 {
  using Roles for Roles.Role;
  
  Roles.Role internal _seizers;

  function initialize(
    address owner, 
    IProcessor processor
  ) 
    public initializer 
  {
    BridgeERC20.initialize(owner, processor);
  }

  modifier onlySeizer() {
    require(isSeizer(msg.sender), "SE02");
    _;
  }

  function isSeizer(address _seizer) public view returns (bool) {
    return _seizers.has(_seizer);
  }

  function addSeizer(address _seizer) public onlyAdministrator {
    _seizers.add(_seizer);
    emit SeizerAdded(_seizer);
  }

  function removeSeizer(address _seizer) public onlyAdministrator {
    _seizers.remove(_seizer);
    emit SeizerRemoved(_seizer);
  }

  /**
   * @dev called by the owner to seize value from the account
   * @return true if approval is successful, false otherwise
   */
  function seize(address _account, uint256 _value)
    public onlySeizer hasProcessor
  {
    _processor.seize(msg.sender, _account, _value);
    emit Seize(_account, _value);
    emit Transfer(_account, msg.sender, _value); 
  }

  /* Reserved slots for future use: https://docs.openzeppelin.com/sdk/2.5/writing-contracts.html#modifying-your-contracts */
  uint256[50] private ______gap;
}