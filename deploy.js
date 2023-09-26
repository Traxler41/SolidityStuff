const ethers = require("ethers");
const fs = require("fs-extra");

async function main(){
  // http:0.0.0.0:8545 The testnet where we will be deploying our contracts. Can be a VM Testnet like Ganache.
  const provider = new ethers.providers.JsonRpcProvider("http:0.0.0.0:8545");
  const wallet = new ethers.Wallet(" *** Private Key *** ",provider); //Never paste the private key directly into the code. Use Encryption. The private key is used to sign transactions.
  const abi = fs.readFileSync(" ***ABI File Path*** ","utf8"); //The ABI file is synchronously read and stored in the abi variable. The script used is utf8.
  const binary = fs.readFileSync(" ***BInary File PAth*** ","utf8"); //The Binary File is synchronously read and stored in the binary variable. The script used is utf8.
  const contractFactory = new ethers.ContractFactory(abi, binary, wallet);
  console.log("Deploying. Please wait...");
  const contract = await contractFactory.deploy(); //The await functions make sure not to execute further before this statement is not executed
  console.log(contract); //Prints the contract object
  const deploymentReceipt = await contract.deployTransaction.wait(1); //Prints the deployment receipt of the smart contract
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
  console.error(error);
  process.exit(1);
});
