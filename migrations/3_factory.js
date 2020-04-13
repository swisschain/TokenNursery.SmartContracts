const NurseryTokenFactory = artifacts.require("NurseryTokenFactory");


module.exports = function(deployer) {
  deployer.deploy(NurseryTokenFactory);
};
