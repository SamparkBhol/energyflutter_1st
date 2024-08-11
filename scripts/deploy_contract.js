const Web3 = require("web3");
const fs = require("fs");
const path = require("path");

// Setup web3 provider (Assume Ganache or another local network is used)
const web3 = new Web3("http://localhost:8545");

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();
  const admin = accounts[0];

  // Read compiled contract
  const contractPath = path.resolve(__dirname, "../build/contracts/EnergyTrading.json");
  const { abi, bytecode } = JSON.parse(fs.readFileSync(contractPath, "utf8"));

  // Deploy contract
  const contract = new web3.eth.Contract(abi);
  const deployedContract = await contract.deploy({ data: bytecode }).send({ from: admin, gas: 1500000 });

  console.log("Contract deployed to:", deployedContract.options.address);
};

deploy().catch(console.error);
