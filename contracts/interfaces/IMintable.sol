
pragma solidity 0.5.2;

/**
 * @title IMintable
 * @dev IMintable interface
 */

 
interface IMintable {
  function mint(address _to, uint256 _amount) external;
  function burn(address _from, uint256 _amount) external;
 
  event Mint(address indexed to, uint256 amount);
  event Burn(address indexed from, uint256 amount);
}
