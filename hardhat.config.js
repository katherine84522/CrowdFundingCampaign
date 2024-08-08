require("@nomicfoundation/hardhat-toolbox");
require('@openzeppelin/hardhat-upgrades');
require("@nomicfoundation/hardhat-verify");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  defaultNetwork: "sepolia",
  networks: {
    hardhat: {},
    sepolia:{
      url: process.env.ALCHEMY_SEPOLIA_ENDPOINT,
      accounts : [process.env.PRIVATE_KEY]
    },
    mainnet: {
  
      url: process.env.ALCHEMY_MAINNET_ENDPOINT,
      accounts: [process.env.PRIVATE_KEY]
    }
  }, 
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  },
  sourcify:{
    enabled: true
  }
};

