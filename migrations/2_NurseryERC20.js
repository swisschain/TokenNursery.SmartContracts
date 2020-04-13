const XNurseryERC20 = artifacts.require("XNurseryERC20");
const XSeizableNurseryERC20 = artifacts.require("XSeizableNurseryERC20");
const NurseryToken = artifacts.require("NurseryToken");


module.exports = function(deployer) {
//  deployer.deploy(XNurseryERC20);
//  deployer.deploy(XSeizableNurseryERC20);
  deployer.deploy(NurseryToken);
};
