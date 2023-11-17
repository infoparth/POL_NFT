require("@nomicfoundation/hardhat-toolbox");
require('@openzeppelin/hardhat-upgrades');
require("@nomiclabs/hardhat-ethers");
require("dotenv").config();

const SHARDEUM_RPC  = process.env.SHARDEUM_RPC;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.21",
    settings: {
      optimizer: {
        enabled: true,
        runs: 20000,
      },
    },
  },
  networks: {
    shardeum: {
      url: SHARDEUM_RPC,
      accounts: [PRIVATE_KEY],
      chainId: 8081,  
    }
  },
};
