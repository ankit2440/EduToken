const { ethers } = require("hardhat");

async function main() {
  console.log("Deploying EduToken contract to Core Blockchain...");

  // Get the contract factory
  const EduToken = await ethers.getContractFactory("EduToken");

  // Deploy the contract with initial supply (1,000,000 tokens)
  const initialSupply = 1000000; // 1 million tokens
  const eduToken = await EduToken.deploy(initialSupply);

  // Wait for the contract to be deployed
  await eduToken.deployed();

  console.log("EduToken deployed to:", eduToken.address);
  console.log("Transaction hash:", eduToken.deployTransaction.hash);
  console.log("Initial supply:", initialSupply, "tokens");
  
  // Get the deployer's address
  const [deployer] = await ethers.getSigners();
  console.log("Deployed by:", deployer.address);
  
  // Verify deployment by checking some contract properties
  const name = await eduToken.name();
  const symbol = await eduToken.symbol();
  const totalSupply = await eduToken.totalSupply();
  
  console.log("Contract Name:", name);
  console.log("Contract Symbol:", symbol);
  console.log("Total Supply:", ethers.utils.formatEther(totalSupply), "EDU");
  
  console.log("Deployment completed successfully!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Error during deployment:", error);
    process.exit(1);
  });