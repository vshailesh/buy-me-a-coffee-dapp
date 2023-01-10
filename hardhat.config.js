require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/harhat-waffle");
require("dotenv").config()

const GOERLI_URL = process.env.GOERLI_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {

  solidity: {
    compilers: [
      {
        version: "0.8.17"
      },
      {
        version: "0.8.0"
      }
    ]
  }
};
