const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
 

module.exports = buildModule("CrowdfundingPlatformModule", (m) => { 

  const deployer = m.getAccount(0); 
 

    const platform = m.contract("CrowdfundingPlatform", [], {
      from: deployer,
    });
  
    m.call(platform, "initialize", [deployer], {
      from: deployer,
    });
 

  return { platform }; 
});