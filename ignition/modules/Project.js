const { ethers, upgrades } = require("hardhat");

async function main() {
  const CrowdfundingPlatform = await ethers.getContractFactory("CrowdfundingPlatform");
  const platform = await upgrades.deployProxy(CrowdfundingPlatform, [], { initializer: "initialize" });

  // const CrowdfundingPlatformV2 = await ethers.getContractFactory("CrowdfundingPlatformV2");
  // const platform = await upgrades.upgradeProxy("<PROXY_ADDRESS>", CrowdfundingPlatformV2);

  await platform.waitForDeployment();
  console.log("CrowdfundingPlatform deployed to:", platform.target);
}

main();