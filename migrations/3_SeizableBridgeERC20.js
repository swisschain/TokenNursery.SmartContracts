const SeizableBridgeERC20 = artifacts.require("SeizableBridgeERC20");

module.exports = function(deployer) {
  deployer.deploy(SeizableBridgeERC20);
};
