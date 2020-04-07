* `truffle init`
* `npm init`

* Add smart contracts (contracts/Counter.sol)

* Add migration with deploy smart contract (migrations/2_Counter.js)

* `npm install truffle-hdwallet-provider`

* `npm install dotenv`
* `npx yarn add dotenv`

* `npm install truffle-plugin-verify`
* `npx yarn add truffle-plugin-verify`

* Add to the truffle-config.js:
```
  require('dotenv').config();

  const HDWallet = require('truffle-hdwallet-provider');

  module.exports = {
      
      ...,

      ropsten: {
        provider: () => new HDWallet('your private key', `https://ropsten.infura.io/v3/PROJECT_ID`),
        network_id: 3,       // Ropsten's id
        gas: 5500000,        // Ropsten has a lower block limit than mainnet
        confirmations: 2,    // # of confs to wait between deployments. (default: 0)
        timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
        skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
      },

      // Useful for private networks
      private: {
        provider: () => new HDWallet('your private key', `RPC URL ADDRESS`),
        network_id: "*",   // This network is yours, in the cloud.
        production: false,   // Treats this network as if it was a public net. (default: false)
        gasPrice: 0
      }

  },
  plugins: [
    'truffle-plugin-verify'
  ],

  api_keys: {
    etherscan: process.env.ETHERSCAN_API_KEY
  }
```

* Add to .env file:
```
ETHERSCAN_API_KEY=YOUR_API_KEY
```

* Verify your compilator version in truffle-config.js:
```
module.exports = {
  ...,
  compilers: {
    solc: {
       version: "0.5.10"
    }
  }
}
```

* `npm install`
* `truffle compile`
* `truffle migrate --network ropsten`
* `truffle run verify CONTRACT_NAME --network ropsten`

* For reploy to private network:
```
truffle migrate --network private
```
