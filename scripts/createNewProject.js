const { ethers } = require("ethers");
const fs = require("fs");
const path = require("path");

const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;



const CONTRACT_ABI = JSON.parse(fs.readFileSync(path.resolve(__dirname, '../artifacts/contracts/CrowdfundingPlatform.sol/CrowdfundingPlatform.json'))).abi;

async function createNewProject() {
 
  const provider = new ethers.AlchemyProvider("sepolia", ALCHEMY_API_KEY);

  const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

  const contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, wallet);

  console.log('contract', contract);

  let currentDate = new Date();

  let futureDate = new Date(currentDate.getTime() + (30 * 24 * 60 * 60 * 1000));


  let futureTimestamp = Math.floor(futureDate.getTime() / 1000);

  const newProject = await contract.createProject("Everyone should love cats", "Cats are Awesome", 100000, futureTimestamp, { gasLimit: 3000000 });
  console.log("New project deployed to:", newProject.address);

}

createNewProject().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
