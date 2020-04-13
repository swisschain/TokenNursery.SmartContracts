pragma solidity 0.5.2;

import "./NurseryToken.sol";

contract NurseryTokenFactory {
 
    event ContractCreated(address indexed newContract);

    function createNurseryToken() public {
        NurseryToken c = new NurseryToken();
        emit ContractCreated(address(c));
    } 
}