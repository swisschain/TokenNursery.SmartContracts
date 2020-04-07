
pragma solidity 0.5.2;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/access/Roles.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";
import "../../interfaces/IERC20Detailed.sol";
import "../../interfaces/IAdministrable.sol";
import "../../interfaces/IGovernable.sol";
import "../../interfaces/IPriceable.sol";
import "../../interfaces/IProcessor.sol";
import "../../interfaces/IPriceOracle.sol";

/**
 * @title NurseryERC20
 * @dev NurseryERC20 contract
 *
 * Error messages
 * PR01: Processor is not set
 * AD01: Caller is not administrator
 * AL01: Spender is not allowed for this amount
 * PO03: Price Oracle not set
 * KI01: Caller of setRealm has to be owner or administrator of initial token address for realm
**/


contract NurseryERC20 is Initializable, Ownable, IAdministrable, IGovernable, IPriceable, IERC20Detailed {
  using Roles for Roles.Role;
  using SafeMath for uint256;

  event ProcessorChanged(address indexed newProcessor);

  IProcessor internal _processor;
  Roles.Role internal _administrators;
  Roles.Role internal _realmAdministrators;
  address[] internal _trustedIntermediaries;
  address internal _realm;
  IPriceOracle internal _priceOracle;

  /** 
  * @dev Initialization function that replaces constructor in the case of upgradable contracts
  **/
  function initialize(address owner, IProcessor processor) public initializer {
    Ownable.initialize(owner);
    _processor = processor;
    _realm = address(this);
    emit ProcessorChanged(address(processor));
    emit RealmChanged(address(this));
  }

  modifier hasProcessor() {
    require(address(_processor) != address(0), "PR01");
    _;
  }

  modifier onlyAdministrator() {
    require(isOwner() || isAdministrator(msg.sender), "AD01");
    _;
  }

  /* Administrable */
  function isAdministrator(address _administrator) public view returns (bool) {
    return _administrators.has(_administrator);
  }

  function addAdministrator(address _administrator) public onlyOwner {
    _administrators.add(_administrator);
    emit AdministratorAdded(_administrator);
  }

  function removeAdministrator(address _administrator) public onlyOwner {
    _administrators.remove(_administrator);
    emit AdministratorRemoved(_administrator);
  }

  /* Governable */
  function realm() public view returns (address) {
    return _realm;
  }

  function setRealm(address newRealm) public onlyAdministrator {
    NurseryERC20 king = NurseryERC20(newRealm);
    require(king.owner() == msg.sender || king.isRealmAdministrator(msg.sender), "KI01");
    _realm = newRealm;
    emit RealmChanged(newRealm);
  }

  function trustedIntermediaries() public view returns (address[] memory) {
    return _trustedIntermediaries;
  }

  function setTrustedIntermediaries(address[] calldata newTrustedIntermediaries) external onlyAdministrator {
    _trustedIntermediaries = newTrustedIntermediaries;
    emit TrustedIntermediariesChanged(newTrustedIntermediaries);
  }

  function isRealmAdministrator(address _administrator) public view returns (bool) {
    return _realmAdministrators.has(_administrator);
  }

  function addRealmAdministrator(address _administrator) public onlyAdministrator {
    _realmAdministrators.add(_administrator);
    emit RealmAdministratorAdded(_administrator);
  }

  function removeRealmAdministrator(address _administrator) public onlyAdministrator {
    _realmAdministrators.remove(_administrator);
    emit RealmAdministratorRemoved(_administrator);
  }

  /* Priceable */
  function priceOracle() public view returns (IPriceOracle) {
    return _priceOracle;
  }

  function setPriceOracle(IPriceOracle newPriceOracle) public onlyAdministrator {
    _priceOracle = newPriceOracle;
    emit PriceOracleChanged(address(newPriceOracle));
  }

  function convertTo(
    uint256 _amount, string calldata _currency, uint8 maxDecimals
  ) 
    external hasProcessor view returns(uint256) 
  {
    require(address(_priceOracle) != address(0), "PO03");
    uint256 amountToConvert = _amount;
    uint256 xrate;
    uint8 xrateDecimals;
    uint8 tokenDecimals = _processor.decimals();
    (xrate, xrateDecimals) = _priceOracle.getPrice(_processor.symbol(), _currency);
    if (xrateDecimals > maxDecimals) {
      xrate = xrate.div(10**uint256(xrateDecimals - maxDecimals));
      xrateDecimals = maxDecimals;
    }
    if (tokenDecimals > maxDecimals) {
      amountToConvert = amountToConvert.div(10**uint256(tokenDecimals - maxDecimals));
      tokenDecimals = maxDecimals;
    }
    /* Multiply amount in token decimals by xrate in xrate decimals */
    return amountToConvert.mul(xrate).mul(10**uint256((2*maxDecimals)-xrateDecimals-tokenDecimals));
  }

  /**
  * @dev Set the token processor
  **/
  function setProcessor(IProcessor processor) public onlyAdministrator {
    _processor = processor;
    emit ProcessorChanged(address(processor));
  }

  /**
  * @return the token processor
  **/
  function processor() public view returns (IProcessor) {
    return _processor;
  }

  /**
  * @return the name of the token.
  */
  function name() public view hasProcessor returns (string memory) {
    return _processor.name();
  }

  /**
  * @return the symbol of the token.
  */
  function symbol() public view hasProcessor returns (string memory) {
    return _processor.symbol();
  }

  /**
  * @return the number of decimals of the token.
  */
  function decimals() public view hasProcessor returns (uint8) {
    return _processor.decimals();
  }

  /**
  * @return total number of tokens in existence
  */
  function totalSupply() public view hasProcessor returns (uint256) {
    return _processor.totalSupply();
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  * @return true if transfer is successful, false otherwise
  */
  function transfer(address _to, uint256 _value) public hasProcessor 
    returns (bool) 
  {
    bool success;
    address updatedTo;
    uint256 updatedAmount;
    (success, updatedTo, updatedAmount) = _processor.transferFrom(
      msg.sender, 
      _to, 
      _value
    );
    emit Transfer(msg.sender, updatedTo, updatedAmount);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view hasProcessor 
    returns (uint256) 
  {
    return _processor.balanceOf(_owner);
  }

  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   * @return true if transfer is successful, false otherwise
   */
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    hasProcessor
    returns (bool)
  {
    require(_value <= _processor.allowance(_from, msg.sender), "AL01"); 
    bool success;
    address updatedTo;
    uint256 updatedAmount;
    (success, updatedTo, updatedAmount) = _processor.transferFrom(
      _from, 
      _to, 
      _value
    );
    _processor.decreaseApproval(_from, msg.sender, updatedAmount);
    emit Transfer(_from, updatedTo, updatedAmount);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   * @return true if approval is successful, false otherwise
   */
  function approve(address _spender, uint256 _value) public hasProcessor returns (bool)
  {
    _processor.approve(msg.sender, _spender, _value);
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(
    address _owner,
    address _spender
   )
    public
    view
    hasProcessor
    returns (uint256)
  {
    return _processor.allowance(_owner, _spender);
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   * @return true if increase is successful, false otherwise
   */
  function increaseApproval(
    address _spender,
    uint _addedValue
  )
    public
    hasProcessor
  {
    _processor.increaseApproval(msg.sender, _spender, _addedValue);
    uint256 allowed = _processor.allowance(msg.sender, _spender);
    emit Approval(msg.sender, _spender, allowed);
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   * @return true if decrease is successful, false otherwise
   */
  function decreaseApproval(
    address _spender,
    uint _subtractedValue
  )
    public
    hasProcessor
    returns (bool)
  {
    _processor.decreaseApproval(msg.sender, _spender, _subtractedValue);
    uint256 allowed = _processor.allowance(msg.sender, _spender);
    emit Approval(msg.sender, _spender, allowed);
  }

  /* Reserved slots for future use: https://docs.openzeppelin.com/sdk/2.5/writing-contracts.html#modifying-your-contracts */
  uint256[50] private ______gap;
}