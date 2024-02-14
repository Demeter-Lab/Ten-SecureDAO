const hre = require("hardhat");

async function main() {
  const contract = await hre.ethers.deployContract("Encrypten", []);
  console.log("Deploying contract....");
  await contract.waitForDeployment();

  console.log(`Encrypten contract deployed to: \nAddress: ${contract.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
