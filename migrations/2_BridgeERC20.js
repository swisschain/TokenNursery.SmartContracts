const BridgeERC20 = artifacts.require("BridgeERC20");

module.exports = function(deployer) {
  deployer.deploy(BridgeERC20);
};
