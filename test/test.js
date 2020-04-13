const NurseryERC20 = artifacts.require("NurseryERC20");

contract("1rd test", async accounts => {
  it("should put 10000 MetaCoin in the first account", () =>{

    console.log("1111");
    
    const contractFactoryInstance = await ContractFactory.new();

    const gasEstimate = await contractFactoryInstance.createInstance.estimateGas();

    const tx = await contractFactoryInstance.createInstance({
      gas: gasEstimate
    });
    assert(tx);


    console.log("2222");
  });
});



/*
NurseryToken.web3.eth.getGasPrice(function(error, result){ 
  var gasPrice = Number(result);
  console.log("Gas Price is " + gasPrice + " wei"); // "10000000000000"

  var gas = 

    console.log("gas estimation = " + gas + " units");
    console.log("gas cost estimation = " + (gas * gasPrice) + " wei");
    console.log("gas cost estimation = " + NurseryToken.web3.fromWei((gas * gasPrice), 'ether') + " ether");

});




*/