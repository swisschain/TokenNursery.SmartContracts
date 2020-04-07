const NurseryERC20 = artifacts.require("NurseryERC20");

module.exports = function(deployer) {
  deployer.deploy(NurseryERC20);
};
