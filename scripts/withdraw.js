const hre = require("hardhat");
const abi = require("../artifacts/contracts/BuyMeACoffee.sol/BuyMeACoffee.json");

async function getBalance(provider, address){
    const balanceBigInt = await provider.getBalance(address);
    return hre.ethers.utils.formatEther(balanceBigInt);
}

async function main(){
    // Get the contract that has been deployed to the Goerli Testnet

    const contractAddress = "0x76AB81993C8D378445463bD96fBE6942026E949F"; // 0x08c641F5C73a05271E2b24afC0A2FcC0Bf003aC0
    const contractABI = abi.abi;

    //Get node connection and wallet connection.
    const provider = new hre.ethers.providers.AlchemyProvider("goerli", process.env.GOERLI_API_KEY);

    // Ensure that the signer is same as the original contract deployer,
    // or else this script will fail with an error.
    const signer = new hre.ethers.Wallet(process.env.PRIVATE_KEY, provider);

    //Instantiate the contract
    const buyMeACoffee = new hre.ethers.Contract(contractAddress, contractABI, signer);

    //Check starting balances.
    console.log("current balance of owner: ", await getBalance(provider, signer.address), "ETH");
    const contractBalance = await getBalance(provider, buyMeACoffee.address);
    console.log("current balance of the contract ", contractBalance, "ETH");

    //Withdraw funds if there are funds to withdraw
    if (contractBalance !== "0.0"){
        console.log("withdrawing funds..")
        const withdrawTxn = await buyMeACoffee.withdrawTips();
        await withdrawTxn.wait();


    }else{
        console.log("no funds to withdraw!");
    }


    // Check ending balance
    console.log("Current balance of owner: ", await getBalance(provider, signer.address));

}

main()
    .then(()=> process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    })