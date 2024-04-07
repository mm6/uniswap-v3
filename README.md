# Uniswap v3 local deployment

## Acknowledgements

This code has been taken from the official documentation of Uniswap v3 and 
modified to work with local deployments. The original code can be found here:

https://github.com/Uniswap/uniswap-first-contract-example/tree/main


## Setup and pre-requisites

This project uses [Hardhat](https://hardhat.org/) to compile, deploy and 
test the contracts. Apart from that, it uses [Alchemy](https://alchemy.com/) 
to have a local Ethereum node. This will be an exact replica of the live 
network, but with fake ETH, WETH and DAI.

DO NOTE: 
- You will need to have an Alchemy account to run this code.
- You will be given generated private keys for the accounts in the local 
  network. These are not real accounts and should not be used in any other 
  network. Any money sent to these accounts will be lost forever. You have 
  been warned.
- You will need to have [Node.js](https://nodejs.org/en/) installed in your 
  machine.
- You will need to have [npm](https://www.npmjs.com/) installed in your 
  machine.

## Instructions

### Step 0: Clone the repository

The first thing to do would be to clone this current repository. You can do
that by either running the `git clone` command (`git clone https://github.com/boomcan90/uniswap-v3.git`) 
or by clicking on the Code button, then the Download Zip button, and then 
extracting the zip file to a location of your choice. Open a terminal in 
this folder, and keep it open as we will be using this later. For the rest of 
these instructions, $DIR will refer to this directory.

You will be working in two terminals: one for the local Ethereum node and
another for the Hardhat commands.

### Step 1: Terminal 1 - Local Ethereum node

We start off by going to the alchemy dashboard, and copying the URL of the 
API Key. It should look something like: 

https://eth-mainnet.g.alchemy.com/v2/<API_KEY>

Now, in the terminal, run the following command:

```bash
npm install
```

This will install all the dependencies required for this project. Once this
is done, run the following command:

```bash
npx hardhat node --fork <URL from above>
```

Once this runs, it should give an output  similar to this: 

```
Started HTTP and WebSocket JSON-RPC server at http://127.0.0.1:8545/

Accounts
========

WARNING: These accounts, and their private keys, are publicly known.
Any funds sent to them on Mainnet or any other live network WILL BE LOST.

Account #0: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 (10000 ETH)
Private Key: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

At this point, your local node has been set-up. as mentioned earlier - this 
is a clone of the complete Etherium chain that's running locally. This is ***not***
mainnet. Any transactions you do here will not be reflected in the mainnet.

### Step 2: Setting up MetaMask

As a part of [Lab 1](https://github.com/mm6/ethereum-lab1), metamask was one of
the dependencies that was installed. We would be using this to get a visual 
feedback on the transactions.

Metamask is a wallet extension added into the web-browser of choice.

Click on the MetaMask plugin in your browser. There is a circle icon on the 
top right that is the "Accounts" icon. Click this icon and open "Settings". 
Under "Advanced", set "Advanced Gas Controls" to "ON". Also, set 
"Show test networks" to "ON".

At this point, a new network needs to be added to metamask. Click on the "Add a 
network button on the top right, and on the following page, at the "Add a 
network manually" at the bottom. Under "Network Name" enter Hardhat, under 
"New RPC URL" enter http://127.0.0.1:8545, under "ChainID" enter 31337, and \
under Currency Symbol enter "ETH" and then select "Save". You will now be able to 
import accounts from Hardhat. Always ensure that you are working with the 
"Hardhat" network and not any other networks in MetaMask.

Currently, your account name is "Account 1" and you control 0 ETH. To complete 
transactions through the wallet, you will import accounts from Hardhat into 
your MetaMask wallet as "imported" accounts. On the [first part of the lab](#step-1-terminal-1---local-ethereum-node),
you will have seen a list of accounts and their private keys. Copy the private
key of "Account #0". Back in metamask, click on "Account 1" and then on 
"Add account or hardware wallet", and then on "Import account". Paste the 
copied key in the "Private Key" field in MetaMask and click on "Import". You 
will now see that you have 10000 ETH in your account.

At this point, we will start tracking the ERC-20 tokens that we will be using 
for this lab. Click on "Add token", and under "Token contract address" enter 
0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 and under "Token symbol" enter 
"WETH". Click on "Next" and then on "Import". You will now see that you have 
0 WETH in your account. Similarly, add the DAI token by entering 
0x6B175474E89094C44Da98b954EedeAC495271d0F as the contract address and "DAI" 
as the token symbol. You will now see that you have 0 DAI in your account.

### Step 3: Terminal 2 - Hardhat commands
To interact with the 3 contracts, we will be using the Hardhat console. 
Start off by running the following command:

```bash
npx hardhat console --network localhost
```
The output should look similar to this:

```
Welcome to Node.js v16.19.1.
Type ".help" for more information.
>
```

At this point, you are in the Hardhat console. We first need to import the 
necessary libraries. This can be done by running the following commands:

```js
const { ethers } = require("hardhat");
```

This will import the ethers library. We will also need to define the addresses 
of the contracts that we will be using. This can be done by running the 
following commands:

```js
const WETH_ADDRESS = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";
const DAI_ADDRESS = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const DAI_DECIMALS = 18; 
const SwapRouterAddress = "0xE592427A0AEce92De3Edee1F18E0157C05861564"; 
```

Since we're working with pre-existing contracts, we need to define the 
ABI (Application Binary Interface) for interacting with the contracts. This 
can be done by running the following commands:

```js
const ercAbi = [
  // Read-Only Functions
  "function balanceOf(address owner) view returns (uint256)",
  // Authenticated Functions
  "function transfer(address to, uint amount) returns (bool)",
  "function deposit() public payable",
  "function approve(address spender, uint256 amount) returns (bool)",
];
```

At this point, we're ready to deploy our uniswap v3 contract. This can be done 
by running the following commands:

```js
/* Deploy the SimpleSwap contract */
const simpleSwapFactory = await ethers.getContractFactory("SimpleSwap");
const simpleSwap = await simpleSwapFactory.deploy(SwapRouterAddress);
await simpleSwap.waitForDeployment();
let signers = await ethers.getSigners();
```

With the contract deployed, we need to get some WETH into our account to be 
able to trade. This can be done by running the following commands:

```js
const WETH = new ethers.Contract(WETH_ADDRESS, ercAbi, signers[0]);
const deposit = await WETH.deposit({ value: ethers.parseEther("10") });
await deposit.wait();
```

At this point, if we open up metamask, we see that we have 10 WETH in our 
account. We can now approve the contract to spend our WETH. This can be done 
by running the following commands:

```js
await WETH.approve(simpleSwap.target, ethers.parseEther("1"));
```

Finally, we're ready to swap our WETH for DAI. This can be done by running the 
following commands:

```js
const amountIn = ethers.parseEther("0.1");
const DAI = new ethers.Contract(DAI_ADDRESS, ercAbi, signers[0]);
const swap = await simpleSwap.swapERCforERC(WETH, DAI, amountIn, { gasLimit: 300000 });
await swap.wait(); 
```

At this point, if we open up metamask, we see that we have 200 DAI in our account.

We can also check the DAI balance of our account by running the following commands:

```js

const expandedDAIBalance = await DAI.balanceOf(signers[0].address);
const DAIBalance = Number(ethers.formatUnits(expandedDAIBalance, DAI_DECIMALS));
console.log("DAI Balance: ", DAIBalance);
```
