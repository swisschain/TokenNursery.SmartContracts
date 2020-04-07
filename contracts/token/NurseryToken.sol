
pragma solidity 0.5.2;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/access/Roles.sol";
import "./abstract/SeizableNurseryERC20.sol";
import "../interfaces/IRulable.sol";
import "../interfaces/ISuppliable.sol";
import "../interfaces/IMintable.sol";
import "../interfaces/IContactable.sol";
import "../interfaces/IProcessor.sol";

/**
 * @title NurseryToken
 * @dev NurseryToken contract
 *
 * Error messages
 * SU01: Caller is not supplier
 * RU01: Rules and rules params don't have the same length
 * RE01: Rule id overflow
**/


contract NurseryToken is Initializable, IContactable, IRulable, ISuppliable, IMintable, SeizableNurseryERC20 {
  using Roles for Roles.Role;
  
  Roles.Role internal _suppliers;
  uint256[] internal _rules;
  uint256[] internal _rulesParams;
  string public contact;

  function initialize(
    address owner,
    IProcessor processor,
    string memory name,
    string memory symbol,
    uint8 decimals,
    address[] memory trustedIntermediaries
  ) 
    public initializer 
  {
    SeizableNurseryERC20.initialize(owner, processor);
    processor.register(name, symbol, decimals);
    _trustedIntermediaries = trustedIntermediaries;
    emit TrustedIntermediariesChanged(trustedIntermediaries);
  }

  modifier onlySupplier() {
    require(isSupplier(msg.sender), "SU01");
    _;
  }

  /* Mintable */
  function isSupplier(address _supplier) public view returns (bool) {
    return _suppliers.has(_supplier);
  }

  function addSupplier(address _supplier) public onlyAdministrator {
    _suppliers.add(_supplier);
    emit SupplierAdded(_supplier);
  }

  function removeSupplier(address _supplier) public onlyAdministrator {
    _suppliers.remove(_supplier);
    emit SupplierRemoved(_supplier);
  }  

  function mint(address _to, uint256 _amount)
    public onlySupplier hasProcessor
  {
    _processor.mint(msg.sender, _to, _amount);
    emit Mint(_to, _amount);
    emit Transfer(address(0), _to, _amount);
  }

  function burn(address _from, uint256 _amount)
    public onlySupplier hasProcessor 
  {
    _processor.burn(msg.sender, _from, _amount);
    emit Burn(_from, _amount);
    emit Transfer(_from, address(0), _amount);
  }

  /* Rulable */
  function rules() public view returns (uint256[] memory, uint256[] memory) {
    return (_rules, _rulesParams);
  }
  
  function rule(uint256 ruleId) public view returns (uint256, uint256) {
    require(ruleId < _rules.length, "RE01");
    return (_rules[ruleId], _rulesParams[ruleId]);
  }

  function canTransfer(
    address _from, address _to, uint256 _amount
  ) 
    public hasProcessor view returns (bool, uint256, uint256) 
  {
    return _processor.canTransfer(_from, _to, _amount);
  }

  function setRules(
    uint256[] calldata newRules, 
    uint256[] calldata newRulesParams
  ) 
    external onlyAdministrator
  {
    require(newRules.length == newRulesParams.length, "RU01");
    _rules = newRules;
    _rulesParams = newRulesParams;
    emit RulesChanged(_rules, _rulesParams);
  }

  /* Contactable */
  function setContact(string calldata _contact) external onlyAdministrator {
    contact = _contact;
    emit ContactSet(_contact);
  }

  /* Reserved slots for future use: https://docs.openzeppelin.com/sdk/2.5/writing-contracts.html#modifying-your-contracts */
  uint256[50] private ______gap;
}