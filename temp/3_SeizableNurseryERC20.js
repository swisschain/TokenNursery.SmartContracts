const SeizableNurseryERC20 = artifacts.require("SeizableNurseryERC20");

module.exports = function(deployer) {
  deployer.deploy(SeizableNurseryERC20);
};
